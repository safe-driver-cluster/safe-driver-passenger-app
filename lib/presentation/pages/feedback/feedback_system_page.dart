import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import 'feedback_submission_page.dart';

class FeedbackSystemPage extends ConsumerStatefulWidget {
  const FeedbackSystemPage({super.key});

  @override
  ConsumerState<FeedbackSystemPage> createState() => _FeedbackSystemPageState();
}

class _FeedbackSystemPageState extends ConsumerState<FeedbackSystemPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? selectedBusNumber;
  bool isQRScanMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(),

              // Content Area
              Expanded(
                child: isQRScanMode
                    ? _buildQRScannerView()
                    : selectedBusNumber != null
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
        : isQRScanMode
            ? 'Scan QR Code'
            : 'Give Feedback';
    
    String headerSubtitle = selectedBusNumber != null
        ? 'Share your travel experience'
        : isQRScanMode
            ? 'Scan the QR code on the bus'
            : 'Choose your bus and share feedback';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    if (isQRScanMode) {
                      setState(() {
                        isQRScanMode = false;
                      });
                    } else if (selectedBusNumber != null) {
                      setState(() {
                        selectedBusNumber = null;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: AppDesign.iconLG,
                  ),
                ),
              ),
              
              Row(
                children: [
                  if (!isQRScanMode)
                    Container(
                      margin: const EdgeInsets.only(right: AppDesign.spaceSM),
                      decoration: BoxDecoration(
                        gradient: AppColors.glassGradient,
                        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/feedback-test');
                        },
                        icon: const Icon(
                          Icons.bug_report,
                          color: Colors.white,
                          size: AppDesign.iconLG,
                        ),
                      ),
                    ),
                  if (!isQRScanMode)
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.glassGradient,
                        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: _showQRScanner,
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: AppDesign.iconLG,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: AppDesign.spaceLG),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headerTitle,
                      style: TextStyle(
                        fontSize: AppDesign.text2XL,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: AppDesign.spaceXS),
                    
                    Text(
                      headerSubtitle,
                      style: TextStyle(
                        fontSize: AppDesign.textMD,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppDesign.spaceXL),
          _buildSelectionMethods(),
          const SizedBox(height: AppDesign.spaceXL),
          _buildRecentBuses(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: const Icon(
                  Icons.feedback_outlined,
                  color: AppColors.primaryColor,
                  size: AppDesign.iconLG,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share Your Experience',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppDesign.spaceXS),
                    Text(
                      'Help us improve our service by providing feedback about the bus or driver',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Bus',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceMD),
        Row(
          children: [
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.directions_bus,
                title: 'Select Bus',
                subtitle: 'Choose from available buses',
                onTap: _showBusSelection,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: _buildSelectionCard(
                icon: Icons.qr_code_scanner,
                title: 'Scan QR',
                subtitle: 'Scan bus QR code',
                onTap: _showQRScanner,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: AppColors.greyLight,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: AppDesign.iconXL,
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBuses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Buses',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceMD),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getRecentBuses().length,
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.greyLight,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final bus = _getRecentBuses()[index];
              return _buildRecentBusItem(bus);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBusItem(Map<String, String> bus) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceLG,
        vertical: AppDesign.spaceSM,
      ),
      leading: Container(
        padding: const EdgeInsets.all(AppDesign.spaceSM),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        ),
        child: const Icon(
          Icons.directions_bus,
          color: AppColors.primaryColor,
        ),
      ),
      title: Text(
        'Bus ${bus['number']}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        bus['route']!,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textHint,
        size: 16,
      ),
      onTap: () => _selectBus(bus['number']!),
    );
  }

  Widget _buildQRScannerView() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            color: AppColors.surfaceColor,
            child: const Column(
              children: [
                Text(
                  'Point your camera at the bus QR code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDesign.spaceSM),
                Text(
                  'The QR code is usually located inside the bus',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: _onQRCodeDetected,
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                    ),
                    child: Stack(
                      children: [
                        // Corner decorations
                        Positioned(
                          top: 0,
                          left: 0,
                          child: _buildCornerDecoration(),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Transform.rotate(
                            angle: 1.5708,
                            child: _buildCornerDecoration(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Transform.rotate(
                            angle: -1.5708,
                            child: _buildCornerDecoration(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Transform.rotate(
                            angle: 3.14159,
                            child: _buildCornerDecoration(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            color: AppColors.surfaceColor,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => isQRScanMode = false),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyLight,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDesign.spaceMD,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerDecoration() {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.primaryColor, width: 4),
          left: BorderSide(color: AppColors.primaryColor, width: 4),
        ),
      ),
    );
  }

  Widget _buildFeedbackTypeSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBusInfoCard(),
          const SizedBox(height: AppDesign.spaceXL),
          _buildFeedbackTypeOptions(),
        ],
      ),
    );
  }

  Widget _buildBusInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: const Icon(
              Icons.directions_bus,
              color: AppColors.successColor,
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                const Text(
                  'Selected for feedback',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => selectedBusNumber = null),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What would you like to give feedback about?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceLG),
        _buildFeedbackOption(
          icon: Icons.directions_bus,
          title: 'Bus Behavior',
          subtitle: 'Cleanliness, condition, comfort, facilities',
          color: AppColors.primaryColor,
          onTap: () => _navigateToFeedbackForm(FeedbackTarget.bus),
        ),
        const SizedBox(height: AppDesign.spaceMD),
        _buildFeedbackOption(
          icon: Icons.person,
          title: 'Driver Behavior',
          subtitle: 'Driving skills, courtesy, professionalism',
          color: AppColors.accentColor,
          onTap: () => _navigateToFeedbackForm(FeedbackTarget.driver),
        ),
      ],
    );
  }

  Widget _buildFeedbackOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: AppColors.greyLight,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textHint,
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
    final buses = _getAvailableBuses();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.only(
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
                    color: AppColors.greyMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),
                const Text(
                  'Select Bus',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
              itemCount: buses.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppDesign.spaceSM),
              itemBuilder: (context, index) {
                final bus = buses[index];
                return _buildBusSelectionItem(bus);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusSelectionItem(Map<String, String> bus) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _selectBus(bus['number']!);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: AppColors.greyLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
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
                    'Bus ${bus['number']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    bus['route']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
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

  void _showQRScanner() {
    setState(() => isQRScanMode = true);
  }

  void _onQRCodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final busNumber = _extractBusNumberFromQR(barcodes.first.rawValue ?? '');
      if (busNumber != null) {
        _selectBus(busNumber);
      }
    }
  }

  String? _extractBusNumberFromQR(String qrData) {
    // Extract bus number from QR code data
    // This should be implemented based on your QR code format
    final regex = RegExp(r'bus[_-]?(\d+)', caseSensitive: false);
    final match = regex.firstMatch(qrData);
    return match?.group(1);
  }

  void _selectBus(String busNumber) {
    setState(() {
      selectedBusNumber = busNumber;
      isQRScanMode = false;
    });
  }

  void _navigateToFeedbackForm(FeedbackTarget target) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackSubmissionPage(
          busNumber: selectedBusNumber!,
          feedbackTarget: target,
        ),
      ),
    );
  }

  List<Map<String, String>> _getRecentBuses() {
    return [
      {'number': '101', 'route': 'City Center - Airport'},
      {'number': '205', 'route': 'Mall - University'},
      {'number': '150', 'route': 'Downtown - Suburbs'},
    ];
  }

  List<Map<String, String>> _getAvailableBuses() {
    return [
      {'number': '101', 'route': 'City Center - Airport'},
      {'number': '102', 'route': 'City Center - Airport'},
      {'number': '150', 'route': 'Downtown - Suburbs'},
      {'number': '151', 'route': 'Downtown - Suburbs'},
      {'number': '205', 'route': 'Mall - University'},
      {'number': '206', 'route': 'Mall - University'},
      {'number': '301', 'route': 'Beach - Mountains'},
      {'number': '302', 'route': 'Beach - Mountains'},
    ];
  }
}

enum FeedbackTarget { bus, driver }
