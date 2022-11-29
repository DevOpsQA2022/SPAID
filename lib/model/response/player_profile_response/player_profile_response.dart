class PlayerProfileResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  PlayerProfileResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  PlayerProfileResponse.fromJson(Map<String, dynamic> json) {
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
  int? userIDNo;
  String? userFirstName;
  String? userMiddleName;
  String? userLastName;
  String? userPassword;
  String? userDOB;
  String? userGender;
  String? userCountry;
  String? userAddress1;
  String? userAddress2;
  String? userCity;
  String? userZip;
  String? userEmailID;
  String? userAlternateEmailID;
  String? userPrimaryPhone;
  String? userAlternatePhone;
  String? familyUserIDNo;
  String? fCMTokenID;
  int? teamID;
  String? teamName;
  int? sportIdNo;
  String? teamTimeZone;
  String? teamCountry;
  String? userJerseyNumber;
  String? positions;
  int? roleIDNo;
  int? playerInd;
  String? notificationMessage;
  String? buttonStatus;
  int? managerIdNo;
  String? teamProfileImage;
  String? userProfileImage;

  Result(
      {this.id,
        this.userIDNo,
        this.userFirstName,
        this.userMiddleName,
        this.userLastName,
        this.userPassword,
        this.userDOB,
        this.userGender,
        this.userCountry,
        this.userAddress1,
        this.userAddress2,
        this.userCity,
        this.userZip,
        this.userEmailID,
        this.userAlternateEmailID,
        this.userPrimaryPhone,
        this.userAlternatePhone,
        this.familyUserIDNo,
        this.fCMTokenID,
        this.teamID,
        this.teamName,
        this.sportIdNo,
        this.teamTimeZone,
        this.teamCountry,
        this.userJerseyNumber,
        this.positions,
        this.roleIDNo,
        this.playerInd,
        this.notificationMessage,
        this.buttonStatus,
        this.managerIdNo,
        this.teamProfileImage,
        this.userProfileImage});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userIDNo = json['UserIDNo'];
    userFirstName = json['UserFirstName'];
    userMiddleName = json['UserMiddleName'];
    userLastName = json['UserLastName'];
    userPassword = json['UserPassword'];
    userDOB = json['UserDOB'];
    userGender = json['UserGender'];
    userCountry = json['UserCountry'];
    userAddress1 = json['UserAddress1'];
    userAddress2 = json['UserAddress2'];
    userCity = json['UserCity'];
    userZip = json['UserZip'];
    userEmailID = json['UserEmailID'];
    userAlternateEmailID = json['UserAlternateEmailID'];
    userPrimaryPhone = json['UserPrimaryPhone'];
    userAlternatePhone = json['UserAlternatePhone'];
    familyUserIDNo = json['FamilyUserIDNo'];
    fCMTokenID = json['FCMTokenID'];
    teamID = json['TeamID'];
    teamName = json['TeamName'];
    sportIdNo = json['SportIdNo'];
    teamTimeZone = json['TeamTimeZone'];
    teamCountry = json['TeamCountry'];
    userJerseyNumber = json['UserJerseyNumber'];
    positions = json['Positions'];
    roleIDNo = json['RoleIDNo'];
    playerInd = json['PlayerInd'];
    notificationMessage = json['NotificationMessage'];
    buttonStatus = json['Button_Status'];
    managerIdNo = json['ManagerIdNo'];
    teamProfileImage = json['TeamProfileImage'];
    userProfileImage = json['UserProfileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIDNo'] = this.userIDNo;
    data['UserFirstName'] = this.userFirstName;
    data['UserMiddleName'] = this.userMiddleName;
    data['UserLastName'] = this.userLastName;
    data['UserPassword'] = this.userPassword;
    data['UserDOB'] = this.userDOB;
    data['UserGender'] = this.userGender;
    data['UserCountry'] = this.userCountry;
    data['UserAddress1'] = this.userAddress1;
    data['UserAddress2'] = this.userAddress2;
    data['UserCity'] = this.userCity;
    data['UserZip'] = this.userZip;
    data['UserEmailID'] = this.userEmailID;
    data['UserAlternateEmailID'] = this.userAlternateEmailID;
    data['UserPrimaryPhone'] = this.userPrimaryPhone;
    data['UserAlternatePhone'] = this.userAlternatePhone;
    data['FamilyUserIDNo'] = this.familyUserIDNo;
    data['FCMTokenID'] = this.fCMTokenID;
    data['TeamID'] = this.teamID;
    data['TeamName'] = this.teamName;
    data['SportIdNo'] = this.sportIdNo;
    data['TeamTimeZone'] = this.teamTimeZone;
    data['TeamCountry'] = this.teamCountry;
    data['UserJerseyNumber'] = this.userJerseyNumber;
    data['Positions'] = this.positions;
    data['RoleIDNo'] = this.roleIDNo;
    data['PlayerInd'] = this.playerInd;
    data['NotificationMessage'] = this.notificationMessage;
    data['Button_Status'] = this.buttonStatus;
    data['ManagerIdNo'] = this.managerIdNo;
    data['TeamProfileImage'] = this.teamProfileImage;
    data['UserProfileImage'] = this.userProfileImage;
    return data;
  }
}
