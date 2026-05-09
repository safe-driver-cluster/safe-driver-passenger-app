import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({super.key});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, Future<_BusDriverAssignment>> _driverAssignmentFutures = {};
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
          final driverName =
              (data['driverName'] ?? '').toString().toLowerCase();
          final location = data['location'] as Map<String, dynamic>?;
          final address = (location?['address'] ?? '').toString().toLowerCase();

          if (_searchQuery.isEmpty) return true;

          return route.contains(_searchQuery) ||
              busNumber.contains(_searchQuery) ||
              driverName.contains(_searchQuery) ||
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

        return RefreshIndicator(
          onRefresh: () async {
            // Since this uses StreamBuilder, it's already real-time.
            // But we can add a slight delay or manually trigger a reload if needed.
            await Future.delayed(const Duration(seconds: 1));
          },
          color: AppColors.primaryColor,
          backgroundColor: th.cardBackground,
          child: ListView.builder(
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
          ),
        );
      },
    );
  }

  Widget _buildBusCard(
      ThemeHelper th, AppLocalizations l10n, Map<String, dynamic> busData) {
    final route = busData['route'] ?? l10n.unknown;
    final busNumber = busData['busNumberPlate'] ?? busData['busNumber'] ?? 'N/A';
    final busId = busData['id']?.toString();
    final driverName = busData['driverName'] ?? l10n.unknown;
    final model = busData['model'] ?? 'N/A';
    final safetyScore = busData['safetyScore'] ?? 0;
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
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                _buildSafetyPill(safetyScore),
              ],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<_BusDriverAssignment>(
                    future: _driverAssignmentFuture(
                      busNumber: busNumber.toString(),
                      busId: busId,
                      fallbackDriverName: driverName.toString(),
                    ),
                    builder: (context, snapshot) {
                      final assignment = snapshot.data;
                      return _buildBusInfoTile(
                        icon: Icons.person_rounded,
                        label: 'Active driver',
                        value: assignment?.activeDriverName ??
                            driverName.toString(),
                        th: th,
                        isImportant: true,
                      );
                    },
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
            const SizedBox(height: AppDesign.spaceSM),
            FutureBuilder<_BusDriverAssignment>(
              future: _driverAssignmentFuture(
                busNumber: busNumber.toString(),
                busId: busId,
                fallbackDriverName: driverName.toString(),
              ),
              builder: (context, snapshot) {
                return _buildAssignedDriverChips(
                  th,
                  snapshot.data?.assignedDriverNames ?? const [],
                );
              },
            ),
          ],
        ),
      ),
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

  Widget _buildAssignedDriverChips(
    ThemeHelper th,
    List<String> driverNames,
  ) {
    if (driverNames.isEmpty) {
      return Text(
        'Assigned drivers: 0',
        style: AppTextStyles.bodySmall.copyWith(
          color: th.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Wrap(
      spacing: AppDesign.spaceSM,
      runSpacing: AppDesign.spaceSM,
      children: driverNames.map((driverName) {
        return Chip(
          avatar: const Icon(
            Icons.person_rounded,
            size: 15,
            color: AppColors.primaryColor,
          ),
          label: Text(driverName),
          labelStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.primaryColor.withOpacity(0.08),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusFull),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }

  Widget _buildSafetyPill(int score) {
    final color = _getSafetyScoreColor(score);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceSM,
        vertical: AppDesign.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: AppDesign.spaceXS),
          Text(
            '$score%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
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
                    fontWeight:
                        isImportant ? FontWeight.w700 : FontWeight.w500,
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

  Color _getSafetyScoreColor(int score) {
    if (score >= 90) return AppColors.successColor;
    if (score >= 75) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Future<_BusDriverAssignment> _driverAssignmentFuture({
    required String busNumber,
    required String? busId,
    required String fallbackDriverName,
  }) {
    final cacheKey = '$busNumber|${busId ?? ''}';
    return _driverAssignmentFutures.putIfAbsent(
      cacheKey,
      () => _loadDriverAssignment(
        busNumber: busNumber,
        busId: busId,
        fallbackDriverName: fallbackDriverName,
      ),
    );
  }

  Future<_BusDriverAssignment> _loadDriverAssignment({
    required String busNumber,
    required String? busId,
    required String fallbackDriverName,
  }) async {
    final driversById = <String, Map<String, dynamic>>{};
    final drivers = FirebaseFirestore.instance.collection('drivers');
    final busKeys = {
      if (busNumber.trim().isNotEmpty) busNumber.trim(),
      if (busId != null && busId.trim().isNotEmpty) busId.trim(),
    };

    Future<void> addQuery(Query<Map<String, dynamic>> query) async {
      final snapshot = await query.get();
      for (final doc in snapshot.docs) {
        driversById[doc.id] = {
          'id': doc.id,
          ...doc.data(),
        };
      }
    }

    for (final busKey in busKeys) {
      await addQuery(drivers.where('busNumber', isEqualTo: busKey));
      await addQuery(drivers.where('currentBusNumber', isEqualTo: busKey));
      await addQuery(drivers.where('currentBusId', isEqualTo: busKey));
      await addQuery(drivers.where('assignedBuses', arrayContains: busKey));
      await addQuery(
        drivers.where('assignedBusNumbers', arrayContains: busKey),
      );
    }

    final driverDocs = driversById.values.toList();
    final assignedNames = driverDocs
        .map(_driverNameFromData)
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    final activeDriver = driverDocs.cast<Map<String, dynamic>?>().firstWhere(
          (driver) => driver != null && _isOnDutyStatus(driver['status']),
          orElse: () => driverDocs.isNotEmpty ? driverDocs.first : null,
        );

    final fallback = fallbackDriverName.trim();
    final activeName = activeDriver == null
        ? (fallback.isEmpty || fallback.toUpperCase() == 'N/A'
            ? 'No active driver'
            : fallback)
        : _driverNameFromData(activeDriver);

    return _BusDriverAssignment(
      activeDriverName: activeName.isEmpty ? 'No active driver' : activeName,
      assignedDriverNames: assignedNames,
    );
  }

  String _driverNameFromData(Map<String, dynamic> data) {
    final direct = (data['name'] ?? data['driverName'] ?? '').toString().trim();
    if (direct.isNotEmpty) return direct;

    final firstName = (data['firstName'] ?? '').toString().trim();
    final lastName = (data['lastName'] ?? '').toString().trim();
    return '$firstName $lastName'.trim();
  }

  bool _isOnDutyStatus(Object? status) {
    final value = (status ?? '').toString().toLowerCase().replaceAll('_', '');
    return value == 'onduty' || value == 'active' || value == 'driving';
  }
}

class _BusDriverAssignment {
  final String activeDriverName;
  final List<String> assignedDriverNames;

  const _BusDriverAssignment({
    required this.activeDriverName,
    required this.assignedDriverNames,
  });
}
