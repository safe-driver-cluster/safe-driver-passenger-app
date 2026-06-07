import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../widgets/common/bottom_navigation_widget.dart';
import '../../widgets/common/web_responsive_layout.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  State<DriverListPage> createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              // Header with search
              _buildHeader(l10n),

              // Driver list
              Expanded(
                child: _buildDriverList(l10n),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WebResponsive.isWideWeb(
        context,
        minWidth: WebResponsive.desktopBreakpoint,
      )
          ? null
          : BottomNavigationWidget(
              currentIndex: 1, // Search tab is selected for drivers
              onTap: (index) {
                switch (index) {
                  case 0:
                  case 1:
                  case 2:
                  case 3:
                    // Navigate back to dashboard with correct tab
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/dashboard',
                      (route) => false,
                      arguments: {'initialTab': index},
                    );
                    break;
                }
              },
            ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
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
          // Title and back button
          Row(
            children: [
              const CustomBackButton(
                color: Colors.white,
                backgroundColor: Color(0x33FFFFFF),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                l10n.drivers,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Search bar
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: AppDesign.shadowMD,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: l10n.searchDriversHint,
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.textHint,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceLG,
                  vertical: AppDesign.spaceMD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverList(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppColors.errorColor,
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  Text(
                    l10n.noDrivers,
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceSM),
                  Text(
                    l10n.tryAgainLater,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            );
          }

          final drivers = snapshot.data?.docs ?? [];

          // Filter drivers based on search query
          final filteredDrivers = drivers.where((driver) {
            final data = driver.data() as Map<String, dynamic>;
            final name = (data['name'] ?? '').toString().toLowerCase();
            final licenseNumber =
                (data['licenseNumber'] ?? '').toString().toLowerCase();
            final route = (data['route'] ?? '').toString().toLowerCase();
            final assignedBuses = _extractAssignedBuses(data)
                .map((bus) => bus.toLowerCase())
                .toList();

            return name.contains(_searchQuery) ||
                licenseNumber.contains(_searchQuery) ||
                route.contains(_searchQuery) ||
                assignedBuses.any((bus) => bus.contains(_searchQuery));
          }).toList();

          if (filteredDrivers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_rounded,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  Text(
                    _searchQuery.isEmpty
                        ? l10n.noDrivers
                        : l10n.noMatchingDrivers,
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceSM),
                  Text(
                    _searchQuery.isEmpty
                        ? l10n.noData
                        : l10n.tryDifferentSearch,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final isWideWeb = WebResponsive.isWideWeb(
            context,
            minWidth: WebResponsive.desktopBreakpoint,
          );

          return RefreshIndicator(
            onRefresh: () async {
              // Since this uses StreamBuilder, it's already real-time.
              // But we can add a slight delay or manually trigger a reload if needed.
              await Future.delayed(const Duration(seconds: 1));
            },
            color: AppColors.primaryColor,
            backgroundColor: ThemeHelper.of(context).cardBackground,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (!isWideWeb) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredDrivers.length,
                    itemBuilder: (context, index) {
                      final driverData =
                          filteredDrivers[index].data() as Map<String, dynamic>;
                      return _buildDriverCard(l10n, driverData);
                    },
                  );
                }

                return GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 520,
                    mainAxisExtent: 360,
                    crossAxisSpacing: AppDesign.spaceLG,
                    mainAxisSpacing: AppDesign.spaceLG,
                  ),
                  itemCount: filteredDrivers.length,
                  itemBuilder: (context, index) {
                    final driverData =
                        filteredDrivers[index].data() as Map<String, dynamic>;
                    return _buildDriverCard(l10n, driverData);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDriverCard(
      AppLocalizations l10n, Map<String, dynamic> driverData) {
    final th = ThemeHelper.of(context);
    final name = driverData['name'] ?? l10n.unknown;
    final licenseNumber = driverData['licenseNumber'] ?? 'N/A';
    final route = driverData['route'] ?? l10n.unknown;
    final assignedBuses = _extractAssignedBuses(driverData);
    final experience = driverData['experience'] ?? 'N/A';
    final phone = driverData['phone'] ?? 'N/A';
    final email = driverData['email'] ?? 'N/A';
    final status = driverData['status'] ?? 'off_duty';

    final joinDate = driverData['joinDate'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: th.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: th.border,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusFull),
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'D',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDesign.spaceMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: th.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${l10n.license}: $licenseNumber',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: th.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceSM,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                    border: Border.all(
                      color: _getStatusColor(status).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(status, l10n),
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceMD),

            // Route and bus information
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    size: 16,
                    color: AppColors.accentColor,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: Text(
                    route,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: th.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceMD),

            _buildInfoRow(
              th: th,
              icon: Icons.work_rounded,
              label: l10n.driverExperience,
              value: experience.toString(),
            ),

            const SizedBox(height: AppDesign.spaceSM),

            // Contact information
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    th: th,
                    icon: Icons.phone_rounded,
                    label: l10n.phoneNumber,
                    value: _maskPhone(phone.toString()),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildInfoRow(
                    th: th,
                    icon: Icons.email_rounded,
                    label: l10n.email,
                    value: _maskEmail(email.toString()),
                  ),
                ),
              ],
            ),

            if (joinDate.isNotEmpty) ...[
              const SizedBox(height: AppDesign.spaceSM),
              _buildInfoRow(
                th: th,
                icon: Icons.calendar_today_rounded,
                label: l10n.joined,
                value: joinDate,
              ),
            ],

            const SizedBox(height: AppDesign.spaceSM),
            _buildAssignedBusChips(assignedBuses, th),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedBusChips(List<String> busNumbers, ThemeHelper th) {
    if (busNumbers.isEmpty) {
      return Text(
        'Assigned buses: 0',
        style: AppTextStyles.bodySmall.copyWith(
          color: th.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Wrap(
      spacing: AppDesign.spaceSM,
      runSpacing: AppDesign.spaceSM,
      children: busNumbers.map((busNumber) {
        return ActionChip(
          avatar: const Icon(
            Icons.directions_bus_rounded,
            size: 16,
            color: Colors.white,
          ),
          label: Text(busNumber),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          backgroundColor: AppColors.primaryColor,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusSM),
          ),
          onPressed: () => _showBusDetails(busNumber),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow({
    required ThemeHelper th,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: th.textSecondary,
        ),
        const SizedBox(width: AppDesign.spaceXS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: th.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: valueColor ?? th.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on_duty':
        return AppColors.successColor;
      case 'off_duty':
        return AppColors.textSecondary;
      case 'break':
        return AppColors.warningColor;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'on_duty':
        return l10n.onDuty;
      case 'off_duty':
        return l10n.offDuty;
      case 'break':
        return l10n.onBreak;
      default:
        return l10n.unknown;
    }
  }

  List<String> _extractAssignedBuses(Map<String, dynamic> driverData) {
    final buses = <String>{};

    void addValue(Object? value) {
      if (value == null) return;
      if (value is Iterable) {
        for (final item in value) {
          addValue(item);
        }
        return;
      }

      final text = value.toString().trim();
      if (text.isEmpty || text.toUpperCase() == 'N/A') return;
      buses.add(text);
    }

    addValue(driverData['busNumber']);
    addValue(driverData['busNumberPlate']);
    addValue(driverData['currentBusId']);
    addValue(driverData['assignedBuses']);
    addValue(driverData['assignedBusNumbers']);

    return buses.toList();
  }

  String _maskPhone(String phone) {
    final value = phone.trim();
    if (value.isEmpty || value.toUpperCase() == 'N/A') return '***';
    if (value.length <= 4) return '***';

    final visibleStart = value.length >= 7 ? 3 : 1;
    final visibleEnd = value.length >= 7 ? 2 : 1;
    return '${value.substring(0, visibleStart)}***${value.substring(value.length - visibleEnd)}';
  }

  String _maskEmail(String email) {
    final value = email.trim();
    if (value.isEmpty || value.toUpperCase() == 'N/A') return '***';

    final atIndex = value.indexOf('@');
    if (atIndex <= 0) return '***';

    final local = value.substring(0, atIndex);
    final domain = value.substring(atIndex);
    final visible = local.length <= 2 ? local[0] : local.substring(0, 3);
    return '$visible***$domain';
  }

  Future<void> _showBusDetails(String busNumber) async {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<Map<String, dynamic>?>(
          future: _loadBusDetails(busNumber),
          builder: (context, snapshot) {
            final th = ThemeHelper.of(context);
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spaceXL,
                vertical: AppDesign.spaceXL,
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 420,
                  minHeight: 232,
                ),
                decoration: BoxDecoration(
                  color: th.cardBackground,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppDesign.spaceLG),
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _buildBusDetailsContent(
                        th,
                        busNumber,
                        snapshot.data,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _loadBusDetails(String busNumber) async {
    final vehicles = FirebaseFirestore.instance.collection('vehicles');

    Future<Map<String, dynamic>?> queryByField(String field) async {
      final snapshot =
          await vehicles.where(field, isEqualTo: busNumber).limit(1).get();
      if (snapshot.docs.isEmpty) return null;
      return {
        'id': snapshot.docs.first.id,
        ...snapshot.docs.first.data(),
      };
    }

    final byPlate = await queryByField('busNumberPlate');
    if (byPlate != null) return byPlate;

    final byNumber = await queryByField('busNumber');
    if (byNumber != null) return byNumber;

    final byId = await vehicles.doc(busNumber).get();
    if (!byId.exists) return null;
    return {
      'id': byId.id,
      ...byId.data()!,
    };
  }

  Widget _buildBusDetailsContent(
    ThemeHelper th,
    String busNumber,
    Map<String, dynamic>? busData,
  ) {
    final displayBusNumber =
        (busData?['busNumberPlate'] ?? busData?['busNumber'] ?? busNumber)
            .toString();

    if (busData == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBusDialogHeader(th, displayBusNumber),
          const SizedBox(height: AppDesign.spaceXL),
          Icon(
            Icons.directions_bus_filled_outlined,
            color: th.textHint,
            size: 44,
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            'No details found for $busNumber',
            style: TextStyle(
              color: th.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    final location = busData['location'] as Map<String, dynamic>?;
    final details = <_BusDetailItem>[
      _BusDetailItem(
          'Route', (busData['route'] ?? 'N/A').toString(), Icons.route_rounded),
      _BusDetailItem('Model', (busData['model'] ?? 'N/A').toString(),
          Icons.directions_bus_rounded),
      _BusDetailItem('Status', (busData['status'] ?? 'N/A').toString(),
          Icons.info_rounded),
      _BusDetailItem('Driver', (busData['driverName'] ?? 'N/A').toString(),
          Icons.person_rounded),
      _BusDetailItem('Location', (location?['address'] ?? 'N/A').toString(),
          Icons.location_on_rounded),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBusDialogHeader(th, displayBusNumber),
        const SizedBox(height: AppDesign.spaceLG),
        ...details.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppDesign.spaceSM),
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: AppDesign.spaceSM),
                SizedBox(
                  width: 78,
                  child: Text(
                    item.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.value,
                    style: TextStyle(
                      color: th.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusDialogHeader(ThemeHelper th, String busNumber) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesign.radiusMD),
          ),
          child: const Icon(
            Icons.directions_bus_rounded,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: AppDesign.spaceMD),
        Expanded(
          child: Text(
            busNumber,
            style: TextStyle(
              color: th.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          color: AppColors.errorColor,
          tooltip: 'Close',
        ),
      ],
    );
  }
}

class _BusDetailItem {
  final String label;
  final String value;
  final IconData icon;

  const _BusDetailItem(this.label, this.value, this.icon);
}
