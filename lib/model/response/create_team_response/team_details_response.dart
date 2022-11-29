class TeamDetailsResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  TeamDetailsResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  TeamDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  int? teamIDNo;
  int? sportIDNo;
  String? teamName;
  String? teamTimeZone;
  String? teamCountry;
  String? teamProfileImage;
  List<int>? updateProfileImage;
  int? managerIdNo;

  Result(
      {this.teamIDNo,
        this.sportIDNo,
        this.teamName,
        this.teamTimeZone,
        this.teamCountry,
        this.teamProfileImage,
        this.managerIdNo});

  Result.fromJson(Map<String, dynamic> json) {
    teamIDNo = json['TeamIDNo'];
    sportIDNo = json['SportIDNo'];
    teamName = json['TeamName'];
    teamTimeZone = json['TeamTimeZone'];
    teamCountry = json['TeamCountry'];
    teamProfileImage = json['TeamProfileImage'];
    managerIdNo = json['ManagerIdNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamIDNo'] = this.teamIDNo;
    data['SportIDNo'] = this.sportIDNo;
    data['TeamName'] = this.teamName;
    data['TeamTimeZone'] = this.teamTimeZone;
    data['TeamCountry'] = this.teamCountry;
    data['TeamProfileImage'] = this.updateProfileImage;
    data['ManagerIdNo'] = this.managerIdNo;
    return data;
  }
}
