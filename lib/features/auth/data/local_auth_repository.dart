import 'dart:async';
import '../domain/models/auth_session.dart';
import '../domain/models/parent_account.dart';
import '../domain/repositories/auth_repository.dart';

/// Local-first implementation of IAuthRepository with session persistence.
class LocalAuthRepository implements IAuthRepository {
  ParentAccount? _currentAccount;
  AuthSession? _currentSession;
  final Map<String, ParentAccount> _accounts = {};

  LocalAuthRepository() {
    _seedDefaultAccount();
  }

  void _seedDefaultAccount() {
    final now = DateTime.now();
    final defaultParent = ParentAccount(
      id: 'parent_1',
      email: 'parent@adventure.kids',
      displayName: 'Family Explorer Parent',
      createdAt: now,
      updatedAt: now,
      lastLoginAt: now,
      subscriptionStatus: 'free_tier',
      privacyConsentVersion: 'v1.0',
    );
    _accounts[defaultParent.email] = defaultParent;
    _currentAccount = defaultParent;
    _currentSession = AuthSession(
      parentId: defaultParent.id,
      accessToken: 'token_mock_session_2026',
      refreshToken: 'refresh_mock_2026',
      expiresAt: now.add(const Duration(days: 30)),
    );
  }

  @override
  Future<ParentAccount?> getCurrentAccount() async => _currentAccount;

  @override
  Future<AuthSession?> getCurrentSession() async => _currentSession;

  @override
  Future<ParentAccount> registerWithEmail(String email, String password, String displayName) async {
    final cleanEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(cleanEmail)) {
      throw Exception('An account with this email already exists.');
    }

    final now = DateTime.now();
    final newAccount = ParentAccount(
      id: 'parent_${DateTime.now().millisecondsSinceEpoch}',
      email: cleanEmail,
      displayName: displayName.trim(),
      createdAt: now,
      updatedAt: now,
      lastLoginAt: now,
    );

    _accounts[cleanEmail] = newAccount;
    _currentAccount = newAccount;
    _currentSession = AuthSession(
      parentId: newAccount.id,
      accessToken: 'token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: now.add(const Duration(days: 30)),
    );
    return newAccount;
  }

  @override
  Future<ParentAccount> loginWithEmail(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final account = _accounts[cleanEmail];
    if (account == null) {
      throw Exception('Invalid email or password.');
    }

    final now = DateTime.now();
    final updated = account.copyWith(lastLoginAt: now, updatedAt: now);
    _accounts[cleanEmail] = updated;
    _currentAccount = updated;
    _currentSession = AuthSession(
      parentId: updated.id,
      accessToken: 'token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: now.add(const Duration(days: 30)),
    );
    return updated;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (!_accounts.containsKey(cleanEmail)) {
      throw Exception('No account found for this email address.');
    }
  }

  @override
  Future<void> logout() async {
    _currentAccount = null;
    _currentSession = null;
  }

  @override
  Future<void> saveAccount(ParentAccount account) async {
    _accounts[account.email] = account;
    if (_currentAccount?.id == account.id) {
      _currentAccount = account;
    }
  }

  @override
  Future<void> deleteAccount(String parentId) async {
    _accounts.removeWhere((key, value) => value.id == parentId);
    if (_currentAccount?.id == parentId) {
      _currentAccount = null;
      _currentSession = null;
    }
  }
}
