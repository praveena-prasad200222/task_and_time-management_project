import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

class AuthService {
  Box get _authBox => Hive.box(AppConstants.authBoxName);

  bool isLoggedIn() {
    return _authBox.get(AppConstants.isLoggedInKey, defaultValue: false);
  }

  String? getLoggedInUserEmail() {
    return _authBox.get(AppConstants.loggedInUserEmailKey);
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.trim() == AppConstants.mockEmail && password == AppConstants.mockPassword) {
      await _authBox.put(AppConstants.isLoggedInKey, true);
      await _authBox.put(AppConstants.loggedInUserEmailKey, email.trim());
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _authBox.put(AppConstants.isLoggedInKey, false);
    await _authBox.delete(AppConstants.loggedInUserEmailKey);
  }
}
