import 'package:cloud_firestore/cloud_firestore.dart';

class OtpVerificationModel {
  final String id;
  final String phoneNumber;
  final String hashedOTP;
  final int attempts;
  final int maxAttempts;
  final DateTime createdAt;
  final DateTime expiresAt;
  final OtpStatus status;
  final String? smsStatus;
  final String? smsMessageId;
  final DateTime? verifiedAt;
  final String? ipAddress;
  final String? userAgent;

  const OtpVerificationModel({
    required this.id,
    required this.phoneNumber,
    required this.hashedOTP,
    required this.attempts,
    required this.maxAttempts,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
    this.smsStatus,
    this.smsMessageId,
    this.verifiedAt,
    this.ipAddress,
    this.userAgent,
  });

  factory OtpVerificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return OtpVerificationModel(
      id: snapshot.id,
      phoneNumber: data['phoneNumber'] as String,
      hashedOTP: data['hashedOTP'] as String,
      attempts: data['attempts'] as int,
      maxAttempts: data['maxAttempts'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      status: OtpStatus.fromString(data['status'] as String),
      smsStatus: data['smsStatus'] as String?,
      smsMessageId: data['smsMessageId'] as String?,
      verifiedAt: data['verifiedAt'] != null
          ? (data['verifiedAt'] as Timestamp).toDate()
          : null,
      ipAddress: data['ipAddress'] as String?,
      userAgent: data['userAgent'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'hashedOTP': hashedOTP,
      'attempts': attempts,
      'maxAttempts': maxAttempts,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'status': status.toString(),
      if (smsStatus != null) 'smsStatus': smsStatus,
      if (smsMessageId != null) 'smsMessageId': smsMessageId,
      if (verifiedAt != null) 'verifiedAt': Timestamp.fromDate(verifiedAt!),
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
    };
  }

  OtpVerificationModel copyWith({
    String? id,
    String? phoneNumber,
    String? hashedOTP,
    int? attempts,
    int? maxAttempts,
    DateTime? createdAt,
    DateTime? expiresAt,
    OtpStatus? status,
    String? smsStatus,
    String? smsMessageId,
    DateTime? verifiedAt,
    String? ipAddress,
    String? userAgent,
  }) {
    return OtpVerificationModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hashedOTP: hashedOTP ?? this.hashedOTP,
      attempts: attempts ?? this.attempts,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      smsStatus: smsStatus ?? this.smsStatus,
      smsMessageId: smsMessageId ?? this.smsMessageId,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isVerified => status == OtpStatus.verified;
  bool get canRetry =>
      attempts < maxAttempts && !isExpired && status == OtpStatus.pending;

  @override
  String toString() {
    return 'OtpVerificationModel{'
        'id: $id, '
        'phoneNumber: $phoneNumber, '
        'attempts: $attempts/$maxAttempts, '
        'status: $status, '
        'expiresAt: $expiresAt, '
        'isExpired: $isExpired'
        '}';
  }
}

enum OtpStatus {
  pending,
  verified,
  expired,
  failed;

  static OtpStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OtpStatus.pending;
      case 'verified':
        return OtpStatus.verified;
      case 'expired':
        return OtpStatus.expired;
      case 'failed':
        return OtpStatus.failed;
      default:
        return OtpStatus.pending;
    }
  }

  @override
  String toString() {
    return name;
  }
}
