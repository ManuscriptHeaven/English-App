/// Application route path constants.
class RouteNames {
  static const String welcome = '/';
  static const String onboarding = '/onboarding';
  static const String childSelection = '/child-selection';
  static const String createChild = '/create-child';
  static const String home = '/home';
  static const String worldDetail = '/world/:id';
  static const String lesson = '/lesson/:id';
  static const String story = '/story/:id';
  static const String game = '/game/:id';
  static const String rewards = '/rewards';
  static const String parent = '/parent';
  static const String settings = '/settings';

  // Phase 02 Interactive Activity Routes (World 1: Animal Adventure)
  static const String vocabularyDiscovery = '/activity/vocabulary';
  static const String animalHunt = '/activity/animal-hunt';
  static const String listenAndTap = '/activity/listen-and-tap';
  static const String wordMatch = '/activity/word-match';
  static const String grammarThisIs = '/activity/grammar-this-is';
  static const String sentenceBuilder = '/activity/sentence-builder';
  static const String isAreQuiz = '/activity/is-are-quiz';
  static const String valueMoment = '/activity/value-moment';
  static const String listeningPractice = '/activity/listening-practice';
  static const String speakingPractice = '/activity/speaking-practice';
  static const String worldChallenge = '/activity/world-challenge';
  static const String interactiveActivity = '/activity/interactive';
  static const String interactiveSession = '/lesson-session/:id';

  // Phase 03 Interactive Activity Routes (World 2: Home & Family)
  static const String homeVocabulary = '/activity/home-vocabulary';
  static const String homeHunt = '/activity/home-hunt';
  static const String familyVocabulary = '/activity/family-vocabulary';
  static const String listenAndFindHome = '/activity/listen-and-find-home';
  static const String myYourGrammar = '/activity/my-your-grammar';
  static const String cleanlinessSort = '/activity/cleanliness-sort';
  static const String homeChallenge = '/activity/home-challenge';
  static const String adaptiveReview = '/parent/adaptive-review';

  // Phase 05 / 11 Interactive Activity Routes (World 3: School & Classroom)
  static const String schoolVocabulary = '/activity/school-vocabulary';
  static const String classroomHunt = '/activity/classroom-hunt';
  static const String listenAndFindSchool = '/activity/listen-and-find-school';
  static const String listenAndDoSchool = '/activity/listen-and-do-school';
  static const String teacherFriendVocabulary = '/activity/teacher-friend-vocabulary';
  static const String schoolActions = '/activity/school-actions';
  static const String pluralsGrammar = '/activity/plurals-grammar';
  static const String politeRequests = '/activity/polite-requests';
  static const String honestyChallenge = '/activity/honesty-challenge';
  static const String storyQuizSchool = '/activity/story-quiz-school';
  static const String schoolChallenge = '/activity/school-challenge';

  // Phase 06 Interactive Activity Routes (World 4: Delicious Food & Content Engine)
  static const String parentReports = '/parent/reports';
  static const String parentAccount = '/parent/account';
  static const String genericActivity = '/activity/generic/:id';
  static const String foodVocabulary = '/activity/food-vocabulary';
  static const String foodHunt = '/activity/food-hunt';
  static const String listenAndFindFood = '/activity/listen-and-find-food';
  static const String foodMatch = '/activity/food-match';
  static const String grammarIHaveFood = '/activity/grammar-i-have-food';
  static const String foodCount = '/activity/food-count';
  static const String hungryThirsty = '/activity/hungry-thirsty';
  static const String eatingManners = '/activity/eating-manners';
  static const String foodSharing = '/activity/food-sharing';
  static const String foodChallenge = '/activity/food-challenge';

  // Phase 08 Routes (World 5: Nature & Weather, Conversations, Content Studio)
  static const String contentPreview = '/content-preview/:id';
  static const String natureVocabulary = '/activity/nature-vocabulary';
  static const String natureHunt = '/activity/nature-hunt';
  static const String weatherListen = '/activity/weather-listen';
  static const String natureMatch = '/activity/nature-match';
  static const String sunnyRainy = '/activity/sunny-rainy';
  static const String thereIsAre = '/activity/there-is-are';
  static const String weatherConversation = '/activity/weather-conversation';
  static const String careForNature = '/activity/care-for-nature';
  static const String speakingNature = '/activity/speaking-nature';
  static const String natureChallenge = '/activity/nature-challenge';

  // Phase 09 Routes (AI Tutor & Talk with Pip)
  static const String talkWithPip = '/talk-with-pip';

  // P0 Quality Recovery Routes (Voice Diagnostics & Curriculum Browser)
  static const String voiceDiagnostics = '/dev/voice-diagnostics';
  static const String curriculumBrowser = '/dev/curriculum-browser';

  static String worldDetailPath(String worldId) => '/world/$worldId';
  static String lessonPath(String lessonId) => '/lesson/$lessonId';
  static String interactiveSessionPath(String lessonId) => '/lesson-session/$lessonId';
  static String storyPath(String storyId) => '/story/$storyId';
  static String gamePath(String gameId) => '/game/$gameId';
  static String genericActivityPath(String contentId) => '/activity/generic/$contentId';
  static String contentPreviewPath(String contentId) => '/content-preview/$contentId';
}
