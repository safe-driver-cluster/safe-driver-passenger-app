import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/driver_model.dart';
import '../../../data/repositories/driver_repository.dart';
import '../../widgets/common/loading_widget.dart';

class DriverInfoPage extends ConsumerStatefulWidget {
  final String driverId;
  final String? driverName;

  const DriverInfoPage({
    super.key,
    required this.driverId,
    this.driverName,
  });

  @override
  ConsumerState<DriverInfoPage> createState() => _DriverInfoPageState();
}

class _DriverInfoPageState extends ConsumerState<DriverInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DriverModel? _driver;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDriverInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDriverInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final driverRepository = DriverRepository();
      final driver = await driverRepository.getDriverById(widget.driverId);

      if (mounted) {
        setState(() {
          _driver = driver;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Driver Information'),
            if (widget.driverName != null)
              Text(
                widget.driverName!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        bottom: _driver != null
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Safety'),
                  Tab(text: 'Performance'),
                  Tab(text: 'History'),
                ],
              )
            : null,
      ),
      body: _isLoading
          ? const LoadingWidget(
              isLoading: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading driver information...'),
                  ],
                ),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.errorColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading driver info',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadDriverInfo,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : _driver == null
                  ? const Center(child: Text('Driver not found'))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildProfileTab(),
                        _buildSafetyTab(),
                        _buildPerformanceTab(),
                        _buildHistoryTab(),
                      ],
                    ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Photo
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _driver!.profileImageUrl != null
                        ? NetworkImage(_driver!.profileImageUrl!)
                        : null,
                    child: _driver!.profileImageUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.textSecondary,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_driver!.firstName} ${_driver!.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _driver!.status.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Safety Score',
                        '${_driver!.safetyScore.toInt()}%',
                        Icons.security,
                        _driver!.safetyScore > 80
                            ? AppColors.successColor
                            : _driver!.safetyScore > 60
                                ? AppColors.warningColor
                                : AppColors.errorColor,
                      ),
                      _buildStatItem(
                        'Experience',
                        '${_driver!.experience.totalYears} years',
                        Icons.timeline,
                        AppColors.primaryColor,
                      ),
                      _buildStatItem(
                        'Rating',
                        '${_driver!.rating.toStringAsFixed(1)} ★',
                        Icons.star,
                        AppColors.warningColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Personal Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Email', _driver!.email),
                  _buildInfoRow('Phone', _driver!.phoneNumber),
                  _buildInfoRow('Date of Birth',
                      '${_driver!.dateOfBirth.day}/${_driver!.dateOfBirth.month}/${_driver!.dateOfBirth.year}'),
                  _buildInfoRow('License Number', _driver!.licenseNumber),
                  _buildInfoRow('License Type', _driver!.licenseType),
                  _buildInfoRow('License Expiry',
                      '${_driver!.licenseExpiryDate.day}/${_driver!.licenseExpiryDate.month}/${_driver!.licenseExpiryDate.year}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Current Status
          if (_driver!.isActive) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.work, color: AppColors.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Current Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_driver!.currentBusId != null)
                      _buildInfoRow('Current Bus', _driver!.currentBusId!),
                    if (_driver!.currentRoute != null)
                      _buildInfoRow('Current Route', _driver!.currentRoute!),
                    _buildInfoRow('Alertness Level',
                        '${(_driver!.alertnessLevel * 100).toInt()}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Certifications
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Certifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_driver!.certifications.isEmpty)
                    const Text(
                      'No certifications available',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    ...(_driver!.certifications
                        .map((cert) => _buildCertificationItem(cert))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Safety Score Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Safety Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            sections: [
                              PieChartSectionData(
                                color: _driver!.safetyScore > 80
                                    ? AppColors.successColor
                                    : _driver!.safetyScore > 60
                                        ? AppColors.warningColor
                                        : AppColors.errorColor,
                                value: _driver!.safetyScore,
                                radius: 40,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                color: AppColors.greyLight,
                                value: 100 - _driver!.safetyScore,
                                radius: 40,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_driver!.safetyScore.toInt()}%',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _driver!.safetyScore > 80
                                    ? AppColors.successColor
                                    : _driver!.safetyScore > 60
                                        ? AppColors.warningColor
                                        : AppColors.errorColor,
                              ),
                            ),
                            Text(
                              _getSafetyGrade(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Safety Metrics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Safety Metrics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem(
                        'Total Trips',
                        '${_driver!.experience.totalTrips}',
                        Icons.calendar_today,
                        AppColors.successColor,
                      ),
                      _buildMetricItem(
                        'Safety Incidents',
                        '${_driver!.performance.safetyIncidents.toInt()}',
                        Icons.warning,
                        AppColors.errorColor,
                      ),
                      _buildMetricItem(
                        'Alertness',
                        '${(_driver!.alertnessLevel * 100).toInt()}%',
                        Icons.visibility,
                        AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Health Record
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.health_and_safety,
                          color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Health Record',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Last Medical Check',
                      '${_driver!.healthRecord.lastMedicalExam.day}/${_driver!.healthRecord.lastMedicalExam.month}/${_driver!.healthRecord.lastMedicalExam.year}'),
                  _buildInfoRow(
                      'Medical Status',
                      _driver!.healthRecord.isHealthy
                          ? 'Healthy'
                          : 'Health Issues'),
                  _buildInfoRow('Medical Exam Due',
                      '${_driver!.healthRecord.nextMedicalExam.day}/${_driver!.healthRecord.nextMedicalExam.month}/${_driver!.healthRecord.nextMedicalExam.year}'),
                  _buildInfoRow(
                      'Medical Conditions',
                      _driver!.healthRecord.medicalConditions.isEmpty
                          ? 'None'
                          : _driver!.healthRecord.medicalConditions.join(', ')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Performance Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPerformanceCard(
                        'Total Trips',
                        _driver!.experience.totalTrips.toString(),
                        Icons.directions_bus,
                        AppColors.primaryColor,
                      ),
                      _buildPerformanceCard(
                        'Total Distance',
                        '${_driver!.experience.totalKilometers.toStringAsFixed(0)} km',
                        Icons.straighten,
                        AppColors.successColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPerformanceCard(
                        'Punctuality',
                        '${_driver!.performance.punctualityScore.toStringAsFixed(1)}%',
                        Icons.schedule,
                        AppColors.warningColor,
                      ),
                      _buildPerformanceCard(
                        'Fuel Efficiency',
                        _driver!.performance.fuelEfficiencyScore
                            .toStringAsFixed(1),
                        Icons.local_gas_station,
                        AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Route Specializations
          if (_driver!.specializations.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.route, color: AppColors.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Route Specializations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _driver!.specializations
                          .map(
                            (spec) => Chip(
                              label: Text(spec),
                              backgroundColor:
                                  AppColors.primaryColor.withOpacity(0.1),
                              labelStyle: const TextStyle(
                                  color: AppColors.primaryColor),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Training History
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.school, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Training History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_driver!.trainingHistory.isEmpty)
                    const Text(
                      'No training records available',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _driver!.trainingHistory.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final training = _driver!.trainingHistory[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.school,
                            color: AppColors.primaryColor,
                          ),
                          title: Text(training.name),
                          subtitle: Text(
                            'Completed: ${training.completedDate.day}/${training.completedDate.month}/${training.completedDate.year}',
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: training.passed
                                  ? AppColors.successColor
                                  : AppColors.errorColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              training.passed ? 'Passed' : 'Failed',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationItem(Certification cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyExtraLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified,
            color:
                !cert.isExpired ? AppColors.successColor : AppColors.greyMedium,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Expires: ${cert.expiryDate.day}/${cert.expiryDate.month}/${cert.expiryDate.year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: !cert.isExpired
                  ? AppColors.successColor
                  : AppColors.greyMedium,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              !cert.isExpired ? 'Active' : 'Expired',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_driver!.status) {
      case DriverStatus.active:
        return AppColors.successColor;
      case DriverStatus.onBreak:
        return AppColors.warningColor;
      case DriverStatus.offDuty:
        return AppColors.greyMedium;
      case DriverStatus.unavailable:
        return AppColors.errorColor;
      default:
        return AppColors.greyMedium;
    }
  }

  String _getSafetyGrade() {
    if (_driver!.safetyScore >= 90) return 'Excellent';
    if (_driver!.safetyScore >= 80) return 'Good';
    if (_driver!.safetyScore >= 70) return 'Fair';
    if (_driver!.safetyScore >= 60) return 'Poor';
    return 'Critical';
  }
}
