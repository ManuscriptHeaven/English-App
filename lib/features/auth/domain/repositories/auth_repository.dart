import '../models/auth_session.dart';
import '../models/parent_account.dart';

/// Abstract repository interface for managing Parent Accounts and Sessions.
abstract class IAuthRepository {
  Future<ParentAccount?> getCurrentAccount();
  Future<AuthSession?> getCurrentSession();
  Future<ParentAccount> registerWithEmail(String email, String password, String displayName);
  Future<ParentAccount> loginWithEmail(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
  Future<void> saveAccount(ParentAccount account);
  Future<void> deleteAccount(String parentId);
}
