import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/bus_model.dart';
import '../../../data/models/location_model.dart';

/// Live map widget for displaying bus locations and routes
class LiveMapWidget extends StatefulWidget {
  final BusModel? bus;
  final List<BusModel>? buses;
  final LocationModel? userLocation;
  final List<LocationModel>? routePoints;
  final VoidCallback? onMapCreated;
  final Function(BusModel)? onBusMarkerTapped;
  final bool showUserLocation;
  final bool showRoute;
  final double height;

  const LiveMapWidget({
    super.key,
    this.bus,
    this.buses,
    this.userLocation,
    this.routePoints,
    this.onMapCreated,
    this.onBusMarkerTapped,
    this.showUserLocation = true,
    this.showRoute = true,
    this.height = 300,
  });

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  static const LatLng _defaultCenter =
      LatLng(6.9271, 79.8612); // Colombo, Sri Lanka

  @override
  void initState() {
    super.initState();
    _updateMarkers();
    _updatePolylines();
  }

  @override
  void didUpdateWidget(LiveMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bus != oldWidget.bus ||
        widget.buses != oldWidget.buses ||
        widget.userLocation != oldWidget.userLocation ||
        widget.routePoints != oldWidget.routePoints) {
      _updateMarkers();
      _updatePolylines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _getInitialTarget(),
            zoom: 14.0,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: widget.showUserLocation,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
          compassEnabled: true,
          trafficEnabled: false,
          buildingsEnabled: true,
          mapType: MapType.normal,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    widget.onMapCreated?.call();
    _fitMarkersInView();
  }

  LatLng _getInitialTarget() {
    if (widget.bus?.currentLocation != null) {
      return LatLng(
        widget.bus!.currentLocation!.latitude,
        widget.bus!.currentLocation!.longitude,
      );
    } else if (widget.userLocation != null) {
      return LatLng(
        widget.userLocation!.latitude,
        widget.userLocation!.longitude,
      );
    } else if (widget.buses?.isNotEmpty == true) {
      final firstBusWithLocation = widget.buses!.firstWhere(
        (bus) => bus.currentLocation != null,
        orElse: () => widget.buses!.first,
      );
      if (firstBusWithLocation.currentLocation != null) {
        return LatLng(
          firstBusWithLocation.currentLocation!.latitude,
          firstBusWithLocation.currentLocation!.longitude,
        );
      }
    }
    return _defaultCenter;
  }

  void _updateMarkers() {
    final Set<Marker> markers = {};

    // Add user location marker
    if (widget.showUserLocation && widget.userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            widget.userLocation!.latitude,
            widget.userLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
          ),
        ),
      );
    }

    // Add single bus marker
    if (widget.bus?.currentLocation != null) {
      markers.add(_createBusMarker(widget.bus!));
    }

    // Add multiple bus markers
    if (widget.buses != null) {
      for (final bus in widget.buses!) {
        if (bus.currentLocation != null) {
          markers.add(_createBusMarker(bus));
        }
      }
    }

    // Add route points markers
    if (widget.routePoints != null && widget.showRoute) {
      for (int i = 0; i < widget.routePoints!.length; i++) {
        final point = widget.routePoints![i];
        markers.add(
          Marker(
            markerId: MarkerId('route_point_$i'),
            position: LatLng(point.latitude, point.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
              title: point.name ?? 'Stop ${i + 1}',
              snippet: point.address,
            ),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  Marker _createBusMarker(BusModel bus) {
    return Marker(
      markerId: MarkerId('bus_${bus.id}'),
      position: LatLng(
        bus.currentLocation!.latitude,
        bus.currentLocation!.longitude,
      ),
      icon: _getBusMarkerIcon(bus.status),
      infoWindow: InfoWindow(
        title: bus.displayName,
        snippet: '${bus.routeDisplay} • ${bus.statusDisplay}',
        onTap: () => widget.onBusMarkerTapped?.call(bus),
      ),
      onTap: () => widget.onBusMarkerTapped?.call(bus),
    );
  }

  BitmapDescriptor _getBusMarkerIcon(BusStatus status) {
    switch (status) {
      case BusStatus.online:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case BusStatus.inTransit:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case BusStatus.atStop:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      case BusStatus.offline:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      case BusStatus.maintenance:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case BusStatus.emergency:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case BusStatus.active:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case BusStatus.enRoute:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  void _updatePolylines() {
    final Set<Polyline> polylines = {};

    if (widget.showRoute &&
        widget.routePoints != null &&
        widget.routePoints!.length > 1) {
      final List<LatLng> routeCoordinates = widget.routePoints!
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      polylines.add(
        Polyline(
          polylineId: const PolylineId('bus_route'),
          points: routeCoordinates,
          color: AppColors.primaryColor,
          width: 4,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }

    setState(() {
      _polylines = polylines;
    });
  }

  void _fitMarkersInView() {
    if (_markers.isEmpty || _mapController == null) return;

    final List<LatLng> positions =
        _markers.map((marker) => marker.position).toList();

    if (positions.length == 1) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(positions.first, 16.0),
      );
      return;
    }

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (final position in positions) {
      minLat = minLat < position.latitude ? minLat : position.latitude;
      maxLat = maxLat > position.latitude ? maxLat : position.latitude;
      minLng = minLng < position.longitude ? minLng : position.longitude;
      maxLng = maxLng > position.longitude ? maxLng : position.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // padding
      ),
    );
  }

  /// Center map on specific bus
  void centerOnBus(BusModel bus) {
    if (bus.currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            bus.currentLocation!.latitude,
            bus.currentLocation!.longitude,
          ),
          16.0,
        ),
      );
    }
  }

  /// Center map on user location
  void centerOnUser() {
    if (widget.userLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            widget.userLocation!.latitude,
            widget.userLocation!.longitude,
          ),
          16.0,
        ),
      );
    }
  }
}

/// Compact map widget for smaller displays
class CompactMapWidget extends StatelessWidget {
  final BusModel bus;
  final double height;
  final VoidCallback? onTap;

  const CompactMapWidget({
    super.key,
    required this.bus,
    this.height = 150,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (bus.currentLocation == null) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.textSecondary.withOpacity(0.2),
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 48,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 8),
              Text(
                'Location not available',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: LiveMapWidget(
        bus: bus,
        height: height,
        showUserLocation: false,
        showRoute: false,
      ),
    );
  }
}
