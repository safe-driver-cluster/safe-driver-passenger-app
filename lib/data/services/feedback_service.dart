import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/firebase_service.dart';
import '../models/passenger_model.dart';
import '../services/passenger_service.dart';

/// Model for feedback submitted by passengers
class FeedbackModel {
  final String id;
  final String userId;
  final String? busId;
  final String? driverId;
  final String? journeyId;
  final String type; // positive, negative, neutral, suggestion, inquiry, urgent, general
  final String category; // service, safety, comfort, driver, vehicle, route
  final FeedbackRating rating;
  final String title;
  final String description;
  final List<FeedbackAttachment> attachments;
  final String status; // submitted, received, inReview, responded, resolved, closed
  final String priority; // low, medium, high, urgent
  final bool isAnonymous;
  final FeedbackAdminResponse? adminResponse;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    this.busId,
    this.driverId,
    this.journeyId,
    required this.type,
    required this.category,
    required this.rating,
    required this.title,
    required this.description,
    this.attachments = const [],
    this.status = 'submitted',
    this.priority = 'medium',
    this.isAnonymous = false,
    this.adminResponse,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      busId: json['busId'],
      driverId: json['driverId'],
      journeyId: json['journeyId'],
      type: json['type'] ?? 'general',
      category: json['category'] ?? 'service',
      rating: FeedbackRating.fromJson(json['rating'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((item) => FeedbackAttachment.fromJson(item))
          .toList(),
      status: json['status'] ?? 'submitted',
      priority: json['priority'] ?? 'medium',
      isAnonymous: json['isAnonymous'] ?? false,
      adminResponse: json['adminResponse'] != null
          ? FeedbackAdminResponse.fromJson(json['adminResponse'])
          : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : DateTime.now(),
    );
  }

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'busId': busId,
      'driverId': driverId,
      'journeyId': journeyId,
      'type': type,
      'category': category,
      'rating': rating.toJson(),
      'title': title,
      'description': description,
      'attachments': attachments.map((item) => item.toJson()).toList(),
      'status': status,
      'priority': priority,
      'isAnonymous': isAnonymous,
      'adminResponse': adminResponse?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FeedbackRating {
  final int overall;
  final int safety;
  final int comfort;
  final int cleanliness;
  final int punctuality;
  final int driverBehavior;
  final int vehicleCondition;

  FeedbackRating({
    this.overall = 0,
    this.safety = 0,
    this.comfort = 0,
    this.cleanliness = 0,
    this.punctuality = 0,
    this.driverBehavior = 0,
    this.vehicleCondition = 0,
  });

  factory FeedbackRating.fromJson(Map<String, dynamic> json) {
    return FeedbackRating(
      overall: json['overall']?.toInt() ?? 0,
      safety: json['safety']?.toInt() ?? 0,
      comfort: json['comfort']?.toInt() ?? 0,
      cleanliness: json['cleanliness']?.toInt() ?? 0,
      punctuality: json['punctuality']?.toInt() ?? 0,
      driverBehavior: json['driverBehavior']?.toInt() ?? 0,
      vehicleCondition: json['vehicleCondition']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'safety': safety,
      'comfort': comfort,
      'cleanliness': cleanliness,
      'punctuality': punctuality,
      'driverBehavior': driverBehavior,
      'vehicleCondition': vehicleCondition,
    };
  }
}

class FeedbackAttachment {
  final String type; // image, video
  final String url;
  final String? thumbnail;

  FeedbackAttachment({
    required this.type,
    required this.url,
    this.thumbnail,
  });

  factory FeedbackAttachment.fromJson(Map<String, dynamic> json) {
    return FeedbackAttachment(
      type: json['type'] ?? 'image',
      url: json['url'] ?? '',
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
    };
  }
}

class FeedbackAdminResponse {
  final String message;
  final String responderId;
  final DateTime respondedAt;

  FeedbackAdminResponse({
    required this.message,
    required this.responderId,
    required this.respondedAt,
  });

  factory FeedbackAdminResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackAdminResponse(
      message: json['message'] ?? '',
      responderId: json['responderId'] ?? '',
      respondedAt: json['respondedAt'] != null
          ? (json['respondedAt'] is Timestamp
              ? (json['respondedAt'] as Timestamp).toDate()
              : DateTime.parse(json['respondedAt']))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'responderId': responderId,
      'respondedAt': respondedAt.toIso8601String(),
    };
  }
}

