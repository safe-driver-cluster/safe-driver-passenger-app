# Dark Theme Comprehensive Fix Guide

## Strategy
Fix all hardcoded colors across the app by:
1. Importing `ThemeHelper` from `lib/core/utils/theme_helper.dart`
2. Using `final th = ThemeHelper.of(context)` at the start of build methods
3. Replacing hardcoded colors with `th.*` properties
4. Handling gradients, shadows, and borders appropriately

## Color Mapping Reference

### Light Theme → Dark Theme Replacements
- `Colors.white` → Check context (backgrounds: `th.cardBackground`, text: `th.textPrimary`)
- `Colors.grey` variants → `th.textSecondary`, `th.textHint`, `th.border`
- `AppColors.textPrimary` → `th.textPrimary`
- `AppColors.scaffoldBackground` → `th.background`
- `AppColors.cardColor` → `th.cardBackground`
- Hardcoded `0xFF` colors → Use theme-aware alternatives
- `Colors.black.withOpacity()` → `th.shadowMedium`, `th.shadowLight`

## Files Needing Fixes (Critical)

### Auth Pages (7 files)
- [x] splash_page.dart - FIXED
- [ ] login_page.dart - Needs theme helper integration
- [ ] register_page.dart
- [ ] otp_verification_page.dart
- [ ] phone_input_page.dart
- [ ] forgot_password_page.dart
- [ ] forgot_password_otp_page.dart
- [ ] account_verification_page.dart
- [ ] reset_password_page.dart

### Dashboard Pages (3 files)
- [ ] dashboard_page.dart
- [ ] home_page.dart
- [ ] safe_driver_dashboard.dart

### Profile Pages (8 files)
- [ ] user_profile_page.dart
- [ ] faq_page.dart
- [ ] about_page.dart
- [ ] help_support_page.dart
- [ ] notifications_page.dart
- [ ] trip_history_page.dart
- [ ] support_category_page.dart
- [ ] received_notifications_page.dart
- [ ] live_chat_page.dart

### Safety Pages (7 files)
- [ ] emergency_page.dart
- [ ] sos_contacts_page.dart
- [ ] hazard_zones_page.dart
- [ ] safety_alerts_page.dart
- [ ] safety_tips_page.dart
- [ ] hazard_zone_intelligence_page.dart
- [ ] safety_hub_page.dart
- [ ] emergency_contacts_page.dart
- [ ] incident_report_page.dart

### Driver Pages (6 files)
- [ ] driver_list_page.dart
- [ ] driver_info_page.dart
- [ ] driver_profile_page.dart
- [ ] driver_rating_page.dart
- [ ] driver_history_page.dart
- [ ] driver_performance_page.dart

### Bus Pages (2 files)
- [ ] bus_list_page.dart
- [ ] live_map_widget.dart

### Feedback Pages (5 files)
- [ ] feedback_page.dart
- [ ] reviews_page.dart
- [ ] feedback_history_page.dart
- [ ] feedback_test_page.dart

### Other Pages (5+ files)
- [ ] map_page.dart
- [ ] language_selection_page.dart
- [ ] onboarding_page.dart
- [ ] qr_ticket_page.dart
- [ ] error_page.dart
- [ ] not_found_page.dart
- [ ] simple_maps_page.dart

### Widgets (Critical)
- [ ] emergency_button.dart
- [ ] sos_contacts_dialog.dart
- [ ] quick_actions_widget.dart
- [ ] All custom widgets with hardcoded colors

## Implementation Pattern

### Before (Hardcoded)
```dart
Container(
  color: Colors.white,
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.black87),
  ),
)
```

### After (Theme-Aware)
```dart
final th = ThemeHelper.of(context);

Container(
  color: th.cardBackground,
  child: Text(
    'Hello',
    style: TextStyle(color: th.textPrimary),
  ),
)
```

## Specific Rules

### Text Colors
- Primary text (headings, labels): Use `th.textPrimary`
- Secondary text (subtitles, descriptions): Use `th.textSecondary`
- Hints/placeholders: Use `th.textHint`
- Disabled text: Use `th.textDisabled`
- Text on colored backgrounds: Use `th.textOnPrimary` or white

### Background Colors
- Page background: Use `th.background`
- Cards/containers: Use `th.cardBackground`
- Input fields: Use `th.inputFill`
- Subtle separators: Use `th.subtleBackground`

### Border/Divider Colors
- Standard borders: Use `th.border`
- Light borders: Use `th.borderLight`
- Dividers: Use `th.divider`

### Shadow Colors
- Light shadows: Use `th.shadowLight`
- Medium shadows: Use `th.shadowMedium`

### Action Colors (Same in both themes)
- Primary actions: Use `th.primary` or `AppColors.primaryColor`
- Error/danger: Use `th.error` or `AppColors.errorColor`
- Success: Use `th.success` or `AppColors.successColor`
- Warning: Use `th.warning` or `AppColors.warningColor`

## Testing Checklist

- [ ] All text is readable in both light and dark modes
- [ ] All cards/containers have appropriate backgrounds
- [ ] All buttons are visible and clickable
- [ ] All icons are visible
- [ ] Shadows are appropriate for each theme
- [ ] Gradients work well (or are theme-aware)
- [ ] Status indicators (success, error, warning) are visible
- [ ] Input fields are usable
- [ ] Dialogs and bottom sheets are readable
- [ ] Navigation elements are clear

## Gradient Handling

Most gradients use primary colors which are action colors and don't need theme adjustment.
However, check custom gradients that might use white/black.

Example:
```dart
// Before - problematic in dark mode
gradient: LinearGradient(colors: [Colors.white, Colors.transparent])

// After - theme-aware
gradient: LinearGradient(colors: [
  th.isDark ? th.cardBackground : Colors.white,
  Colors.transparent
])
```
