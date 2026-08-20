import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  bool checkAuthStatus() {
    return _authService.isLoggedIn();
  }

  String? get currentUserEmail => _authService.getLoggedInUserEmail();

  Future<void> login({required String email, required String password}) async {
    final success = await _authService.login(email, password);
    if (!success) {
      throw Exception('Invalid email or password. Hint: Use admin@example.com / 123456');
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
