


import 'package:spaid/model/response/base_response.dart';
class SignInResponse extends BaseResponse {
  String? id;
  String? errorMessage;
  int? status;
  Result? result;

  SignInResponse({this.id, this.errorMessage, this.status, this.result});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    errorMessage = json['ErrorMessage'];
    status = json['Status'];
    result =
    json['Result'] != null ? new Result.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ErrorMessage'] = this.errorMessage;
    data['Status'] = this.status;
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
  int? roleIdNo;
  List<Teams>? teams;

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
        this.roleIdNo,
        this.teams,
        });

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
    roleIdNo = json['RoleIdNo'];
    if (json['Teams'] != null) {
      teams = <Teams>[];
      json['Teams'].forEach((v) {
        teams!.add(new Teams.fromJson(v));
      });
    }

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
    data['RoleIdNo'] = this.roleIdNo;
    if (this.teams != null) {
      data['Teams'] = this.teams!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Teams {
  String? id;
  String? teamName;
  String? country;
  int? teamId;

  Teams({this.id, this.teamName, this.country, this.teamId});

  Teams.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamName = json['Team_Name'];
    country = json['Country'];
    teamId = json['Team_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['Team_Name'] = this.teamName;
    data['Country'] = this.country;
    data['Team_Id'] = this.teamId;
    return data;
  }
}