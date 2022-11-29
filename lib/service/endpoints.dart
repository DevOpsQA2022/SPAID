class Endpoints {
 // static String baseUrl = "http://192.168.1.121/";
  //static String baseUrl = "http://192.168.1.220:3393/SpaidClient/";
  // static String baseUrl = "http://192.168.1.220:3393/Spaid1/";
  // static String emailUrl = "http://192.168.1.220:3393/";
  // static String baseUrl = "http://192.168.1.220:3393/Spaid/";
  // static String emailUrl = "http://192.168.1.220:3393/";
  // static String baseUrl = "https://spaid.ca/SpaidAPI/";
  static String emailUrl = "https://spaid.ca/SpaidWeb/";
  // static String emailUrl = "http://localhost/";
  // static String baseUrls = "http://192.168.1.220:3388/api/CoachesCorner/";

  static String baseUrl = "http://192.168.1.220:3393/Spaid/";
  // static String emailUrl = "http://202.83.25.234:3393/";
  //static String emailUrl = "http://spaidtest.azurewebsites.net/";
  //static String baseUrl = "https://192.168.1.220:3385/Spaid1/";

  //  static String baseUrl = "http://202.83.25.234:3393/SpaidClient/";
  //static String baseUrl = "http://202.83.25.234:3393/Spaid1/";
  //static String serverUrl = "http://202.83.25.234:3393/Spaid/api/User/";
 // static String serverUrl = "http://192.168.1.121/api/User/";
  static String serverUrl = baseUrl+"api/User/";
  static String serverValidateUrl = baseUrl+"api/SignIn/";
  static String serverEmailUrl = baseUrl+"api/Email/";
  static String serverGameUrl = baseUrl+"api/EventOrGame/";
  static String serverNotificationUrl = baseUrl+"api/Notification/";
  static String serverTimeKeeperConsoleUrl = baseUrl+"api/TimeKeeperConsole/";
  static String serverCoachesCornerUrl = baseUrl+"api/CoachesCorner/";
  static String signupValidate = "ValidateUser";
  static String userLogin = "UserLogin";
  static String changeUserLoginPassword = "ChangeUserLoginPassword";
  static String getRoles = "getRoles";
  static String addUpdateUserUrl = "AddUpdateUser";
  static String addTeamUrl = "AddTeam";
  static String getTeamMembersUrl = "GetTeamMembersDetail";
  static String getUserTeamUrl = "GetUserTeams";
  static String getUserDetailsUrl = "GetUserInfo";
  static String notificationUrl = "GetNotifications";
  static String addPlayer = "AddPlayer";
  static String setEditPlayer = "SetEditPlayer";
  static String sendMail = "SendMail";
  static String addGameorEvent = "AddEditGameOrEvent";
  static String updateVolunteerStatus = "UpdateVolunteerStatus";
  static String getGameorEvent = "GetGameOrEvent";
  static String getVoluenteerType = "GetEventVolunteerType";
  static String getVolunteers = "GetEventVolunteers";
  static String updateVolunteers = "SaveEventVolunteers";
  static String addOpponentTeam = "AddOpponentTeam";
  static String getOpponentTeam = "GetOpponentTeam";
  static String removeGameorEvent = "RemoveGameOrEvent";
  static String updateGameStatus = "UpdateStatusForGameOrEvent";
  static String getTeamMembersEmail = "GetTeamMembersEmail";
  static String getTeamMember = "GetTeamMember";
  static String getGameAvailability = "GetGameAvailability";
  static String getPlayerAvailability = "GetPlayerAvailability";
  static String addTeamNotification = "AddTeamNotification";
  static String createEventNotification = "CreateEventNotification";
  static String sendEventNotificationMail = "SendEventNotificationMail";
  static String sendSpecificNotificationMail = "SendSpecificNotificationMail";
  static String resendVolunteerInvite = "ResendVolunteerInvite";
  static String updatePlayerAvailability = "UpdatePlayerAvailability";
  static String getGameOrEventForTeam = "GetGameOrEventForTeam";
  static String getTeamDetails = "GetTeamDetails";
  static String editTeam = "EditTeam";
  static String volunteerInvite = "VolunteerInvite";
  static String volunteerAvailabilityStatus = "VolunteerAvailabilityStatus";
  static String removeTeamMember = "RemoveTeamMember";
  static String getFamilyMembers = "GetFamilyMembers";
  static String playerRespondRequest = "PlayerRespondRequest";
  static String getOnGoingGameOrEvent = "GetOnGoingGameOrEvent";
  static String searchUserUsingMail = "SearchUserUsingMail";
  static String removeNotification = "RemoveNotification";
  static String getScore = "GetScore";
  static String updateUserCalendar = "UpdateUserCalendar";
  static String updatePlayerSelection = "UpdatePlayerSelection";
  static String removeVolunteerType = "RemoveVolunteerType";
  static String addVolunteerType = "AddVolunteerType";
  static String applyEventUrl = serverUrl + "";

  static String getAllDrillPlanUrl =  serverCoachesCornerUrl+"GetAllDrillPlan";
  static String getSharedDrillPlan =  serverCoachesCornerUrl+"GetSharedDrillPlan";
  static String copyDrillPlanToOtherTeam =  serverCoachesCornerUrl+"ShareDrillPlanToOtherTeam";


  static String createNewDrillPlanUrl =  serverCoachesCornerUrl+"CreateNewDrillPlan";
  static String updateDrillPlan =  serverCoachesCornerUrl+"UpdateDrillPlan";

  static String getDrillUrl =  serverCoachesCornerUrl+"GetDrillCategory";
  static String getAllDrillUrl =  serverCoachesCornerUrl+"GetDrillPlan";

}





