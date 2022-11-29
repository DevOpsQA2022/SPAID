class NewSelectTeamResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  NewSelectTeamResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  NewSelectTeamResponse.fromJson(Map<String, dynamic> json) {
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
  List<UserTeamList>? userTeamList;

  Result({this.id, this.userIDNo, this.userTeamList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userIDNo = json['UserIDNo'];
    if (json['UserTeamList'] != null) {
      userTeamList = [];
      json['UserTeamList'].forEach((v) {
        userTeamList!.add(new UserTeamList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIDNo'] = this.userIDNo;
    if (this.userTeamList != null) {
      data['UserTeamList'] = this.userTeamList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserTeamList {
  String? id;
  String? teamName;
  String? country;
  int? teamId;
  int? roleIDNo;
  int? PlayerAvailabilityStatusId;
  int? UserRoleID;
  String? roleName;
  String? TeamProfileImage;
  String? email;
  String? name;
  String? fcm;
  int? userId;
  bool? isSelect=false;


  UserTeamList(
      {this.id,
        this.teamName,
        this.country,
        this.teamId,
        this.roleIDNo,
        this.PlayerAvailabilityStatusId,
        this.TeamProfileImage,
        this.email,
        this.name,
        this.fcm,
        this.userId,
        this.isSelect,
        this.roleName});

  UserTeamList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamName = json['Team_Name'];
    country = json['Country'];
    teamId = json['Team_Id'];
    roleIDNo = json['RoleIDNo'];
    roleName = json['RoleName'];
    TeamProfileImage = json['TeamProfileImage'];
    PlayerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
    UserRoleID = json['UserRoleID'];
    email = json['Email'];
    name = json['Name'];
    fcm = json['FCM'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['Team_Name'] = this.teamName;
    data['Country'] = this.country;
    data['Team_Id'] = this.teamId;
    data['RoleIDNo'] = this.roleIDNo;
    data['RoleName'] = this.roleName;
    data['TeamProfileImage'] = this.TeamProfileImage;
    data['PlayerAvailabilityStatusId'] = this.PlayerAvailabilityStatusId;
    data['UserRoleID'] = this.UserRoleID;
    data['Email'] = this.email;
    data['Name'] = this.name;
    data['FCM'] = this.fcm;
    data['UserId'] = this.userId;
    return data;
  }
}
