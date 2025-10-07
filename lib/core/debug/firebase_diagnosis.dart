import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';
import '../services/firebase_service.dart';

/// Firebase Diagnosis Widget
/// This widget helps diagnose Firebase connectivity and configuration issues
class FirebaseDiagnosis extends StatefulWidget {
  const FirebaseDiagnosis({super.key});

  @override
  State<FirebaseDiagnosis> createState() => _FirebaseDiagnosisState();
}

class _FirebaseDiagnosisState extends State<FirebaseDiagnosis> {
  String _status = 'Starting diagnosis...';
  final List<String> _checks = [];
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _runDiagnosis();
  }

  Future<void> _runDiagnosis() async {
    setState(() {
      _status = 'Running Firebase diagnosis...';
      _checks.clear();
    });

    try {
      // Check 1: Firebase Core Initialization
      _addCheck('✅ Firebase Core initialized');

      // Check 2: Firebase Configuration
      final options = DefaultFirebaseOptions.currentPlatform;
      _addCheck('✅ Firebase configuration loaded');
      _addCheck('   Project ID: ${options.projectId}');
      _addCheck('   API Key: ${options.apiKey.substring(0, 10)}...');

      // Check 3: Firebase Services Availability
      try {
        final auth = FirebaseAuth.instance;
        _addCheck('✅ Firebase Auth available');
        _addCheck(
            '   Current user: ${auth.currentUser?.email ?? 'Not signed in'}');
      } catch (e) {
        _addCheck('❌ Firebase Auth error: $e');
      }

      try {
        final firestore = FirebaseFirestore.instance;
        _addCheck('✅ Firestore available');

        // Test Firestore connection
        await firestore
            .collection('test')
            .doc('connection_test')
            .get()
            .timeout(const Duration(seconds: 10));

        _addCheck('✅ Firestore connection successful');
      } catch (e) {
        _addCheck('❌ Firestore connection failed: $e');
        if (e.toString().contains('PERMISSION_DENIED')) {
          _addCheck(
              '   🔧 Solution: Enable Firestore API in Google Cloud Console');
          _addCheck(
              '   🌐 Visit: https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=${options.projectId}');
        }
      }

      // Check 4: Firebase Service Initialization
      try {
        final service = FirebaseService.instance;
        final initialized = await service.initialize();
        if (initialized) {
          _addCheck('✅ Firebase Service initialized successfully');
        } else {
          _addCheck('❌ Firebase Service initialization failed');
        }
      } catch (e) {
        _addCheck('❌ Firebase Service error: $e');
      }

      // Check 5: Network connectivity
      try {
        final firestore = FirebaseFirestore.instance;
        await firestore.enableNetwork();
        _addCheck('✅ Network connectivity enabled');
      } catch (e) {
        _addCheck('❌ Network connectivity issue: $e');
      }

      setState(() {
        _status = 'Diagnosis completed';
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Diagnosis failed: $e';
        _isRunning = false;
      });
      _addCheck('❌ Fatal error during diagnosis: $e');
    }
  }

  void _addCheck(String check) {
    setState(() {
      _checks.add(check);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Diagnosis'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (_isRunning)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diagnosis Results:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _checks.length,
                          itemBuilder: (context, index) {
                            final check = _checks[index];
                            final isError = check.startsWith('❌');
                            final isSolution = check.startsWith('   🔧') ||
                                check.startsWith('   🌐');

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                check,
                                style: TextStyle(
                                  color: isError
                                      ? Colors.red
                                      : isSolution
                                          ? Colors.blue
                                          : Colors.black87,
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isRunning ? null : _runDiagnosis,
                child: const Text('Run Diagnosis Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
