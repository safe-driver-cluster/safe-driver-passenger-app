import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';
import 'package:video_player/video_player.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/feedback_model.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../controllers/feedback_controller.dart';

class FeedbackHistoryPage extends ConsumerStatefulWidget {
  const FeedbackHistoryPage({super.key});

  @override
  ConsumerState<FeedbackHistoryPage> createState() =>
      _FeedbackHistoryPageState();
}

class _FeedbackHistoryPageState extends ConsumerState<FeedbackHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFeedback());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFeedback() async {
    final user = ref.read(authStateProvider).user;
    if (user?.uid == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);
    await ref
        .read(feedbackControllerProvider.notifier)
        .loadUserFeedback(user!.uid);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    final feedbackController = ref.read(feedbackControllerProvider.notifier);

    return Scaffold(
      backgroundColor: th.background,
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
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(th, l10n),
              Expanded(
                child: ValueListenableBuilder<List<FeedbackModel>>(
                  valueListenable: feedbackController.feedbacksNotifier,
                  builder: (context, feedbacks, _) {
                    final sortedFeedbacks = feedbacks.toList()
                      ..sort(
                        (a, b) => _getDisplayDateTime(b).compareTo(
                          _getDisplayDateTime(a),
                        ),
                      );
                    final filteredFeedbacks =
                        sortedFeedbacks.where(_matchesSearch).toList();

                    if (_isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      );
                    }

                    if (feedbacks.isEmpty) {
                      return _buildMessageState(
                        th,
                        Icons.rate_review_outlined,
                        l10n.noFeedbackYet,
                        l10n.noFeedbackSubtitle,
                      );
                    }

                    if (filteredFeedbacks.isEmpty) {
                      return _buildMessageState(
                        th,
                        Icons.search_off_rounded,
                        'No feedback found',
                        'Try another bus, category, or status.',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadFeedback,
                      child: ListView(
                        padding: const EdgeInsets.all(AppDesign.spaceLG),
                        children: [
                          _buildSummary(th, sortedFeedbacks),
                          const SizedBox(height: AppDesign.spaceMD),
                          ...filteredFeedbacks.map(
                            (feedback) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDesign.spaceMD,
                              ),
                              child: _buildFeedbackCard(th, feedback, l10n),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeHelper th, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomBackButton(
                color: Colors.white,
                backgroundColor: Color(0x33FFFFFF),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Text(
                  l10n.feedbackHistory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              IconButton(
                onPressed: _isLoading ? null : _loadFeedback,
                icon: Icon(
                  Icons.refresh_rounded,
                  color: _isLoading ? Colors.white54 : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Container(
            decoration: BoxDecoration(
              color: th.cardBackground,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: th.textPrimary),
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Search by bus, category, status...',
                hintStyle: TextStyle(
                  color: th.textHint,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: th.textHint,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceLG,
                  vertical: AppDesign.spaceMD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(ThemeHelper th, List<FeedbackModel> feedbacks) {
    final resolvedCount = feedbacks.where((item) => item.isResolved).length;
    final averageRating = feedbacks.isEmpty
        ? 0.0
        : feedbacks.fold<int>(0, (sum, item) => sum + item.rating.overall) /
            feedbacks.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildSummaryTile(
            feedbacks.length.toString(),
            'Total',
            Icons.rate_review_rounded,
          ),
          const SizedBox(width: 10),
          _buildSummaryTile(
            resolvedCount.toString(),
            'Resolved',
            Icons.check_circle_rounded,
          ),
          const SizedBox(width: 10),
          _buildSummaryTile(
            averageRating.toStringAsFixed(1),
            'Avg Rating',
            Icons.star_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTile(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.16)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(
    ThemeHelper th,
    FeedbackModel feedback,
    AppLocalizations l10n,
  ) {
    final feedbackDate = DateFormat('MMM dd, yyyy, hh:mm a')
        .format(_getDisplayDateTime(feedback));
    final busText = feedback.busNumber?.trim().isNotEmpty == true
        ? l10n.busLabel(feedback.busNumber!)
        : 'General Feedback';
    final bodyText = feedback.comment.trim().isNotEmpty
        ? feedback.comment
        : feedback.description;
    final statusColor = _getStatusColor(feedback.status);

    return Container(
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: th.border),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.feedback_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      busText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: th.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feedback.title.isEmpty
                          ? feedback.categoryDisplay
                          : feedback.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: th.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(statusColor, feedback.statusDisplay),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildRatingStars(feedback.rating.overall),
              const SizedBox(width: 8),
              Text(
                '${feedback.rating.overall}/5',
                style: TextStyle(
                  color: th.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _buildChip(feedback.categoryDisplay),
            ],
          ),
          if (bodyText.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              bodyText,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: th.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
          if (_getFeedbackMedia(feedback).isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildFeedbackMediaStrip(th, feedback),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 16, color: th.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  feedbackDate,
                  style: TextStyle(
                    color: th.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (feedback.hasResponse)
                const Icon(
                  Icons.mark_chat_read_rounded,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<_FeedbackMediaItem> _getFeedbackMedia(FeedbackModel feedback) {
    final media = <_FeedbackMediaItem>[];
    final seenUrls = <String>{};

    void addMedia(String? url, {String? fileType}) {
      final trimmedUrl = url?.trim();
      if (trimmedUrl == null || trimmedUrl.isEmpty) return;
      if (!seenUrls.add(trimmedUrl)) return;

      media.add(
        _FeedbackMediaItem(
          url: trimmedUrl,
          fileType: fileType ?? _inferMediaType(trimmedUrl),
        ),
      );
    }

    for (final imageUrl in feedback.images) {
      addMedia(imageUrl);
    }

    for (final attachment in feedback.attachments) {
      addMedia(attachment.fileUrl, fileType: attachment.fileType);
    }

    final metadataUrls = feedback.metadata['mediaUrls'];
    if (metadataUrls is List) {
      for (final url in metadataUrls) {
        addMedia(url?.toString());
      }
    }

    return media;
  }

  Widget _buildFeedbackMediaStrip(ThemeHelper th, FeedbackModel feedback) {
    final media = _getFeedbackMedia(feedback);

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = media[index];
          return _buildMediaPreviewTile(th, item, index + 1);
        },
      ),
    );
  }

  Widget _buildMediaPreviewTile(
    ThemeHelper th,
    _FeedbackMediaItem item,
    int number,
  ) {
    return InkWell(
      onTap: () => _openMediaPreview(item),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 92,
        height: 92,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: th.subtleBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: th.border),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.isImage)
              Image.network(
                item.url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildMediaFallback(th, item),
              )
            else
              _buildMediaFallback(th, item),
            Positioned(
              left: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (item.isVideo)
              const Center(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xB3000000),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaFallback(ThemeHelper th, _FeedbackMediaItem item) {
    return Container(
      color: AppColors.primaryColor.withValues(alpha: 0.08),
      child: Icon(
        item.isVideo ? Icons.videocam_rounded : Icons.broken_image_rounded,
        color: AppColors.primaryColor,
        size: 28,
      ),
    );
  }

  void _openMediaPreview(_FeedbackMediaItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(18),
          backgroundColor: Colors.black,
          child: AspectRatio(
            aspectRatio: item.isVideo ? 16 / 9 : 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: item.isVideo
                      ? _FeedbackVideoPreview(url: item.url)
                      : InteractiveViewer(
                          child: Image.network(
                            item.url,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: Colors.white70,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _inferMediaType(String url) {
    final lowerUrl = Uri.decodeFull(url).toLowerCase();
    if (lowerUrl.contains('.mp4')) return 'video/mp4';
    if (lowerUrl.contains('.mov')) return 'video/quicktime';
    if (lowerUrl.contains('.avi')) return 'video/x-msvideo';
    if (lowerUrl.contains('.mkv')) return 'video/x-matroska';
    if (lowerUrl.contains('.webp')) return 'image/webp';
    if (lowerUrl.contains('.png')) return 'image/png';
    if (lowerUrl.contains('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  Widget _buildStatusBadge(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
          color: AppColors.primaryColor,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildMessageState(
    ThemeHelper th,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: th.textSecondary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: th.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: th.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _matchesSearch(FeedbackModel feedback) {
    if (_searchQuery.isEmpty) return true;

    final values = [
      feedback.busNumber,
      feedback.driverName,
      feedback.title,
      feedback.comment,
      feedback.description,
      feedback.categoryDisplay,
      feedback.statusDisplay,
      feedback.typeDisplay,
    ].map((value) => (value ?? '').toLowerCase());

    return values.any((value) => value.contains(_searchQuery));
  }

  DateTime _getDisplayDateTime(FeedbackModel feedback) {
    if (feedback.feedbackDateTime != null) {
      return feedback.feedbackDateTime!;
    }

    final metadataDate = feedback.metadata['feedbackDateTime'];
    if (metadataDate is String) {
      return DateTime.tryParse(metadataDate) ?? feedback.submittedAt;
    }

    return feedback.submittedAt;
  }

  Color _getStatusColor(FeedbackStatus status) {
    switch (status) {
      case FeedbackStatus.submitted:
      case FeedbackStatus.received:
        return AppColors.primaryColor;
      case FeedbackStatus.inReview:
      case FeedbackStatus.responded:
        return Colors.orange.shade700;
      case FeedbackStatus.resolved:
      case FeedbackStatus.closed:
        return Colors.green.shade700;
      case FeedbackStatus.escalated:
        return Colors.red.shade700;
    }
  }
}

class _FeedbackMediaItem {
  final String url;
  final String fileType;

  const _FeedbackMediaItem({
    required this.url,
    required this.fileType,
  });

  bool get isVideo => fileType.startsWith('video/');
  bool get isImage => fileType.startsWith('image/');
}

class _FeedbackVideoPreview extends StatefulWidget {
  final String url;

  const _FeedbackVideoPreview({required this.url});

  @override
  State<_FeedbackVideoPreview> createState() => _FeedbackVideoPreviewState();
}

class _FeedbackVideoPreviewState extends State<_FeedbackVideoPreview> {
  late final VideoPlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      }).catchError((_) {
        if (mounted) setState(() => _hasError = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Icon(
          Icons.videocam_off_rounded,
          color: Colors.white70,
          size: 48,
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (!_controller.value.isPlaying)
            const CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xB3000000),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
        ],
      ),
    );
  }
}
