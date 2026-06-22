class AppValidators {
  AppValidators._();

  static String? required(
    String? value, {
    required String fieldLabel,
    bool isArabic = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return isArabic ? '$fieldLabel مطلوب' : '$fieldLabel is required';
    }
    return null;
  }

  static String? minLength(
    String? value, {
    required int min,
    required String fieldLabel,
    bool isArabic = false,
  }) {
    if (value == null || value.trim().length < min) {
      return isArabic
          ? '$fieldLabel لازم يكون $min حروف على الأقل'
          : '$fieldLabel must be at least $min characters';
    }
    return null;
  }
}
