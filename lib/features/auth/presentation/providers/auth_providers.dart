import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local_auth_repository.dart';
import '../../domain/models/parent_account.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/auth_service.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return LocalAuthRepository();
});

final authServiceProvider = Provider<AuthService>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthService(repo);
});

final currentParentAccountProvider = FutureProvider<ParentAccount?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentAccount();
});
