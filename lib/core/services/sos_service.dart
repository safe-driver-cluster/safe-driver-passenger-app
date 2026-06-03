import 'dart:convert';
import 'dart:io';

import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Model for a user-defined SOS contact
class SosContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final bool sendSms;
  final bool sendWhatsapp;

  SosContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.sendSms = true,
    this.sendWhatsapp = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'relationship': relationship,
        'sendSms': sendSms,
        'sendWhatsapp': sendWhatsapp,
      };

  factory SosContact.fromJson(Map<String, dynamic> json) => SosContact(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        relationship: json['relationship'] ?? '',
        sendSms: json['sendSms'] ?? true,
        sendWhatsapp: json['sendWhatsapp'] ?? true,
      );

  SosContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? relationship,
    bool? sendSms,
    bool? sendWhatsapp,
  }) {
    return SosContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      sendSms: sendSms ?? this.sendSms,
      sendWhatsapp: sendWhatsapp ?? this.sendWhatsapp,
    );
  }
}

/// Result of an SOS alert attempt
class SosAlertResult {
  final int totalContacts;
  final int smsSent;
  final int smsFailed;
  final int whatsappLaunched;
  final int whatsappFailed;
  final List<String> errors;

  SosAlertResult({
    required this.totalContacts,
    required this.smsSent,
    required this.smsFailed,
    required this.whatsappLaunched,
    required this.whatsappFailed,
    required this.errors,
  });

  bool get isPartialSuccess => smsSent > 0 || whatsappLaunched > 0;
  bool get isCompleteSuccess =>
      smsSent + whatsappLaunched > 0 && smsFailed == 0 && whatsappFailed == 0;

  String get summary {
    final parts = <String>[];
    if (smsSent > 0) {
      parts.add('SMS sent to $smsSent contact${smsSent > 1 ? 's' : ''}');
    }
    if (whatsappLaunched > 0) {
      parts.add(
          'WhatsApp sent to $whatsappLaunched contact${whatsappLaunched > 1 ? 's' : ''}');
    }
    if (smsFailed > 0) parts.add('$smsFailed SMS failed');
    if (whatsappFailed > 0) parts.add('$whatsappFailed WhatsApp failed');
    return parts.isEmpty ? 'No actions taken' : parts.join(', ');
  }
}

/// Service for handling SOS emergency alerts
class SosService {
  static final SosService _instance = SosService._internal();
  factory SosService() => _instance;
  SosService._internal();

  static const String _contactsKey = 'sos_contacts';
  static const String _eventsKey = 'sos_events';
  static const String _sosCollection = 'SOS';
  static const String _sosEnabledKey = 'sos_auto_enabled';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  String _contactsCacheKey(String? userId) {
    return userId == null ? _contactsKey : '${_contactsKey}_$userId';
  }

  String _autoSendCacheKey(String? userId) {
    return userId == null ? _sosEnabledKey : '${_sosEnabledKey}_$userId';
  }

