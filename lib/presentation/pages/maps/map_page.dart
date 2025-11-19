import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

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

  // Map types
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;
  
  // Location tracking
  bool _isTrackingLocation = false;

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
          _errorMessage = 'Location services are disabled. Please enable location services.';
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
            _errorMessage = 'Location permission denied. Please grant location access.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied. Please enable in settings.';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
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
    _markers.removeWhere((marker) => marker.markerId.value == 'current_location');
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
    // Add some sample bus stops around Colombo
    final busStops = [
      {'name': 'Fort Railway Station', 'lat': 6.9344, 'lng': 79.8428},
      {'name': 'Pettah Bus Stand', 'lat': 6.9367, 'lng': 79.8505},
      {'name': 'Town Hall', 'lat': 6.9147, 'lng': 79.8774},
      {'name': 'Bambalapitiya Junction', 'lat': 6.8918, 'lng': 79.8509},
      {'name': 'Kollupitiya Junction', 'lat': 6.9069, 'lng': 79.8562},
    ];

    for (var stop in busStops) {
      _markers.add(
        Marker(
          markerId: MarkerId(stop['name'] as String),
          position: LatLng(stop['lat'] as double, stop['lng'] as double),
          infoWindow: InfoWindow(
            title: stop['name'] as String,
            snippet: 'Bus Stop',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    setState(() {});
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
      // TODO: Implement actual place search with Google Places API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Searching for "$query"...'),
            backgroundColor: AppColors.primaryColor,
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
    // TODO: Implement bus routes display
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bus routes feature coming soon!'),
        backgroundColor: AppColors.warningColor,
      ),
    );
  }

  void _navigateToDestination() {
    // TODO: Implement navigation functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation feature coming soon!'),
        backgroundColor: AppColors.successColor,
      ),
    );
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
          prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
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
            icon: _currentMapType == MapType.normal ? Icons.satellite : Icons.map,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryColor),
          const SizedBox(height: AppDesign.spaceLG),
          const Text(
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
                              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                              : const LatLng(6.9271, 79.8612), // Colombo default
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