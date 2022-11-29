class CreateTeamResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  CreateTeamResponse({this.id,
    this.responseResult,
    this.responseMessage,
    this.result,});

  CreateTeamResponse.fromJson(Map<String, dynamic> json) {
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
  String? teamName;
  int? sportIDNo;
  String? teamTimeZone;
  String? teamCountry;
  int? teamCreatedBy;
  String? teamCreatedDate;
  int? teamModifiedBy;
  String? teamModifiedDate;
  String? teamProfileImage;
  int? managerIdNo;

  Result(
      {this.id,
        this.teamIDNo,
        this.teamName,
        this.sportIDNo,
        this.teamTimeZone,
        this.teamCountry,
        this.teamCreatedBy,
        this.teamCreatedDate,
        this.teamModifiedBy,
        this.teamModifiedDate,
        this.teamProfileImage,
        this.managerIdNo});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamIDNo = json['TeamIDNo'];
    teamName = json['TeamName'];
    sportIDNo = json['SportIDNo'];
    teamTimeZone = json['TeamTimeZone'];
    teamCountry = json['TeamCountry'];
    teamCreatedBy = json['TeamCreatedBy'];
    teamCreatedDate = json['TeamCreatedDate'];
    teamModifiedBy = json['TeamModifiedBy'];
    teamModifiedDate = json['TeamModifiedDate'];
    teamProfileImage = json['TeamProfileImage'];
    managerIdNo = json['ManagerIdNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamIDNo'] = this.teamIDNo;
    data['TeamName'] = this.teamName;
    data['SportIDNo'] = this.sportIDNo;
    data['TeamTimeZone'] = this.teamTimeZone;
    data['TeamCountry'] = this.teamCountry;
    data['TeamCreatedBy'] = this.teamCreatedBy;
    data['TeamCreatedDate'] = this.teamCreatedDate;
    data['TeamModifiedBy'] = this.teamModifiedBy;
    data['TeamModifiedDate'] = this.teamModifiedDate;
    data['TeamProfileImage'] = this.teamProfileImage;
    data['ManagerIdNo'] = this.managerIdNo;
    return data;
  }
}
