import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/core/constants/color_constants.dart';
import 'package:safedriver_passenger_app/core/utils/theme_helper.dart';
import 'package:safedriver_passenger_app/data/models/faq_model.dart';
import 'package:safedriver_passenger_app/data/services/support_data_service.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final SupportDataService _supportService = SupportDataService();
  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _filteredFAQs = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _showOnlyPopular = false;

  @override
  void initState() {
    super.initState();
    _loadFAQs();
    _categories = _supportService.getFAQCategories();
    _categories.insert(0, 'All');
    _searchController.addListener(_filterFAQs);
  }

  void _loadFAQs() {
    setState(() {
      _filteredFAQs = _supportService.getAllFAQs();
    });
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      List<FAQItem> faqs;

      if (_showOnlyPopular) {
        faqs = _supportService.getPopularFAQs();
      } else if (_selectedCategory == 'All') {
        faqs = _supportService.getAllFAQs();
      } else {
        faqs = _supportService.getFAQsByCategory(_selectedCategory);
      }

      if (query.isEmpty) {
        _filteredFAQs = faqs;
      } else {
        _filteredFAQs = faqs
            .where((faq) =>
                faq.question.toLowerCase().contains(query) ||
                faq.answer.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomBackButton(
                          color: th.isDark ? th.textPrimary : Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: th.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: th.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search FAQs...',
                      hintStyle: TextStyle(
                        color: th.textSecondary,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primaryColor,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: th.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Category Filter & Popular Toggle
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Popular Toggle
                            Row(
                              children: [
                                Text(
                                  'Show Popular Questions',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: th.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                Switch(
                                  value: _showOnlyPopular,
                                  onChanged: (value) {
                                    setState(() {
                                      _showOnlyPopular = value;
                                    });
                                    _filterFAQs();
                                  },
                                  activeThumbColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Category Pills
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _categories.map((category) {
                                  final isSelected =
                                      _selectedCategory == category;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(category),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedCategory = category;
                                        });
                                        _filterFAQs();
                                      },
                                      backgroundColor: th.subtleBackground,
                                      selectedColor: AppColors.primaryColor,
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? th.textOnPrimary
                                            : th.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : th.border,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // FAQ List
                      Expanded(
                        child: _filteredFAQs.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      size: 64,
                                      color: AppColors.textSecondary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No FAQs found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 32),
                                      child: Text(
                                        'Try different search terms or select another category',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredFAQs.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _buildFAQItem(_filteredFAQs[index]);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    final th = ThemeHelper.of(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                faq.question,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: th.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (faq.isPopular)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Popular',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.successColor,
                  ),
                ),
              ),
          ],
        ),
        collapsedBackgroundColor: th.subtleBackground,
        backgroundColor: th.subtleBackground.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: th.border),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: th.border),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.answer,
                  style: TextStyle(
                    fontSize: 13,
                    color: th.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Category: ${faq.category}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.infoColor,
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
}
