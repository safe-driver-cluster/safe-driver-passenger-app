import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';

class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({super.key});

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage>
    with TickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isScanning = true;
  bool _hasPermission = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkPermissions();
  }

  void _initializeAnimations() {
    // Scan line animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation for corner indicators
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      final result = await Permission.camera.request();
      setState(() {
        _hasPermission = result.isGranted;
      });
    } else {
      setState(() {
        _hasPermission = status.isGranted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_hasPermission) _buildCameraView(),
          
          // Professional Overlay
          _buildProfessionalOverlay(),
          
          // Top Header
          _buildTopHeader(),
          
          // Bottom Controls
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return MobileScanner(
      controller: controller,
      onDetect: _onDetect,
      errorBuilder: (context, error, child) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_rounded,
                  color: AppColors.errorColor,
                  size: 64,
                ),
                const SizedBox(height: AppDesign.spaceLG),
                Text(
                  'Camera Error',
                  style: AppTextStyles.headline6.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),
                Text(
                  error.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfessionalOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          width: 280,
          height: 280,
          child: Stack(
            children: [
              // Scanning area background
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              
              // Corner indicators
              _buildCornerIndicators(),
              
              // Scanning line
              if (_isScanning) _buildScanningLine(),
              
              // Center instruction
              _buildCenterInstruction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerIndicators() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Top-left corner
            Positioned(
              top: 0,
              left: 0,
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDesign.radiusXL),
                    ),
                  ),
                ),
              ),
            ),
            
            // Top-right corner
            Positioned(
              top: 0,
              right: 0,
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppDesign.radiusXL),
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom-left corner
            Positioned(
              bottom: 0,
              left: 0,
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppDesign.radiusXL),
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom-right corner
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(AppDesign.radiusXL),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, child) {
        return Positioned(
          top: 20 + (240 * _scanLineAnimation.value),
          left: 20,
          right: 20,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primaryColor,
                  AppColors.accentColor,
                  AppColors.primaryColor,
                  Colors.transparent,
                ],
                stops: [0.0, 0.2, 0.5, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterInstruction() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceLG,
          vertical: AppDesign.spaceMD,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.primaryColor,
              size: AppDesign.iconSM,
            ),
            const SizedBox(width: AppDesign.spaceXS),
            Text(
              'Position QR code here',
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDesign.spaceLG,
          60,
          AppDesign.spaceLG,
          AppDesign.spaceLG,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: AppDesign.iconMD,
                ),
              ),
            ),
            
            const SizedBox(width: AppDesign.spaceLG),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QR Scanner',
                    style: AppTextStyles.headline5.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    'Scan QR code on bus or stop',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: IconButton(
                onPressed: _toggleTorch,
                icon: Icon(
                  _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  color: _isTorchOn ? AppColors.warningColor : Colors.white,
                  size: AppDesign.iconMD,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.space2XL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Manual entry option
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showManualEntryDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDesign.spaceLG,
                    horizontal: AppDesign.spaceLG,
                  ),
                ),
                icon: const Icon(Icons.keyboard_rounded),
                label: const Text('Enter Code Manually'),
              ),
            ),
            
            const SizedBox(height: AppDesign.spaceLG),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_rounded,
                    color: AppColors.primaryColor,
                    size: AppDesign.iconSM,
                  ),
                  const SizedBox(width: AppDesign.spaceMD),
                  Expanded(
                    child: Text(
                      'Hold steady and align QR code within the frame',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() {
        _isScanning = false;
      });

      HapticFeedback.heavyImpact();
      
      final String code = barcodes.first.rawValue ?? '';
      // Handle QR code processing
      _processQrCode(code);
    }
  }

  void _toggleTorch() async {
    try {
      await controller.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        title: const Text('Enter Code Manually'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter bus or stop code',
                prefixIcon: const Icon(Icons.qr_code_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ProfessionalButton(
            text: 'Submit',
            onPressed: () {
              Navigator.pop(context);
              // Handle manual code entry
            },
            height: 36,
          ),
        ],
      ),
    );
  }

  void _processQrCode(String code) {
    // Process QR code and navigate accordingly
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR Code detected: $code'),
        backgroundColor: AppColors.successColor,
      ),
    );
    
    // Add navigation logic here based on the QR code content
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    controller.dispose();
    super.dispose();
  }
}
