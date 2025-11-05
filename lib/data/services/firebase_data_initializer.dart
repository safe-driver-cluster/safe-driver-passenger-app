import 'package:cloud_firestore/cloud_firestore.dart';

/// Sample Firebase data initialization script
/// Run this once to populate your Firestore with initial data
class FirebaseDataInitializer {
  static Future<void> initializeCollections() async {
    try {
      await _createAppSettings();
      await _createSampleBuses();
      await _createSampleRoutes();
      await _createSampleSafetyAlerts();
      await _createHazardZones();

      print('✅ Firebase collections initialized successfully!');
    } catch (e) {
      print('❌ Error initializing Firebase data: $e');
      rethrow;
    }
  }

  static Future<void> _createAppSettings() async {
    await FirebaseFirestore.instance
        .collection('app_settings')
        .doc('settings')
        .set({
      'maintenance': {
        'isEnabled': false,
        'message': 'App is under maintenance. Please try again later.',
        'estimatedEndTime': null,
      },
      'features': {
        'biometricAuth': true,
        'darkMode': true,
        'locationSharing': true,
        'pushNotifications': true,
        'crashReporting': true,
        'analytics': true,
      },
      'emergencyContacts': {
        'police': '119',
        'medical': '1990',
        'fire': '111',
        'support': '+94-11-2345678',
      },
      'safetyThresholds': {
        'maxSafeSpeedKmh': 80.0,
        'harshBrakingThreshold': -3.5,
        'harshAccelerationThreshold': 3.0,
        'drowsinessAlertThreshold': 0.7,
        'distractionAlertThreshold': 0.6,
      },
      'versions': {
        'minSupportedVersion': '1.0.0',
        'latestVersion': '1.0.0',
        'forceUpdate': false,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> _createSampleBuses() async {
    final buses = [
      {
        'busNumber': 'NB-1234',
        'routeNumber': 'Route 1',
        'registration': 'ABC-1234',
        'busType': 'standard',
        'passengerCapacity': 45,
        'driverId': 'driver1',
        'driverName': 'Kamal Perera',
        'status': 'online',
        'currentLocation': {
          'latitude': 6.9271,
          'longitude': 79.8612,
          'address': 'Colombo Fort',
          'timestamp': FieldValue.serverTimestamp(),
        },
        'currentSpeed': 35.0,
        'heading': 90.0,
        'safetyScore': 4.5,
        'amenities': ['wifi', 'ac', 'gps', 'cctv'],
        'specifications': {
          'manufacturer': 'Ashok Leyland',
          'model': 'Viking',
          'year': 2022,
          'engineType': 'Diesel',
          'fuelCapacity': 200.0,
          'maxSpeed': 80.0,
        },
        'isActive': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      {
        'busNumber': 'NB-5678',
        'routeNumber': 'Route 2',
        'registration': 'DEF-5678',
        'busType': 'electric',
        'passengerCapacity': 40,
        'driverId': 'driver2',
        'driverName': 'Nimal Silva',
        'status': 'inTransit',
        'currentLocation': {
          'latitude': 6.9319,
          'longitude': 79.8478,
          'address': 'Pettah',
          'timestamp': FieldValue.serverTimestamp(),
        },
        'currentSpeed': 25.0,
        'heading': 180.0,
        'safetyScore': 4.8,
        'amenities': ['wifi', 'ac', 'gps', 'cctv', 'usb_charging'],
        'specifications': {
          'manufacturer': 'BYD',
          'model': 'K7M',
          'year': 2023,
          'engineType': 'Electric',
          'batteryCapacity': 324.0,
          'maxSpeed': 75.0,
        },
        'isActive': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      },
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (var bus in buses) {
      final docRef = FirebaseFirestore.instance.collection('buses').doc();
      batch.set(docRef, bus);
    }
    await batch.commit();
  }

  static Future<void> _createSampleRoutes() async {
    final routes = [
      {
        'routeNumber': 'Route 1',
        'routeName': 'Colombo - Kandy Express',
        'description': 'Direct service between Colombo and Kandy',
        'startLocation': {
          'name': 'Colombo Fort',
          'coordinates': {'latitude': 6.9271, 'longitude': 79.8612},
        },
        'endLocation': {
          'name': 'Kandy Bus Stand',
          'coordinates': {'latitude': 7.2906, 'longitude': 80.6337},
        },
        'distance': 115.0,
        'estimatedDuration': 180,
        'fare': {'adult': 150.0, 'child': 75.0, 'senior': 100.0},
        'schedule': {
          'weekday': {
            'firstDeparture': '05:00',
            'lastDeparture': '22:00',
            'frequency': 30,
          },
          'weekend': {
            'firstDeparture': '06:00',
            'lastDeparture': '21:00',
            'frequency': 45,
          },
        },
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'routeNumber': 'Route 2',
        'routeName': 'Colombo - Galle Coastal',
        'description': 'Scenic coastal route to Galle',
        'startLocation': {
          'name': 'Colombo Central',
          'coordinates': {'latitude': 6.9319, 'longitude': 79.8478},
        },
        'endLocation': {
          'name': 'Galle Bus Stand',
          'coordinates': {'latitude': 6.0535, 'longitude': 80.2210},
        },
        'distance': 95.0,
        'estimatedDuration': 150,
        'fare': {'adult': 120.0, 'child': 60.0, 'senior': 80.0},
        'schedule': {
          'weekday': {
            'firstDeparture': '05:30',
            'lastDeparture': '21:30',
            'frequency': 45,
          },
          'weekend': {
            'firstDeparture': '06:30',
            'lastDeparture': '20:30',
            'frequency': 60,
          },
        },
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (var route in routes) {
      final docRef = FirebaseFirestore.instance.collection('routes').doc();
      batch.set(docRef, route);
    }
    await batch.commit();
  }

  static Future<void> _createSampleSafetyAlerts() async {
    final alerts = [
      {
        'type': 'weather',
        'severity': 3,
        'title': 'Heavy Rain Warning',
        'description':
            'Heavy rain expected on Colombo-Kandy route. Drive carefully.',
        'location': {
          'latitude': 7.0000,
          'longitude': 80.0000,
          'address': 'Colombo-Kandy Highway',
        },
        'status': 'active',
        'priority': 'medium',
        'affectedAreas': ['Colombo-Kandy Highway'],
        'affectedUsers': [],
        'additionalData': {
          'weatherCondition': 'heavy_rain',
          'visibility': 'poor',
          'recommendedSpeed': 40.0,
        },
        'tags': ['weather', 'rain', 'highway'],
        'recommendedActions': [
          'Reduce speed to 40 km/h',
          'Maintain safe following distance',
          'Use headlights',
        ],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'timestamp': FieldValue.serverTimestamp(),
      },
      {
        'type': 'traffic',
        'severity': 2,
        'title': 'Traffic Congestion',
        'description': 'Heavy traffic reported in Pettah area.',
        'location': {
          'latitude': 6.9319,
          'longitude': 79.8478,
          'address': 'Pettah, Colombo',
        },
        'status': 'active',
        'priority': 'low',
        'affectedAreas': ['Pettah'],
        'affectedUsers': [],
        'additionalData': {
          'trafficLevel': 'heavy',
          'estimatedDelay': 15,
        },
        'tags': ['traffic', 'congestion', 'city'],
        'recommendedActions': [
          'Consider alternative routes',
          'Allow extra travel time',
        ],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'timestamp': FieldValue.serverTimestamp(),
      },
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (var alert in alerts) {
      final docRef =
          FirebaseFirestore.instance.collection('safety_alerts').doc();
      batch.set(docRef, alert);
    }
    await batch.commit();
  }

  static Future<void> _createHazardZones() async {
    final hazardZones = [
      {
        'name': 'Sharp Curve Zone - Kadugannawa',
        'description':
            'Dangerous curve with limited visibility on Colombo-Kandy route',
        'location': {
          'center': {'latitude': 7.2500, 'longitude': 80.5000},
          'radius': 500.0,
        },
        'severity': 'high',
        'type': 'road_hazard',
        'restrictions': {
          'maxSpeed': 40.0,
          'timeRestrictions': {
            'nightTime': true,
            'weather': ['rain', 'fog'],
          },
        },
        'alerts': {
          'passengerAlert': 'Please hold handrails, approaching sharp curve',
          'driverAlert': 'Reduce speed, sharp curve ahead - Max 40 km/h',
        },
        'statistics': {
          'totalIncidents': 3,
          'lastIncident': FieldValue.serverTimestamp(),
        },
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Steep Gradient - Balana',
        'description': 'Steep uphill section requiring reduced speed',
        'location': {
          'center': {'latitude': 7.2000, 'longitude': 80.4500},
          'radius': 1000.0,
        },
        'severity': 'medium',
        'type': 'steep_gradient',
        'restrictions': {
          'maxSpeed': 50.0,
        },
        'alerts': {
          'passengerAlert': 'Steep section ahead, please remain seated',
          'driverAlert': 'Steep gradient - Engage lower gear, Max 50 km/h',
        },
        'statistics': {
          'totalIncidents': 1,
        },
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (var zone in hazardZones) {
      final docRef =
          FirebaseFirestore.instance.collection('hazard_zones').doc();
      batch.set(docRef, zone);
    }
    await batch.commit();
  }
}

/// Usage example:
/// 
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///   
///   // Initialize sample data (run once)
///   await FirebaseDataInitializer.initializeCollections();
///   
///   runApp(MyApp());
/// }