  SosContact _contactFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return SosContact.fromJson({
      ...?data,
      'id': data?['id'] ?? doc.id,
    });
  }

  DocumentReference<Map<String, dynamic>> _sosUserDoc(String userId) {
    return _firestore.collection(_sosCollection).doc(userId);
  }

  CollectionReference<Map<String, dynamic>> _sosContactsRef(String userId) {
    return _sosUserDoc(userId).collection(_contactsKey);
  }

  CollectionReference<Map<String, dynamic>> _sosEventsRef(String userId) {
    return _sosUserDoc(userId).collection(_eventsKey);
  }

  CollectionReference<Map<String, dynamic>> _legacySosContactsRef(
      String userId) {
    return _firestore.collection('users').doc(userId).collection(_contactsKey);
  }

  // ─── Contact Management ────────────────────────────────────────────────

  /// Get all SOS contacts from local storage
  Future<List<SosContact>> getContacts() async {
    try {
      // Try Firestore first (if user is authenticated)
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _sosContactsRef(user.uid).get();

        if (doc.docs.isNotEmpty) {
          final contacts = doc.docs.map(_contactFromDoc).toList();
          // Cache locally
          await _saveContactsLocal(contacts, user.uid);
          return contacts;
        }

        final legacyDoc = await _legacySosContactsRef(user.uid).get();
        if (legacyDoc.docs.isNotEmpty) {
          final contacts = legacyDoc.docs.map(_contactFromDoc).toList();
          await _saveContactsLocal(contacts, user.uid);
          await saveContacts(contacts);
          return contacts;
        }

        return _getContactsLocal(user.uid);
      }

      // Fallback to local storage
      return _getContactsLocal();
    } catch (e) {
      // Fallback to local storage on error
      return _getContactsLocal(_currentUserId);
    }
  }

  /// Save SOS contacts (both local and Firestore)
  Future<void> saveContacts(List<SosContact> contacts) async {
    final user = _auth.currentUser;

    // Save locally
    await _saveContactsLocal(contacts, user?.uid);

    // Save to Firestore if authenticated
    try {
      if (user != null) {
        final batch = _firestore.batch();
        final sosUserRef = _sosUserDoc(user.uid);
        final collectionRef = _sosContactsRef(user.uid);

        // Delete existing
        final existing = await collectionRef.get();
        for (var doc in existing.docs) {
          batch.delete(doc.reference);
        }

        batch.set(
            sosUserRef,
            {
              'userId': user.uid,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));

        // Add new
        for (var contact in contacts) {
          batch.set(collectionRef.doc(contact.id), {
            ...contact.toJson(),
            'userId': user.uid,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        await batch.commit();
      }
    } catch (e) {
      debugPrint('Error saving contacts to Firestore: $e');
    }
  }

  /// Add a single SOS contact
  Future<void> addContact(SosContact contact) async {
    final contacts = await getContacts();
    contacts.add(contact);
    await saveContacts(contacts);
  }

  /// Update a single SOS contact
  Future<void> updateContact(SosContact contact) async {
    final contacts = await getContacts();
    final index = contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      contacts[index] = contact;
      await saveContacts(contacts);
    }
  }

  /// Delete a single SOS contact
  Future<void> deleteContact(String contactId) async {
    final contacts = await getContacts();
    contacts.removeWhere((c) => c.id == contactId);
    await saveContacts(contacts);
  }

  Future<List<SosContact>> _getContactsLocal([String? userId]) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_contactsCacheKey(userId));
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList
        .map((j) => SosContact.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveContactsLocal(
      List<SosContact> contacts, String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = contacts.map((c) => c.toJson()).toList();
    await prefs.setString(_contactsCacheKey(userId), json.encode(jsonList));
  }

  /// Check if SOS auto-send is enabled
  Future<bool> isAutoSendEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoSendCacheKey(_currentUserId)) ?? true;
  }

  /// Enable/disable SOS auto-send
  Future<void> setAutoSendEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSendCacheKey(_currentUserId), enabled);
  }

  // ─── SOS Alert ─────────────────────────────────────────────────────────

  /// Send SOS alert to all contacts via SMS and WhatsApp
  Future<SosAlertResult> sendSosAlert({
    String? customMessage,
    bool includeLocation = true,
  }) async {
    debugPrint('=== SOS ALERT START ===');
    final contacts = await getContacts();

    if (contacts.isEmpty) {
      debugPrint('SOS: No contacts configured');
      return SosAlertResult(
        totalContacts: 0,
        smsSent: 0,
        smsFailed: 0,
        whatsappLaunched: 0,
        whatsappFailed: 0,
        errors: ['No SOS contacts configured'],
      );
    }

    debugPrint('SOS: Found ${contacts.length} SOS contacts');

    // Get location
    String? locationUrl;
    String? locationText;
    if (includeLocation) {
      try {
        debugPrint('SOS: Attempting to get location...');
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        locationUrl =
            'https://maps.google.com/?q=${position.latitude},${position.longitude}';
        locationText =
            'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
        debugPrint('SOS: Location obtained: $locationText');
      } catch (e) {
        debugPrint('SOS: Could not get location: $e');
      }
    }

    // Build message
    final timestamp = DateTime.now().toString().substring(0, 19);
    String message = customMessage ?? '🆘 EMERGENCY SOS ALERT!';
    message += '\nI need immediate help!';
    if (locationUrl != null) {
      message += '\n📍 My Location: $locationUrl';
      if (locationText != null) {
        message += '\n($locationText)';
      }
    }
    message += '\n🕐 Time: $timestamp';

    debugPrint('SOS: Alert message prepared (length: ${message.length})');

    int smsSent = 0;
    int smsFailed = 0;
    int whatsappLaunched = 0;
    int whatsappFailed = 0;
    final errors = <String>[];

    // Send to each contact
    for (final contact in contacts) {
      final phone = _formatPhoneNumber(contact.phoneNumber);
      debugPrint('SOS: Processing contact: ${contact.name} ($phone)');

      // Send SMS
      if (contact.sendSms) {
        try {
          debugPrint('SOS: Sending SMS to ${contact.name}...');
          final result = await _sendSms(phone, message);
          if (result) {
            smsSent++;
            debugPrint('SOS: SMS sent successfully to ${contact.name}');
          } else {
            smsFailed++;
            final errorMsg = 'SMS failed for ${contact.name}';
            debugPrint('SOS: $errorMsg');
            errors.add(errorMsg);
          }
        } catch (e) {
          smsFailed++;
          final errorMsg = 'SMS error for ${contact.name}: $e';
          debugPrint('SOS: $errorMsg');
          errors.add(errorMsg);
        }
      }

      // Send WhatsApp
      if (contact.sendWhatsapp) {
        try {
          debugPrint('SOS: Launching WhatsApp for ${contact.name}...');
          final result = await _sendWhatsapp(phone, message);
          if (result) {
            whatsappLaunched++;
            debugPrint('SOS: WhatsApp launched for ${contact.name}');
          } else {
            whatsappFailed++;
            final errorMsg = 'WhatsApp failed for ${contact.name}';
            debugPrint('SOS: $errorMsg');
            errors.add(errorMsg);
          }
        } catch (e) {
          whatsappFailed++;
          final errorMsg = 'WhatsApp error for ${contact.name}: $e';
          debugPrint('SOS: $errorMsg');
          errors.add(errorMsg);
        }
      }
    }

    // Log SOS event to Firestore
    await _logSosEvent(contacts, message, locationUrl);

    debugPrint(
        'SOS: Alert complete - SMS: $smsSent sent, $smsFailed failed | WhatsApp: $whatsappLaunched launched, $whatsappFailed failed');
    debugPrint('=== SOS ALERT END ===');

    return SosAlertResult(
      totalContacts: contacts.length,
      smsSent: smsSent,
      smsFailed: smsFailed,
      whatsappLaunched: whatsappLaunched,
      whatsappFailed: whatsappFailed,
      errors: errors,
    );
  }

  /// Send SMS using background_sms plugin (sends directly without leaving app)
  Future<bool> _sendSms(String phoneNumber, String message) async {
    try {
      if (!Platform.isAndroid) {
        debugPrint('SMS: Non-Android platform, using SMS app');
        return _launchSmsApp(phoneNumber, message);
      }

      // Verify and request SMS permission
      debugPrint('SMS: Checking SMS permission...');
      final permission = await Permission.sms.request();
      if (!permission.isGranted) {
        debugPrint('SMS: Permission denied, falling back to SMS app');
        return _launchSmsApp(phoneNumber, message);
      }
      debugPrint('SMS: Permission granted');

      // Send SMS in background using the plugin
      debugPrint('SMS: Attempting to send via background_sms to $phoneNumber');
      try {
        final result = await BackgroundSms.sendMessage(
          phoneNumber: phoneNumber,
          message: message,
        );

        debugPrint('SMS: background_sms returned status: $result');

        // The plugin may return success but not actually send, so we add extra diagnostics
        if (result == SmsStatus.sent) {
          debugPrint('SMS: Reported as sent to $phoneNumber');
          return true;
        } else {
          debugPrint(
              'SMS: background_sms returned status $result, falling back to SMS app');
          return _launchSmsApp(phoneNumber, message);
        }
      } catch (pluginError) {
        debugPrint('SMS: background_sms plugin error: $pluginError');
        debugPrint('SMS: Falling back to SMS app launcher');
        return _launchSmsApp(phoneNumber, message);
      }
    } catch (e) {
      debugPrint('SMS: Unexpected error in _sendSms: $e');
      // Final fallback: open SMS app
      try {
        return await _launchSmsApp(phoneNumber, message);
      } catch (e2) {
        debugPrint('SMS: Final fallback also failed: $e2');
      }
      return false;
    }
  }

  Future<bool> _launchSmsApp(String phoneNumber, String message) async {
    try {
      debugPrint('SMS: Launching SMS app for $phoneNumber');
      final uri =
          Uri.parse('sms:$phoneNumber?body=${Uri.encodeComponent(message)}');
      if (await canLaunchUrl(uri)) {
        debugPrint('SMS: SMS URI is launchable, opening SMS app');
        final result = await launchUrl(uri);
        debugPrint('SMS: SMS app launch result: $result');
        return result;
      } else {
        debugPrint('SMS: SMS URI cannot be launched');
        return false;
      }
    } catch (e) {
      debugPrint('SMS: Error launching SMS app: $e');
      return false;
    }
  }

  /// Send WhatsApp message via deep link
  Future<bool> _sendWhatsapp(String phoneNumber, String message) async {
    try {
      // Format phone for WhatsApp (remove +, spaces, dashes)
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[+\s\-()]'), '');
      final uri = Uri.parse(
        'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}',
      );

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('WhatsApp send error: $e');
      return false;
    }
  }

  /// Format phone number to include country code
  String _formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    // Sri Lankan numbers: add +94 if no country code
    if (phone.startsWith('0') && !phone.startsWith('+')) {
      phone = '+94${phone.substring(1)}';
    } else if (!phone.startsWith('+')) {
      phone = '+94$phone';
    }
    return phone;
  }

  /// Log SOS event to Firestore for record keeping
  Future<void> _logSosEvent(
      List<SosContact> contacts, String message, String? locationUrl) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final sosUserRef = _sosUserDoc(user.uid);
        final eventRef = _sosEventsRef(user.uid).doc();
        final batch = _firestore.batch();

        batch.set(
            sosUserRef,
            {
              'userId': user.uid,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));

        batch.set(eventRef, {
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'message': message,
          'locationUrl': locationUrl,
          'contactsNotified': contacts.map((c) => c.toJson()).toList(),
          'platform': 'mobile_app',
        });

        await batch.commit();
      }
    } catch (e) {
      debugPrint('Error logging SOS event: $e');
    }
  }

  /// Check and request SMS permission
  Future<bool> requestSmsPermission() async {
    try {
      if (!Platform.isAndroid) return false;
      final result = await Permission.sms.request();
      return result.isGranted;
    } catch (e) {
      debugPrint('SMS permission check error: $e');
      return false;
    }
  }
}
