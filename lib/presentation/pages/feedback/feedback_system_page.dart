import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/bus_model.dart';
import '../../../data/models/driver_model.dart';
import '../../../data/repositories/driver_repository.dart';
import '../../controllers/feedback_controller.dart';
import '../qr/qr_scanner_page.dart';
import 'feedback_submission_page.dart';

class FeedbackSystemPage extends ConsumerStatefulWidget {
  const FeedbackSystemPage({super.key});

  @override
  ConsumerState<FeedbackSystemPage> createState() => _FeedbackSystemPageState();
}

class _FeedbackSystemPageState extends ConsumerState<FeedbackSystemPage> {
  final DriverRepository _driverRepository = DriverRepository();
  String? selectedBusNumber;
  BusModel? selectedBus;
  bool isLoadingDrivers = false;

  @override
  void initState() {
    super.initState();
    // Load bus data from Firebase on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🚀 FeedbackSystemPage: Calling loadBusData...');
      ref.read(feedbackControllerProvider.notifier).loadBusData();
      debugPrint('✅ FeedbackSystemPage: loadBusData called');
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    // Watch the feedback controller state to ensure it's initialized
    ref.watch(feedbackControllerProvider);

    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              const Color(0xFF2F63F6),
              th.background,
            ],
            stops: const [0.0, 0.28, 0.78],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildModernHeader(),
              Expanded(
                child: selectedBusNumber != null
                    ? _buildFeedbackTypeSelection()
                    : _buildBusSelectionView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    String headerTitle = selectedBusNumber != null
        ? 'Bus ${selectedBusNumber!} Feedback'
        : 'Give Feedback';

    String headerSubtitle = selectedBusNumber != null
        ? 'Share your travel experience'
        : 'Choose your bus and share feedback';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomBackButton(
                color: Colors.white,
                backgroundColor: Color(0x33FFFFFF),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Text(
                  headerTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              IconButton(
                onPressed: _showQRScanner,
                icon: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0x1FFFFFFF),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            headerSubtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        0,
        AppDesign.spaceLG,
        AppDesign.spaceXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryCard(),
          const SizedBox(height: AppDesign.spaceLG),
          _buildSelectionMethods(),
          const SizedBox(height: AppDesign.spaceLG),
          _buildRecentBuses(),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/feedback-history');
      },
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Colors.white,
                size: AppDesign.iconLG,
              ),
            ),
            const SizedBox(width: AppDesign.spaceLG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View Feedback History',
                    style: AppTextStyles.headline6.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    'Check your previous feedback and status',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionMethods() {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        border: Border.all(color: th.border),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Bus',
            style: AppTextStyles.headline6.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            'Pick a bus manually or scan the QR code for faster access.',
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildSelectionCard(
                    icon: Icons.directions_bus,
                    title: 'Select Bus',
                    subtitle: 'Choose from available buses',
                    accent: AppColors.primaryColor,
                    onTap: _showBusSelection,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildSelectionCard(
                    icon: Icons.qr_code_scanner,
                    title: 'Scan QR',
                    subtitle: 'Open the scanner and scan the bus QR',
                    accent: AppColors.infoColor,
                    onTap: _showQRScanner,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required VoidCallback onTap,
  }) {
    final th = ThemeHelper.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: th.background,
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
          border: Border.all(
            color: accent.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: Icon(
                icon,
                color: accent,
                size: AppDesign.iconXL,
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: th.textPrimary,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: th.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBuses() {
    final th = ThemeHelper.of(context);
    final controller = ref.read(feedbackControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        border: Border.all(color: th.border),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Buses',
            style: AppTextStyles.headline6.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            'Choose one of the buses you recently viewed or used.',
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          ValueListenableBuilder(
            valueListenable: controller.recentBusesNotifier,
            builder: (context, buses, _) {
              debugPrint(
                  '🔄 FeedbackPage: Recent buses updated: ${buses.length} buses');

              if (buses.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDesign.spaceMD,
                  ),
                  child: Text(
                    'No recent buses available',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: th.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: buses.length,
                separatorBuilder: (context, index) => Divider(
                  color: th.border,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final bus = buses[index];
                  return _buildRecentBusItem(bus);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBusItem(bus) {
    final th = ThemeHelper.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceLG,
        vertical: AppDesign.spaceSM,
      ),
      leading: Container(
        padding: const EdgeInsets.all(AppDesign.spaceSM),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        ),
        child: const Icon(
          Icons.directions_bus,
          color: AppColors.primaryColor,
        ),
      ),
      title: Text(
        'Bus ${bus.busNumber}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: th.textPrimary,
        ),
      ),
      subtitle: Text(
        bus.routeNumber,
        style: TextStyle(
          fontSize: 14,
          color: th.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: th.textHint,
        size: 16,
      ),
      onTap: () => _selectBus(bus),
    );
  }

  Widget _buildFeedbackTypeSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        0,
        AppDesign.spaceLG,
        AppDesign.spaceXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBusInfoCard(),
          const SizedBox(height: AppDesign.spaceLG),
          _buildFeedbackTypeOptions(),
        ],
      ),
    );
  }

  Widget _buildBusInfoCard() {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        border: Border.all(color: th.border),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: const Icon(
              Icons.directions_bus,
              color: AppColors.primaryColor,
              size: AppDesign.iconLG,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus ${selectedBusNumber!}',
                  style: AppTextStyles.headline5.copyWith(
                    color: th.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  'Selected for feedback',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  'Change the selected bus anytime before submitting.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textHint,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              selectedBus = null;
              selectedBusNumber = null;
            }),
            icon: const Icon(
              Icons.edit,
              color: AppColors.primaryColor,
            ),
            tooltip: 'Change Bus',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeOptions() {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        border: Border.all(color: th.border),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What would you like to give feedback about?',
            style: AppTextStyles.headline6.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            'Choose the area that best matches your experience.',
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildFeedbackOption(
            icon: Icons.directions_bus,
            title: 'Bus Behavior',
            subtitle: 'Cleanliness, condition, comfort, and facilities.',
            color: AppColors.primaryColor,
            onTap: () => _navigateToFeedbackForm(FeedbackTarget.bus),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildFeedbackOption(
            icon: Icons.person,
            title: 'Driver Behavior',
            subtitle: isLoadingDrivers
                ? 'Checking assigned drivers...'
                : 'Driving skills, courtesy, and professionalism.',
            color: AppColors.accentColor,
            onTap: isLoadingDrivers
                ? () {}
                : () => _navigateToFeedbackForm(FeedbackTarget.driver),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final th = ThemeHelper.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: th.background,
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
          border: Border.all(
            color: color.withValues(alpha: 0.18),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: Icon(
                icon,
                color: color,
                size: AppDesign.iconLG,
              ),
            ),
            const SizedBox(width: AppDesign.spaceLG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: th.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: th.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: th.textHint,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showBusSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBusSelectionBottomSheet(),
    );
  }

  Widget _buildBusSelectionBottomSheet() {
    final th = ThemeHelper.of(context);
    final controller = ref.read(feedbackControllerProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDesign.radiusXL),
          topRight: Radius.circular(AppDesign.radiusXL),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: th.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),
                Text(
                  'Select Bus',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller.availableBusesNotifier,
              builder: (context, buses, _) {
                if (buses.isEmpty) {
                  return const Center(
                    child: Text('No buses available'),
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
                  itemCount: buses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppDesign.spaceSM),
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    return _buildBusSelectionItem(bus);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusSelectionItem(bus) {
    final th = ThemeHelper.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _selectBus(bus);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: th.cardBackground,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: th.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              child: const Icon(
                Icons.directions_bus,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bus ${bus.busNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: th.textPrimary,
                    ),
                  ),
                  Text(
                    bus.routeNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: th.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDriverSelectionBottomSheet(List<DriverModel> drivers) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDriverSelectionBottomSheet(drivers),
    );
  }

  Widget _buildDriverSelectionBottomSheet(List<DriverModel> drivers) {
    final th = ThemeHelper.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDesign.radiusXL),
          topRight: Radius.circular(AppDesign.radiusXL),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: th.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),
                Text(
                  'Select Driver',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  'Choose the driver you want to give feedback about',
                  style: TextStyle(
                    fontSize: 14,
                    color: th.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spaceLG,
                vertical: AppDesign.spaceSM,
              ),
              itemCount: drivers.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppDesign.spaceSM),
              itemBuilder: (context, index) {
                return _buildDriverSelectionItem(drivers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverSelectionItem(DriverModel driver) {
    final th = ThemeHelper.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _openFeedbackForm(
          FeedbackTarget.driver,
          driverId: driver.id,
          driverName: _driverDisplayName(driver),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: th.cardBackground,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: th.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.accentColor,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _driverDisplayName(driver),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: th.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    'ID: ${driver.id}',
                    style: TextStyle(
                      fontSize: 14,
                      color: th.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: th.textHint,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQRScanner() async {
    final bus = await Navigator.of(context).push<BusModel>(
      MaterialPageRoute(
        builder: (_) => const QrScannerPage(),
      ),
    );

    if (!mounted || bus == null) {
      return;
    }

    _selectBus(bus);
  }

  void _selectBus(BusModel bus) {
    setState(() {
      selectedBus = bus;
      selectedBusNumber = bus.busNumber;
    });
  }

  Future<void> _navigateToFeedbackForm(FeedbackTarget target) async {
    final busNumber = selectedBusNumber;
    if (busNumber == null) return;

    if (target == FeedbackTarget.driver) {
      await _handleDriverFeedbackSelection();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackSubmissionPage(
          busId: selectedBus?.id ?? busNumber,
          busNumber: busNumber,
          feedbackTarget: target,
        ),
      ),
    );
  }

  Future<void> _handleDriverFeedbackSelection() async {
    final busNumber = selectedBusNumber;
    if (busNumber == null) return;

    setState(() => isLoadingDrivers = true);

    try {
      final drivers = await _driverRepository.getAssignedDriversForBus(
        busId: selectedBus?.id ?? busNumber,
        busNumber: busNumber,
        primaryDriverId: selectedBus?.driverId,
      );

      if (!mounted) return;

      if (drivers.isEmpty) {
        if (selectedBus?.driverId.trim().isNotEmpty == true) {
          _openFeedbackForm(
            FeedbackTarget.driver,
            driverId: selectedBus!.driverId,
            driverName: selectedBus!.driverName,
          );
          return;
        }

        _showMessage('No assigned driver found for this bus.');
        return;
      }

      if (drivers.length == 1) {
        final driver = drivers.first;
        _openFeedbackForm(
          FeedbackTarget.driver,
          driverId: driver.id,
          driverName: _driverDisplayName(driver),
        );
        return;
      }

      _showDriverSelectionBottomSheet(drivers);
    } catch (e) {
      if (mounted) {
        _showMessage('Could not load assigned drivers: $e');
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingDrivers = false);
      }
    }
  }

  void _openFeedbackForm(
    FeedbackTarget target, {
    String? driverId,
    String? driverName,
  }) {
    final busNumber = selectedBusNumber;
    if (busNumber == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackSubmissionPage(
          busId: selectedBus?.id ?? busNumber,
          busNumber: busNumber,
          driverId: driverId,
          driverName: driverName,
          feedbackTarget: target,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.dangerColor,
      ),
    );
  }

  String _driverDisplayName(DriverModel driver) {
    final fullName = driver.fullName.trim();
    if (fullName.isNotEmpty) return fullName;
    return driver.displayName;
  }
}

enum FeedbackTarget { bus, driver }
