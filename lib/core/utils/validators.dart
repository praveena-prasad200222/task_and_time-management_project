class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task Title is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Task Title must be at least 3 characters';
    }
    if (trimmed.length > 60) {
      return 'Task Title cannot exceed 60 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 5) {
      return 'Description must be at least 5 characters';
    }
    if (trimmed.length > 300) {
      return 'Description cannot exceed 300 characters';
    }
    return null;
  }

  static String? validateAssignedUser(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Assigned User is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Assigned User name must be at least 2 characters';
    }
    if (trimmed.length > 40) {
      return 'Assigned User name cannot exceed 40 characters';
    }
    return null;
  }
}
