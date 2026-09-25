/// Structured event record for logged safety incidents.
class AiSafetyEvent {
  final String childId;
  final DateTime timestamp;
  final String category;
  final String rawSnippet;

  const AiSafetyEvent({
    required this.childId,
    required this.timestamp,
    required this.category,
    required this.rawSnippet,
  });

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'timestamp': timestamp.toIso8601String(),
        'category': category,
        'rawSnippet': rawSnippet,
      };
}

/// Deterministic safety evaluation result.
class SafetyCheckResult {
  final bool isSafe;
  final String sanitizedInput;
  final String? blockedReason;
  final String redirectMessage;
  final AiSafetyEvent? loggedEvent;

  const SafetyCheckResult({
    required this.isSafe,
    required this.sanitizedInput,
    this.blockedReason,
    this.redirectMessage = "Let's talk about our fun English lesson! 🌟",
    this.loggedEvent,
  });
}

/// Deterministic pre-processing safety layer inspecting child inputs.
/// Operates locally with zero network calls, zero API key exposure, and strict child privacy.
class AiSafetyGuard {
  // Static log of recorded safety events for parent diagnostic review
  static final List<AiSafetyEvent> safetyLog = [];

  // Regex filters for personal information
  static final _phoneRegex = RegExp(r'\b(?:\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b');
  static final _emailRegex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b');
  static final _streetRegex = RegExp(r'\b(?:\d+\s+[A-Za-z]+(?:\s+[A-Za-z]+)*\s+(?:Street|St|Road|Rd|Avenue|Ave|Drive|Dr|Boulevard|Blvd|Lane|Ln|Terrace|Terr|Way|Court|Ct|Place|Pl))\b', caseSensitive: false);

  // Private contact requests
  static final _contactRequests = [
    'call me',
    'text me',
    'whatsapp',
    'snapchat',
    'instagram',
    'tiktok',
    'meet me',
    'where do you live',
    'what is your address',
    'phone number',
  ];

  // Inappropriate keyword categories
  static final _secretWords = [
    'keep a secret',
    'dont tell mom',
    'dont tell dad',
    'secret code',
    'secret conversation',
    'private chat',
    'our little secret',
    'password',
    'passcode',
    'credit card',
    'bank account',
  ];

  // App exit / external navigation requests
  static final _appExitRequests = [
    'open youtube',
    'open browser',
    'open google',
    'leave the app',
    'go to website',
    'browse internet',
  ];

  // Unsafe topics
  static final _unsafeTopics = [
    'kill',
    'killing',
    'kill myself',
    'suicide',
    'die',
    'dead',
    'gun',
    'guns',
    'knife',
    'knives',
    'weapon',
    'weapons',
    'bomb',
    'bombs',
    'bullet',
    'rifle',
    'grenade',
    'fight',
    'fighting',
    'punch',
    'hit you',
    'murder',
    'stab',
    'blood',
    'bleed',
    'hurt myself',
    'cut myself',
    'end my life',
    'hate',
    'terrorist',
    'terrorists',
    'extremist',
    'naked',
    'sex',
    'porn',
    'drugs',
    'weed',
    'alcohol',
    'beer',
    'wine',
    'smoke',
    'cigarette',
    'steal',
    'shoplift',
    'rob a store',
    'play with fire',
    'drink poison',
  ];

  /// Validates child input before passing to AI provider.
  static SafetyCheckResult inspectInput(String input, {String childId = 'child_current'}) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const SafetyCheckResult(
        isSafe: true,
        sanitizedInput: '',
      );
    }

    final lower = trimmed.toLowerCase();

    // 1. Check Phone numbers
    if (_phoneRegex.hasMatch(lower)) {
      final event = AiSafetyEvent(childId: childId, timestamp: DateTime.now(), category: 'phone_detected', rawSnippet: '[PHONE_REDACTED]');
      safetyLog.add(event);
      return SafetyCheckResult(
        isSafe: false,
        sanitizedInput: '',
        blockedReason: 'phone_number_detected',
        redirectMessage: "Let's protect our privacy and talk about our fun English lesson!",
        loggedEvent: event,
      );
    }

    // 2. Check Emails
    if (_emailRegex.hasMatch(lower)) {
      final event = AiSafetyEvent(childId: childId, timestamp: DateTime.now(), category: 'email_detected', rawSnippet: '[EMAIL_REDACTED]');
      safetyLog.add(event);
      return SafetyCheckResult(
        isSafe: false,
        sanitizedInput: '',
        blockedReason: 'email_detected',
        redirectMessage: "Let's keep our private info safe and practice English words!",
        loggedEvent: event,
      );
    }

    // 3. Check Street Addresses
    if (_streetRegex.hasMatch(lower)) {
      final event = AiSafetyEvent(childId: childId, timestamp: DateTime.now(), category: 'address_detected', rawSnippet: '[ADDRESS_REDACTED]');
      safetyLog.add(event);
      return SafetyCheckResult(
        isSafe: false,
        sanitizedInput: '',
        blockedReason: 'address_detected',
        redirectMessage: "We don't need to share locations! Let's explore our English world!",
        loggedEvent: event,
      );
    }

    // 4. Check Private Contact Requests
    for (final contact in _contactRequests) {
      if (lower.contains(contact)) {
        final event = AiSafetyEvent(childId: childId, timestamp: DateTime.now(), category: 'private_contact_request', rawSnippet: contact);
        safetyLog.add(event);
        return SafetyCheckResult(
          isSafe: false,
          sanitizedInput: '',
          blockedReason: 'private_contact_request',
          redirectMessage: "Pip is here to practice English with you in our safe app! 🦜",
          loggedEvent: event,
        );
      }
    }

    // 5. Check Secret Seeking or Passwords
    for (final phrase in _secretWords) {
      if (lower.contains(phrase)) {
        final event = AiSafetyEvent(childId: childId, timestamp: DateTime.now(), category: 'secret_seeking_detected', rawSnippet: phrase);
        safetyLog.add(event);
        return SafetyCheckResult(
          isSafe: false,
          sanitizedInput: '',
          blockedReason: 'secret_seeking_detected',
          redirectMessage: "We always share openly with parents! Let's continue our lesson.",
          loggedEvent: event,
        );
      }
    }

    // 6. Check App Exit / External Navigation Requests
    for (final exitReq in _appExitRequests) {
      if (lower.contains(exitReq)) {
        final event = AiSafetyEvent(childId: childId, timestamp: DateTime.now(), category: 'app_exit_request', rawSnippet: exitReq);
        safetyLog.add(event);
        return SafetyCheckResult(
          isSafe: false,
          sanitizedInput: '',
          blockedReason: 'app_exit_request',
          redirectMessage: "Let's stay right here in our adventure and finish our fun game! 🌟",
          loggedEvent: event,
        );
      }
    }

    // 7. Check Unsafe / Inappropriate Content
    for (final term in _unsafeTopics) {
      final pattern = RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false);
      if (pattern.hasMatch(lower)) {
        final event = AiSafetyEvent(childId: childId, timestamp: DateTime.now(), category: 'inappropriate_topic', rawSnippet: term);
        safetyLog.add(event);
        return SafetyCheckResult(
          isSafe: false,
          sanitizedInput: '',
          blockedReason: 'inappropriate_topic',
          redirectMessage: "Let's keep our conversation positive, kind, and focused on English! 🌟",
          loggedEvent: event,
        );
      }
    }

    return SafetyCheckResult(
      isSafe: true,
      sanitizedInput: trimmed,
    );
  }
}
