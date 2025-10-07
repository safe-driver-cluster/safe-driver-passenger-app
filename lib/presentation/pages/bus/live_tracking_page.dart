import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/bus_model.dart';
import '../../../data/repositories/bus_repository.dart';

class LiveTrackingPage extends ConsumerStatefulWidget {
  final String busId;
  final String? busNumber;
  final String? routeNumber;

  const LiveTrackingPage({
    super.key,
    required this.busId,
    this.busNumber,
    this.routeNumber,
  });

  @override
  ConsumerState<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends ConsumerState<LiveTrackingPage> {
  GoogleMapController? _mapController;
  StreamSubscription<BusModel?>? _busLocationSubscription;
  StreamSubscription<geo.Position>? _userLocationSubscription;

  BusModel? _currentBus;
  geo.Position? _userLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = true;
  bool _followBus = true;
  bool _showRoute = true;

  // Default camera position (Colombo, Sri Lanka)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  @override
  void dispose() {
    _busLocationSubscription?.cancel();
    _userLocationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeTracking() async {
    await _requestLocationPermission();
    _startUserLocationTracking();
    _startBusTracking();
  }

  Future<void> _requestLocationPermission() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
    }
  }

  void _startUserLocationTracking() {
    _userLocationSubscription = geo.Geolocator.getPositionStream(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      setState(() {
        _userLocation = position;
        _updateMarkers();
      });
    });
  }

  void _startBusTracking() {
    final busRepository = BusRepository();
    _busLocationSubscription =
        busRepository.getBusLocationStream(widget.busId).listen((bus) {
      if (bus != null) {
        setState(() {
          _currentBus = bus;
          _isLoading = false;
          _updateMarkers();
          _updateRoute();

          if (_followBus &&
              _mapController != null &&
              bus.currentLocation != null) {
            _animateToLocation(
              bus.currentLocation!.latitude,
              bus.currentLocation!.longitude,
            );
          }
        });
      }
    });
  }

  void _updateMarkers() {
    _markers.clear();

    // Add user location marker
    if (_userLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(_userLocation!.latitude, _userLocation!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
        ),
      );
    }

    // Add bus marker
    if (_currentBus?.currentLocation != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('bus_${widget.busId}'),
          position: LatLng(
            _currentBus!.currentLocation!.latitude,
            _currentBus!.currentLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Bus ${widget.busNumber ?? _currentBus!.busNumber}',
            snippet:
                'Route ${widget.routeNumber ?? _currentBus!.routeNumber} • ${_currentBus!.currentSpeed?.toStringAsFixed(1) ?? '0'} km/h',
          ),
          rotation: _currentBus?.heading ?? 0.0,
        ),
      );
    }
  }

  void _updateRoute() {
    if (!_showRoute) {
      _polylines.clear();
      return;
    }

    // In a real app, you would fetch the actual route from your backend
    // For now, we'll create a simple polyline if both locations are available
    if (_userLocation != null && _currentBus?.currentLocation != null) {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [
            LatLng(_userLocation!.latitude, _userLocation!.longitude),
            LatLng(
              _currentBus!.currentLocation!.latitude,
              _currentBus!.currentLocation!.longitude,
            ),
          ],
          color: AppColors.primaryColor,
          width: 3,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }
  }

  void _animateToLocation(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
  }

  void _zoomToFitBounds() {
    if (_userLocation != null && _currentBus?.currentLocation != null) {
      final userLat = _userLocation!.latitude;
      final userLng = _userLocation!.longitude;
      final busLat = _currentBus!.currentLocation!.latitude;
      final busLng = _currentBus!.currentLocation!.longitude;

      final minLat = userLat < busLat ? userLat : busLat;
      final maxLat = userLat > busLat ? userLat : busLat;
      final minLng = userLng < busLng ? userLng : busLng;
      final maxLng = userLng > busLng ? userLng : busLng;

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    }
  }

  String _getStatusText() {
    if (_currentBus == null) return 'Loading...';

    switch (_currentBus!.status) {
      case BusStatus.online:
        return 'Online';
      case BusStatus.inTransit:
        return 'In Transit';
      case BusStatus.atStop:
        return 'At Stop';
      case BusStatus.offline:
        return 'Offline';
      case BusStatus.emergency:
        return 'Emergency';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor() {
    if (_currentBus == null) return AppColors.greyMedium;

    switch (_currentBus!.status) {
      case BusStatus.online:
      case BusStatus.inTransit:
        return AppColors.successColor;
      case BusStatus.atStop:
        return AppColors.warningColor;
      case BusStatus.offline:
        return AppColors.greyMedium;
      case BusStatus.emergency:
        return AppColors.errorColor;
      default:
        return AppColors.greyMedium;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Live Tracking'),
            if (widget.busNumber != null)
              Text(
                'Bus ${widget.busNumber} • Route ${widget.routeNumber ?? 'Unknown'}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon:
                Icon(_followBus ? Icons.my_location : Icons.location_disabled),
            onPressed: () {
              setState(() {
                _followBus = !_followBus;
              });
              if (_followBus && _currentBus?.currentLocation != null) {
                _animateToLocation(
                  _currentBus!.currentLocation!.latitude,
                  _currentBus!.currentLocation!.longitude,
                );
              }
            },
            tooltip: _followBus ? 'Stop following bus' : 'Follow bus',
          ),
          IconButton(
            icon: const Icon(Icons.fit_screen),
            onPressed: _zoomToFitBounds,
            tooltip: 'Fit to screen',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      _showRoute ? Icons.route : Icons.route_outlined,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(_showRoute ? 'Hide Route' : 'Show Route'),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _showRoute = !_showRoute;
                    _updateRoute();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading bus location...'),
                ],
              ),
            )
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  trafficEnabled: true,
                  buildingsEnabled: true,
                  mapType: MapType.normal,
                ),

                // Bus Information Card
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_bus,
                                color: AppColors.primaryColor,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bus ${widget.busNumber ?? _currentBus?.busNumber ?? 'Unknown'}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Route ${widget.routeNumber ?? _currentBus?.routeNumber ?? 'Unknown'}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _getStatusText(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_currentBus != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '${_currentBus!.currentSpeed?.toStringAsFixed(1) ?? '0'} km/h',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const Text(
                                      'Speed',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '${_currentBus!.safetyScore.toInt()}%',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _currentBus!.safetyScore > 80
                                            ? AppColors.successColor
                                            : _currentBus!.safetyScore > 60
                                                ? AppColors.warningColor
                                                : AppColors.errorColor,
                                      ),
                                    ),
                                    const Text(
                                      'Safety Score',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_currentBus!.driverName != null)
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                                      Text(
                                        _currentBus!.driverName!
                                            .split(' ')
                                            .first,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Emergency Button
                if (_currentBus?.status == BusStatus.emergency)
                  Positioned(
                    bottom: 100,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.errorColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Emergency Alert',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'This bus is in emergency mode',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle emergency contact
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Emergency Contact'),
                                  content: const Text(
                                    'Would you like to contact emergency services?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Implement emergency contact functionality
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.errorColor,
                                      ),
                                      child: const Text(
                                        'Call 911',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Help',
                              style: TextStyle(color: AppColors.errorColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
