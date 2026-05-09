import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/core/constants/color_constants.dart';
import 'package:safedriver_passenger_app/core/constants/design_constants.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

import '../../../data/models/passenger_model.dart';
import '../../../data/services/feedback_service.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/passenger_provider.dart';
import '../../widgets/common/loading_widget.dart';

class FeedbackFormScreen extends ConsumerStatefulWidget {
  final String? busId;
  final String? driverId;
  final String? journeyId;

  const FeedbackFormScreen({
    super.key,
    this.busId,
    this.driverId,
    this.journeyId,
  });

  @override
  ConsumerState<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends ConsumerState<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'general';
  String _selectedCategory = 'service';
  String _selectedPriority = 'medium';
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  // Rating values
  int _overallRating = 0;
  int _safetyRating = 0;
  int _comfortRating = 0;
  int _cleanlinessRating = 0;
  int _punctualityRating = 0;
  int _driverBehaviorRating = 0;
  int _vehicleConditionRating = 0;

  List<Map<String, String>> _getFeedbackTypes(AppLocalizations l10n) => [
        {'value': 'positive', 'label': l10n.typePositive},
        {'value': 'negative', 'label': l10n.typeNegative},
        {'value': 'neutral', 'label': l10n.typeNeutral},
        {'value': 'suggestion', 'label': l10n.typeSuggestion},
        {'value': 'inquiry', 'label': l10n.typeInquiry},
        {'value': 'urgent', 'label': l10n.typeUrgent},
        {'value': 'general', 'label': l10n.typeGeneral},
      ];

  List<Map<String, String>> _getCategories(AppLocalizations l10n) => [
        {'value': 'service', 'label': l10n.categoryService},
        {'value': 'safety', 'label': l10n.categorySafety},
        {'value': 'comfort', 'label': l10n.categoryComfort},
        {'value': 'driver', 'label': l10n.categoryDriver},
        {'value': 'vehicle', 'label': l10n.categoryVehicle},
        {'value': 'route', 'label': l10n.categoryRoute},
      ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback(
      PassengerModel passenger, AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final feedbackService = FeedbackService.instance;
      final rating = FeedbackRating(
        overall: _overallRating,
        safety: _safetyRating,
        comfort: _comfortRating,
        cleanliness: _cleanlinessRating,
        punctuality: _punctualityRating,
        driverBehavior: _driverBehaviorRating,
        vehicleCondition: _vehicleConditionRating,
      );

      final feedbackId = await feedbackService.submitFeedback(
        userId: passenger.id,
        busId: widget.busId,
        driverId: widget.driverId,
        journeyId: widget.journeyId,
        type: _selectedType,
        category: _selectedCategory,
        rating: rating,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        isAnonymous: _isAnonymous,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(l10n.feedbackSuccessWithId(feedbackId.substring(0, 8))),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.feedbackFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final passengerAsync = ref.watch(currentPassengerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(l10n),

              // Content Area
              Expanded(
                child: LoadingWidget(
                  isLoading: _isSubmitting,
                  child: passengerAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.failedToLoadPassenger,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.pleaseTryAgainLater,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    data: (passenger) {
                      if (passenger == null) {
                        return Center(
                          child: Text(l10n.noPassengerProfile),
                        );
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Passenger Info Card (shows passenger details being used)
                              _buildPassengerInfoCard(passenger, l10n),

                              const SizedBox(height: 16),

                              // Feedback Type and Category
                              _buildBasicInfoCard(l10n),

                              const SizedBox(height: 16),

                              // Ratings
                              _buildRatingsCard(l10n),

                              const SizedBox(height: 16),

                              // Feedback Content
                              _buildContentCard(l10n),

                              const SizedBox(height: 16),

                              // Options
                              _buildOptionsCard(l10n),

                              const SizedBox(height: 24),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => _submitFeedback(passenger, l10n),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Text(
                                          l10n.submitFeedback,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(AppLocalizations l10n) {
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
              const CustomBackButton(
                color: Colors.white,
                backgroundColor: Color(0x33FFFFFF),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    // Add help functionality
                  },
                  icon: const Icon(
                    Icons.help_outline_rounded,
                    color: Colors.white,
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
                    Text(
                      l10n.submitFeedback,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      l10n.submitFeedbackSubtitle,
                      style: TextStyle(
                        fontSize: AppDesign.textMD,
                        color: Colors.white.withOpacity(0.8),
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

  Widget _buildPassengerInfoCard(
      PassengerModel passenger, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.passengerInformation,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.nameLabel(passenger.fullName),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.emailLabel(passenger.email),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.phoneLabel(passenger.phoneNumber),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (passenger.stats.totalTrips > 0) ...[
              const SizedBox(height: 4),
              Text(
                l10n.totalTripsLabel(passenger.stats.totalTrips),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.category,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.feedbackDetails,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.feedbackType,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _getFeedbackTypes(l10n).map((type) {
                return DropdownMenuItem<String>(
                  value: type['value'],
                  child: Text(type['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: l10n.categoryLabel,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _getCategories(l10n).map((category) {
                return DropdownMenuItem<String>(
                  value: category['value'],
                  child: Text(category['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsCard(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.ratings,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRatingRow(l10n.overallExperience, _overallRating, (rating) {
              setState(() => _overallRating = rating);
            }),
            _buildRatingRow(l10n.categorySafety, _safetyRating, (rating) {
              setState(() => _safetyRating = rating);
            }),
            _buildRatingRow(l10n.comfort, _comfortRating, (rating) {
              setState(() => _comfortRating = rating);
            }),
            _buildRatingRow(l10n.cleanliness, _cleanlinessRating, (rating) {
              setState(() => _cleanlinessRating = rating);
            }),
            _buildRatingRow(l10n.punctuality, _punctualityRating, (rating) {
              setState(() => _punctualityRating = rating);
            }),
            _buildRatingRow(l10n.driverBehavior, _driverBehaviorRating,
                (rating) {
              setState(() => _driverBehaviorRating = rating);
            }),
            _buildRatingRow(l10n.vehicleCondition, _vehicleConditionRating,
                (rating) {
              setState(() => _vehicleConditionRating = rating);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(
      String label, int rating, Function(int) onRatingChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => onRatingChanged(index + 1),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.edit,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.feedbackContent,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.title,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.titleRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.description,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.descriptionRequired;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsCard(AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.settings,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.options,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedPriority,
              decoration: InputDecoration(
                labelText: l10n.priority,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [
                DropdownMenuItem(value: 'low', child: Text(l10n.priorityLow)),
                DropdownMenuItem(
                    value: 'medium', child: Text(l10n.priorityMedium)),
                DropdownMenuItem(value: 'high', child: Text(l10n.priorityHigh)),
                DropdownMenuItem(
                    value: 'urgent', child: Text(l10n.priorityUrgent)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text(l10n.anonymousFeedback),
              subtitle: Text(l10n.anonymousFeedbackSubtitle),
              value: _isAnonymous,
              onChanged: (value) {
                setState(() {
                  _isAnonymous = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
    );
  }
}
