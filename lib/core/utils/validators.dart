class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!re.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final n = num.tryParse(value);
    if (n == null || n <= 0) return 'Enter a positive number';
    return null;
  }
}
