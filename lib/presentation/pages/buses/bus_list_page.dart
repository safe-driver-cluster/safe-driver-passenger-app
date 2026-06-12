import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../widgets/common/web_responsive_layout.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({super.key});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              th.background,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(th, l10n),
              Expanded(
                child: _buildBusList(th, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeHelper th, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and back button
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard',
                    (route) => false,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                l10n.availableBuses,
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

          // Simple Search Bar
          Container(
            decoration: BoxDecoration(
              color: th.cardBackground,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: th.textPrimary),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: l10n.searchBusesHint,
                hintStyle: TextStyle(
                  color: th.textHint,
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
                        icon: Icon(
                          Icons.clear_rounded,
                          color: th.textHint,
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

  Widget _buildBusList(ThemeHelper th, AppLocalizations l10n) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('vehicles')
          .where('status', isEqualTo: 'active')
          .snapshots(),
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
                  l10n.noBuses,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceSM),
                Text(
                  l10n.tryAgainLater,
                  style: TextStyle(
                    color: th.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          );
        }

        final buses = snapshot.data?.docs ?? [];

        // Filter buses based on search query
        final filteredBuses = buses.where((bus) {
          final data = bus.data() as Map<String, dynamic>;
          final route = (data['route'] ?? '').toString().toLowerCase();
          final busNumber =
              (data['busNumberPlate'] ?? '').toString().toLowerCase();
          final routeId = (data['routeId'] ?? '').toString().toLowerCase();
          final ownerName = (data['ownerName'] ?? '').toString().toLowerCase();
          final model = (data['model'] ?? '').toString().toLowerCase();
          final location = data['location'] as Map<String, dynamic>?;
          final address = (location?['address'] ?? '').toString().toLowerCase();

          if (_searchQuery.isEmpty) return true;

          return route.contains(_searchQuery) ||
              routeId.contains(_searchQuery) ||
              busNumber.contains(_searchQuery) ||
              ownerName.contains(_searchQuery) ||
              model.contains(_searchQuery) ||
              address.contains(_searchQuery);
        }).toList();

        if (filteredBuses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_bus_rounded,
                  size: 64,
                  color: th.textHint,
                ),
                const SizedBox(height: AppDesign.spaceMD),
                Text(
                  _searchQuery.isEmpty ? l10n.noBusesAvailable : l10n.noResults,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceSM),
                Text(
                  _searchQuery.isEmpty
                      ? l10n.checkBackLaterBuses
                      : l10n.tryDifferentSearch,
                  style: TextStyle(
                    color: th.textSecondary,
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
          backgroundColor: th.cardBackground,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (!isWideWeb) {
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppDesign.spaceLG),
                  itemCount: filteredBuses.length,
                  itemBuilder: (context, index) {
                    final busData =
                        filteredBuses[index].data() as Map<String, dynamic>;
                    return _buildBusCard(th, l10n, {
                      'id': filteredBuses[index].id,
                      ...busData,
                    });
                  },
                );
              }

              return GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppDesign.spaceXL),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 560,
                  mainAxisExtent: 340,
                  crossAxisSpacing: AppDesign.spaceLG,
                  mainAxisSpacing: AppDesign.spaceLG,
                ),
                itemCount: filteredBuses.length,
                itemBuilder: (context, index) {
                  final busData =
                      filteredBuses[index].data() as Map<String, dynamic>;
                  return _buildBusCard(th, l10n, {
                    'id': filteredBuses[index].id,
                    ...busData,
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBusCard(
      ThemeHelper th, AppLocalizations l10n, Map<String, dynamic> busData) {
    final route = busData['route'] ?? l10n.unknown;
    final routeId = (busData['routeId'] ?? '').toString().trim();
    final busNumber =
        busData['busNumberPlate'] ?? busData['busNumber'] ?? 'N/A';
    final ownerName = (busData['ownerName'] ?? l10n.unknown).toString();
    final model = busData['model'] ?? 'N/A';
    final status = (busData['status'] ?? 'active').toString();
    final location = busData['location'] as Map<String, dynamic>?;
    final address = location?['address'] ?? l10n.noData;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              busNumber,
                              style: TextStyle(
                                color: th.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppDesign.spaceSM),
                          _buildStatusPill(status),
                        ],
                      ),
                      const SizedBox(height: AppDesign.spaceXS),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              route,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: th.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppDesign.spaceSM),
                          _buildModelChip(model),
                          if (routeId.isNotEmpty) ...[
                            const SizedBox(width: AppDesign.spaceSM),
                            _buildRouteChip(routeId),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Row(
              children: [
                Expanded(
                  child: _buildBusInfoTile(
                    icon: Icons.person_rounded,
                    label: 'Bus Owner',
                    value: ownerName,
                    th: th,
                    isImportant: true,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: _buildBusInfoTile(
                    icon: Icons.location_on_rounded,
                    label: 'Depot',
                    value: address,
                    th: th,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteChip(String routeId) {
    return ActionChip(
      avatar: const Icon(
        Icons.route_rounded,
        size: 14,
        color: AppColors.primaryColor,
      ),
      label: Text(routeId),
      labelStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
      backgroundColor: AppColors.primaryColor.withOpacity(0.08),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      onPressed: () => _showRouteDetails(routeId),
    );
  }

  Widget _buildModelChip(Object model) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 92),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceSM,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.confirmation_number_rounded,
            color: AppColors.primaryColor,
            size: 13,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              model.toString(),
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceSM,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: AppColors.successColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBusInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required ThemeHelper th,
    bool isImportant = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceSM),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 17,
          ),
          const SizedBox(width: AppDesign.spaceXS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: th.textPrimary,
                    fontSize: 13,
                    fontWeight: isImportant ? FontWeight.w700 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRouteDetails(String routeId) async {
    showDialog(
      context: context,
      builder: (context) {
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
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _loadRouteDetails(routeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                }

                return _buildRouteDetailsContent(
                  th,
                  routeId,
                  snapshot.data,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _loadRouteDetails(String routeId) async {
    final routes = FirebaseFirestore.instance.collection('routes');
    final byDoc = await routes.doc(routeId).get();
    if (byDoc.exists) {
      return {
        'id': byDoc.id,
        ...?byDoc.data(),
      };
    }

    final byId = await routes.where('id', isEqualTo: routeId).limit(1).get();
    if (byId.docs.isEmpty) return null;

    final doc = byId.docs.first;
    return {
      'id': doc.id,
      ...doc.data(),
    };
  }

  Widget _buildRouteDetailsContent(
    ThemeHelper th,
    String routeId,
    Map<String, dynamic>? routeData,
  ) {
    final details = routeData == null
        ? <_DriverDetailItem>[
            _DriverDetailItem(
              'Route ID',
              routeId,
              Icons.confirmation_number_rounded,
            ),
            const _DriverDetailItem(
              'Status',
              'No route details found',
              Icons.info_outline_rounded,
            ),
          ]
        : <_DriverDetailItem>[
            _DriverDetailItem(
              'Route ID',
              (routeData['id'] ?? routeId).toString(),
              Icons.confirmation_number_rounded,
            ),
            _DriverDetailItem(
              'Name',
              (routeData['name'] ?? 'N/A').toString(),
              Icons.route_rounded,
            ),
            _DriverDetailItem(
              'Bus Number',
              (routeData['busNumber'] ?? 'N/A').toString(),
              Icons.directions_bus_rounded,
            ),
            _DriverDetailItem(
              'Start',
              (routeData['startPoint'] ?? 'N/A').toString(),
              Icons.trip_origin_rounded,
            ),
            _DriverDetailItem(
              'End',
              (routeData['endPoint'] ?? 'N/A').toString(),
              Icons.location_on_rounded,
            ),
            _DriverDetailItem(
              'Distance',
              _formatRouteNumber(routeData['distance'], suffix: ' km'),
              Icons.straighten_rounded,
            ),
            _DriverDetailItem(
              'Time',
              _formatRouteNumber(routeData['estimatedTime'], suffix: ' min'),
              Icons.schedule_rounded,
            ),
            _DriverDetailItem(
              'Vehicles',
              _routeVehiclesText(routeData['vehicles']),
              Icons.directions_bus_filled_rounded,
            ),
            _DriverDetailItem(
              'Status',
              _driverStatusText(routeData['status']),
              Icons.circle_rounded,
            ),
          ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRouteDialogHeader(th, routeData?['name']?.toString() ?? routeId),
        const SizedBox(height: AppDesign.spaceLG),
        ...details.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppDesign.spaceSM),
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: AppDesign.spaceSM),
                SizedBox(
                  width: 92,
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
                      fontWeight: item.label == 'Route ID'
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteDialogHeader(ThemeHelper th, String routeTitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesign.radiusMD),
          ),
          child: const Icon(
            Icons.route_rounded,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: AppDesign.spaceMD),
        Expanded(
          child: Text(
            routeTitle.isEmpty ? 'Route details' : routeTitle,
            style: TextStyle(
              color: th.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
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

  String _driverStatusText(Object? status) {
    final value = (status ?? 'N/A').toString().trim();
    if (value.isEmpty) return 'N/A';
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String _formatRouteNumber(Object? value, {required String suffix}) {
    if (value == null) return 'N/A';

    if (value is num) {
      if (value == 0) return 'N/A';
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}$suffix';
    }

    final text = value.toString().trim();
    if (text.isEmpty || text == '0') return 'N/A';
    return text.endsWith(suffix.trim()) ? text : '$text$suffix';
  }

  String _routeVehiclesText(Object? vehicles) {
    if (vehicles is Iterable) {
      final values = vehicles
          .map((vehicle) => vehicle.toString().trim())
          .where((vehicle) => vehicle.isNotEmpty)
          .toList();

      if (values.isEmpty) return 'N/A';
      return values.join(', ');
    }

    final value = (vehicles ?? '').toString().trim();
    return value.isEmpty ? 'N/A' : value;
  }
}

class _DriverDetailItem {
  final String label;
  final String value;
  final IconData icon;

  const _DriverDetailItem(this.label, this.value, this.icon);
}
