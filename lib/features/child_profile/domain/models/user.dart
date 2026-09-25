import 'package:equatable/equatable.dart';

/// Top-level account user.
class User extends Equatable {
  final String id;
  final String email;
  final bool isParentVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.isParentVerified = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'isParentVerified': isParentVerified,
        'createdAt': createdAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        isParentVerified: json['isParentVerified'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [id, email, isParentVerified, createdAt];
}
