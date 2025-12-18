import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/themes/app_theme.dart';
import '../../../data/models/feedback_model.dart';

/// Page displaying user's feedback history with filtering and search
class FeedbackHistoryPage extends StatefulWidget {
  const FeedbackHistoryPage({super.key});

  @override
  State<FeedbackHistoryPage> createState() => _FeedbackHistoryPageState();
}

class _FeedbackHistoryPageState extends State<FeedbackHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FeedbackModel> _filteredFeedback = [];
  final List<FeedbackModel> _allFeedback = [];

  // Filter state
  FeedbackStatus? _selectedStatus;
  FeedbackCategory? _selectedCategory;
  DateTimeRange? _selectedDateRange;
  bool _showWithAttachmentsOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback History'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Active filters display
          if (_hasActiveFilters) _buildActiveFiltersChips(),

          // Content
          Expanded(
            child: _buildFeedbackList(),
          ),
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search feedback...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGray),
          ),
            borderSide: const BorderSide(color: AppColors.greyLight),
          ),
        ),
        onChanged: (value) {
          setState(() => _applyFilters());
        },
      ),  
       );
  }

  /// Build active filters display
  Widget _buildActiveFiltersChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_selectedStatus != null)
            _buildFilterChip(
              label: _selectedStatus!.toString().split('.').last,
              onDelete: () => setState(() {
                _selectedStatus = null;
                _applyFilters();
              }),
            ),
          if (_selectedCategory != null)
            _buildFilterChip(
              label: _selectedCategory!.toString().split('.').last,
              onDelete: () => setState(() {
                _selectedCategory = null;
                _applyFilters();
              }),
            ),
          if (_selectedDateRange != null)
            _buildFilterChip(
              label:
                  '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
              onDelete: () => setState(() {
                _selectedDateRange = null;
                _applyFilters();
              }),
            ),
          if (_showWithAttachmentsOnly)
            _buildFilterChip(
              label: 'With Attachments',
              onDelete: () => setState(() {
                _showWithAttachmentsOnly = false;
                _applyFilters();
              }),
            ),
        ],
      ),
    );
  }

  /// Build individual filter chip
  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDelete,
  }) {
    return Chip(
      label: Text(label),
      onDeleted: onDelete,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: const TextStyle(color: AppColors.primary),
    );
  }

  /// Build feedback list
  Widget _buildFeedbackList() {
    if (_filteredFeedback.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: AppColors.gray.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No feedback found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.gray,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _filteredFeedback.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _buildFeedbackItem(_filteredFeedback[index]);
      },
    );
  }

  /// Build individual feedback item
  Widget _buildFeedbackItem(FeedbackModel feedback) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      title: Text(
        feedback.title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            feedback.description.length > 100
                ? '${feedback.description.substring(0, 100)}...'
                : feedback.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Rating
              _buildRatingBadge(feedback.rating.overall),
              const SizedBox(width: 8),

              // Status
              _buildStatusBadge(feedback.status),
              const SizedBox(width: 8),

              // Category
              _buildCategoryBadge(feedback.category),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                feedback.timeAgo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray,
                    ),
              ),
              if (feedback.attachments.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.attachment, size: 14, color: AppColors.gray),
                    const SizedBox(width: 4),
                    Text(
                      '${feedback.attachments.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gray,
                          ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
      onTap: () => _showFeedbackDetail(feedback),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  /// Build rating badge
  Widget _buildRatingBadge(int rating) {
    Color badgeColor;
    String label;

    switch (rating) {
      case 5:
        badgeColor = AppColors.successColor;
        label = '⭐ 5';
        break;
      case 4:
        badgeColor = AppColors.secondaryColor;
        label = '⭐ 4';
        break;
      case 3:
        badgeColor = AppColors.warningColor;
        label = '⭐ 3';
        break;
      case 2:
        badgeColor = AppColors.warningColorAlt;
        label = '⭐ 2';
        break;
      case 1:
        badgeColor = AppColors.dangerColor;
        label = '⭐ 1';
        break;
      default:
        badgeColor = AppColors.grey;
        label = 'N/A';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build status badge
  Widget _buildStatusBadge(FeedbackStatus status) {
    Color badgeColor;
    IconData iconData;

    switch (status) {
      case FeedbackStatus.submitted:
        badgeColor = AppColors.grey;
        iconData = Icons.pending;
        break;
      case FeedbackStatus.received:
        badgeColor = AppColors.infoColor;
        iconData = Icons.check_circle;
        break;
      case FeedbackStatus.inReview:
        badgeColor = AppColors.warningColor;
        iconData = Icons.hourglass_top;
        break;
      case FeedbackStatus.responded:
        badgeColor = AppColors.infoColor;
        iconData = Icons.reply;
        break;
      case FeedbackStatus.resolved:
        badgeColor = AppColors.successColor;
        iconData = Icons.done_all;
        break;
      case FeedbackStatus.closed:
        badgeColor = AppColors.grey;
        iconData = Icons.check_circle;
        break;
      case FeedbackStatus.escalated:
        badgeColor = AppColors.dangerColor;
        iconData = Icons.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 12, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            status.toString().split('.').last,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build category badge
  Widget _buildCategoryBadge(FeedbackCategory category) {
    const categoryColors = {
      FeedbackCategory.safety: AppColors.dangerColor,
      FeedbackCategory.service: AppColors.infoColor,
      FeedbackCategory.comfort: AppColors.accentColor,
      FeedbackCategory.driver: AppColors.warningColor,
      FeedbackCategory.vehicle: AppColors.tealAccent,
      FeedbackCategory.route: AppColors.primaryVariant,
      FeedbackCategory.general: AppColors.grey,
      FeedbackCategory.suggestion: AppColors.successColor,
      FeedbackCategory.complaint: AppColors.dangerColor,
      FeedbackCategory.compliment: AppColors.warningColorAlt,
    };

    final color = categoryColors[category] ?? AppColors.gray;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category.toString().split('.').last,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Show filter dialog
  Future<void> _showFilterDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Feedback'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status filter
              Text(
                'Status',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ..._buildStatusFilterOptions(),

              const SizedBox(height: 16),

              // Category filter
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ..._buildCategoryFilterOptions(),

              const SizedBox(height: 16),

              // Date range filter
              Text(
                'Date Range',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              _buildDateRangeFilter(),

              const SizedBox(height: 16),

              // Attachments filter
              CheckboxListTile(
                title: const Text('With Attachments Only'),
                value: _showWithAttachmentsOnly,
                onChanged: (value) {
                  setState(() => _showWithAttachmentsOnly = value ?? false);
                  Navigator.pop(context);
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                _selectedCategory = null;
                _selectedDateRange = null;
                _showWithAttachmentsOnly = false;
              });
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Build status filter options
  List<Widget> _buildStatusFilterOptions() {
    return FeedbackStatus.values.map((status) {
      return CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(status.toString().split('.').last),
        value: _selectedStatus == status,
        onChanged: (value) {
          setState(() {
            _selectedStatus = value == true ? status : null;
          });
          Navigator.pop(context);
          _applyFilters();
        },
      );
    }).toList();
  }

  /// Build category filter options
  List<Widget> _buildCategoryFilterOptions() {
    return FeedbackCategory.values.map((category) {
      return CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(category.toString().split('.').last),
        value: _selectedCategory == category,
        onChanged: (value) {
          setState(() {
            _selectedCategory = value == true ? category : null;
          });
          Navigator.pop(context);
          _applyFilters();
        },
      );
    }).toList();
  }

  /// Build date range filter
  Widget _buildDateRangeFilter() {
    return GestureDetector(
      onTap: () async {
        final DateTimeRange? range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: _selectedDateRange,
        );

        if (range != null) {
          setState(() {
            _selectedDateRange = range;
          });
          _applyFilters();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDateRange != null
                  ? '${DateFormat('MMM d, y').format(_selectedDateRange!.start)} - ${DateFormat('MMM d, y').format(_selectedDateRange!.end)}'
                  : 'Select date range',
            ),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
    );
  }

  /// Apply filters to feedback list
  void _applyFilters() {
    _filteredFeedback = _allFeedback.where((feedback) {
      // Search filter
      final searchTerm = _searchController.text.toLowerCase();
      final matchesSearch = searchTerm.isEmpty ||
          feedback.title.toLowerCase().contains(searchTerm) ||
          feedback.description.toLowerCase().contains(searchTerm);

      if (!matchesSearch) return false;

      // Status filter
      if (_selectedStatus != null && feedback.status != _selectedStatus) {
        return false;
      }

      // Category filter
      if (_selectedCategory != null &&
          feedback.category != _selectedCategory) {
        return false;
      }

      // Date range filter
      if (_selectedDateRange != null) {
        final isInRange = feedback.timestamp.isAfter(_selectedDateRange!.start) &&
            feedback.timestamp.isBefore(
              _selectedDateRange!.end.add(const Duration(days: 1)),
            );
        if (!isInRange) return false;
      }

      // Attachments filter
      if (_showWithAttachmentsOnly && feedback.attachments.isEmpty) {
        return false;
      }

      return true;
    }).toList();

    // Sort by timestamp descending
    _filteredFeedback
        .sort((a, b) => b.timestamp.compareTo(a.timestamp));

    setState(() {});
  }

  /// Show feedback detail
  void _showFeedbackDetail(FeedbackModel feedback) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFeedbackDetailSheet(feedback),
    );
  }

  /// Build feedback detail sheet
  Widget _buildFeedbackDetailSheet(FeedbackModel feedback) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                feedback.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // Metadata
              Row(
                children: [
                  Text(
                    feedback.timeAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray,
                        ),
                  ),
                  const SizedBox(width: 16),
                  _buildStatusBadge(feedback.status),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                feedback.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Rating
              Text(
                'Rating',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              _buildRatingBadge(feedback.rating.overall),
              const SizedBox(height: 16),

              // Attachments
              if (feedback.attachments.isNotEmpty) ...[
                Text(
                  'Attachments',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: feedback.attachments.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final attachment = feedback.attachments[index];
                      return GestureDetector(
                        onTap: () => _openAttachment(attachment.fileUrl),
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.greyLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey),
                          ),
                          child: Center(
                            child: Icon(
                              attachment.isImage
                                  ? Icons.image
                                  : attachment.isVideo
                                      ? Icons.videocam
                                      : Icons.description,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Response
              if (feedback.hasResponse) ...[
                Text(
                  'Response',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.response ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Responded on ${DateFormat('MMM d, y').format(feedback.respondedAt ?? DateTime.now())}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.gray,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Open attachment
  void _openAttachment(String url) {
    // Implementation would depend on file type
    // Could open image viewer, video player, or download document
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening attachment: $url')),
    );
  }

  /// Check if any filters are active
  bool get _hasActiveFilters =>
      _selectedStatus != null ||
      _selectedCategory != null ||
      _selectedDateRange != null ||
      _showWithAttachmentsOnly;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildModernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.white,
                    size: AppDesign.iconLG,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    // Add filter functionality
                  },
                  icon: const Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.white,
                    size: AppDesign.iconLG,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Feedback History',
                      style: TextStyle(
                        fontSize: AppDesign.text2XL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      'Track all your feedback submissions',
                      style: TextStyle(
                        fontSize: AppDesign.textMD,
                        color: AppColors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