/// Service for managing feedback with passenger integration
class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  static FeedbackService get instance => _instance;
  FeedbackService._internal();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final PassengerService _passengerService = PassengerService.instance;
  final String _collection = 'feedback';

  /// Submit feedback with passenger details
  Future<String> submitFeedback({
    required String userId,
    String? busId,
    String? driverId,
    String? journeyId,
    required String type,
    required String category,
    required FeedbackRating rating,
    required String title,
    required String description,
    List<FeedbackAttachment> attachments = const [],
    String priority = 'medium',
    bool isAnonymous = false,
  }) async {
    try {
      // Get passenger details for context
      final passenger = await _passengerService.getPassengerProfile(userId);
      
      if (passenger == null) {
        throw Exception('Passenger profile not found');
      }

      final now = DateTime.now();
      final feedbackData = FeedbackModel(
        id: '', // Will be auto-generated
        userId: userId,
        busId: busId,
        driverId: driverId,
        journeyId: journeyId,
        type: type,
        category: category,
        rating: rating,
        title: title,
        description: description,
        attachments: attachments,
        priority: priority,
        isAnonymous: isAnonymous,
        createdAt: now,
        updatedAt: now,
      );

      final docRef = await _firebaseService.firestore
          .collection(_collection)
          .add(feedbackData.toJson());

      // Add passenger context for anonymous feedback handling
      if (!isAnonymous) {
        await docRef.update({
          'passengerInfo': {
            'firstName': passenger.firstName,
            'lastName': passenger.lastName,
            'email': passenger.email,
            'phoneNumber': passenger.phoneNumber,
          },
        });
      }

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  /// Get user's feedback history
  Future<List<FeedbackModel>> getUserFeedbackHistory(String userId) async {
    try {
      final querySnapshot = await _firebaseService.firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FeedbackModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user feedback history: $e');
    }
  }

  /// Get feedback by ID
  Future<FeedbackModel?> getFeedbackById(String feedbackId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(_collection)
          .doc(feedbackId)
          .get();

      if (doc.exists) {
        return FeedbackModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get feedback: $e');
    }
  }

  /// Update feedback status
  Future<void> updateFeedbackStatus({
    required String feedbackId,
    required String status,
  }) async {
    try {
      await _firebaseService.firestore
          .collection(_collection)
          .doc(feedbackId)
          .update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update feedback status: $e');
    }
  }

  /// Add admin response to feedback
  Future<void> addAdminResponse({
    required String feedbackId,
    required String message,
    required String responderId,
  }) async {
    try {
      final adminResponse = FeedbackAdminResponse(
        message: message,
        responderId: responderId,
        respondedAt: DateTime.now(),
      );

      await _firebaseService.firestore
          .collection(_collection)
          .doc(feedbackId)
          .update({
        'adminResponse': adminResponse.toJson(),
        'status': 'responded',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add admin response: $e');
    }
  }

  /// Get feedback statistics for a passenger
  Future<Map<String, dynamic>> getPassengerFeedbackStats(String userId) async {
    try {
      final querySnapshot = await _firebaseService.firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      int totalFeedback = 0;
      int positiveFeedback = 0;
      int negativeFeedback = 0;
      double averageRating = 0.0;
      int totalRatings = 0;

      for (final doc in querySnapshot.docs) {
        final feedback = FeedbackModel.fromFirestore(doc);
        totalFeedback++;

        if (feedback.type == 'positive') positiveFeedback++;
        if (feedback.type == 'negative') negativeFeedback++;

        if (feedback.rating.overall > 0) {
          totalRatings += feedback.rating.overall;
        }
      }

      if (totalFeedback > 0) {
        averageRating = totalRatings / totalFeedback;
      }

      return {
        'totalFeedback': totalFeedback,
        'positiveFeedback': positiveFeedback,
        'negativeFeedback': negativeFeedback,
        'averageRating': averageRating,
      };
    } catch (e) {
      throw Exception('Failed to get passenger feedback statistics: $e');
    }
  }

  /// Search feedback by various criteria
  Future<List<FeedbackModel>> searchFeedback({
    String? userId,
    String? busId,
    String? driverId,
    String? type,
    String? category,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 20,
  }) async {
    try {
      Query query = _firebaseService.firestore.collection(_collection);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }
      if (busId != null) {
        query = query.where('busId', isEqualTo: busId);
      }
      if (driverId != null) {
        query = query.where('driverId', isEqualTo: driverId);
      }
      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }
      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: endDate);
      }

      query = query.orderBy('createdAt', descending: true).limit(limit);

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => FeedbackModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search feedback: $e');
    }
  }

  /// Get feedback stream for real-time updates
  Stream<List<FeedbackModel>> getFeedbackStream({
    String? userId,
    int limit = 10,
  }) {
    Query query = _firebaseService.firestore.collection(_collection);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    query = query.orderBy('createdAt', descending: true).limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FeedbackModel.fromFirestore(doc))
          .toList();
    });
  }
}