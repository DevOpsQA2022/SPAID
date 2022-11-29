class SignUpResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  SignUpResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  SignUpResponse.fromJson(Map<String, dynamic> json) {
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
  int? familyUserIDNo;
  String? fCMTokenID;
  int? userCreatedBy;
  String? userCreatedTimestamp;
  int? userModifiedBy;
  String? userModifiedTimestamp;
  String? userPrimaryPhone;
  String? userAlternatePhone;

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
        this.familyUserIDNo,
        this.fCMTokenID,
        this.userCreatedBy,
        this.userCreatedTimestamp,
        this.userModifiedBy,
        this.userModifiedTimestamp,
        this.userPrimaryPhone,
        this.userAlternatePhone,
        });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userIdNo = json['UserIDNo'];
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
    familyUserIDNo = json['FamilyUserIDNo'];
    fCMTokenID = json['FCMTokenID'];
    userCreatedBy = json['UserCreatedBy'];
    userCreatedTimestamp = json['UserCreatedTimestamp'];
    userModifiedBy = json['UserModifiedBy'];
    userModifiedTimestamp = json['UserModifiedTimestamp'];
    userPrimaryPhone = json['UserPrimaryPhone'];
    userAlternatePhone = json['UserAlternatePhone'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIDNo'] = this.userIdNo;
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
    data['FamilyUserIDNo'] = this.familyUserIDNo;
    data['FCMTokenID'] = this.fCMTokenID;
    data['UserCreatedBy'] = this.userCreatedBy;
    data['UserCreatedTimestamp'] = this.userCreatedTimestamp;
    data['UserModifiedBy'] = this.userModifiedBy;
    data['UserModifiedTimestamp'] = this.userModifiedTimestamp;
    data['UserPrimaryPhone'] = this.userPrimaryPhone;
    data['UserAlternatePhone'] = this.userAlternatePhone;

    return data;
  }
}
