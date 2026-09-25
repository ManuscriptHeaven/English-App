import 'package:equatable/equatable.dart';

/// Secure parent authentication session entity.
class AuthSession extends Equatable {
  final String parentId;
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  const AuthSession({
    required this.parentId,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
        'parentId': parentId,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAt': expiresAt.toIso8601String(),
      };

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
        parentId: json['parentId'] as String,
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String?,
        expiresAt: DateTime.parse(json['expiresAt'] as String),
      );

  @override
  List<Object?> get props => [parentId, accessToken, refreshToken, expiresAt];
}
