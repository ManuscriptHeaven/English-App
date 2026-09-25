import '../models/auth_session.dart';
import '../models/parent_account.dart';
import '../repositories/auth_repository.dart';

/// Application authentication service wrapping account management and session lifecycle.
class AuthService {
  final IAuthRepository _repository;

  AuthService(this._repository);

  Future<ParentAccount?> getCurrentAccount() => _repository.getCurrentAccount();

  Future<AuthSession?> getCurrentSession() => _repository.getCurrentSession();

  Future<bool> isAuthenticated() async {
    final session = await _repository.getCurrentSession();
    return session != null && !session.isExpired;
  }

  Future<ParentAccount> register(String email, String password, String displayName) {
    return _repository.registerWithEmail(email, password, displayName);
  }

  Future<ParentAccount> login(String email, String password) {
    return _repository.loginWithEmail(email, password);
  }

  Future<void> sendPasswordReset(String email) {
    return _repository.sendPasswordResetEmail(email);
  }

  Future<void> logout() {
    return _repository.logout();
  }
}
