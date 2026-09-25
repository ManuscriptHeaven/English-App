import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';

/// Detailed functional conversation turn for production spoken English.
class FunctionalConversationTurn extends Equatable {
  final String id;
  final String topic;
  final String opening;
  final String expectedResponse;
  final List<String> acceptableAlternatives;
  final String followUp;
  final String recoveryPrompt;
  final String strongerResponse;
  final LearningAgeBand targetAgeBand;
  final String connectedValue;

  const FunctionalConversationTurn({
    required this.id,
    required this.topic,
    required this.opening,
    required this.expectedResponse,
    required this.acceptableAlternatives,
    required this.followUp,
    required this.recoveryPrompt,
    required this.strongerResponse,
    required this.targetAgeBand,
    required this.connectedValue,
  });

  @override
  List<Object?> get props => [
        id,
        topic,
        opening,
        expectedResponse,
        acceptableAlternatives,
        followUp,
        recoveryPrompt,
        strongerResponse,
        targetAgeBand,
        connectedValue,
      ];
}

/// Comprehensive functional conversation library for CURRICULUM_CONTENT_V2.
class CurriculumV2Conversations {
  static final List<FunctionalConversationTurn> conversations = [
    // 1. Greetings
    const FunctionalConversationTurn(
      id: 'conv_v2_greetings',
      topic: 'Greetings',
      opening: 'Assalamu Alaikum! Good morning, my friend! How are you today?',
      expectedResponse: 'Wa Alaikum Assalam! I am fine, thank you.',
      acceptableAlternatives: [
        'I am good, thank you',
        'Hello Pip! I am happy today',
        'Good morning! I am very well',
      ],
      followUp: 'Alhamdulillah! I am so glad to hear that. Let us start our adventure!',
      recoveryPrompt: 'You can say: "I am fine, thank you!"',
      strongerResponse: 'Wa Alaikum Assalam! I am doing great and excited to learn with you today!',
      targetAgeBand: LearningAgeBand.bandALittleExplorers,
      connectedValue: 'Spreading peace (Salam) and warm courtesy',
    ),

    // 2. Introducing Yourself
    const FunctionalConversationTurn(
      id: 'conv_v2_introductions',
      topic: 'Introducing yourself',
      opening: 'Hello! My name is Pip the Parrot. What is your name?',
      expectedResponse: 'My name is Zain. Nice to meet you, Pip!',
      acceptableAlternatives: [
        'I am Sara',
        'My name is Ahmed',
        'Nice to meet you, I am Ali',
      ],
      followUp: 'It is wonderful to meet you! We are going to be great friends!',
      recoveryPrompt: 'Say: "My name is..."',
      strongerResponse: 'Hello Pip! My name is Maryam, and I am eight years old. Nice to meet you!',
      targetAgeBand: LearningAgeBand.bandBYoungAdventurers,
      connectedValue: 'Friendliness and respectful communication',
    ),

    // 3. Asking for Help
    const FunctionalConversationTurn(
      id: 'conv_v2_help',
      topic: 'Asking for help',
      opening: 'Uh oh, that heavy book is hard to reach! What do you say when you need a hand?',
      expectedResponse: 'Can you help me, please?',
      acceptableAlternatives: [
        'Please help me, Pip',
        'Could you help me reach that?',
        'Help me, please',
      ],
      followUp: 'Of course! I would love to help you. Always ask with kindness!',
      recoveryPrompt: 'Remember the polite magic word: "Can you help me, please?"',
      strongerResponse: 'Excuse me, could you please help me reach the top shelf?',
      targetAgeBand: LearningAgeBand.bandBYoungAdventurers,
      connectedValue: 'Humility and polite cooperation',
    ),

    // 4. Food Requests
    const FunctionalConversationTurn(
      id: 'conv_v2_food_requests',
      topic: 'Food requests',
      opening: 'We are sitting down together for lunch! Would you like some fruit or water?',
      expectedResponse: 'Can I have some water, please?',
      acceptableAlternatives: [
        'I would like an apple, please',
        'May I have some bread, please?',
        'Water, please',
      ],
      followUp: 'Here you are! Say Bismillah before you drink, and drink gently.',
      recoveryPrompt: 'Say: "Can I have..., please?"',
      strongerResponse: 'I would like a glass of fresh water, please. JazakAllahu khayran!',
      targetAgeBand: LearningAgeBand.bandALittleExplorers,
      connectedValue: 'Gratitude for food, dining etiquette (Bismillah & right hand)',
    ),

    // 5. Asking Permission
    const FunctionalConversationTurn(
      id: 'conv_v2_permission',
      topic: 'Asking permission',
      opening: 'You want to borrow your sister\'s colored pencils to draw a picture. What do you say?',
      expectedResponse: 'May I borrow your pencil, please?',
      acceptableAlternatives: [
        'Can I use your pencil, please?',
        'May I please have a turn?',
        'Could I borrow this, please?',
      ],
      followUp: 'Yes, certainly! Thank you for asking permission before taking things.',
      recoveryPrompt: 'Ask nicely: "May I borrow your pencil, please?"',
      strongerResponse: 'Excuse me, may I please borrow your blue pencil for a minute? I will return it safely.',
      targetAgeBand: LearningAgeBand.bandBYoungAdventurers,
      connectedValue: 'Respecting others\' property and trustworthiness (Amanah)',
    ),

    // 6. Family
    const FunctionalConversationTurn(
      id: 'conv_v2_family',
      topic: 'Family',
      opening: 'Family is a wonderful blessing! Who lives with you in your home?',
      expectedResponse: 'I live with my father, mother, and brother.',
      acceptableAlternatives: [
        'My mom, dad, and sister',
        'I have two brothers and one sister',
        'My parents and my grandparents live with me',
      ],
      followUp: 'SubhanAllah! May your home always be filled with warmth and mercy!',
      recoveryPrompt: 'You can say: "I live with my mother and father."',
      strongerResponse: 'I live with my parents and my younger sister. I love helping my mother in the kitchen.',
      targetAgeBand: LearningAgeBand.bandBYoungAdventurers,
      connectedValue: 'Filial piety, honoring parents (Birr al-Walidayn)',
    ),

    // 7. School Life
    const FunctionalConversationTurn(
      id: 'conv_v2_school',
      topic: 'School',
      opening: 'The school bell rings! What is your favorite subject to learn?',
      expectedResponse: 'My favorite subject is science because I love learning about nature.',
      acceptableAlternatives: [
        'I like English and math',
        'My favorite is reading stories',
        'I enjoy art and science',
      ],
      followUp: 'Wonderful! Seeking beneficial knowledge makes our minds grow bright and curious.',
      recoveryPrompt: 'Say: "My favorite subject is... because..."',
      strongerResponse: 'I really enjoy science because it helps me understand how plants and stars are created.',
      targetAgeBand: LearningAgeBand.bandCGrowingSpeakers,
      connectedValue: 'Seeking knowledge with dedication and curiosity',
    ),

    // 8. Playing & Taking Turns
    const FunctionalConversationTurn(
      id: 'conv_v2_playing',
      topic: 'Playing',
      opening: 'There is one football and both you and your friend want to kick it. What should we do?',
      expectedResponse: 'Let us take turns! You kick first, then I kick.',
      acceptableAlternatives: [
        'We can play together',
        'Let us share the ball',
        'You go first, then my turn',
      ],
      followUp: 'That is wonderful sportsmanship! Sharing and taking turns makes games twice as fun!',
      recoveryPrompt: 'You can propose: "Let us take turns!"',
      strongerResponse: 'Why don\'t we play as a team and pass the ball to each other? That way we both enjoy!',
      targetAgeBand: LearningAgeBand.bandBYoungAdventurers,
      connectedValue: 'Fair play, patience (Sabr), and sharing with peers',
    ),

    // 9. Shopping & Market
    const FunctionalConversationTurn(
      id: 'conv_v2_shopping',
      topic: 'Shopping',
      opening: 'Welcome to our neighborhood market! How can I help you today?',
      expectedResponse: 'Hello! How much are these red apples?',
      acceptableAlternatives: [
        'I need some bread and milk, please',
        'Can I have three bananas, please?',
        'Do you have fresh oranges?',
      ],
      followUp: 'They are two dollars a kilo. Crisp, sweet, and freshly picked this morning!',
      recoveryPrompt: 'Ask the shopkeeper: "How much is this, please?"',
      strongerResponse: 'Good morning! Could I please get one kilogram of apples and a carton of milk?',
      targetAgeBand: LearningAgeBand.bandCGrowingSpeakers,
      connectedValue: 'Honest trade, polite interaction with community workers',
    ),

    // 10. Directions in Town
    const FunctionalConversationTurn(
      id: 'conv_v2_directions',
      topic: 'Directions',
      opening: 'Excuse me! I am looking for the neighborhood library. Do you know where it is?',
      expectedResponse: 'Yes! Walk straight ahead and turn right at the corner.',
      acceptableAlternatives: [
        'It is next to the green park',
        'Go straight and it is on your left',
        'It is behind the school',
      ],
      followUp: 'Thank you so much for your kind help! Have a blessed day!',
      recoveryPrompt: 'Describe where to go: "Go straight and turn right."',
      strongerResponse: 'Certainly! Walk straight past the mosque, turn left at the bakery, and the library will be right ahead.',
      targetAgeBand: LearningAgeBand.bandCGrowingSpeakers,
      connectedValue: 'Helping travelers and community members gladly',
    ),

    // 11. Expressing Feelings
    const FunctionalConversationTurn(
      id: 'conv_v2_feelings',
      topic: 'Feelings',
      opening: 'You look a little quiet today, my friend. How are you feeling inside?',
      expectedResponse: 'I am feeling a bit tired because I studied late last night.',
      acceptableAlternatives: [
        'I am feeling happy because my family visited',
        'I was a bit worried, but now I feel better',
        'I am cheerful and ready to learn',
      ],
      followUp: 'Thank you for sharing your feelings honestly. Take a deep breath and rest well!',
      recoveryPrompt: 'Express yourself: "I am feeling... because..."',
      strongerResponse: 'To be honest, I was feeling nervous about my presentation, but talking with you made me calm.',
      targetAgeBand: LearningAgeBand.bandCGrowingSpeakers,
      connectedValue: 'Emotional honesty, empathy, and listening with compassion',
    ),

    // 12. Weather & Outdoors
    const FunctionalConversationTurn(
      id: 'conv_v2_weather',
      topic: 'Weather',
      opening: 'Look out the window! The clouds are grey and soft raindrops are falling. How is the weather?',
      expectedResponse: 'It is rainy and cool today.',
      acceptableAlternatives: [
        'It is raining outside',
        'It is wet and windy',
        'The rain is falling on the trees',
      ],
      followUp: 'Alhamdulillah for the rain! It waters the thirsty trees and flowers so they blossom.',
      recoveryPrompt: 'Say: "It is rainy today."',
      strongerResponse: 'It is quite rainy and windy outside, so we should put on our raincoats before going out.',
      targetAgeBand: LearningAgeBand.bandALittleExplorers,
      connectedValue: 'Gratitude for rain and water as divine blessings',
    ),

    // 13. Hobbies & Free Time
    const FunctionalConversationTurn(
      id: 'conv_v2_hobbies',
      topic: 'Hobbies',
      opening: 'When your homework is finished on the weekend, what do you enjoy doing most?',
      expectedResponse: 'I enjoy reading books and playing football with my cousins.',
      acceptableAlternatives: [
        'I like drawing and painting pictures',
        'I enjoy gardening with my grandfather',
        'I like building model airplanes and coding',
      ],
      followUp: 'Those are wonderful and productive ways to spend your time! Keep pursuing good talents.',
      recoveryPrompt: 'Share your hobby: "In my free time, I like to..."',
      strongerResponse: 'I am passionate about nature photography and sketching animals because it teaches me patience and observation.',
      targetAgeBand: LearningAgeBand.bandCGrowingSpeakers,
      connectedValue: 'Productive time management, creative expression',
    ),

    // 14. Future Plans
    const FunctionalConversationTurn(
      id: 'conv_v2_plans',
      topic: 'Plans',
      opening: 'Next Saturday is our family day! What are your plans for the upcoming weekend?',
      expectedResponse: 'InshaAllah, we are going to visit our grandparents in the countryside.',
      acceptableAlternatives: [
        'I am planning to help my dad clean the garden',
        'We are going to have a picnic in the park',
        'I will finish my science project and play with my friends',
      ],
      followUp: 'That sounds like a rewarding weekend! Spending time with family brings immense barakah.',
      recoveryPrompt: 'State your plan: "Next weekend, I am going to..."',
      strongerResponse: 'InshaAllah, my family and I are planning to visit my grandparents, and I hope to help my grandfather tend to his olive trees.',
      targetAgeBand: LearningAgeBand.bandDConfidentSpeakers,
      connectedValue: 'Remembering InshaAllah for future intentions, kinship ties (Silat ar-Rahim)',
    ),

    // 15. Apologizing & Making Things Right
    const FunctionalConversationTurn(
      id: 'conv_v2_apologizing',
      topic: 'Apologizing',
      opening: 'You accidentally bumped into someone\'s table and knocked over their pencil case. What should you do?',
      expectedResponse: 'I am so sorry! Let me help you pick up your pencils.',
      acceptableAlternatives: [
        'Excuse me, I am sorry! Are you okay?',
        'I apologize, it was an accident. Here, let me help you',
        'Please forgive me, let me clean this up',
      ],
      followUp: 'True courage is saying sorry immediately and helping to fix the mistake! You have noble character.',
      recoveryPrompt: 'Apologize and help: "I am sorry! Let me help you."',
      strongerResponse: 'I sincerely apologize for bumping your table. It was entirely my mistake; please let me help you gather your pencils.',
      targetAgeBand: LearningAgeBand.bandCGrowingSpeakers,
      connectedValue: 'Taking responsibility, apologizing sincerely, repairing mistakes gracefully',
    ),

    // 16. Expressing Gratitude
    const FunctionalConversationTurn(
      id: 'conv_v2_thanking',
      topic: 'Thanking',
      opening: 'Your friend spent ten minutes explaining a challenging math problem to you until you understood. What do you tell them?',
      expectedResponse: 'Thank you so much for your patience! I really appreciate your help.',
      acceptableAlternatives: [
        'JazakAllahu khayran for helping me!',
        'Thank you, friend! You explained it so well',
        'I am very grateful for your kindness',
      ],
      followUp: 'Whoever does not thank people does not truly thank Allah. Expressing gratitude strengthens friendship!',
      recoveryPrompt: 'Say: "Thank you so much for your help!"',
      strongerResponse: 'JazakAllahu khayran for your time and patience. Your explanation made it so easy to understand, and I am very grateful!',
      targetAgeBand: LearningAgeBand.bandBYoungAdventurers,
      connectedValue: 'Expressing gratitude (Shukr), appreciating kindness',
    ),

    // 17. Inviting Others to Join
    const FunctionalConversationTurn(
      id: 'conv_v2_inviting',
      topic: 'Inviting',
      opening: 'You notice a new classmate standing alone at recess while others are playing. How do you invite them?',
      expectedResponse: 'Hello! Would you like to come and play with us?',
      acceptableAlternatives: [
        'Hi! Come join our game!',
        'Would you like to be on our team?',
        'You are welcome to sit and read with us!',
      ],
      followUp: 'Welcoming someone who feels left out is the mark of a truly caring heart. You made their day bright!',
      recoveryPrompt: 'Invite warmly: "Would you like to play with us?"',
      strongerResponse: 'Hi there! We are just starting a game of catch. We would love to have you join our team if you would like!',
      targetAgeBand: LearningAgeBand.bandCGrowingSpeakers,
      connectedValue: 'Inclusivity, welcoming newcomers, compassion for the lonely',
    ),

    // 18. Agreeing & Disagreeing Politely
    const FunctionalConversationTurn(
      id: 'conv_v2_agree_disagree',
      topic: 'Agreeing/disagreeing',
      opening: 'Your classmate suggests eating only chips and soda for lunch every day. How do you respond respectfully?',
      expectedResponse: 'I understand why you like chips, but in my opinion eating fruit and vegetables gives us healthier energy.',
      acceptableAlternatives: [
        'I disagree politely because junk food makes us tired',
        'I see your point, but our bodies need clean healthy food',
        'I agree chips taste good, but balanced food is much better for our health',
      ],
      followUp: 'Brilliant response! You can share a different viewpoint with gentle reasoning and respect without arguing.',
      recoveryPrompt: 'State your view politely: "I understand, but in my opinion..."',
      strongerResponse: 'While snacks are tasty as occasional treats, in my opinion our bodies are an Amanah (trust), so nourishing them with fresh food is essential for staying strong.',
      targetAgeBand: LearningAgeBand.bandDConfidentSpeakers,
      connectedValue: 'Respectful dialogue, health stewardship (body as trust), gentle reasoning',
    ),

    // 19. Collaborative Problem Solving
    const FunctionalConversationTurn(
      id: 'conv_v2_problem_solving',
      topic: 'Problem solving',
      opening: 'Our classroom group project is due tomorrow, but two team members have not finished their drawings. What should our team do?',
      expectedResponse: 'Let us divide the remaining tasks and help each other finish before the deadline.',
      acceptableAlternatives: [
        'We can work together during lunch break',
        'Let us ask the teacher for guidance and support our teammates',
        'I can help color their sketches so we finish on time',
      ],
      followUp: 'Excellent team leadership! Cooperating in good works ensures everyone succeeds together.',
      recoveryPrompt: 'Suggest teamwork: "Let us work together to finish."',
      strongerResponse: 'Instead of worrying, let us look at what remains, split the work fairly among those who have finished, and support our teammates so we submit our best collective work.',
      targetAgeBand: LearningAgeBand.bandDConfidentSpeakers,
      connectedValue: 'Cooperation in good deeds (Ta\'awun), leadership, mutual support',
    ),
  ];
}
