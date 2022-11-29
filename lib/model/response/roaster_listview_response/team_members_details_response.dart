class TeamMembersDetailsResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  TeamMembersDetailsResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  TeamMembersDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  int? familyUserIDNo;
  int? playerInd;
  String? userProfileImage;
  int? roleIdNo;
  String? roleName;
  int? playerAvailabilityStatusId;
  int? UserRoleId;
  String? userRoleActiveStatus;
  String? userGamePosition;
  String? userJerseyNumber;
  String? shoot;
  String? medicalNote;
  String? note;

  Result(
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
        this.roleName,
        this.playerAvailabilityStatusId,
        this.userRoleActiveStatus,
        this.userGamePosition,
        this.UserRoleId,
        this.shoot,
        this.medicalNote,
        this.note,
        this.userJerseyNumber});

  Result.fromJson(Map<String, dynamic> json) {
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
    playerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
    userRoleActiveStatus = json['UserRoleActiveStatus'];
    userGamePosition = json['UserGamePosition'];
    userJerseyNumber = json['UserJerseyNumber'];
    UserRoleId = json['UserRoleId'];
    shoot = json['Shoot'];
    medicalNote = json['MedicalNote'];
    note = json['Note'];
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
    data['PlayerAvailabilityStatusId'] = this.playerAvailabilityStatusId;
    data['UserRoleActiveStatus'] = this.userRoleActiveStatus;
    data['UserGamePosition'] = this.userGamePosition;
    data['UserJerseyNumber'] = this.userJerseyNumber;
    data['UserRoleId'] = this.UserRoleId;
    data['Shoot'] = this.shoot;
    data['MedicalNote'] = this.medicalNote;
    data['Note'] = this.note;
    return data;
  }
}
