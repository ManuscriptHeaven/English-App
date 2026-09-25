/// Strict classification of religious and moral content for pedagogical safety
/// and scholarly verification safeguards.
enum ReligiousContentType {
  /// Universal and child-friendly ethics: kindness, sharing, honesty, tidiness.
  generalMoralValue,

  /// Common cultural / daily Muslim lifestyle terms: Salam, Alhamdulillah, Eid, mosque.
  lifestyleVocabulary,

  /// Explicit pedagogical instruction on Islamic doctrine or duties.
  directReligiousTeaching,

  /// Direct translation or excerpt from the Noble Qur'an.
  quranicQuotation,

  /// Direct translation or narration from the Sunnah / Hadith collections.
  hadithQuotation,

  /// Juristic / legal rulings (fiqh). NOT permitted in automated/unreviewed content.
  religiousRuling;

  /// Whether content of this type strictly requires human scholarly review before production release.
  bool get requiresScholarReview {
    switch (this) {
      case ReligiousContentType.generalMoralValue:
      case ReligiousContentType.lifestyleVocabulary:
        return false;
      case ReligiousContentType.directReligiousTeaching:
      case ReligiousContentType.quranicQuotation:
      case ReligiousContentType.hadithQuotation:
      case ReligiousContentType.religiousRuling:
        return true;
    }
  }

  String get displayName {
    switch (this) {
      case ReligiousContentType.generalMoralValue:
        return 'General Moral Value (Universal)';
      case ReligiousContentType.lifestyleVocabulary:
        return 'Everyday Muslim Lifestyle Vocabulary';
      case ReligiousContentType.directReligiousTeaching:
        return 'Direct Religious Teaching (Scholar Review Required)';
      case ReligiousContentType.quranicQuotation:
        return 'Qur\'anic Quotation (Verification Required)';
      case ReligiousContentType.hadithQuotation:
        return 'Hadith Quotation (Verification Required)';
      case ReligiousContentType.religiousRuling:
        return 'Religious Ruling / Fiqh (Strict Review Required)';
    }
  }
}
