import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo show LocationAccuracy;
import 'package:geolocator/geolocator.dart' hide LocationAccuracy;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/google_places_service.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with WidgetsBindingObserver {
  // ── Controllers ──
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;

  // ── Map state ──
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;

  // ── Location state ──
  bool _isLoadingLocation = true;
  String? _locationError;

  // ── Search state ──
  final GooglePlacesService _placesService = GooglePlacesService();
  List<Prediction> _suggestions = [];
  bool _showSuggestions = false;
  bool _isSearching = false;

  // ── Destination state ──
  LatLng? _destinationLatLng;
  String? _destinationName;

  // ── Navigation state ──
  bool _isLoadingRoutes = false;
  List<DirectionsResult> _allRoutes = [];
  int _selectedRouteIndex = 0;
  bool _showRouteDetails = false;

  // ── Colors for alternative routes ──
  static const List<Color> _routeColors = [
    Color(0xFF1A73E8), // Google blue (selected)
    Color(0xFF9AA0A6), // grey alternative
    Color(0xFFBDC1C6), // lighter grey
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // Location
  // ═══════════════════════════════════════════════════════════

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoadingLocation = true;
        _locationError = null;
      });

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services disabled. Please enable GPS.';
          _isLoadingLocation = false;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permission denied.';
            _isLoadingLocation = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError =
              'Location permanently denied. Enable in device settings.';
          _isLoadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
      _animateTo(LatLng(position.latitude, position.longitude), zoom: 15);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationError = 'Could not get location.';
        _isLoadingLocation = false;
      });
    }
  }

  void _animateTo(LatLng target, {double zoom = 15}) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, zoom));
  }

  void _fitBounds(LatLngBounds bounds) {
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  // ═══════════════════════════════════════════════════════════
  // Search / Autocomplete
  // ═══════════════════════════════════════════════════════════

  void _onSearchChanged(String input) {
    _debounce?.cancel();
    if (input.trim().length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final results = await _placesService.autocomplete(
          input,
          location: _currentPosition != null
              ? LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude)
              : null,
        );
        if (!mounted) return;
        setState(() {
          _suggestions = results;
          _showSuggestions = results.isNotEmpty;
        });
      } catch (_) {}
    });
  }

  Future<void> _selectSuggestion(Prediction p) async {
    _searchFocus.unfocus();
    setState(() {
      _isSearching = true;
      _showSuggestions = false;
      _searchController.text = p.mainText ?? p.description;
    });

    try {
      final latLng = await _placesService.getPlaceLatLng(p.placeId);
      if (!mounted) return;

      _setDestination(latLng, p.mainText ?? p.description);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Place lookup failed');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // Destination & Navigation
  // ═══════════════════════════════════════════════════════════

  void _setDestination(LatLng latLng, String name) {
    setState(() {
      _destinationLatLng = latLng;
      _destinationName = name;
      _allRoutes = [];
      _selectedRouteIndex = 0;
      _showRouteDetails = false;
      _polylines.clear();

      // Remove old destination marker
      _markers.removeWhere((m) => m.markerId.value != 'current_location');

      _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: latLng,
        infoWindow: InfoWindow(title: name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });

    // Zoom to show both origin and destination
    if (_currentPosition != null) {
      final bounds = _boundsFromLatLngs([
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        latLng,
      ]);
      _fitBounds(bounds);
    } else {
      _animateTo(latLng, zoom: 15);
    }
  }

  Future<void> _fetchRoutes() async {
    if (_currentPosition == null || _destinationLatLng == null) return;

    setState(() => _isLoadingRoutes = true);

    final origin =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    final destination = _destinationLatLng!;

    try {
      final routes =
          await _placesService.getMultiModeDirections(origin, destination);

      if (!mounted) return;

      if (routes.isEmpty) {
        _showSnack('No routes found for this destination');
        setState(() => _isLoadingRoutes = false);
        return;
      }

      // Find the first transit (bus) route and make it default
      int defaultIndex = 0;
      for (int i = 0; i < routes.length; i++) {
        if (routes[i].mode == TravelMode.transit) {
          defaultIndex = i;
          break;
        }
      }

      setState(() {
        _allRoutes = routes;
        _selectedRouteIndex = defaultIndex;
        _isLoadingRoutes = false;
        _showRouteDetails = true;
      });

      _drawRoutes();
      _addBusStopMarkers();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Failed to get directions');
      setState(() => _isLoadingRoutes = false);
    }
  }

  void _drawRoutes() {
    _polylines.clear();
    // Remove bus-stop markers from previous routes
    _markers.removeWhere(
        (m) => m.markerId.value.startsWith('bus_stop_route_'));

    for (int i = _allRoutes.length - 1; i >= 0; i--) {
      final route = _allRoutes[i];
      final isSelected = i == _selectedRouteIndex;
      final points =
          GooglePlacesService.decodePolyline(route.overviewPolyline);

      _polylines.add(Polyline(
        polylineId: PolylineId('route_$i'),
        points: points,
        color: isSelected ? _routeColors[0] : _routeColors[math.min(i, 2)],
        width: isSelected ? 6 : 4,
        zIndex: isSelected ? 10 : 1,
        patterns: route.mode == TravelMode.walking
            ? [PatternItem.dot, PatternItem.gap(8)]
            : [],
      ));
    }

    // Fit bounds to selected route
    if (_allRoutes.isNotEmpty) {
      final sel = _allRoutes[_selectedRouteIndex];
      final pts = GooglePlacesService.decodePolyline(sel.overviewPolyline);
      if (pts.isNotEmpty) {
        _fitBounds(_boundsFromLatLngs(pts));
      }
    }

    setState(() {});
  }

  void _selectRoute(int index) {
    setState(() => _selectedRouteIndex = index);
    _drawRoutes();
    _addBusStopMarkers();
  }

  // ═══════════════════════════════════════════════════════════
  // Bus stop markers along the selected transit route
  // ═══════════════════════════════════════════════════════════

  void _addBusStopMarkers() {
    // Remove old bus stop markers
    _markers.removeWhere(
        (m) => m.markerId.value.startsWith('bus_stop_route_'));

    if (_allRoutes.isEmpty) return;
    final route = _allRoutes[_selectedRouteIndex];
    if (route.mode != TravelMode.transit) return;

    int stopIdx = 0;
    for (final step in route.steps) {
      if (step.travelMode == 'TRANSIT') {
        // departure stop
        if (step.departureStop != null) {
          _markers.add(Marker(
            markerId: MarkerId('bus_stop_route_dep_$stopIdx'),
            position: step.startLocation,
            infoWindow: InfoWindow(
              title: step.departureStop!,
              snippet: step.lineShortName != null
                  ? 'Bus ${step.lineShortName}'
                  : 'Bus stop',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ));
          stopIdx++;
        }
        // arrival stop
        if (step.arrivalStop != null) {
          _markers.add(Marker(
            markerId: MarkerId('bus_stop_route_arr_$stopIdx'),
            position: step.endLocation,
            infoWindow: InfoWindow(
              title: step.arrivalStop!,
              snippet: step.lineShortName != null
                  ? 'Bus ${step.lineShortName}'
                  : 'Bus stop',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ));
          stopIdx++;
        }
      }
    }
    setState(() {});
  }

  // ═══════════════════════════════════════════════════════════
  // Clear / Reset
  // ═══════════════════════════════════════════════════════════

  void _clearSearch() {
    _searchController.clear();
    _searchFocus.unfocus();
    setState(() {
      _suggestions = [];
      _showSuggestions = false;
      _destinationLatLng = null;
      _destinationName = null;
      _allRoutes = [];
      _selectedRouteIndex = 0;
      _showRouteDetails = false;
      _polylines.clear();
      _markers.removeWhere((m) => m.markerId.value != 'current_location');
    });

    if (_currentPosition != null) {
      _animateTo(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════════

  LatLngBounds _boundsFromLatLngs(List<LatLng> points) {
    double south = points.first.latitude;
    double north = points.first.latitude;
    double west = points.first.longitude;
    double east = points.first.longitude;
    for (final p in points) {
      if (p.latitude < south) south = p.latitude;
      if (p.latitude > north) north = p.latitude;
      if (p.longitude < west) west = p.longitude;
      if (p.longitude > east) east = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  IconData _modeIcon(TravelMode mode) {
    switch (mode) {
      case TravelMode.transit:
        return Icons.directions_bus;
      case TravelMode.driving:
        return Icons.directions_car;
      case TravelMode.walking:
        return Icons.directions_walk;
      case TravelMode.bicycling:
        return Icons.directions_bike;
    }
  }

  String _modeLabel(TravelMode mode) {
    switch (mode) {
      case TravelMode.transit:
        return 'Bus';
      case TravelMode.driving:
        return 'Car';
      case TravelMode.walking:
        return 'Walk';
      case TravelMode.bicycling:
        return 'Bike';
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Full-screen Google Map ──
          _buildMap(),

          // ── Search bar (top) ──
          _buildSearchBar(),

          // ── Map controls (right side) ──
          _buildMapControls(),

          // ── My-location FAB ──
          Positioned(
            right: 16,
            bottom: _showRouteDetails ? 340 : (_destinationLatLng != null ? 120 : 24),
            child: FloatingActionButton.small(
              heroTag: 'myLocation',
              backgroundColor: Colors.white,
              onPressed: () {
                if (_currentPosition != null) {
                  _animateTo(LatLng(_currentPosition!.latitude,
                      _currentPosition!.longitude));
                } else {
                  _getCurrentLocation();
                }
              },
              child: const Icon(Icons.my_location, color: Color(0xFF1A73E8)),
            ),
          ),

          // ── Navigate button (when destination set but no routes yet) ──
          if (_destinationLatLng != null && _allRoutes.isEmpty)
            _buildNavigateButton(),

          // ── Route details bottom sheet ──
          if (_showRouteDetails && _allRoutes.isNotEmpty) _buildRouteSheet(),

          // ── Loading overlay ──
          if (_isLoadingRoutes)
            Container(
              color: Colors.black26,
              child: const Center(
                child:
                    CircularProgressIndicator(color: Color(0xFF1A73E8)),
              ),
            ),
        ],
      ),
    );
  }

  // ───────────── Map ─────────────

  Widget _buildMap() {
    if (_isLoadingLocation) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF1A73E8)),
            SizedBox(height: 16),
            Text('Getting your location...'),
          ],
        ),
      );
    }

    if (_locationError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(_locationError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final initialTarget = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : const LatLng(6.9271, 79.8612);

    return GoogleMap(
      onMapCreated: (c) {
        _mapController = c;
        if (_currentPosition != null) {
          _animateTo(LatLng(
              _currentPosition!.latitude, _currentPosition!.longitude));
        }
      },
      initialCameraPosition:
          CameraPosition(target: initialTarget, zoom: 15),
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
      onTap: (_) {
        if (_showSuggestions) {
          setState(() => _showSuggestions = false);
        }
        _searchFocus.unfocus();
      },
    );
  }

  // ───────────── Search bar ─────────────

  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 12,
      right: 12,
      child: Column(
        children: [
          // Main search card
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(28),
            color: Colors.white,
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                // Search field
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search here',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade500, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: _clearSearch,
                  )
                else
                  const SizedBox(width: 8),
              ],
            ),
          ),

          // Autocomplete suggestions dropdown
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final p = _suggestions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: Colors.grey),
                    title: Text(
                      p.mainText ?? p.description,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: p.secondaryText != null
                        ? Text(p.secondaryText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13))
                        : null,
                    dense: true,
                    onTap: () => _selectSuggestion(p),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // ───────────── Map controls ─────────────

  Widget _buildMapControls() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).padding.top + 80,
      child: Column(
        children: [
          _mapControlBtn(
            _currentMapType == MapType.normal
                ? Icons.satellite_alt
                : Icons.map_outlined,
            () => setState(() {
              _currentMapType = _currentMapType == MapType.normal
                  ? MapType.satellite
                  : MapType.normal;
            }),
          ),
          const SizedBox(height: 8),
          _mapControlBtn(
            Icons.traffic,
            () => setState(() => _trafficEnabled = !_trafficEnabled),
            active: _trafficEnabled,
          ),
        ],
      ),
    );
  }

  Widget _mapControlBtn(IconData icon, VoidCallback onTap,
      {bool active = false}) {
    return Material(
      elevation: 2,
      shape: const CircleBorder(),
      color: active ? const Color(0xFF1A73E8) : Colors.white,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon,
              size: 22,
              color: active ? Colors.white : const Color(0xFF1A73E8)),
        ),
      ),
    );
  }

  // ───────────── Navigate button ─────────────

  Widget _buildNavigateButton() {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: ElevatedButton.icon(
        onPressed: _fetchRoutes,
        icon: const Icon(Icons.directions, color: Colors.white),
        label: Text(
            _destinationName != null
                ? 'Directions to $_destinationName'
                : 'Get Directions',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 4,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Route details bottom sheet (Google Maps style)
  // ═══════════════════════════════════════════════════════════

  Widget _buildRouteSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Mode tabs (Bus / Car / Walk) ──
            _buildModeTabs(),

            const Divider(height: 1),

            // ── Route alternatives list ──
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shrinkWrap: true,
                itemCount: _allRoutes.length,
                itemBuilder: (context, index) =>
                    _buildRouteCard(index),
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _showRouteDetails = false);
                    _polylines.clear();
                    _markers.removeWhere(
                        (m) => m.markerId.value.startsWith('bus_stop_route_'));
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTabs() {
    // Collect unique modes from available routes
    final modes = <TravelMode>{};
    for (final r in _allRoutes) {
      modes.add(r.mode);
    }
    final modeList = modes.toList();

    // Current selected mode
    final selectedMode =
        _allRoutes.isNotEmpty ? _allRoutes[_selectedRouteIndex].mode : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: modeList.map((mode) {
          final isSelected = mode == selectedMode;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(_modeIcon(mode),
                  size: 18,
                  color: isSelected ? Colors.white : const Color(0xFF1A73E8)),
              label: Text(_modeLabel(mode)),
              selected: isSelected,
              selectedColor: const Color(0xFF1A73E8),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              onSelected: (_) {
                // Select first route of that mode
                for (int i = 0; i < _allRoutes.length; i++) {
                  if (_allRoutes[i].mode == mode) {
                    _selectRoute(i);
                    break;
                  }
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRouteCard(int index) {
    final route = _allRoutes[index];
    final isSelected = index == _selectedRouteIndex;

    return GestureDetector(
      onTap: () => _selectRoute(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A73E8).withOpacity(0.08)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1A73E8)
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duration + distance row
            Row(
              children: [
                Icon(_modeIcon(route.mode),
                    size: 20,
                    color: isSelected
                        ? const Color(0xFF1A73E8)
                        : Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  route.totalDuration,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? const Color(0xFF1A73E8)
                        : Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  route.totalDistance,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade600),
                ),
                const Spacer(),
                if (route.mode == TravelMode.transit &&
                    route.departureTime != null)
                  Text(
                    '${route.departureTime} → ${route.arrivalTime ?? ''}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),

            // Transit steps summary
            if (route.mode == TravelMode.transit) ...[
              const SizedBox(height: 8),
              _buildTransitStepsSummary(route),
            ],
          ],
        ),
      ),
    );
  }

  /// Renders a compact horizontal summary of transit steps like Google Maps:
  /// Walk ● Bus 138 (5 stops) ● Walk
  Widget _buildTransitStepsSummary(DirectionsResult route) {
    final widgets = <Widget>[];

    for (int i = 0; i < route.steps.length; i++) {
      final step = route.steps[i];

      if (step.travelMode == 'WALKING') {
        widgets.add(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_walk, size: 14, color: Colors.grey),
            const SizedBox(width: 2),
            Text(step.duration,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ));
      } else if (step.travelMode == 'TRANSIT') {
        widgets.add(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF1A73E8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                step.vehicleType == 'BUS'
                    ? Icons.directions_bus
                    : Icons.train,
                size: 14,
                color: const Color(0xFF1A73E8),
              ),
              const SizedBox(width: 4),
              Text(
                step.lineShortName ?? step.lineName ?? 'Transit',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A73E8),
                ),
              ),
              if (step.numStops != null) ...[
                const SizedBox(width: 4),
                Text('(${step.numStops} stops)',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
              ],
            ],
          ),
        ));
      }

      // Arrow separator
      if (i < route.steps.length - 1) {
        widgets.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child:
              Icon(Icons.chevron_right, size: 14, color: Colors.grey),
        ));
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: widgets),
    );
  }
}
