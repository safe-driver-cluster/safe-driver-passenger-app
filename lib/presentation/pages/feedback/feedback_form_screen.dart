import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/core/constants/color_constants.dart';
import 'package:safedriver_passenger_app/core/constants/design_constants.dart';

import '../../../data/models/passenger_model.dart';
import '../../../data/services/feedback_service.dart';
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

  final List<Map<String, String>> _feedbackTypes = [
    {'value': 'positive', 'label': 'Positive'},
    {'value': 'negative', 'label': 'Negative'},
    {'value': 'neutral', 'label': 'Neutral'},
    {'value': 'suggestion', 'label': 'Suggestion'},
    {'value': 'inquiry', 'label': 'Inquiry'},
    {'value': 'urgent', 'label': 'Urgent'},
    {'value': 'general', 'label': 'General'},
  ];

  final List<Map<String, String>> _categories = [
    {'value': 'service', 'label': 'Service'},
    {'value': 'safety', 'label': 'Safety'},
    {'value': 'comfort', 'label': 'Comfort'},
    {'value': 'driver', 'label': 'Driver'},
    {'value': 'vehicle', 'label': 'Vehicle'},
    {'value': 'route', 'label': 'Route'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback(PassengerModel passenger) async {
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
            content: Text(
                'Feedback submitted successfully! ID: ${feedbackId.substring(0, 8)}...'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback: ${e.toString()}'),
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
              _buildModernHeader(),

              // Content Area
              Expanded(
                child: LoadingWidget(
        isLoading: _isSubmitting,
        child: passengerAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
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
                  'Failed to load passenger data',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
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
              return const Center(
                child: Text('No passenger profile found'),
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
                    _buildPassengerInfoCard(passenger),

                    const SizedBox(height: 16),

                    // Feedback Type and Category
                    _buildBasicInfoCard(),

                    const SizedBox(height: 16),

                    // Ratings
                    _buildRatingsCard(),

                    const SizedBox(height: 16),

                    // Feedback Content
                    _buildContentCard(),

                    const SizedBox(height: 16),

                    // Options
                    _buildOptionsCard(),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _submitFeedback(passenger),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Submit Feedback',
                                style: TextStyle(
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

  Widget _buildModernHeader() {
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
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: AppDesign.iconLG,
                  ),
                ),
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
                      'Submit Feedback',
                      style: TextStyle(
                        fontSize: AppDesign.text2XL,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: AppDesign.spaceXS),
                    
                    Text(
                      'Share your experience and help us improve',
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

  Widget _buildPassengerInfoCard(PassengerModel passenger) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Passenger Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Name: ${passenger.fullName}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Email: ${passenger.email}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Phone: ${passenger.phoneNumber}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (passenger.stats.totalTrips > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Total Trips: ${passenger.stats.totalTrips}',
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

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.category,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Feedback Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Feedback Type',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _feedbackTypes.map((type) {
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
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories.map((category) {
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

  Widget _buildRatingsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.star,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Ratings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRatingRow('Overall Experience', _overallRating, (rating) {
              setState(() => _overallRating = rating);
            }),
            _buildRatingRow('Safety', _safetyRating, (rating) {
              setState(() => _safetyRating = rating);
            }),
            _buildRatingRow('Comfort', _comfortRating, (rating) {
              setState(() => _comfortRating = rating);
            }),
            _buildRatingRow('Cleanliness', _cleanlinessRating, (rating) {
              setState(() => _cleanlinessRating = rating);
            }),
            _buildRatingRow('Punctuality', _punctualityRating, (rating) {
              setState(() => _punctualityRating = rating);
            }),
            _buildRatingRow('Driver Behavior', _driverBehaviorRating, (rating) {
              setState(() => _driverBehaviorRating = rating);
            }),
            _buildRatingRow('Vehicle Condition', _vehicleConditionRating,
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

  Widget _buildContentCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Feedback Content',
                  style: TextStyle(
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
                labelText: 'Title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Color(0xFF2563EB),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Submit anonymously'),
              subtitle:
                  const Text('Your personal information will not be shared'),
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
