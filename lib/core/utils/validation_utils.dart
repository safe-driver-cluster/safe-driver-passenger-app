class ValidationUtils {
  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Phone number validation (basic)
  static bool isValidPhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Check if length is valid (8-15 digits)
    return cleanPhone.length >= 8 && cleanPhone.length <= 15;
  }

  // Password validation
  static bool isValidPassword(String password) {
    // At least 8 characters, contains uppercase, lowercase, number
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  // Name validation
  static bool isValidName(String name) {
    return name.trim().length >= 2 &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim());
  }

  // Vehicle registration validation
  static bool isValidRegistration(String registration) {
    return registration.trim().length >= 3 && registration.trim().length <= 10;
  }

  // Route number validation
  static bool isValidRouteNumber(String routeNumber) {
    return routeNumber.trim().isNotEmpty && routeNumber.trim().length <= 20;
  }

  // License number validation
  static bool isValidLicenseNumber(String licenseNumber) {
    return licenseNumber.trim().length >= 5 &&
        licenseNumber.trim().length <= 20;
  }

  // Validation error messages
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!isValidPassword(value)) {
      return 'Password must be at least 8 characters with uppercase, lowercase, and number';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!isValidName(value)) {
      return 'Please enter a valid name (letters and spaces only)';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid 6-digit OTP';
    }
    return null;
  }

  static String? validateRating(int? rating) {
    if (rating == null || rating < 1 || rating > 5) {
      return 'Please provide a rating between 1 and 5';
    }
    return null;
  }

  static String? validateFeedback(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Feedback description is required';
    }
    if (value.trim().length < 10) {
      return 'Please provide more detailed feedback (at least 10 characters)';
    }
    if (value.trim().length > 1000) {
      return 'Feedback is too long (maximum 1000 characters)';
    }
    return null;
  }

  // Sanitization methods
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'[<>"/\\\x00-\x1f\x7f-\x9f]'), '');
  }

  static String sanitizeName(String name) {
    return name
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) =>
            part.substring(0, 1).toUpperCase() +
            part.substring(1).toLowerCase())
        .join(' ');
  }

  static String sanitizePhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  // Format validation
  static bool isValidLatitude(double lat) {
    return lat >= -90.0 && lat <= 90.0;
  }

  static bool isValidLongitude(double lng) {
    return lng >= -180.0 && lng <= 180.0;
  }

  static bool isValidUrl(String url) {
    return Uri.tryParse(url) != null &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }

  // Date validation
  static bool isValidDate(DateTime date) {
    final now = DateTime.now();
    final hundredYearsAgo = DateTime(now.year - 100);
    return date.isAfter(hundredYearsAgo) && date.isBefore(now);
  }

  static bool isValidBirthDate(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.difference(birthDate).inDays / 365;
    return age >= 13 && age <= 120; // Minimum age 13, maximum 120
  }

  static bool isValidFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  // Business logic validation
  static bool isValidSafetyScore(double score) {
    return score >= 0.0 && score <= 100.0;
  }

  static bool isValidSpeed(double speed) {
    return speed >= 0.0 && speed <= 200.0; // Reasonable speed range in km/h
  }

  static bool isValidCapacity(int capacity) {
    return capacity > 0 && capacity <= 100; // Reasonable bus capacity
  }

  // File validation
  static bool isValidImageFile(String fileName) {
    final extensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return extensions.any((ext) => fileName.toLowerCase().endsWith(ext));
  }

  static bool isValidVideoFile(String fileName) {
    final extensions = ['.mp4', '.avi', '.mov', '.wmv', '.flv'];
    return extensions.any((ext) => fileName.toLowerCase().endsWith(ext));
  }

  static bool isValidFileSize(int sizeInBytes, int maxSizeInMB) {
    return sizeInBytes <= (maxSizeInMB * 1024 * 1024);
  }

  // Composite validation for forms
  static Map<String, String?> validateRegistrationForm({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) {
    return {
      'firstName': validateName(firstName),
      'lastName': validateName(lastName),
      'email': validateEmail(email),
      'phoneNumber': validatePhoneNumber(phoneNumber),
      'password': validatePassword(password),
      'confirmPassword': validateConfirmPassword(confirmPassword, password),
    };
  }

  static Map<String, String?> validateLoginForm({
    required String email,
    required String password,
  }) {
    return {
      'email': validateEmail(email),
      'password': password.isEmpty ? 'Password is required' : null,
    };
  }

  static Map<String, String?> validateFeedbackForm({
    required String title,
    required String description,
    required int rating,
  }) {
    return {
      'title': validateRequired(title, 'Title'),
      'description': validateFeedback(description),
      'rating': validateRating(rating),
    };
  }

  // Helper method to check if form is valid
  static bool isFormValid(Map<String, String?> validationResults) {
    return validationResults.values.every((error) => error == null);
  }

  // Get first error from validation results
  static String? getFirstError(Map<String, String?> validationResults) {
    for (String? error in validationResults.values) {
      if (error != null) return error;
    }
    return null;
  }
}
