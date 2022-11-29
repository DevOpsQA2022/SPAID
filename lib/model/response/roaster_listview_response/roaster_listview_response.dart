class RoasterListViewResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  RoasterListViewResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  RoasterListViewResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    responseResult = json['ResponseResult'];
    responseMessage = json['ResponseMessage'];
    result =
    json['Result'] != null ? new Result.fromJson(json['Result']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ResponseResult'] = this.responseResult;
    data['ResponseMessage'] = this.responseMessage;
    if (this.result != null) {
      data['Result'] = this.result!.toJson();
    }

    return data;
  }
}

class Result {
  String? id;
  int? teamIDNo;
  int? ResponseResult;
  String? teamName;
  List<UserDetails>? userDetails;

  Result(
      {this.id, this.teamIDNo,this.ResponseResult, this.teamName, this.userDetails});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamIDNo = json['TeamIDNo'];
    ResponseResult = json['ResponseResult'];
    teamName = json['TeamName'];
    if (json['UserDetails'] != null) {
      userDetails = <UserDetails>[];
      json['UserDetails'].forEach((v) {
        userDetails!.add(new UserDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamIDNo'] = this.teamIDNo;
    data['TeamName'] = this.teamName;
    if (this.userDetails != null) {
      data['UserDetails'] = this.userDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDetails {
  String? id;
  int? userIdNo;
  String? userPassword;
  String? userFirstName;
  String? userMiddleName;
  String? userLastName;
  String? userDOB;
  String? userGender;
  String? userCountry;
  String? userAddress1;
  String? userAddress2;
  String? userState;
  String? userCity;
  String? userZip;
  String? userEmailID;
  String? userAlternateEmailID;
  String? userPrimaryPhone;
  String? userAlternatePhone;
  String? UserJerseyNumber;
  String? UserGamePosition;
  int? familyUserIDNo;
  int? playerInd;
  int? PlayerAvailabilityStatusId;
  int? UserRoleId;
  String? userProfileImage;
  int? roleIdNo;
  String? roleName;
  String? shoot;
  String? medicalNote;
  String? note;
  int? totalMatchesPlayed;
  int? totalGoals;
  int? playerAssists;
  int? totalPenalty;

  UserDetails(
      {this.id,
        this.userIdNo,
        this.userPassword,
        this.userFirstName,
        this.userMiddleName,
        this.userLastName,
        this.userDOB,
        this.userGender,
        this.userCountry,
        this.userAddress1,
        this.userAddress2,
        this.userState,
        this.userCity,
        this.userZip,
        this.userEmailID,
        this.userAlternateEmailID,
        this.userPrimaryPhone,
        this.userAlternatePhone,
        this.familyUserIDNo,
        this.playerInd,
        this.userProfileImage,
        this.roleIdNo,
        this.PlayerAvailabilityStatusId,
        this.UserRoleId,
        this.UserJerseyNumber,
        this.UserGamePosition,
        this.shoot,
        this.medicalNote,
        this.note,
        this.totalMatchesPlayed,
        this.totalGoals,
        this.playerAssists,
        this.totalPenalty,
        this.roleName});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userIdNo = json['UserIdNo'];
    userPassword = json['UserPassword'];
    userFirstName = json['UserFirstName'];
    userMiddleName = json['UserMiddleName'];
    userLastName = json['UserLastName'];
    userDOB = json['UserDOB'];
    userGender = json['UserGender'];
    userCountry = json['UserCountry'];
    userAddress1 = json['UserAddress1'];
    userAddress2 = json['UserAddress2'];
    userState = json['UserState'];
    userCity = json['UserCity'];
    userZip = json['UserZip'];
    userEmailID = json['UserEmailID'];
    userAlternateEmailID = json['UserAlternateEmailID'];
    userPrimaryPhone = json['UserPrimaryPhone'];
    userAlternatePhone = json['UserAlternatePhone'];
    familyUserIDNo = json['FamilyUserIDNo'];
    playerInd = json['PlayerInd'];
    userProfileImage = json['UserProfileImage'];
    roleIdNo = json['RoleIdNo'];
    roleName = json['RoleName'];
    PlayerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
    UserRoleId = json['UserRoleId'];
    UserJerseyNumber = json['UserJerseyNumber'];
    UserGamePosition = json['UserGamePosition'];
    shoot = json['Shoot'];
    medicalNote = json['MedicalNote'];
    note = json['Note'];
    totalMatchesPlayed = json['TotalMatchesPlayed'];
    totalGoals = json['TotalGoals'];
    playerAssists = json['PlayerAssists'];
    totalPenalty = json['TotalPenalty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIdNo'] = this.userIdNo;
    data['UserPassword'] = this.userPassword;
    data['UserFirstName'] = this.userFirstName;
    data['UserMiddleName'] = this.userMiddleName;
    data['UserLastName'] = this.userLastName;
    data['UserDOB'] = this.userDOB;
    data['UserGender'] = this.userGender;
    data['UserCountry'] = this.userCountry;
    data['UserAddress1'] = this.userAddress1;
    data['UserAddress2'] = this.userAddress2;
    data['UserState'] = this.userState;
    data['UserCity'] = this.userCity;
    data['UserZip'] = this.userZip;
    data['UserEmailID'] = this.userEmailID;
    data['UserAlternateEmailID'] = this.userAlternateEmailID;
    data['UserPrimaryPhone'] = this.userPrimaryPhone;
    data['UserAlternatePhone'] = this.userAlternatePhone;
    data['FamilyUserIDNo'] = this.familyUserIDNo;
    data['PlayerInd'] = this.playerInd;
    data['UserProfileImage'] = this.userProfileImage;
    data['RoleIdNo'] = this.roleIdNo;
    data['RoleName'] = this.roleName;
    data['PlayerAvailabilityStatusId'] = this.PlayerAvailabilityStatusId;
    data['UserRoleId'] = this.UserRoleId;
    data['UserJerseyNumber'] = this.UserJerseyNumber;
    data['UserGamePosition'] = this.UserGamePosition;
    data['Shoot'] = this.shoot;
    data['MedicalNote'] = this.medicalNote;
    data['Note'] = this.note;
    data['TotalMatchesPlayed'] = this.totalMatchesPlayed;
    data['TotalGoals'] = this.totalGoals;
    data['PlayerAssists'] = this.playerAssists;
    data['TotalPenalty'] = this.totalPenalty;
    return data;
  }
}
