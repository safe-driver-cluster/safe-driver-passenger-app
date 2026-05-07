import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo show LocationAccuracy;
import 'package:geolocator/geolocator.dart' hide LocationAccuracy;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../services/google_places_service.dart' as places_service;

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final places_service.GooglePlacesService _placesService =
      places_service.GooglePlacesService();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  GoogleMapController? _mapController;
  Position? _currentPosition;
  Timer? _debounce;
  List<places_service.Prediction> _suggestions = [];
  places_service.DirectionsResult? _currentDirections;
  LatLng? _selectedDestination;
  String? _selectedDestinationName;

  bool _isLoading = true;
  bool _isSearching = false;
  bool _showSuggestions = false;
  bool _showingBusStops = false;
  bool _showingBusRoute = false;
  String? _errorMessage;

  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;

  LatLng? get _currentLatLng {
    final position = _currentPosition;
    if (position == null) return null;
    return LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeMap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage =
              'Location services are disabled. Please enable location services.';
          _isLoading = false;
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage =
              'Location permission denied. Please grant location access.';
          _isLoading = false;
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Location permissions are permanently denied. Please enable them in settings.';
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _updateCurrentLocationMarker(position);
      _animateToPosition(position);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  void _updateCurrentLocationMarker(Position position) {
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'current_location',
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: AppLocalizations.of(context).yourLocation,
          snippet: AppLocalizations.of(context).currentPosition,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    setState(() {});
  }

  void _animateToPosition(Position position) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        16,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    final position = _currentPosition;
    if (position != null) _animateToPosition(position);
  }

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
          locationBias: _currentLatLng,
          radiusMeters: 50000,
        );
        if (!mounted) return;
        setState(() {
          _suggestions = results;
          _showSuggestions = results.isNotEmpty;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _suggestions = [];
          _showSuggestions = false;
        });
      }
    });
  }

  Future<void> _searchPlaces() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);
    try {
      var results = _suggestions;
      if (results.isEmpty || results.first.description != query) {
        results = await _placesService.autocomplete(
          query,
          locationBias: _currentLatLng,
          radiusMeters: 50000,
        );
      }

      if (results.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No matching locations found'),
              backgroundColor: AppColors.warningColor,
            ),
          );
        }
        return;
      }

      await _selectSuggestion(results.first);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search failed: $e'),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _selectSuggestion(places_service.Prediction prediction) async {
    setState(() {
      _isSearching = true;
      _showSuggestions = false;
      _searchController.text = prediction.description;
    });

    try {
      final latLng = await _placesService.getPlaceLatLng(prediction.placeId);
      _setDestination(prediction.description, latLng);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${prediction.description}'),
            backgroundColor: AppColors.primaryColor,
            action: SnackBarAction(
              label: 'Bus',
              textColor: Colors.white,
              onPressed: _navigateToDestination,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Place lookup failed: $e'),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _setDestination(String name, LatLng latLng) {
    _clearRouteOverlays();
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'search_destination',
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('search_destination'),
        position: latLng,
        infoWindow: InfoWindow(title: name, snippet: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );

    setState(() {
      _selectedDestination = latLng;
      _selectedDestinationName = name;
      _currentDirections = null;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
  }

  Future<void> _showBusStops() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) return;
    }

    setState(() => _showingBusStops = true);
    try {
      _markers.removeWhere(
        (marker) => marker.markerId.value.startsWith('bus_stop_'),
      );

      final stops = await _placesService.nearbyBusStops(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        radiusMeters: 1500,
      );

      for (final stop in stops) {
        _markers.add(
          Marker(
            markerId: MarkerId('bus_stop_${stop.placeId}'),
            position: LatLng(stop.lat, stop.lng),
            infoWindow: InfoWindow(
              title: stop.name,
              snippet: stop.vicinity.isEmpty ? 'Bus stop' : stop.vicinity,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
          ),
        );
      }

      if (!mounted) return;
      setState(() => _showingBusStops = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found ${stops.length} nearby bus stops'),
          backgroundColor:
              stops.isEmpty ? AppColors.warningColor : AppColors.successColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _showingBusStops = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load nearby bus stops: $e'),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    }
  }

  Future<void> _navigateToDestination() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) return;
    }

    final origin = _currentLatLng;
    final destination = _selectedDestination;
    if (origin == null || destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Search and select a destination first'),
          backgroundColor: AppColors.warningColor,
        ),
      );
      return;
    }

    setState(() => _showingBusRoute = true);
    try {
      final directions = await _placesService.getDirections(
        origin,
        destination,
      );

      if (directions == null) {
        if (!mounted) return;
        setState(() => _showingBusRoute = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No bus route found for this destination'),
            backgroundColor: AppColors.warningColor,
          ),
        );
        return;
      }

      _drawBusRoute(directions);
      if (!mounted) return;
      setState(() {
        _currentDirections = directions;
        _showingBusRoute = false;
      });

      final routePoints = places_service.GooglePlacesService.decodePolyline(
        directions.overviewPolyline,
      );
      _fitPoints(routePoints);
      _showRouteInfoBottomSheet(directions);
      if (directions.isFallback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Google bus directions unavailable. Showing estimated road route.',
            ),
            backgroundColor: AppColors.warningColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _showingBusRoute = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bus navigation failed: $e'),
          backgroundColor: AppColors.dangerColor,
        ),
      );
    }
  }

  void _drawBusRoute(places_service.DirectionsResult directions) {
    _clearRouteOverlays();

    final routePoints = places_service.GooglePlacesService.decodePolyline(
      directions.overviewPolyline,
    );

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('bus_route_main'),
        points: routePoints,
        color: AppColors.primaryColor,
        width: 6,
      ),
    );

    for (var i = 0; i < directions.steps.length; i++) {
      final step = directions.steps[i];
      if (step.travelMode != 'TRANSIT') continue;

      _markers.addAll([
        Marker(
          markerId: MarkerId('route_stop_${i}_depart'),
          position: step.startLocation,
          infoWindow: InfoWindow(
            title: step.departureStop ?? 'Board bus',
            snippet: _busLineLabel(step),
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: MarkerId('route_stop_${i}_arrive'),
          position: step.endLocation,
          infoWindow: InfoWindow(
            title: step.arrivalStop ?? 'Leave bus',
            snippet: _busLineLabel(step),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ]);
    }
  }

  void _clearRouteOverlays() {
    _polylines.removeWhere(
      (polyline) => polyline.polylineId.value.contains('bus_route'),
    );
    _markers.removeWhere(
      (marker) => marker.markerId.value.startsWith('route_stop_'),
    );
  }

  void _fitPoints(List<LatLng> points) {
    if (points.isEmpty || _mapController == null) return;

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        72,
      ),
    );
  }

  Future<void> _openGoogleMapsBusNavigation() async {
    final origin = _currentLatLng;
    final destination = _selectedDestination;
    if (origin == null || destination == null) return;

    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'travelmode': 'transit',
      'dir_action': 'navigate',
    });

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _clearSearchAndRoute() {
    _debounce?.cancel();
    _searchController.clear();
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'search_destination',
    );
    _clearRouteOverlays();
    setState(() {
      _selectedDestination = null;
      _selectedDestinationName = null;
      _currentDirections = null;
      _suggestions = [];
      _showSuggestions = false;
    });
  }

  String _busLineLabel(places_service.TransitStep step) {
    final line = step.lineShortName ?? step.lineName;
    if (line == null || line.isEmpty) return 'Bus';
    return 'Bus $line';
  }

  String _averageSpeed(places_service.DirectionsResult directions) {
    if (directions.totalDistanceMeters <= 0 ||
        directions.totalDurationSeconds <= 0) {
      return '--';
    }
    final km = directions.totalDistanceMeters / 1000;
    final hours = directions.totalDurationSeconds / 3600;
    return '${(km / hours).toStringAsFixed(1)} km/h';
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _toggleTraffic() {
    setState(() => _trafficEnabled = !_trafficEnabled);
  }

  void _centerOnLocation() {
    final position = _currentPosition;
    if (position != null) {
      _animateToPosition(position);
    } else {
      _getCurrentLocation();
    }
  }

  void _zoomIn() => _mapController?.animateCamera(CameraUpdate.zoomIn());

  void _zoomOut() => _mapController?.animateCamera(CameraUpdate.zoomOut());

  Widget _buildHeader() {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: th.glassBackground,
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
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).mapsNavigation,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildSearchBox(),
          if (_showSuggestions && _suggestions.isNotEmpty)
            _buildSuggestionsList(),
          const SizedBox(height: AppDesign.spaceLG),
          _buildActionCards(),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    final th = ThemeHelper.of(context);
    return Container(
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _onSearchChanged(value);
          setState(() {});
        },
        onSubmitted: (_) => _searchPlaces(),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search destination or bus stop',
          hintStyle: TextStyle(
            color: th.textHint,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryColor,
            size: 24,
          ),
          suffixIcon: _isSearching
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: _clearSearchAndRoute,
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
    );
  }

  Widget _buildSuggestionsList() {
    final th = ThemeHelper.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.28,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: math.min(_suggestions.length, 6),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final prediction = _suggestions[index];
          return ListTile(
            leading: const Icon(
              Icons.place_outlined,
              color: AppColors.primaryColor,
            ),
            title: Text(prediction.mainText ?? prediction.description),
            subtitle: prediction.secondaryText == null
                ? null
                : Text(prediction.secondaryText!),
            onTap: () => _selectSuggestion(prediction),
          );
        },
      ),
    );
  }

  Widget _buildActionCards() {
    return Row(
      children: [
        Expanded(
          child: _SmallActionButton(
            icon: Icons.bus_alert_rounded,
            title: AppLocalizations.of(context).busStop,
            color: AppColors.secondaryColor,
            isLoading: _showingBusStops,
            onTap: _showBusStops,
          ),
        ),
        const SizedBox(width: AppDesign.spaceMD),
        Expanded(
          child: _SmallActionButton(
            icon: Icons.directions_bus_rounded,
            title: AppLocalizations.of(context).navigate,
            color: AppColors.accentColor,
            isLoading: _showingBusRoute,
            onTap: _navigateToDestination,
          ),
        ),
      ],
    );
  }

  Widget _buildMapContainer() {
    final th = ThemeHelper.of(context);
    return Container(
      margin: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
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
                  target: _currentLatLng ?? const LatLng(6.9271, 79.8612),
                  zoom: 14,
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
            if (!_isLoading && _errorMessage == null) _buildMapControls(),
            if (_currentDirections != null)
              Positioned(
                left: AppDesign.spaceMD,
                right: AppDesign.spaceMD,
                bottom: AppDesign.spaceMD,
                child: _buildRouteSummaryCard(_currentDirections!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSummaryCard(places_service.DirectionsResult directions) {
    final th = ThemeHelper.of(context);
    return Material(
      color: th.cardBackground,
      elevation: 6,
      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        onTap: () => _showRouteInfoBottomSheet(directions),
        child: Padding(
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedDestinationName ?? 'Bus route',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: th.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      '${directions.totalDistance} - ${directions.totalDuration} - ${_averageSpeed(directions)}${directions.isFallback ? ' - estimated' : ''}',
                      style: TextStyle(
                        color: th.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _openGoogleMapsBusNavigation,
                icon: const Icon(
                  Icons.open_in_new_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
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
            icon: Icons.add_rounded,
            onTap: _zoomIn,
            tooltip: 'Zoom In',
          ),
          const SizedBox(height: AppDesign.spaceSM),
          _MapControlButton(
            icon: Icons.remove_rounded,
            onTap: _zoomOut,
            tooltip: 'Zoom Out',
          ),
          const SizedBox(height: AppDesign.spaceSM),
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

  void _showRouteInfoBottomSheet(places_service.DirectionsResult directions) {
    final transitSteps =
        directions.steps.where((step) => step.travelMode == 'TRANSIT').toList();

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          final th = ThemeHelper.of(context);
          return Container(
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              color: th.cardBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: th.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            child: Text(
                              _selectedDestinationName ??
                                  AppLocalizations.of(context)
                                      .busRouteToDestination,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: th.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _openGoogleMapsBusNavigation,
                            icon: const Icon(Icons.open_in_new_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDesign.spaceMD),
                      Row(
                        children: [
                          _RouteMetric(
                            label: 'Distance',
                            value: directions.totalDistance,
                            icon: Icons.straighten_rounded,
                          ),
                          const SizedBox(width: AppDesign.spaceSM),
                          _RouteMetric(
                            label: 'Duration',
                            value: directions.totalDuration,
                            icon: Icons.schedule_rounded,
                          ),
                          const SizedBox(width: AppDesign.spaceSM),
                          _RouteMetric(
                            label: 'Avg speed',
                            value: _averageSpeed(directions),
                            icon: Icons.speed_rounded,
                          ),
                        ],
                      ),
                      if (directions.isFallback) ...[
                        const SizedBox(height: AppDesign.spaceSM),
                        const Text(
                          'Estimated road route because Google bus directions are unavailable.',
                          style: TextStyle(
                            color: AppColors.warningColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: directions.steps.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final step = directions.steps[index];
                      return _TransitStepTile(
                        step: step,
                        title: step.travelMode == 'TRANSIT'
                            ? _busLineLabel(step)
                            : step.instructions,
                      );
                    },
                  ),
                ),
                if (transitSteps.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Text(
                      'Google did not return a bus segment for this route.',
                      style: TextStyle(color: th.textSecondary),
                    ),
                  ),
              ],
            ),
          );
        });
  }

  Widget _buildErrorState() {
    final th = ThemeHelper.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.space2XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: th.textSecondary,
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Text(
              AppLocalizations.of(context).unableToLoadMap,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: th.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: th.textSecondary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    final th = ThemeHelper.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryColor),
          const SizedBox(height: AppDesign.spaceLG),
          Text(
            AppLocalizations.of(context).loadingMap,
            style: TextStyle(
              color: th.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
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
              _buildHeader(),
              Expanded(child: _buildMapContainer()),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _RouteMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceSM),
        decoration: BoxDecoration(
          color: th.inputFill,
          borderRadius: BorderRadius.circular(AppDesign.radiusMD),
          border: Border.all(color: th.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 18),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: th.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: th.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransitStepTile extends StatelessWidget {
  final places_service.TransitStep step;
  final String title;

  const _TransitStepTile({
    required this.step,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final isBus = step.travelMode == 'TRANSIT';
    final subtitle = isBus
        ? [
            if (step.departureStop != null) step.departureStop,
            if (step.arrivalStop != null) step.arrivalStop,
          ].join(' to ')
        : step.instructions;

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.inputFill,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: th.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (isBus ? AppColors.primaryColor : th.textDisabled)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: Icon(
              isBus ? Icons.directions_bus_rounded : Icons.directions_walk,
              color: isBus ? AppColors.primaryColor : th.textDisabled,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: th.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: th.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  '${step.distance} - ${step.duration}',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isBus && step.numStops != null)
            Text(
              '${step.numStops} stops',
              style: TextStyle(
                color: th.textSecondary,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _SmallActionButton({
    required this.icon,
    required this.title,
    required this.color,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: th.surface,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          boxShadow: [
            BoxShadow(
              color: th.shadowMedium,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            else
              Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isLoading ? th.textSecondary : th.textPrimary,
                ),
              ),
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
    final th = ThemeHelper.of(context);
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : th.surface,
            borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            boxShadow: [
              BoxShadow(
                color: th.shadowMedium,
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
