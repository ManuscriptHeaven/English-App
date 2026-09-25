import 'package:equatable/equatable.dart';

/// Parent account domain entity.
class ParentAccount extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final String subscriptionStatus; // placeholder: 'free_tier', 'premium', 'family_pass'
  final String privacyConsentVersion;
  final Map<String, dynamic> settings;

  const ParentAccount({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.subscriptionStatus = 'free_tier',
    this.privacyConsentVersion = 'v1.0',
    this.settings = const {},
  });

  ParentAccount copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    String? subscriptionStatus,
    String? privacyConsentVersion,
    Map<String, dynamic>? settings,
  }) {
    return ParentAccount(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      privacyConsentVersion: privacyConsentVersion ?? this.privacyConsentVersion,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'lastLoginAt': lastLoginAt?.toIso8601String(),
        'subscriptionStatus': subscriptionStatus,
        'privacyConsentVersion': privacyConsentVersion,
        'settings': settings,
      };

  factory ParentAccount.fromJson(Map<String, dynamic> json) => ParentAccount(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['displayName'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'] as String)
            : null,
        subscriptionStatus: json['subscriptionStatus'] as String? ?? 'free_tier',
        privacyConsentVersion: json['privacyConsentVersion'] as String? ?? 'v1.0',
        settings: (json['settings'] as Map<String, dynamic>?) ?? {},
      );

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        createdAt,
        updatedAt,
        lastLoginAt,
        subscriptionStatus,
        privacyConsentVersion,
        settings,
      ];
}
