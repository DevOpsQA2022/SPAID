class FamilyMembersResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  FamilyMembersResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  FamilyMembersResponse.fromJson(Map<String, dynamic> json) {
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
  List<FamilyMemberList>? familyMemberList;
  int? userIdNo;
  int? PlayerAvailabilityStatusId;
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
  String? fCMTokenID;
  String? userPrimaryPhone;
  String? userAlternatePhone;
  String? userProfileImage;

  Result(
      {this.id,
        this.familyMemberList,
        this.userIdNo,
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
        this.fCMTokenID,
        this.userPrimaryPhone,
        this.userAlternatePhone,
        this.PlayerAvailabilityStatusId,
        this.userProfileImage});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['FamilyMemberList'] != null) {
      familyMemberList = <FamilyMemberList>[];
      json['FamilyMemberList'].forEach((v) {
        familyMemberList!.add(new FamilyMemberList.fromJson(v));
      });
    }
    userIdNo = json['UserIdNo'];
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
    fCMTokenID = json['FCMTokenID'];
    userPrimaryPhone = json['UserPrimaryPhone'];
    userAlternatePhone = json['UserAlternatePhone'];
    userProfileImage = json['UserProfileImage'];
    PlayerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.familyMemberList != null) {
      data['FamilyMemberList'] =
          this.familyMemberList!.map((v) => v.toJson()).toList();
    }
    data['UserIdNo'] = this.userIdNo;
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
    data['FCMTokenID'] = this.fCMTokenID;
    data['UserPrimaryPhone'] = this.userPrimaryPhone;
    data['UserAlternatePhone'] = this.userAlternatePhone;
    data['UserProfileImage'] = this.userProfileImage;
    data['PlayerAvailabilityStatusId'] = this.PlayerAvailabilityStatusId;
    return data;
  }
}

class FamilyMemberList {
  String? id;
  int? userIdNo;
  int? PlayerAvailabilityStatusId;
  int? userRoleID;
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
  String? fCMTokenID;
  String? userPrimaryPhone;
  String? userAlternatePhone;
  String? userProfileImage;

  FamilyMemberList(
      {this.id,
        this.userIdNo,
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
        this.fCMTokenID,
        this.userPrimaryPhone,
        this.userAlternatePhone,
        this.PlayerAvailabilityStatusId,
        this.userRoleID,
        this.userProfileImage});

  FamilyMemberList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userIdNo = json['UserIdNo'];
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
    fCMTokenID = json['FCMTokenID'];
    userPrimaryPhone = json['UserPrimaryPhone'];
    userAlternatePhone = json['UserAlternatePhone'];
    userProfileImage = json['UserProfileImage'];
    PlayerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
    userRoleID = json['UserRoleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIdNo'] = this.userIdNo;
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
    data['FCMTokenID'] = this.fCMTokenID;
    data['UserPrimaryPhone'] = this.userPrimaryPhone;
    data['UserAlternatePhone'] = this.userAlternatePhone;
    data['UserProfileImage'] = this.userProfileImage;
    data['PlayerAvailabilityStatusId'] = this.PlayerAvailabilityStatusId;
    data['UserRoleID'] = this.userRoleID;
    return data;
  }
}
