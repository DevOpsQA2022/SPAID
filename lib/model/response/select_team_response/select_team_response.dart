import 'package:spaid/model/response/base_response.dart';

class SelectTeamResponse extends BaseResponse{
  String? id;
  User? user;
  Notification? notification;
  String? errorMessage;
  int? status;

  SelectTeamResponse(
      {this.id, this.user, this.notification, this.errorMessage, this.status});

  SelectTeamResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    notification = json['Notification'] != null
        ? new Notification.fromJson(json['Notification'])
        : null;
    errorMessage = json['ErrorMessage'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    if (this.notification != null) {
      data['Notification'] = this.notification!.toJson();
    }
    data['ErrorMessage'] = this.errorMessage;
    data['Status'] = this.status;
    return data;
  }
}

class User {
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
  int? userPrimaryPhone;
  int? userAlternatePhone;
  int? familyUserIDNo;
  int? playerInd;
  int? roleIdNo;
  List<Team>? team;
  List<Members>? members;

  User(
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
        this.team,
        this.members});

  User.fromJson(Map<String, dynamic> json) {
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
    if (json['Team'] != null) {
      team = <Team>[];
      json['Team'].forEach((v) {
        team!.add(new Team.fromJson(v));
      });
    }
    if (json['Members'] != null) {
      members = <Members>[];
      json['Members'].forEach((v) {
        members!.add(new Members.fromJson(v));
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
    if (this.team != null) {
      data['Team'] = this.team!.map((v) => v.toJson()).toList();
    }
    if (this.members != null) {
      data['Members'] = this.members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Members {
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
  String? userCity;
  String? userZip;
  String? userEmailID;
  String? userAlternateEmailID;
  int? userPrimaryPhone;
  int? userAlternatePhone;
  int? familyUserIDNo;
  int? playerInd;
  int? roleIdNo;

  Members(
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
        this.userCity,
        this.userZip,
        this.userEmailID,
        this.userAlternateEmailID,
        this.userPrimaryPhone,
        this.userAlternatePhone,
        this.familyUserIDNo,
        this.playerInd,
        this.roleIdNo});

  Members.fromJson(Map<String, dynamic> json) {
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
    userCity = json['UserCity'];
    userZip = json['UserZip'];
    userEmailID = json['UserEmailID'];
    userAlternateEmailID = json['UserAlternateEmailID'];
    userPrimaryPhone = json['UserPrimaryPhone'];
    userAlternatePhone = json['UserAlternatePhone'];
    familyUserIDNo = json['FamilyUserIDNo'];
    playerInd = json['PlayerInd'];
    roleIdNo = json['RoleIdNo'];
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
    data['UserCity'] = this.userCity;
    data['UserZip'] = this.userZip;
    data['UserEmailID'] = this.userEmailID;
    data['UserAlternateEmailID'] = this.userAlternateEmailID;
    data['UserPrimaryPhone'] = this.userPrimaryPhone;
    data['UserAlternatePhone'] = this.userAlternatePhone;
    data['FamilyUserIDNo'] = this.familyUserIDNo;
    data['PlayerInd'] = this.playerInd;
    data['RoleIdNo'] = this.roleIdNo;
    return data;
  }
}
class Team {
  String? id;
  String? teamName;
  String? country;
  int? teamId;

  Team({this.id, this.teamName, this.country, this.teamId});

  Team.fromJson(Map<String, dynamic> json) {
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

class Notification {
  String? id;
  String? notificationMessage;
  String? buttonStatus;
  String? sender;
  String? receiver;

  Notification(
      {this.id,
        this.notificationMessage,
        this.buttonStatus,
        this.sender,
        this.receiver});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    notificationMessage = json['NotificationMessage'];
    buttonStatus = json['Button_Status'];
    sender = json['Sender'];
    receiver = json['Receiver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['NotificationMessage'] = this.notificationMessage;
    data['Button_Status'] = this.buttonStatus;
    data['Sender'] = this.sender;
    data['Receiver'] = this.receiver;
    return data;
  }
}