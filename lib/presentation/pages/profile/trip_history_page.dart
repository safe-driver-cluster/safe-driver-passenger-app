import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../widgets/common/custom_back_button.dart';

class TripHistoryPage extends StatefulWidget {
  const TripHistoryPage({super.key});

  @override
  State<TripHistoryPage> createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
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
                child: _buildTripList(th),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeHelper th, AppLocalizations l10n) {
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const CustomBackButton(color: Colors.white),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                l10n.tripHistory,
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
                setState(() => _searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Search by bus, route, driver...',
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
                          setState(() => _searchQuery = '');
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

  Widget _buildTripList(ThemeHelper th) {
    final userId =
        FirebaseService.instance.currentUser?.uid ?? 'current_user_id';

    return StreamBuilder(
      stream: FirebaseService.instance.firestore
          .collection('journeys')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildMessageState(
            th,
            Icons.error_outline_rounded,
            'Unable to load trips',
            snapshot.error.toString(),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          );
        }

        final journeys = (snapshot.data?.docs ?? [])
            .map((doc) => {
                  ...doc.data(),
                  'id': doc.id,
                })
            .where((journey) => journey['status'] == 'completed')
            .toList()
          ..sort((a, b) => _journeySortTime(b).compareTo(_journeySortTime(a)));

        final filteredJourneys = journeys.where(_matchesSearch).toList();

        if (journeys.isEmpty) {
          return _buildMessageState(
            th,
            Icons.history_rounded,
            'No completed trips yet',
            'End an active journey to see it here.',
          );
        }

        if (filteredJourneys.isEmpty) {
          return _buildMessageState(
            th,
            Icons.search_off_rounded,
            'No trips found',
            'Try another bus, route, or driver name.',
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          children: [
            _buildSummary(th, journeys),
            const SizedBox(height: AppDesign.spaceMD),
            ...filteredJourneys.map(
              (journey) => Padding(
                padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
                child: _buildTripCard(context, th, journey),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _matchesSearch(Map<String, dynamic> journey) {
    if (_searchQuery.isEmpty) return true;

    final values = [
      journey['busNumber'],
      journey['routeNumber'],
      journey['driverName'],
      journey['status'],
    ].map((value) => (value ?? '').toString().toLowerCase());

    return values.any((value) => value.contains(_searchQuery));
  }

  DateTime _journeySortTime(Map<String, dynamic> journey) {
    return _readDate(
          journey['endedAt'] ?? journey['startedAt'] ?? journey['createdAt'],
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  Widget _buildSummary(ThemeHelper th, List<Map<String, dynamic>> journeys) {
    final thisMonth = journeys.where((journey) {
      final endedAt = _readDate(journey['endedAt']);
      final now = DateTime.now();
      return endedAt != null &&
          endedAt.year == now.year &&
          endedAt.month == now.month;
    }).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Travel Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildSummaryTile(
                  '${journeys.length}', 'Completed', Icons.check_circle),
              const SizedBox(width: 10),
              _buildSummaryTile(
                  '$thisMonth', 'This Month', Icons.calendar_month),
              const SizedBox(width: 10),
              _buildSummaryTile(
                '${journeys.length - thisMonth}',
                'Earlier',
                Icons.history_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTile(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.16)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(
    BuildContext context,
    ThemeHelper th,
    Map<String, dynamic> journey,
  ) {
    final busNumber = (journey['busNumber'] ?? 'N/A').toString();
    final routeNumber = (journey['routeNumber'] ?? '').toString();
    final driverName = (journey['driverName'] ?? '').toString();
    final startedAt = _readDate(journey['startedAt'] ?? journey['createdAt']);
    final endedAt = _readDate(journey['endedAt'] ?? journey['updatedAt']);
    final duration = _formatDuration(startedAt, endedAt);
    final routeText = routeNumber.trim().isEmpty
        ? 'Route details unavailable'
        : 'Route $routeNumber';
    final driverText =
        driverName.trim().isEmpty ? 'Driver not assigned' : driverName;

    return Container(
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: th.border),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bus $busNumber',
                        style: TextStyle(
                          color: th.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        routeText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: th.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 14),
            _buildInfoRow(
              th,
              Icons.person_outline,
              'Driver',
              driverText,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              th,
              Icons.play_circle_outline,
              'Started',
              _formatDateTime(context, startedAt),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              th,
              Icons.stop_circle_outlined,
              'Ended',
              _formatDateTime(context, endedAt),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              th,
              Icons.timer_outlined,
              'Duration',
              duration,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showTripDetails(context, th, journey),
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text('Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: const BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'COMPLETED',
        style: TextStyle(
          color: Colors.green.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeHelper th,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: th.textSecondary, size: 17),
        const SizedBox(width: 8),
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: TextStyle(
              color: th.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: th.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageState(
    ThemeHelper th,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: th.textSecondary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: th.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: th.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTripDetails(
    BuildContext context,
    ThemeHelper th,
    Map<String, dynamic> journey,
  ) {
    final startedAt = _readDate(journey['startedAt'] ?? journey['createdAt']);
    final endedAt = _readDate(journey['endedAt'] ?? journey['updatedAt']);

    showModalBottomSheet(
      context: context,
      backgroundColor: th.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Details',
                  style: TextStyle(
                    color: th.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                    th, 'Trip ID', journey['id']?.toString() ?? 'N/A'),
                _buildDetailRow(
                    th, 'Bus', journey['busNumber']?.toString() ?? 'N/A'),
                _buildDetailRow(
                  th,
                  'Route',
                  journey['routeNumber']?.toString().isNotEmpty == true
                      ? 'Route ${journey['routeNumber']}'
                      : 'Route details unavailable',
                ),
                _buildDetailRow(
                  th,
                  'Driver',
                  journey['driverName']?.toString().isNotEmpty == true
                      ? journey['driverName'].toString()
                      : 'Driver not assigned',
                ),
                _buildDetailRow(
                    th, 'Started', _formatDateTime(context, startedAt)),
                _buildDetailRow(th, 'Ended', _formatDateTime(context, endedAt)),
                _buildDetailRow(
                    th, 'Duration', _formatDuration(startedAt, endedAt)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(ThemeHelper th, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: TextStyle(
                color: th.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: th.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    try {
      final toDate = value.toDate;
      if (toDate is Function) return toDate() as DateTime;
    } catch (_) {
      // Fall through to string parsing.
    }

    return DateTime.tryParse(value.toString());
  }

  String _formatDateTime(BuildContext context, DateTime? value) {
    if (value == null) return 'Not available';
    final local = value.toLocal();
    final material = MaterialLocalizations.of(context);
    final date = material.formatMediumDate(local);
    final time = material.formatTimeOfDay(TimeOfDay.fromDateTime(local));
    return '$date, $time';
  }

  String _formatDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 'Not available';
    final duration = end.difference(start);
    if (duration.inMinutes < 1) return 'Less than 1 min';
    if (duration.inHours < 1) return '${duration.inMinutes} min';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (minutes == 0) return '$hours hr';
    return '$hours hr $minutes min';
  }
}
