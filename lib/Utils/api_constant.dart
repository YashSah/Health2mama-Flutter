class APIEndPoints {

  // Base URL for the API
  //      static const String baseUrl = 'http://172.16.6.42:2121/api/v1';   // Aamir
  //     static const String baseUrl = 'http://172.16.1.132:2121/api/v1';   // Rajnikant
  //  static const String baseUrl = 'http://172.16.6.41:2121/api/v1';   // Anurag

 static const String baseUrl = 'https://node-health2mama.mobiloitte.io/api/v1';

  static const String dynTubeBaseUrl = "https://api.dyntube.com/v1/apps/hls/";

  // User related endpoints
  static const String userLogin = '$baseUrl/user/userLogin';
  static const String resendOtp = '$baseUrl/user/resendOtp';
  static const String verifyOtp = '$baseUrl/user/verifyOtp';
  static const String createSetReminder = '$baseUrl/user/setReminder';
  static const String getReminder = '$baseUrl/user/getRemiders';
  static const String deleteReminder = '$baseUrl/user/deleteRemiders';
  static const String getAllCountries = '$baseUrl/user/getAllCountry';
  static const String resetPassword = '$baseUrl/user/resetPassword';
  static const String getAllStaticContentByType = '$baseUrl/staticContent/getAllStaticContentByType';
  static const String changePassword = '$baseUrl/user/changePassword';
  static const String signUp = '$baseUrl/user/SignUp';
  static const String socialLogin = '$baseUrl/user/socialLogin';
  static const String getCategoryByStage = '$baseUrl/user/getCategoryByStage';
  static const String globalSearch = '$baseUrl/user/globalSearch';
  static const String getCategoryByUserPreference = '$baseUrl/user/getCategoryByUserPreference';
  static const String updatePreference = '$baseUrl/user/updatePreference';
  static const String viewProfile = '$baseUrl/user/viewProfile';
  static const String uploadFile = '$baseUrl/user/uploadFile';
  static const String updateProfile = '$baseUrl/user/updateProfile';
  static const String getAllWorkoutCategory = '$baseUrl/user/getAllWorkoutCategory';
  static const String getWorkoutSubcategoryById = '$baseUrl/user/getWorkoutSubcategoryById';
  static const String getRecipeByStage = '$baseUrl/user/getRecipeByStage';
  static const String viewRecipe = '$baseUrl/user/viewRecipe';
  static const String saveUnsaveItem = '$baseUrl/user/saveUnsaveItem';
  static const String getSaveUnsaveStatus = '$baseUrl/user/getSaveUnsaveStatus';
  static const String getSavedTopicsByCategoryId = '$baseUrl/user/getSavedTopicsByCategoryId';
  static const String updateLocation = '$baseUrl/user/updateLocation';

  // Program related endpoints
  static const String getProgramByCategory = '$baseUrl/user/getProgramByCategory';
  static const String getTopicByProgram = '$baseUrl/user/getTopicByProgram';
  static const String viewTopic = '$baseUrl/user/viewTopic';
  static const String getAllRecipeDetails = '$baseUrl/user/getAllRecipeDetails';
  static const String listRecipeWithType = '$baseUrl/user/listRecipeWithType';
  static const String programPercentageCalculation = '$baseUrl/user/percentageCalculation';
  static const String getQuiz = '$baseUrl/user/getQuestions';


  // Forum related endpoints
  static const String createForumTopic = '$baseUrl/user/createForumTopic';
  static const String listForum = '$baseUrl/user/listForum';
  static const String viewForum = '$baseUrl/user/viewForum';
  static const String getTopic = '$baseUrl/user/getTopic';
  static const String userReplyInForum = '$baseUrl/user/userReplyInForum';

  // Weekly Goals endpoint
  static const String createWeeklyGoal = '$baseUrl/user/createWeeklyGoal';
  static const String getWeeklyPoints = '$baseUrl/user/getWeeklyPoints';
  static const String getWeeklyGoal = '$baseUrl/user/getWeeklyGoal';

  // Notifications endpoints
  static const String createNotification = '$baseUrl/notification/createNotifications';
  static const String listNotifications = '$baseUrl/notification/getAllNotifications';
  static const String deleteNotifications = '$baseUrl/notification/deleteOneNotification';
  static const String deleteAllNotifications = '$baseUrl/notification/deleteAllNotifications';

  // Payment endpoint
      static const String stripePaymentSubscription = '$baseUrl/stripe/getStripeSession';

  // Activation endpoint
  static const String getLearnHowToActivate = '$baseUrl/user/getLearnHowToActivate';
  static const String listActivateExercise = '$baseUrl/user/listActivateExercise';
  static const String exerciseRecord = '$baseUrl/user/exerciseRecord';
  static const String addPointsToUserWallet = '$baseUrl/user/addPointsToUserWallet';
  static const String getExerciseRecord = '$baseUrl/user/getExerciseRecord';

  // Service and Specialization endpoints
  static const String getServiceSpecialization = '$baseUrl/user/getAllServicesOrSpecializations';
  static const String listSpecialization = '$baseUrl/user/listSpecialization';
  static const String searchConsults = '$baseUrl/user/searchConsults';
  static const String viewConsult = '$baseUrl/user/viewConsult';
  static const String createBooking = '$baseUrl/user/createBooking';
  static const String listBookingById = '$baseUrl/user/listBookingById';
  static const String getOptions = '$baseUrl/user/getOptions';
  static const String cancelBookingById = '$baseUrl/user/cancelBooking';
  static const String getConnectedMums = '$baseUrl/user/getConnectedMums';
  static const String filterMums = '$baseUrl/user/filterMums';
  static const String sendFriendRequest = '$baseUrl/user/sendFriendRequest';
  static const String getPendingFriendRequests = '$baseUrl/user/getPendingFriendRequests';
  static const String connectMums = '$baseUrl/user/sendFriendRequest';
  static const String CancelFriendRequest = '$baseUrl/user/deleteFriendRequest';
  static const String respondToFriendRequest = '$baseUrl/user/respondToFriendRequest';
  static const String CreateNotification = '$baseUrl/notification/createNotifications';


  // Pregnancy Tracker
  static const String getTrimester = '$baseUrl/user/getTrimester';
  static const String listWeekByTrimester = '$baseUrl/user/listWeekByTrimester';
  static const String updateDueDate = '$baseUrl/user/addUpdateDueDate';
  static const String viewWeek = '$baseUrl/user/viewWeek';

  // Subscription Plans
  static const String listSubscriptions = '$baseUrl/user/listSubscriptions';
}

