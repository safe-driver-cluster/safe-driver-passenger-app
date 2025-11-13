import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../data/models/feedback_model.dart';
import '../../../providers/auth_provider.dart';
import '../../controllers/feedback_controller.dart';
import 'feedback_system_page.dart';

class FeedbackSubmissionPage extends ConsumerStatefulWidget {
  final String busNumber;
  final FeedbackTarget feedbackTarget;

  const FeedbackSubmissionPage({
    super.key,
    required this.busNumber,
    required this.feedbackTarget,
  });

  @override
  ConsumerState<FeedbackSubmissionPage> createState() =>
      _FeedbackSubmissionPageState();
}

class _FeedbackSubmissionPageState extends ConsumerState<FeedbackSubmissionPage>
    with TickerProviderStateMixin {
  int selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  Set<String> selectedQuickActions = <String>{};
  List<File> selectedMediaFiles = [];
  Position? currentLocation;
  bool isSubmitting = false;
  bool isLoadingLocation = false;

  late AnimationController _starAnimationController;
  late List<AnimationController> _starControllers;

  final List<String> busQuickActions = [
    'Clean and comfortable',
    'Good condition',
    'Air conditioning works well',
    'Seats are comfortable',
    'Bus needs cleaning',
    'Maintenance required',
    'Uncomfortable seats',
    'Poor ventilation',
  ];

  final List<String> driverQuickActions = [
    'Excellent driving',
    'Courteous and helpful',
    'Safe driving',
    'Professional behavior',
    'Reckless driving',
    'Unprofessional behavior',
    'Poor customer service',
    'Safety concerns',
  ];

  @override
  void initState() {
    super.initState();
    _starAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _starControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 200 + (index * 50)),
        vsync: this,
      ),
    );

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _starAnimationController.dispose();
    for (var controller in _starControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              AppColors.backgroundColor,
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: Column(
          children: [
            _buildModernAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDesign.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBusInfoHeader(),
                    const SizedBox(height: AppDesign.spaceXL),
                    _buildRatingSection(),
                    const SizedBox(height: AppDesign.spaceXL),
                    _buildQuickActionsSection(),
                    const SizedBox(height: AppDesign.spaceXL),
                    _buildCommentSection(),
                    const SizedBox(height: AppDesign.spaceXL),
                    _buildMediaUploadSection(),
                    const SizedBox(height: AppDesign.spaceXL),
                    _buildLocationSection(),
                    const SizedBox(height: AppDesign.spaceXL),
                    _buildContactOptionsSection(),
                    const SizedBox(height: AppDesign.space3XL),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Location services
  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = position;
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  Widget _buildModernAppBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.9),
            AppColors.primaryDark.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.feedbackTarget == FeedbackTarget.bus ? 'Bus' : 'Driver'} Feedback',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppDesign.textXL,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Share your experience',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: AppDesign.textSM,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaUploadSection() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: const Icon(
                  Icons.attach_file,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Expanded(
                child: Text(
                  'Add Photos or Videos (Optional)',
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          const Text(
            'Upload images or videos to better explain your feedback (Max 10MB)',
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Upload button
          GestureDetector(
            onTap: _pickMediaFile,
            child: Container(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                color: AppColors.primaryColor.withOpacity(0.05),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: AppDesign.spaceSM),
                  Text(
                    'Tap to select photos or videos',
                    style: TextStyle(
                      fontSize: AppDesign.textMD,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'PNG, JPG, MP4 (Max 10MB)',
                    style: TextStyle(
                      fontSize: AppDesign.textSM,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Selected files display
          if (selectedMediaFiles.isNotEmpty) ...[
            const SizedBox(height: AppDesign.spaceLG),
            ...selectedMediaFiles.map((file) => _buildMediaFileItem(file)),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaFileItem(File file) {
    final fileName = file.path.split('/').last;
    final fileSize = (file.lengthSync() / (1024 * 1024)).toStringAsFixed(2);
    final isVideo = fileName.toLowerCase().endsWith('.mp4') ||
        fileName.toLowerCase().endsWith('.mov') ||
        fileName.toLowerCase().endsWith('.avi');

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceSM),
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.greyExtraLight,
        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        border: Border.all(
          color: AppColors.greyLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isVideo ? Icons.videocam : Icons.image,
            color: AppColors.primaryColor,
            size: 24,
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: AppDesign.textSM,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${fileSize}MB',
                  style: const TextStyle(
                    fontSize: AppDesign.textXS,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeMediaFile(file),
            icon: const Icon(
              Icons.close,
              color: AppColors.dangerColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.successColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Expanded(
                child: Text(
                  'Location Information',
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          const Text(
            'Your location helps us understand the context of your feedback',
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          if (isLoadingLocation)
            const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: AppDesign.spaceSM),
                Text(
                  'Getting your location...',
                  style: TextStyle(
                    fontSize: AppDesign.textSM,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          else if (currentLocation != null)
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                border: Border.all(
                  color: AppColors.successColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.successColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppDesign.spaceSM),
                  const Expanded(
                    child: Text(
                      'Location captured successfully',
                      style: TextStyle(
                        fontSize: AppDesign.textSM,
                        color: AppColors.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _getCurrentLocation,
                    child: const Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: AppDesign.textSM,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                border: Border.all(
                  color: AppColors.warningColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    color: AppColors.warningColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppDesign.spaceSM),
                  const Expanded(
                    child: Text(
                      'Location not available',
                      style: TextStyle(
                        fontSize: AppDesign.textSM,
                        color: AppColors.warningColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _getCurrentLocation,
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: AppDesign.textSM,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactOptionsSection() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Expanded(
                child: Text(
                  'Need More Help?',
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          const Text(
            'For large files or detailed discussions, contact us directly',
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  'WhatsApp',
                  Icons.message,
                  AppColors.successColor,
                  _shareViaWhatsApp,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildContactButton(
                  'Email',
                  Icons.email,
                  AppColors.primaryColor,
                  _shareViaEmail,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDesign.spaceMD,
          horizontal: AppDesign.spaceLG,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: AppDesign.spaceSM),
            Text(
              title,
              style: TextStyle(
                fontSize: AppDesign.textMD,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Media and contact methods
  Future<void> _pickMediaFile() async {
    try {
      // Show dialog to choose between camera and gallery
      final action = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          title: const Text('Add Media'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.camera_alt, color: AppColors.primaryColor),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: AppColors.primaryColor),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
            ],
          ),
        ),
      );

      if (action != null) {
        // For now, just show a placeholder message since image_picker is not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '$action selected - Media upload will be available in the next update'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to pick media files: $e');
    }
  }

  void _removeMediaFile(File file) {
    setState(() {
      selectedMediaFiles.remove(file);
    });
  }

  void _shareViaWhatsApp() {
    // WhatsApp sharing logic
    final message = _buildShareMessage();
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    _launchUrl(whatsappUrl);
  }

  void _shareViaEmail() {
    // Email sharing logic
    final message = _buildShareMessage();
    final subject = 'SafeDriver Feedback - Bus ${widget.busNumber}';
    final emailUrl =
        'mailto:support@safedriver.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(message)}';
    _launchUrl(emailUrl);
  }

  String _buildShareMessage() {
    final buffer = StringBuffer();
    buffer.writeln('SafeDriver Feedback');
    buffer.writeln('');
    buffer.writeln('Bus Number: ${widget.busNumber}');
    buffer.writeln(
        'Feedback Type: ${widget.feedbackTarget == FeedbackTarget.bus ? 'Bus' : 'Driver'}');
    buffer.writeln('Rating: $selectedRating/5 stars');
    buffer.writeln('');
    if (selectedQuickActions.isNotEmpty) {
      buffer.writeln('Quick Feedback:');
      for (String action in selectedQuickActions) {
        buffer.writeln('• $action');
      }
      buffer.writeln('');
    }
    if (_commentController.text.trim().isNotEmpty) {
      buffer.writeln('Comments:');
      buffer.writeln(_commentController.text.trim());
      buffer.writeln('');
    }
    if (currentLocation != null) {
      buffer.writeln(
          'Location: ${currentLocation!.latitude}, ${currentLocation!.longitude}');
    }
    return buffer.toString();
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not launch $url');
      }
    } catch (e) {
      _showError('Error launching URL: $e');
    }
  }

  void _showFileSizeError(String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fileName is too large. Maximum size is 10MB.'),
        backgroundColor: AppColors.dangerColor,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.dangerColor,
      ),
    );
  }

  Widget _buildBusInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.feedbackTarget == FeedbackTarget.bus
                    ? [AppColors.primaryColor, AppColors.primaryDark]
                    : [AppColors.accentColor, AppColors.accentDark],
              ),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: (widget.feedbackTarget == FeedbackTarget.bus
                          ? AppColors.primaryColor
                          : AppColors.accentColor)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              widget.feedbackTarget == FeedbackTarget.bus
                  ? Icons.directions_bus
                  : Icons.person,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: AppDesign.spaceLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus ${widget.busNumber}',
                  style: const TextStyle(
                    fontSize: AppDesign.text2XL,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  ),
                  child: Text(
                    '${widget.feedbackTarget == FeedbackTarget.bus ? 'Bus' : 'Driver'} Feedback',
                    style: const TextStyle(
                      fontSize: AppDesign.textSM,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate your experience',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            _getRatingDescription(),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildStarRating(),
          if (selectedRating > 0) ...[
            const SizedBox(height: AppDesign.spaceMD),
            _buildRatingFeedback(),
          ],
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => _selectRating(index + 1),
          child: AnimatedBuilder(
            animation: _starControllers[index],
            builder: (context, child) {
              return Transform.scale(
                scale: selectedRating > index ? 1.2 : 1.0,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppDesign.spaceXS),
                  child: Icon(
                    selectedRating > index ? Icons.star : Icons.star_outline,
                    size: 40,
                    color: selectedRating > index
                        ? _getStarColor(index + 1)
                        : AppColors.greyMedium,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildRatingFeedback() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: _getRatingColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        border: Border.all(
          color: _getRatingColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getRatingIcon(),
            color: _getRatingColor(),
            size: 20,
          ),
          const SizedBox(width: AppDesign.spaceSM),
          Text(
            _getRatingText(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _getRatingColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final actions = widget.feedbackTarget == FeedbackTarget.bus
        ? busQuickActions
        : driverQuickActions;

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick feedback (optional)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceSM),
          const Text(
            'Select a common feedback or write your own below',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Wrap(
            spacing: AppDesign.spaceSM,
            runSpacing: AppDesign.spaceSM,
            children:
                actions.map((action) => _buildQuickActionChip(action)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String action) {
    final isSelected = selectedQuickActions.contains(action);
    final isPositive = _isPositiveAction(action);

    return GestureDetector(
      onTap: () => _selectQuickAction(action),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceMD,
          vertical: AppDesign.spaceSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isPositive ? AppColors.successColor : AppColors.warningColor)
              : AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppDesign.radiusFull),
          border: isSelected
              ? Border.all(
                  color: isPositive
                      ? AppColors.successColor
                      : AppColors.warningColor,
                  width: 2,
                )
              : null,
        ),
        child: Text(
          action,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceSM),
          const Text(
            'Share more details about your experience (optional)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Type your feedback here...',
              hintStyle: const TextStyle(
                color: AppColors.textHint,
              ),
              filled: true,
              fillColor: AppColors.greyExtraLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
              counterStyle: const TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
              ),
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: const BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSubmit() ? _submitFeedback : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Submit Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _getRatingDescription() {
    if (widget.feedbackTarget == FeedbackTarget.bus) {
      return 'How would you rate the overall condition and comfort of the bus?';
    } else {
      return 'How would you rate the driver\'s performance and professionalism?';
    }
  }

  void _selectRating(int rating) {
    setState(() {
      selectedRating = rating;
    });

    // Animate stars
    for (int i = 0; i < rating; i++) {
      _starControllers[i].forward();
    }
    for (int i = rating; i < 5; i++) {
      _starControllers[i].reverse();
    }
  }

  void _selectQuickAction(String action) {
    setState(() {
      if (selectedQuickActions.contains(action)) {
        selectedQuickActions.remove(action);
      } else {
        selectedQuickActions.add(action);
      }
    });
  }

  Color _getStarColor(int rating) {
    if (rating <= 2) return AppColors.dangerColor;
    if (rating == 3) return AppColors.warningColor;
    return AppColors.successColor;
  }

  Color _getRatingColor() {
    if (selectedRating <= 2) return AppColors.dangerColor;
    if (selectedRating == 3) return AppColors.warningColor;
    return AppColors.successColor;
  }

  IconData _getRatingIcon() {
    if (selectedRating <= 2) return Icons.sentiment_very_dissatisfied;
    if (selectedRating == 3) return Icons.sentiment_neutral;
    if (selectedRating == 4) return Icons.sentiment_satisfied;
    return Icons.sentiment_very_satisfied;
  }

  String _getRatingText() {
    switch (selectedRating) {
      case 1:
        return 'Very Poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  bool _isPositiveAction(String action) {
    const positiveKeywords = [
      'clean',
      'comfortable',
      'good',
      'excellent',
      'courteous',
      'helpful',
      'safe',
      'professional',
      'works well',
    ];

    return positiveKeywords.any(
      (keyword) => action.toLowerCase().contains(keyword),
    );
  }

  bool _canSubmit() {
    return selectedRating > 0 && !isSubmitting;
  }

  Future<void> _submitFeedback() async {
    if (!_canSubmit()) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      // Get current user info
      final authState = ref.read(authStateProvider);
      final user = {
        'id': authState.user?.uid ?? 'anonymous',
        'name': authState.user?.displayName ?? 'Anonymous User',
        'email': authState.user?.email ?? '',
      };

      debugPrint('🔍 Starting feedback submission...');
      debugPrint('👤 User: ${user['name']} (${user['id']})');
      debugPrint('🚌 Bus: ${widget.busNumber}');
      debugPrint('⭐ Rating: $selectedRating');
      debugPrint('📝 Comment: ${_commentController.text.trim()}');

      // Submit to Firebase
      await ref.read(feedbackControllerProvider.notifier).submitFeedback(
        userId: user['id']!,
        userName: user['name']!,
        busId: widget.busNumber,
        busNumber: widget.busNumber,
        rating: selectedRating,
        comment: _commentController.text.trim().isEmpty
            ? selectedQuickActions.join(', ').isEmpty
                ? _getRatingText()
                : selectedQuickActions.join(', ')
            : _commentController.text.trim(),
        category: widget.feedbackTarget == FeedbackTarget.bus
            ? FeedbackCategory.vehicle
            : FeedbackCategory.driver,
        type:
            selectedRating >= 4 ? FeedbackType.positive : FeedbackType.negative,
        title: selectedQuickActions.join(', ').isEmpty
            ? _getRatingText()
            : selectedQuickActions.first,
        metadata: {
          'feedbackTarget': widget.feedbackTarget.name,
          'quickActions': selectedQuickActions.toList(),
          'platform': 'mobile',
          'userEmail': user['email']!,
          'submittedAt': DateTime.now().toIso8601String(),
        },
      );

      debugPrint('✅ Feedback submitted successfully!');

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  List<String> _generateTags() {
    final tags = <String>[];

    tags.add(widget.feedbackTarget.name);
    tags.add('bus-${widget.busNumber}');
    tags.add('rating-$selectedRating');

    for (String action in selectedQuickActions) {
      if (_isPositiveAction(action)) {
        tags.add('positive');
      } else {
        tags.add('negative');
      }
    }

    return tags;
  }

  FeedbackPriority _getPriority() {
    if (selectedRating <= 2) return FeedbackPriority.high;
    if (selectedRating == 3) return FeedbackPriority.medium;
    return FeedbackPriority.low;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.successColor,
                size: 48,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            const Text(
              'Feedback Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            const Text(
              'Thank you for your feedback. It helps us improve our service.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close feedback page
              Navigator.of(context).pop(); // Close feedback system page
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error,
                color: AppColors.errorColor,
                size: 48,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            const Text(
              'Submission Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            const Text(
              'Failed to submit feedback. Please try again.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Try Again',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
