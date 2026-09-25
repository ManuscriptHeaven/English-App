/// Emotional expressions supported by animated dialogue characters.
enum CharacterExpression {
  happy,
  curious,
  thinking,
  encouraging,
  celebrating,
  concerned,
}

/// Character profile model.
class DialogueCharacter {
  final String id;
  final String name;
  final String avatarEmoji;
  final String voiceId;
  final CharacterExpression defaultExpression;

  const DialogueCharacter({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    this.voiceId = 'en-US-standard',
    this.defaultExpression = CharacterExpression.happy,
  });

  static const pip = DialogueCharacter(
    id: 'pip',
    name: 'Pip the Parrot',
    avatarEmoji: '🦜',
  );

  static const ayaan = DialogueCharacter(
    id: 'ayaan',
    name: 'Ayaan',
    avatarEmoji: '👦',
  );

  static const maryam = DialogueCharacter(
    id: 'maryam',
    name: 'Maryam',
    avatarEmoji: '👧',
  );

  static const mother = DialogueCharacter(
    id: 'mother',
    name: 'Mother',
    avatarEmoji: '🧕',
  );

  static const teacher = DialogueCharacter(
    id: 'teacher',
    name: 'Teacher Fatima',
    avatarEmoji: '👩‍🏫',
  );
}
