import 'package:equatable/equatable.dart';
import '../models/learning_age_band.dart';
import '../models/learning_concept.dart';

/// Interaction pacing style matching a child's developmental processing speed.
enum InteractionPacing {
  relaxed, // 5–8s pauses, generous animations (Band A)
  standard, // 3–5s responsive transitions (Band B)
  brisk, // 1.5–2.5s rapid, streamlined flow (Band C & D)
}

/// Visual presentation card style ensuring older beginners are not subjected to preschool styling.
enum VisualCardStyle {
  playfulCartoonCard, // Band A: big chunky icons, high whimsy
  illustratedStoryCard, // Band B: clear narrative illustration, warm storybook style
  cleanRealisticCard, // Band C & D: mature, realistic/semi-realistic, modern UI
}

/// Tailored presentation specification for a concept adapted to a child's age band.
class ConceptPresentationSpec extends Equatable {
  final String conceptId;
  final String canonicalText;
  final LearningAgeBand ageBand;
  final VisualCardStyle visualStyle;
  final InteractionPacing pacing;
  final bool audioAutoplay;
  final bool showTextLabel;
  final bool isPreschoolStyled;
  final String promptText;
  final String contextualExample;
  final String pedagogicalHint;

  const ConceptPresentationSpec({
    required this.conceptId,
    required this.canonicalText,
    required this.ageBand,
    required this.visualStyle,
    required this.pacing,
    required this.audioAutoplay,
    required this.showTextLabel,
    required this.isPreschoolStyled,
    required this.promptText,
    required this.contextualExample,
    required this.pedagogicalHint,
  });

  @override
  List<Object?> get props => [
        conceptId,
        canonicalText,
        ageBand,
        visualStyle,
        pacing,
        audioAutoplay,
        showTextLabel,
        isPreschoolStyled,
        promptText,
        contextualExample,
        pedagogicalHint,
      ];
}

/// Adapts the delivery, pacing, styling, and scaffolding of curriculum concepts
/// according to the learner's developmental age band.
/// Ensures an 8–10 year-old beginner receives mature, respectful presentation without babyish UI.
class ConceptPresentationAdapter {
  const ConceptPresentationAdapter();

  /// Generates the age-adapted presentation specification for [concept] under [ageBand].
  ConceptPresentationSpec adaptConcept({
    required LearningConcept concept,
    required LearningAgeBand ageBand,
  }) {
    switch (ageBand) {
      case LearningAgeBand.bandPreALittleListeners:
        return ConceptPresentationSpec(
          conceptId: concept.id,
          canonicalText: concept.canonicalText,
          ageBand: ageBand,
          visualStyle: VisualCardStyle.playfulCartoonCard,
          pacing: InteractionPacing.relaxed,
          audioAutoplay: true,
          showTextLabel: false, // Pure iconography, zero required reading
          isPreschoolStyled: true,
          promptText: '${concept.canonicalText}! 🎈',
          contextualExample: concept.canonicalText,
          pedagogicalHint: 'Pip says: Listen and touch! 👂',
        );

      case LearningAgeBand.bandALittleExplorers:
        return ConceptPresentationSpec(
          conceptId: concept.id,
          canonicalText: concept.canonicalText,
          ageBand: ageBand,
          visualStyle: VisualCardStyle.playfulCartoonCard,
          pacing: InteractionPacing.relaxed,
          audioAutoplay: true,
          showTextLabel: false, // Relies primarily on large iconography
          isPreschoolStyled: true,
          promptText: 'Tap the ${concept.canonicalText}! 🎈',
          contextualExample: '${concept.canonicalText}!',
          pedagogicalHint: 'Pip says: Listen and repeat after me! 😊',
        );

      case LearningAgeBand.bandBYoungAdventurers:
        return ConceptPresentationSpec(
          conceptId: concept.id,
          canonicalText: concept.canonicalText,
          ageBand: ageBand,
          visualStyle: VisualCardStyle.illustratedStoryCard,
          pacing: InteractionPacing.standard,
          audioAutoplay: false, // Child taps audio speaker icon or triggers via interaction
          showTextLabel: true,
          isPreschoolStyled: false,
          promptText: 'Look at the ${concept.canonicalText}. Can you say it?',
          contextualExample: 'This is a ${concept.canonicalText}.',
          pedagogicalHint: 'Say "${concept.canonicalText}" clearly into the microphone. 🎙️',
        );

      case LearningAgeBand.bandCGrowingSpeakers:
        return ConceptPresentationSpec(
          conceptId: concept.id,
          canonicalText: concept.canonicalText,
          ageBand: ageBand,
          visualStyle: VisualCardStyle.cleanRealisticCard,
          pacing: InteractionPacing.brisk,
          audioAutoplay: false,
          showTextLabel: true,
          isPreschoolStyled: false, // Absolutely no preschool animations or baby talk
          promptText: 'What is this? Say "${concept.canonicalText}".',
          contextualExample: _getContextualSentence(concept.canonicalText),
          pedagogicalHint: 'Say "${concept.canonicalText}" clearly into the microphone.',
        );

      case LearningAgeBand.bandDConfidentSpeakers:
        return ConceptPresentationSpec(
          conceptId: concept.id,
          canonicalText: concept.canonicalText,
          ageBand: ageBand,
          visualStyle: VisualCardStyle.cleanRealisticCard,
          pacing: InteractionPacing.brisk,
          audioAutoplay: false,
          showTextLabel: true,
          isPreschoolStyled: false,
          promptText: 'Can you use "${concept.canonicalText}" in a sentence?',
          contextualExample: _getContextualSentence(concept.canonicalText),
          pedagogicalHint: 'Try saying a full sentence with "${concept.canonicalText}".',
        );
    }
  }

  static String _getContextualSentence(String text) {
    if (text == 'water') return 'We drink clean water every day.';
    if (text == 'apple') return 'Apples are sweet and good to eat.';
    if (text == 'elephant') return 'The elephant is a big, gentle animal.';
    if (text == 'mother') return 'This is my mother.';
    return 'We can say "$text" when we speak English.';
  }
}
