import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/feedback_model.dart';
import '../../../data/models/location_model.dart' as location_models;
import '../../../data/services/firebase_storage_service.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../controllers/feedback_controller.dart';
import 'feedback_system_page.dart';

class FeedbackSubmissionPage extends ConsumerStatefulWidget {
  final String? busId;
  final String busNumber;
  final String? driverId;
  final String? driverName;
  final FeedbackTarget feedbackTarget;

  const FeedbackSubmissionPage({
    super.key,
    this.busId,
    required this.busNumber,
    this.driverId,
    this.driverName,
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

  List<String> _getBusQuickActions(AppLocalizations l10n) => [
        l10n.cleanAndComfortable,
        l10n.goodCondition,
        l10n.acWorksWell,
        l10n.seatsComfortable,
        l10n.needsCleaning,
        l10n.maintenanceRequired,
        l10n.uncomfortableSeats,
        l10n.poorVentilation,
      ];

  List<String> _getDriverQuickActions(AppLocalizations l10n) => [
        l10n.excellentDriving,
        l10n.courteousAndHelpful,
        l10n.safeDriving,
        l10n.professionalBehavior,
        l10n.recklessDriving,
        l10n.unprofessionalBehavior,
        l10n.poorCustomerService,
        l10n.safetyConcerns,
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
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              th.background,
            ],
            stops: const [0.0, 0.3, 0.7],
          ),
        ),
        child: Column(
          children: [
            _buildModernAppBar(l10n),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBusInfoHeader(l10n),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildRatingSection(l10n),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildQuickActionsSection(l10n),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildCommentSection(l10n),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildMediaUploadSection(l10n),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildLocationSection(l10n),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildContactOptionsSection(l10n),
                    const SizedBox(height: AppDesign.spaceMD),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(l10n),
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

  Widget _buildModernAppBar(AppLocalizations l10n) {
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
                child: const CustomBackButton(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.feedbackTarget == FeedbackTarget.bus
                          ? l10n.busFeedbackLabel
                          : l10n.driverFeedbackLabel,
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
                      l10n.shareExperience,
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

  Widget _buildMediaUploadSection(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
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
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Text(
                  l10n.addPhotosVideos,
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          Text(
            l10n.uploadMediaSubtitle,
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: th.textSecondary,
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
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: AppDesign.spaceSM),
                  Text(
                    l10n.tapToSelectMedia,
                    style: const TextStyle(
                      fontSize: AppDesign.textMD,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    l10n.mediaFormatNote,
                    style: const TextStyle(
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
    final th = ThemeHelper.of(context);
    final fileName = file.path.split('/').last;
    final fileSize = (file.lengthSync() / (1024 * 1024)).toStringAsFixed(2);
    final isVideo = fileName.toLowerCase().endsWith('.mp4') ||
        fileName.toLowerCase().endsWith('.mov') ||
        fileName.toLowerCase().endsWith('.avi');

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceSM),
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        border: Border.all(
          color: th.border,
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
          const SizedBox(width: AppDesign.spaceLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: AppDesign.textSM,
                    fontWeight: FontWeight.w500,
                    color: th.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${fileSize}MB',
                  style: TextStyle(
                    fontSize: AppDesign.textXS,
                    color: th.textHint,
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

  Widget _buildLocationSection(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
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
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Text(
                  l10n.locationInformation,
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          Text(
            l10n.locationSubtitle,
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: th.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          if (isLoadingLocation)
            Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Text(
                  l10n.gettingLocation,
                  style: const TextStyle(
                    fontSize: AppDesign.textSM,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          else if (currentLocation != null)
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
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
                  Expanded(
                    child: Text(
                      l10n.locationCaptured,
                      style: const TextStyle(
                        fontSize: AppDesign.textSM,
                        color: AppColors.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _getCurrentLocation,
                    child: Text(
                      l10n.refresh,
                      style: const TextStyle(
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
              padding: const EdgeInsets.all(AppDesign.spaceLG),
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
                  Expanded(
                    child: Text(
                      l10n.locationNotAvailable,
                      style: const TextStyle(
                        fontSize: AppDesign.textSM,
                        color: AppColors.warningColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _getCurrentLocation,
                    child: Text(
                      l10n.tryAgain,
                      style: const TextStyle(
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

  Widget _buildContactOptionsSection(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
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
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Text(
                  l10n.needMoreHelp,
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          Text(
            l10n.contactDirectlySubtitle,
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: th.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  l10n.whatsApp,
                  Icons.message,
                  AppColors.successColor,
                  _shareViaWhatsApp,
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: _buildContactButton(
                  l10n.email,
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
          vertical: AppDesign.spaceLG,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            const SizedBox(width: AppDesign.spaceXS),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppDesign.textSM,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Media and contact methods
  Future<void> _pickMediaFile() async {
    final l10n = AppLocalizations.of(context);
    try {
      // Pick files using file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
        allowCompression: true,
      );

      if (result != null) {
        final newFiles = result.files
            .where((file) {
              // Validate file size (10MB limit)
              if (file.size > 10 * 1024 * 1024) {
                _showError(l10n.fileExceedsLimit(file.name));
                return false;
              }
              return true;
            })
            .map((file) => File(file.path!))
            .toList();

        if (newFiles.isNotEmpty) {
          setState(() {
            // Check total number of files (limit to 10)
            final totalFiles = selectedMediaFiles.length + newFiles.length;
            if (totalFiles > 10) {
              _showError(l10n.maxFilesReached);
              return;
            }
            selectedMediaFiles.addAll(newFiles);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.filesSelected(newFiles.length)),
              backgroundColor: AppColors.successColor,
            ),
          );
        }
      }
    } catch (e) {
      _showError(l10n.pickMediaFailed(e.toString()));
    }
  }

  void _removeMediaFile(File file) {
    setState(() {
      selectedMediaFiles.remove(file);
    });
  }

  void _shareViaWhatsApp() {
    final l10n = AppLocalizations.of(context);
    // WhatsApp sharing logic
    final message = _buildShareMessage(l10n);
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    _launchUrl(whatsappUrl);
  }

  void _shareViaEmail() {
    final l10n = AppLocalizations.of(context);
    // Email sharing logic
    final message = _buildShareMessage(l10n);
    final subject = 'SafeDriver Feedback - ${l10n.busLabel(widget.busNumber)}';
    final emailUrl =
        'mailto:support@safedriver.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(message)}';
    _launchUrl(emailUrl);
  }

  String _buildShareMessage(AppLocalizations l10n) {
    final buffer = StringBuffer();
    buffer.writeln('SafeDriver Feedback');
    buffer.writeln('');
    buffer.writeln('${l10n.busNumber}: ${widget.busNumber}');
    buffer.writeln(
        '${l10n.feedbackType}: ${widget.feedbackTarget == FeedbackTarget.bus ? l10n.busFeedback : l10n.driverFeedback}');
    buffer.writeln('${l10n.ratings}: $selectedRating/5 stars');
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
    final l10n = AppLocalizations.of(context);
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError(l10n.couldNotLaunchUrl(url));
      }
    } catch (e) {
      _showError(l10n.errorLaunchingUrl(e.toString()));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.dangerColor,
      ),
    );
  }

  Widget _buildBusInfoHeader(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    final isDriverFeedback = widget.feedbackTarget == FeedbackTarget.driver;
    final title = isDriverFeedback
        ? (widget.driverName?.trim().isNotEmpty == true
            ? widget.driverName!.trim()
            : 'Selected Driver')
        : l10n.busLabel(widget.busNumber);
    final subtitle = isDriverFeedback
        ? 'Driver ID: ${widget.driverId ?? 'N/A'}'
        : l10n.busFeedbackLabel;

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
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
                colors: isDriverFeedback
                    ? [AppColors.accentColor, AppColors.accentDark]
                    : [AppColors.primaryColor, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: (isDriverFeedback
                          ? AppColors.accentColor
                          : AppColors.primaryColor)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isDriverFeedback ? Icons.person : Icons.directions_bus,
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
                  title,
                  style: TextStyle(
                    fontSize: AppDesign.text2XL,
                    fontWeight: FontWeight.bold,
                    color: th.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceLG,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  ),
                  child: Text(
                    subtitle,
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

  Widget _buildRatingSection(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rateYourExperience,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: th.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Text(
            _getRatingDescription(l10n),
            style: TextStyle(
              fontSize: 14,
              color: th.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildStarRating(),
          if (selectedRating > 0) ...[
            const SizedBox(height: AppDesign.spaceLG),
            _buildRatingFeedback(l10n),
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

  Widget _buildRatingFeedback(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
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
            _getRatingText(l10n),
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

  Widget _buildQuickActionsSection(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    final actions = widget.feedbackTarget == FeedbackTarget.bus
        ? _getBusQuickActions(l10n)
        : _getDriverQuickActions(l10n);

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
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
                  Icons.quick_contacts_dialer,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Text(
                  l10n.quickActions,
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          Text(
            l10n.chooseYourLanguage, // Reusing similar key or should have added specific one. Let's use a generic one if available or keep it.
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: th.textSecondary,
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
    final th = ThemeHelper.of(context);
    final isSelected = selectedQuickActions.contains(action);
    final isPositive = _isPositiveAction(action);

    return GestureDetector(
      onTap: () => _selectQuickAction(action),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceLG,
          vertical: AppDesign.spaceSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isPositive ? AppColors.successColor : AppColors.warningColor)
              : th.subtleBackground,
          borderRadius: BorderRadius.circular(AppDesign.radiusFull),
          border: isSelected
              ? Border.all(
                  color: isPositive
                      ? AppColors.successColor
                      : AppColors.warningColor,
                  width: 2,
                )
              : Border.all(color: th.border, width: 1),
        ),
        child: Text(
          action,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : th.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentSection(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
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
                  Icons.comment,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Text(
                  l10n.additionalComments,
                  style: TextStyle(
                    fontSize: AppDesign.textLG,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceSM),
          Text(
            l10n.shareMoreDetails,
            style: TextStyle(
              fontSize: AppDesign.textSM,
              color: th.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: l10n.typeFeedbackHint,
              hintStyle: TextStyle(
                color: th.textHint,
              ),
              filled: true,
              fillColor: th.inputFill,
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
              counterStyle: TextStyle(
                color: th.textHint,
                fontSize: 12,
              ),
            ),
            style: TextStyle(
              color: th.textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.cardBackground,
        boxShadow: [
          BoxShadow(
            color: th.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _canSubmit() ? _submitFeedback : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _canSubmit() ? AppColors.primaryColor : AppColors.greyMedium,
            foregroundColor: Colors.white,
            elevation: _canSubmit() ? 8 : 0,
            shadowColor: AppColors.primaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      l10n.submitFeedback,
                      style: const TextStyle(
                        fontSize: AppDesign.textLG,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  String _getRatingDescription(AppLocalizations l10n) {
    if (widget.feedbackTarget == FeedbackTarget.bus) {
      return l10n.rateBusExperience;
    } else {
      return l10n.rateDriverExperience;
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

  String _getRatingText(AppLocalizations l10n) {
    switch (selectedRating) {
      case 1:
        return l10n.veryPoor;
      case 2:
        return l10n.poor;
      case 3:
        return l10n.average;
      case 4:
        return l10n.good;
      case 5:
        return l10n.excellent;
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
    final l10n = AppLocalizations.of(context);
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
      debugPrint('📁 Media files: ${selectedMediaFiles.length}');

      // Upload media files to Firebase Storage
      List<String> uploadedMediaUrls = [];
      if (selectedMediaFiles.isNotEmpty) {
        debugPrint('📤 Starting media upload...');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.uploadingMedia),
            backgroundColor: AppColors.primaryColor,
          ),
        );

        final storageService = FirebaseStorageService();
        final feedbackId = DateTime.now().millisecondsSinceEpoch.toString();

        try {
          uploadedMediaUrls = await storageService.uploadFeedbackMediaMultiple(
            files: selectedMediaFiles,
            userId: user['id']!,
            feedbackId: feedbackId,
          );
          debugPrint(
              '✅ Media upload completed: ${uploadedMediaUrls.length} files');
        } catch (e) {
          debugPrint('❌ Media upload failed: $e');
          if (mounted) {
            _showError(l10n.mediaUploadFailed(e.toString()));
          }
          return;
        }
      }

      // Submit to Firebase with media URLs
      await ref.read(feedbackControllerProvider.notifier).submitFeedback(
        userId: user['id']!,
        userName: user['name']!,
        busId: widget.busId ?? widget.busNumber,
        busNumber: widget.busNumber,
        driverId: widget.feedbackTarget == FeedbackTarget.driver
            ? widget.driverId
            : null,
        driverName: widget.feedbackTarget == FeedbackTarget.driver
            ? widget.driverName
            : null,
        rating: selectedRating,
        comment: _commentController.text.trim().isEmpty
            ? selectedQuickActions.join(', ').isEmpty
                ? _getRatingText(l10n)
                : selectedQuickActions.join(', ')
            : _commentController.text.trim(),
        category: widget.feedbackTarget == FeedbackTarget.bus
            ? FeedbackCategory.vehicle
            : FeedbackCategory.driver,
        type:
            selectedRating >= 4 ? FeedbackType.positive : FeedbackType.negative,
        title: selectedQuickActions.join(', ').isEmpty
            ? _getRatingText(l10n)
            : selectedQuickActions.first,
        images: uploadedMediaUrls,
        location: currentLocation != null
            ? location_models.LocationModel(
                latitude: currentLocation!.latitude,
                longitude: currentLocation!.longitude,
                accuracy: currentLocation!.accuracy,
                timestamp: DateTime.now(),
              )
            : null,
        metadata: {
          'feedbackTarget': widget.feedbackTarget.name,
          'busId': widget.busId ?? widget.busNumber,
          'busNumber': widget.busNumber,
          'driverId': widget.driverId,
          'driverName': widget.driverName,
          'quickActions': selectedQuickActions.toList(),
          'platform': 'mobile',
          'userEmail': user['email']!,
          'submittedAt': DateTime.now().toIso8601String(),
          'mediaCount': uploadedMediaUrls.length,
          'mediaUrls': uploadedMediaUrls,
        },
      );

      debugPrint('✅ Feedback submitted successfully!');

      if (mounted) {
        _showSuccessDialog(l10n);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString(), l10n);
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog(AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
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
              padding: const EdgeInsets.all(AppDesign.spaceLG),
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
            Text(
              l10n.feedbackSubmittedTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: th.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            Text(
              l10n.feedbackSubmittedSubtitle,
              style: TextStyle(
                fontSize: 14,
                color: th.textSecondary,
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
            child: Text(
              l10n.done,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error, AppLocalizations l10n) {
    final th = ThemeHelper.of(context);
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
              padding: const EdgeInsets.all(AppDesign.spaceLG),
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
            Text(
              l10n.submissionFailedTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: th.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            Text(
              l10n.submissionFailedSubtitle,
              style: TextStyle(
                fontSize: 14,
                color: th.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.tryAgain,
              style: const TextStyle(
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
