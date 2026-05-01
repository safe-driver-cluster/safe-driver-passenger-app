import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:background_sms/background_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

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
      smsSent + whatsappLaunched > 0 &&
      smsFailed == 0 &&
      whatsappFailed == 0;

  String get summary {
    final parts = <String>[];
    if (smsSent > 0) parts.add('SMS sent to $smsSent contact${smsSent > 1 ? 's' : ''}');
    if (whatsappLaunched > 0) parts.add('WhatsApp sent to $whatsappLaunched contact${whatsappLaunched > 1 ? 's' : ''}');
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
  static const String _sosEnabledKey = 'sos_auto_enabled';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ─── Contact Management ────────────────────────────────────────────────

  /// Get all SOS contacts from local storage
  Future<List<SosContact>> getContacts() async {
    try {
      // Try Firestore first (if user is authenticated)
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('sos_contacts')
            .get();

        if (doc.docs.isNotEmpty) {
          final contacts =
              doc.docs.map((d) => SosContact.fromJson(d.data())).toList();
          // Cache locally
          await _saveContactsLocal(contacts);
          return contacts;
        }
      }

      // Fallback to local storage
      return _getContactsLocal();
    } catch (e) {
      // Fallback to local storage on error
      return _getContactsLocal();
    }
  }

  /// Save SOS contacts (both local and Firestore)
  Future<void> saveContacts(List<SosContact> contacts) async {
    // Save locally
    await _saveContactsLocal(contacts);

    // Save to Firestore if authenticated
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final batch = _firestore.batch();
        final collectionRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('sos_contacts');

        // Delete existing
        final existing = await collectionRef.get();
        for (var doc in existing.docs) {
          batch.delete(doc.reference);
        }

        // Add new
        for (var contact in contacts) {
          batch.set(collectionRef.doc(contact.id), contact.toJson());
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

  Future<List<SosContact>> _getContactsLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_contactsKey);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((j) => SosContact.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> _saveContactsLocal(List<SosContact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = contacts.map((c) => c.toJson()).toList();
    await prefs.setString(_contactsKey, json.encode(jsonList));
  }

  /// Check if SOS auto-send is enabled
  Future<bool> isAutoSendEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sosEnabledKey) ?? true;
  }

  /// Enable/disable SOS auto-send
  Future<void> setAutoSendEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sosEnabledKey, enabled);
  }

  // ─── SOS Alert ─────────────────────────────────────────────────────────

  /// Send SOS alert to all contacts via SMS and WhatsApp
  Future<SosAlertResult> sendSosAlert({
    String? customMessage,
    bool includeLocation = true,
  }) async {
    final contacts = await getContacts();
    if (contacts.isEmpty) {
      return SosAlertResult(
        totalContacts: 0,
        smsSent: 0,
        smsFailed: 0,
        whatsappLaunched: 0,
        whatsappFailed: 0,
        errors: ['No SOS contacts configured'],
      );
    }

    // Get location
    String? locationUrl;
    String? locationText;
    if (includeLocation) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        locationUrl =
            'https://maps.google.com/?q=${position.latitude},${position.longitude}';
        locationText =
            'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
      } catch (e) {
        debugPrint('Could not get location for SOS: $e');
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

    int smsSent = 0;
    int smsFailed = 0;
    int whatsappLaunched = 0;
    int whatsappFailed = 0;
    final errors = <String>[];

    // Send to each contact
    for (final contact in contacts) {
      final phone = _formatPhoneNumber(contact.phoneNumber);

      // Send SMS
      if (contact.sendSms) {
        try {
          final result = await _sendSms(phone, message);
          if (result) {
            smsSent++;
          } else {
            smsFailed++;
            errors.add('SMS failed for ${contact.name}');
          }
        } catch (e) {
          smsFailed++;
          errors.add('SMS error for ${contact.name}: $e');
        }
      }

      // Send WhatsApp
      if (contact.sendWhatsapp) {
        try {
          final result = await _sendWhatsapp(phone, message);
          if (result) {
            whatsappLaunched++;
          } else {
            whatsappFailed++;
            errors.add('WhatsApp failed for ${contact.name}');
          }
        } catch (e) {
          whatsappFailed++;
          errors.add('WhatsApp error for ${contact.name}: $e');
        }
      }
    }

    // Log SOS event to Firestore
    await _logSosEvent(contacts, message, locationUrl);

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
        return _launchSmsApp(phoneNumber, message);
      }

      final permission = await Permission.sms.request();
      if (!permission.isGranted) {
        return _launchSmsApp(phoneNumber, message);
      }

      // Send SMS in background
      final result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber,
        message: message,
      );

      return result == SmsStatus.sent;
    } catch (e) {
      debugPrint('SMS send error: $e');
      // Fallback: open SMS app
      try {
        return await _launchSmsApp(phoneNumber, message);
      } catch (e2) {
        debugPrint('SMS fallback error: $e2');
      }
      return false;
    }
  }

  Future<bool> _launchSmsApp(String phoneNumber, String message) async {
    final uri = Uri.parse('sms:$phoneNumber?body=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
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
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('sos_events')
            .add({
          'timestamp': FieldValue.serverTimestamp(),
          'message': message,
          'locationUrl': locationUrl,
          'contactsNotified': contacts.map((c) => c.toJson()).toList(),
          'platform': 'mobile_app',
        });
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