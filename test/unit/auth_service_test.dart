import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/auth/data/local_auth_repository.dart';
import 'package:kids_english_adventure/features/auth/domain/services/auth_service.dart';

void main() {
  group('Parent Authentication & Session Tests', () {
    late LocalAuthRepository repo;
    late AuthService authService;

    setUp(() {
      repo = LocalAuthRepository();
      authService = AuthService(repo);
    });

    test('Initializes with seeded parent account and active session', () async {
      final account = await authService.getCurrentAccount();
      expect(account, isNotNull);
      expect(account!.email, equals('parent@adventure.kids'));
      expect(await authService.isAuthenticated(), isTrue);
    });

    test('Registers a new parent account and generates session token', () async {
      final newAccount = await authService.register(
        'mother.amina@example.com',
        'securePass123',
        'Mother Amina',
      );

      expect(newAccount.email, equals('mother.amina@example.com'));
      expect(newAccount.displayName, equals('Mother Amina'));

      final session = await authService.getCurrentSession();
      expect(session, isNotNull);
      expect(session!.parentId, equals(newAccount.id));
      expect(session.isExpired, isFalse);
    });

    test('Logs in existing parent and updates lastLoginAt', () async {
      final account = await authService.login('parent@adventure.kids', 'password');
      expect(account.email, equals('parent@adventure.kids'));
      expect(account.lastLoginAt, isNotNull);
    });

    test('Throws exception on invalid login email', () async {
      expect(
        () => authService.login('nonexistent@example.com', 'password'),
        throwsA(isA<Exception>()),
      );
    });

    test('Logs out parent and clears active session', () async {
      expect(await authService.isAuthenticated(), isTrue);
      await authService.logout();
      expect(await authService.isAuthenticated(), isFalse);
      expect(await authService.getCurrentAccount(), isNull);
    });

    test('Sends password reset without throwing error for valid email', () async {
      await expectLater(
        authService.sendPasswordReset('parent@adventure.kids'),
        completes,
      );
    });
  });
}
