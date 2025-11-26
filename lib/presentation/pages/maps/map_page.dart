import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo show LocationAccuracy;
import 'package:geolocator/geolocator.dart' hide LocationAccuracy;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with WidgetsBindingObserver {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;
  bool _showingBusStops = false;
  final bool _showingBusRoute = false;
  String? _searchedDestination;

  // Map types
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeMap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    _addSampleBusStops();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage =
              'Location services are disabled. Please enable location services.';
          _isLoading = false;
        });
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage =
                'Location permission denied. Please grant location access.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Location permissions are permanently denied. Please enable in settings.';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });

        _updateCurrentLocationMarker(position);
        _animateToPosition(position);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error getting location: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  void _updateCurrentLocationMarker(Position position) {
    _markers
        .removeWhere((marker) => marker.markerId.value == 'current_location');
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Current position',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    setState(() {});
  }

  void _animateToPosition(Position position) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16.0,
        ),
      );
    }
  }

  void _addSampleBusStops() {
    // This is now called when user clicks "Bus Stop" button
    // Will be implemented in _showBusStops method
  }

  void _showBusStops() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) return;
    }

    setState(() => _showingBusStops = true);

    // Clear existing bus stop markers
    _markers
        .removeWhere((marker) => marker.markerId.value.contains('bus_stop'));

    // Sample bus stops around current location (within ~2km radius)
    final busStops = _getBusStopsAroundLocation(_currentPosition!);

    for (var stop in busStops) {
      _markers.add(
        Marker(
          markerId: MarkerId('bus_stop_${stop['name']}'),
          position: LatLng(stop['lat'] as double, stop['lng'] as double),
          infoWindow: InfoWindow(
            title: stop['name'] as String,
            snippet: 'Bus Stop • ${stop['routes']}',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }

    setState(() => _showingBusStops = false);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found ${busStops.length} bus stops nearby'),
          backgroundColor: AppColors.successColor,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _getBusStopsAroundLocation(Position position) {
    // Generate bus stops within 2km of current location
    const baseLatOffset = 0.01; // ~1km
    const baseLngOffset = 0.01; // ~1km

    return [
      {
        'name': 'Main Bus Terminal',
        'lat': position.latitude + (baseLatOffset * 0.5),
        'lng': position.longitude + (baseLngOffset * 0.3),
        'routes': 'Routes 101, 105, 138'
      },
      {
        'name': 'Shopping Complex Stop',
        'lat': position.latitude - (baseLatOffset * 0.7),
        'lng': position.longitude + (baseLngOffset * 0.8),
        'routes': 'Routes 205, 220'
      },
      {
        'name': 'Hospital Junction',
        'lat': position.latitude + (baseLatOffset * 0.9),
        'lng': position.longitude - (baseLngOffset * 0.4),
        'routes': 'Routes 150, 176, 185'
      },
      {
        'name': 'University Gate',
        'lat': position.latitude - (baseLatOffset * 0.3),
        'lng': position.longitude - (baseLngOffset * 0.9),
        'routes': 'Routes 301, 307'
      },
      {
        'name': 'City Center Plaza',
        'lat': position.latitude + (baseLatOffset * 0.2),
        'lng': position.longitude + (baseLngOffset * 0.6),
        'routes': 'Routes 110, 125, 240'
      },
      {
        'name': 'Railway Station Stop',
        'lat': position.latitude - (baseLatOffset * 0.5),
        'lng': position.longitude + (baseLngOffset * 0.2),
        'routes': 'Routes 101, 138, 205'
      },
    ];
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _animateToPosition(_currentPosition!);
    }
  }

  void _searchPlaces() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      // Store the searched destination for navigation
      _searchedDestination = query;

      // Simulate place search - in real app, use Google Places API
      await Future.delayed(const Duration(seconds: 1));

      // Add a sample marker for searched location
      final searchLat = _currentPosition?.latitude ?? 6.9271;
      final searchLng = _currentPosition?.longitude ?? 79.8612;

      // Offset slightly to simulate different location
      final destinationLat = searchLat + 0.02;
      final destinationLng = searchLng + 0.015;

      _markers.removeWhere(
          (marker) => marker.markerId.value == 'search_destination');
      _markers.add(
        Marker(
          markerId: const MarkerId('search_destination'),
          position: LatLng(destinationLat, destinationLng),
          infoWindow: InfoWindow(
            title: query,
            snippet: 'Searched destination',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );

      // Animate to show both current location and destination
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                math.min(searchLat, destinationLat) - 0.005,
                math.min(searchLng, destinationLng) - 0.005,
              ),
              northeast: LatLng(
                math.max(searchLat, destinationLat) + 0.005,
                math.max(searchLng, destinationLng) + 0.005,
              ),
            ),
            100.0, // padding
          ),
        );
      }

      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Found "$query". Tap Navigate to see bus route!'),
            backgroundColor: AppColors.primaryColor,
            action: SnackBarAction(
              label: 'Navigate',
              textColor: Colors.white,
              onPressed: _navigateToDestination,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _showBusRoutes() {
    _showBusStops();
  }

  void _navigateToDestination() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to get current location'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
        return;
      }
    }

    if (_searchedDestination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please search for a destination first'),
          backgroundColor: AppColors.warningColor,
        ),
      );
      return;
    }

    setState(() => _showingBusRoute = true);

    // Clear existing route
    _polylines.removeWhere(
        (polyline) => polyline.polylineId.value.contains('bus_route'));

    // Get destination coordinates (from search marker)
    final destinationMarker = _markers.firstWhere(
      (marker) => marker.markerId.value == 'search_destination',
      orElse: () => throw StateError('Destination not found'),
    );

    final currentLatLng =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    final destinationLatLng = destinationMarker.position;

    // Create bus route with intermediate stops
    final busRoutePoints = _generateBusRoute(currentLatLng, destinationLatLng);

    // Add bus route polyline
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('bus_route_main'),
        points: busRoutePoints,
        color: AppColors.primaryColor,
        width: 5,
        patterns: [PatternItem.dot, PatternItem.gap(10)],
      ),
    );

    // Add bus stops along the route
    final routeStops = _getBusStopsAlongRoute(busRoutePoints);
    for (int i = 0; i < routeStops.length; i++) {
      final stop = routeStops[i];
      _markers.add(
        Marker(
          markerId: MarkerId('route_stop_$i'),
          position: LatLng(stop['lat'], stop['lng']),
          infoWindow: InfoWindow(
            title: stop['name'],
            snippet: 'Bus Stop • ${stop['busNumber']}',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    setState(() => _showingBusRoute = false);

    // Show route info
    if (mounted) {
      _showRouteInfoBottomSheet(routeStops);
    }
  }

  void _showRouteInfoBottomSheet(List<Map<String, dynamic>> stops) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.directions_bus,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bus Route to Destination',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total journey: ~25 mins',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bus stops list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: stops.length,
                itemBuilder: (context, index) {
                  final stop = stops[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stop['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                stop['busNumber'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          stop['arrivalTime'],
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LatLng> _generateBusRoute(LatLng start, LatLng end) {
    // Generate a realistic bus route with turns and intermediate points
    final points = <LatLng>[];
    points.add(start);

    // Add intermediate waypoints to simulate bus route
    final latDiff = end.latitude - start.latitude;
    final lngDiff = end.longitude - start.longitude;

    // Add waypoints with some realistic bus route deviations
    for (double i = 0.2; i < 1.0; i += 0.2) {
      final waypoint = LatLng(
        start.latitude +
            (latDiff * i) +
            (i * 0.002 * (i < 0.5 ? 1 : -1)), // slight curve
        start.longitude +
            (lngDiff * i) +
            (i * 0.001 * (i > 0.6 ? 1 : -1)), // another curve
      );
      points.add(waypoint);
    }

    points.add(end);
    return points;
  }

  List<Map<String, dynamic>> _getBusStopsAlongRoute(List<LatLng> routePoints) {
    // Generate bus stops along the route
    return [
      {
        'name': 'Starting Point Stop',
        'lat': routePoints[1].latitude,
        'lng': routePoints[1].longitude,
        'busNumber': 'Bus 138',
        'arrivalTime': '5 mins',
      },
      {
        'name': 'Midway Terminal',
        'lat': routePoints[routePoints.length ~/ 2].latitude,
        'lng': routePoints[routePoints.length ~/ 2].longitude,
        'busNumber': 'Bus 205',
        'arrivalTime': '12 mins',
      },
      {
        'name': 'Junction Stop',
        'lat': routePoints[routePoints.length - 2].latitude,
        'lng': routePoints[routePoints.length - 2].longitude,
        'busNumber': 'Bus 101',
        'arrivalTime': '18 mins',
      },
    ];
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _toggleTraffic() {
    setState(() {
      _trafficEnabled = !_trafficEnabled;
    });
  }

  void _centerOnLocation() {
    if (_currentPosition != null) {
      _animateToPosition(_currentPosition!);
    } else {
      _getCurrentLocation();
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
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
        decoration: InputDecoration(
          hintText: 'Search places, bus stops, routes...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
          suffixIcon: _isSearching
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => _searchController.clear(),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceLG,
            vertical: AppDesign.spaceMD,
          ),
        ),
        onSubmitted: (_) => _searchPlaces(),
      ),
    );
  }

  Widget _buildActionCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
      child: Row(
        children: [
          Expanded(
            child: _ActionCard(
              icon: Icons.directions_bus_rounded,
              title: 'Bus Routes',
              subtitle: 'Find nearby routes',
              color: AppColors.secondaryColor,
              onTap: _showBusRoutes,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: _ActionCard(
              icon: Icons.navigation_rounded,
              title: 'Navigate',
              subtitle: 'Get directions',
              color: AppColors.accentColor,
              onTap: _navigateToDestination,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      right: AppDesign.spaceLG,
      top: 120,
      child: Column(
        children: [
          _MapControlButton(
            icon:
                _currentMapType == MapType.normal ? Icons.satellite : Icons.map,
            onTap: _toggleMapType,
            tooltip: 'Toggle Map Type',
          ),
          const SizedBox(height: AppDesign.spaceSM),
          _MapControlButton(
            icon: Icons.traffic,
            onTap: _toggleTraffic,
            tooltip: 'Toggle Traffic',
            isActive: _trafficEnabled,
          ),
          const SizedBox(height: AppDesign.spaceSM),
          _MapControlButton(
            icon: Icons.my_location,
            onTap: _centerOnLocation,
            tooltip: 'Center on Location',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.space2XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Text(
              'Unable to load map',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            ElevatedButton(
              onPressed: () {
                _getCurrentLocation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryColor),
          SizedBox(height: AppDesign.spaceLG),
          Text(
            'Loading map...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Maps & Navigation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildActionCards(),
          const SizedBox(height: AppDesign.spaceLG),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                child: Stack(
                  children: [
                    if (_isLoading)
                      _buildLoadingState()
                    else if (_errorMessage != null)
                      _buildErrorState()
                    else
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition != null
                              ? LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude)
                              : const LatLng(
                                  6.9271, 79.8612), // Colombo default
                          zoom: 14.0,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        mapType: _currentMapType,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                        trafficEnabled: _trafficEnabled,
                        buildingsEnabled: true,
                        mapToolbarEnabled: false,
                      ),
                    if (!_isLoading && _errorMessage == null)
                      _buildMapControls(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: AppDesign.spaceSM),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool isActive;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : AppColors.primaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}
