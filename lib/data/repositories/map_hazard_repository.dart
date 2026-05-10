import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/map_hazard_model.dart';

class MapHazardRepository {
  final FirebaseFirestore _firestore;

  MapHazardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<MapHazard>> getHazards() async {
    final snapshot = await _firestore.collection('hazards').get();
    final hazards = snapshot.docs
        .map(MapHazard.fromFirestore)
        .whereType<MapHazard>()
        .toList();

    hazards.sort((a, b) {
      final aDate =
          a.updatedAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          b.updatedAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return hazards;
  }
}
