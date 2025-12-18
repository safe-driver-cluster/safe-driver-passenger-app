import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../data/models/feedback_model.dart';

/// Complete QR-based feedback system page
class QRBasedFeedbackPage extends StatefulWidget {
  final String? userId;
  final String? initialBusNumber;

  const QRBasedFeedbackPage({
    super.key,
    this.userId,
    this.initialBusNumber,
  });

  @override
  State<QRBasedFeedbackPage> createState() => _QRBasedFeedbackPageState();
}

class _QRBasedFeedbackPageState extends State<QRBasedFeedbackPage> {
  late MobileScannerController cameraController;
  String? _scannedBusNumber;
  bool _isScanning = true;
  bool _showManualInput = false;
  final TextEditingController _busNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
    if (widget.initialBusNumber != null) {
      _scannedBusNumber = widget.initialBusNumber;
      _isScanning = false;
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _busNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR-Based Feedback'),
        elevation: 0,
      ),
      body: _scannedBusNumber == null
          ? _buildQRScannerView()
          : _buildFeedbackFormView(),
    );
  }

  /// Build QR scanner view
  Widget _buildQRScannerView() {
    return Column(
      children: [
        // Scanner area
        Expanded(
          flex: 3,
          child: _buildScannerArea(),
        ),

        // Manual input section
        Expanded(
          flex: 1,
          child: _buildManualInputSection(),
        ),
      ],
    );
  }

  /// Build scanner area with overlay
  Widget _buildScannerArea() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera scanner
        MobileScanner(
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                _handleScannedQR(barcode.rawValue!);
              }
            }
          },
          errorBuilder: (context, error, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: AppColors.errorColor, size: 48),
                  const SizedBox(height: 16),
                  Text('Camera Error: ${error.errorCode}'),
                ],
              ),
            );
          },
        ),

        // Scanner overlay
        _buildScannerOverlay(),

        // Top info bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: AppColors.textPrimary.withOpacity(0.5),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scan Bus QR Code',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Point your camera at the bus QR code to continue',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ),

        // Camera controls
        Positioned(
          bottom: 16,
          right: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flashlight toggle
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  cameraController.toggleTorch();
                },
                backgroundColor: AppColors.primaryColor,
                child: ValueListenableBuilder<TorchState>(
                  valueListenable: cameraController.torchState,
                  builder: (context, state, child) {
                    switch (state) {
                      case TorchState.off:
                        return const Icon(Icons.flashlight_off);
                      case TorchState.on:
                        return const Icon(Icons.flashlight_on);
                      default:
                        return const Icon(Icons.flashlight_off);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Camera switch
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  cameraController.switchCamera();
                },
                backgroundColor: AppColors.primaryColor,
                child: const Icon(Icons.cameraswitch),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build scanner overlay (frame + guides)
  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            // Corner indicators
            ..._buildCornerIndicators(),

            // Center help text
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Position QR code here',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build corner indicators for scanner
  List<Widget> _buildCornerIndicators() {
    const cornerSize = 30.0;
    const cornerThickness = 4.0;

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
              left: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
              right: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
              left: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
              right: BorderSide(
                color: AppColors.primaryColor,
                width: cornerThickness,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  /// Build manual input section
  Widget _buildManualInputSection() {
    return Container(
      color: AppColors.scaffoldBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Can\'t scan?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() => _showManualInput = true);
            },
            icon: const Icon(Icons.keyboard),
            label: const Text('Enter Bus Number Manually'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
          ),
          if (_showManualInput) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _busNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter bus number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_busNumberController.text.isNotEmpty) {
                      _handleScannedQR(_busNumberController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Icon(Icons.check),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Handle scanned QR code
  void _handleScannedQR(String qrData) {
    // Extract bus number from QR data
    // QR codes might contain full URLs or just bus numbers
    final busNumber = _extractBusNumber(qrData);

    if (busNumber.isNotEmpty) {
      setState(() {
        _scannedBusNumber = busNumber;
        _isScanning = false;
      });
    } else {
      _showError('Invalid QR code. Please try again.');
    }
  }

  /// Extract bus number from QR data
  String _extractBusNumber(String qrData) {
    // Try to extract bus number from various QR formats
    if (qrData.contains('bus/')) {
      final parts = qrData.split('bus/');
      return parts.last.split('/').first;
    } else if (qrData.contains('number=')) {
      final parts = qrData.split('number=');
      return parts.last.split('&').first;
    } else if (RegExp(r'^[A-Z]{1,3}\d{1,4}$').hasMatch(qrData)) {
      return qrData;
    }
    return qrData; // Return as-is if matches bus number format
  }

  /// Build feedback form view after bus selection
  Widget _buildFeedbackFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bus information card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bus Number',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _scannedBusNumber ?? 'N/A',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _scannedBusNumber = null;
                      _isScanning = true;
                      _busNumberController.clear();
                      _showManualInput = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Feedback type selection
          Text(
            'Select Feedback Type',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildFeedbackTypeSelection(),

          const SizedBox(height: 24),

          // Rating section
          Text(
            'Rate Your Experience',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildRatingSelector(),

          const SizedBox(height: 24),

          // Comments section
          Text(
            'Additional Comments',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your feedback (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Submit button
          ElevatedButton(
            onPressed: _submitFeedback,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successColor,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build feedback type selection
  Widget _buildFeedbackTypeSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeCard(
            icon: Icons.directions_bus,
            label: 'Bus Condition',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeCard(
            icon: Icons.person,
            label: 'Driver Behavior',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  /// Build feedback type card
  Widget _buildTypeCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build rating selector
  Widget _buildRatingSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        5,
        (index) => GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.star,
            size: 40,
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  /// Submit feedback
  void _submitFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: AppColors.successColor,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  /// Show error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
      ),
    );
  }
}
