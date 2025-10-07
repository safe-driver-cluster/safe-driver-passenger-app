import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/hazard_zone_model.dart';
import '../../../data/repositories/hazard_zone_repository.dart';
import '../../widgets/common/loading_widget.dart';

class HazardZoneIntelligencePage extends ConsumerStatefulWidget {
  final String? currentBusId;
  final String? currentDriverId;

  const HazardZoneIntelligencePage({
    super.key,
    this.currentBusId,
    this.currentDriverId,
  });

  @override
  ConsumerState<HazardZoneIntelligencePage> createState() =>
      _HazardZoneIntelligencePageState();
}

class _HazardZoneIntelligencePageState
    extends ConsumerState<HazardZoneIntelligencePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GoogleMapController _mapController;
  final HazardZoneRepository _hazardZoneRepository = HazardZoneRepository();

  List<HazardZone> _allHazardZones = [];
  List<HazardZone> _nearbyHazardZones = [];
  List<HazardAlert> _hazardAlerts = [];
  geo.Position? _currentPosition;
  bool _isLoading = true;
  String? _error;

  final Set<Marker> _markers = <Marker>{};
  final Set<Circle> _circles = <Circle>{};
  final Set<Polygon> _polygons = <Polygon>{};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(14.5995, 120.9842), // Manila, Philippines default
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get current location
      await _getCurrentLocation();

      // Load hazard zones
      await _loadHazardZones();

      // Load alerts if driver ID is provided
      if (widget.currentDriverId != null) {
        await _loadHazardAlerts();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        await geo.Geolocator.requestPermission();
      }

      _currentPosition = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Use default location if can't get current location
    }
  }

  Future<void> _loadHazardZones() async {
    _allHazardZones = await _hazardZoneRepository.getAllActiveHazardZones();

    if (_currentPosition != null) {
      _nearbyHazardZones =
          await _hazardZoneRepository.getHazardZonesNearLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        10.0, // 10 km radius
      );
    }

    _updateMapElements();
  }

  Future<void> _loadHazardAlerts() async {
    if (widget.currentDriverId != null) {
      _hazardAlerts = await _hazardZoneRepository
          .getHazardAlertsForDriver(widget.currentDriverId!);
    }
  }

  void _updateMapElements() {
    _markers.clear();
    _circles.clear();
    _polygons.clear();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    // Add hazard zone markers and zones
    for (final hazard in _allHazardZones) {
      if (hazard.coordinates.isNotEmpty) {
        final position = LatLng(
          hazard.coordinates.first.latitude,
          hazard.coordinates.first.longitude,
        );

        // Add marker
        _markers.add(
          Marker(
            markerId: MarkerId(hazard.id),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                _getHazardColor(hazard.severity)),
            infoWindow: InfoWindow(
              title: hazard.name,
              snippet:
                  '${hazard.type.displayName} - ${hazard.severity.displayName}',
            ),
            onTap: () => _showHazardDetails(hazard),
          ),
        );

        // Add circle for single point hazards
        if (hazard.coordinates.length == 1) {
          _circles.add(
            Circle(
              circleId: CircleId(hazard.id),
              center: position,
              radius: hazard.radius,
              fillColor: _getSeverityColor(hazard.severity).withOpacity(0.2),
              strokeColor: _getSeverityColor(hazard.severity),
              strokeWidth: 2,
            ),
          );
        } else {
          // Add polygon for multi-point hazards
          _polygons.add(
            Polygon(
              polygonId: PolygonId(hazard.id),
              points: hazard.coordinates
                  .map((coord) => LatLng(coord.latitude, coord.longitude))
                  .toList(),
              fillColor: _getSeverityColor(hazard.severity).withOpacity(0.2),
              strokeColor: _getSeverityColor(hazard.severity),
              strokeWidth: 2,
            ),
          );
        }
      }
    }
  }

  double _getHazardColor(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.low:
        return BitmapDescriptor.hueGreen;
      case SeverityLevel.medium:
        return BitmapDescriptor.hueYellow;
      case SeverityLevel.high:
        return BitmapDescriptor.hueOrange;
      case SeverityLevel.critical:
        return BitmapDescriptor.hueRed;
    }
  }

  Color _getSeverityColor(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.low:
        return AppColors.successColor;
      case SeverityLevel.medium:
        return AppColors.warningColor;
      case SeverityLevel.high:
        return Colors.orange;
      case SeverityLevel.critical:
        return AppColors.errorColor;
    }
  }

  void _showHazardDetails(HazardZone hazard) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  hazard.type.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hazard.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${hazard.type.displayName} - ${hazard.severity.displayName}',
                        style: TextStyle(
                          color: _getSeverityColor(hazard.severity),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              hazard.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Created: ${_formatDate(hazard.createdAt)}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            if (hazard.reportedBy != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Reported by: ${hazard.reportedBy}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Zone Intelligence'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.map), text: 'Map'),
            Tab(icon: Icon(Icons.warning), text: 'Nearby'),
            Tab(icon: Icon(Icons.notifications), text: 'Alerts'),
            Tab(icon: Icon(Icons.analytics), text: 'Statistics'),
          ],
        ),
      ),
      body: _isLoading
          ? const LoadingWidget(
              isLoading: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading hazard zone data...'),
                  ],
                ),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.errorColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading hazard zones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _initializeData,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMapTab(),
                    _buildNearbyTab(),
                    _buildAlertsTab(),
                    _buildStatisticsTab(),
                  ],
                ),
    );
  }

  Widget _buildMapTab() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        if (_currentPosition != null) {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            ),
          );
        }
      },
      initialCameraPosition: _currentPosition != null
          ? CameraPosition(
              target: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 14,
            )
          : _initialPosition,
      markers: _markers,
      circles: _circles,
      polygons: _polygons,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: true,
    );
  }

  Widget _buildNearbyTab() {
    return RefreshIndicator(
      onRefresh: _initializeData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _nearbyHazardZones.length,
        itemBuilder: (context, index) {
          final hazard = _nearbyHazardZones[index];
          final distance = _currentPosition != null
              ? geo.Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  hazard.coordinates.first.latitude,
                  hazard.coordinates.first.longitude,
                )
              : 0.0;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getSeverityColor(hazard.severity),
                child: Text(
                  hazard.type.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              title: Text(
                hazard.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${hazard.type.displayName} - ${hazard.severity.displayName}',
                    style: TextStyle(
                      color: _getSeverityColor(hazard.severity),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Distance: ${(distance / 1000).toStringAsFixed(1)} km',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
              ),
              onTap: () => _showHazardDetails(hazard),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlertsTab() {
    if (widget.currentDriverId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64),
            SizedBox(height: 16),
            Text('Driver ID required to view alerts'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHazardAlerts,
      child: _hazardAlerts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64),
                  SizedBox(height: 16),
                  Text('No active hazard alerts'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _hazardAlerts.length,
              itemBuilder: (context, index) {
                final alert = _hazardAlerts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: _getAlertColor(alert.alertType).withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(
                      _getAlertIcon(alert.alertType),
                      color: _getAlertColor(alert.alertType),
                    ),
                    title: Text(
                      alert.message,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Time: ${_formatDate(alert.timestamp)}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await _hazardZoneRepository
                            .acknowledgeHazardAlert(alert.id);
                        await _loadHazardAlerts();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: const Text('Acknowledge'),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatisticsTab() {
    final criticalCount = _allHazardZones
        .where((h) => h.severity == SeverityLevel.critical)
        .length;
    final highCount =
        _allHazardZones.where((h) => h.severity == SeverityLevel.high).length;
    final mediumCount =
        _allHazardZones.where((h) => h.severity == SeverityLevel.medium).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hazard Zone Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Total',
                        _allHazardZones.length.toString(),
                        AppColors.primaryColor,
                        Icons.location_on,
                      ),
                      _buildStatCard(
                        'Critical',
                        criticalCount.toString(),
                        AppColors.errorColor,
                        Icons.priority_high,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'High',
                        highCount.toString(),
                        Colors.orange,
                        Icons.warning,
                      ),
                      _buildStatCard(
                        'Medium',
                        mediumCount.toString(),
                        AppColors.warningColor,
                        Icons.info,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hazard Types',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...HazardType.values.map((type) {
                    final count =
                        _allHazardZones.where((h) => h.type == type).length;
                    return ListTile(
                      leading: Text(
                        type.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(type.displayName),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          count.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAlertColor(AlertType alertType) {
    switch (alertType) {
      case AlertType.info:
        return AppColors.primaryColor;
      case AlertType.warning:
        return AppColors.warningColor;
      case AlertType.danger:
        return Colors.orange;
      case AlertType.critical:
        return AppColors.errorColor;
    }
  }

  IconData _getAlertIcon(AlertType alertType) {
    switch (alertType) {
      case AlertType.info:
        return Icons.info;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.danger:
        return Icons.dangerous;
      case AlertType.critical:
        return Icons.priority_high;
    }
  }
}
