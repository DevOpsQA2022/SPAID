class GetDrillPlanResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  GetDrillPlanResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  GetDrillPlanResponse.fromJson(Map<String, dynamic> json) {
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
  int? teamDrillPlanId;
  int? teamDrillCategoryId;
  String? categoryDescription;
  String? planDescription;
  String? planNotes;
  String? planImage;
  String? planVideoLink;
  String? drillDate;
  int? duration;
  int? userIdNo;
  int? teamIdNo;

  Result(
      {this.id,
        this.teamDrillPlanId,
        this.teamDrillCategoryId,
        this.categoryDescription,
        this.planDescription,
        this.planNotes,
        this.planImage,
        this.planVideoLink,
        this.drillDate,
        this.duration,
        this.userIdNo,
        this.teamIdNo});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamDrillPlanId = json['DrillId'];
    teamDrillCategoryId = json['DrillCategoryId'];
    categoryDescription = json['CategoryDescription'];
    planDescription = json['PlanDescription'];
    planNotes = json['PlanNotes'];
    planImage = json['PlanImageJson'];
    planVideoLink = json['PlanVideoLink'];
    drillDate = json['DrillDate'];
    duration = json['Duration'];
    userIdNo = json['UserIdNo'];
    teamIdNo = json['CreatedTeamIdNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['DrillId'] = this.teamDrillPlanId;
    data['DrillCategoryId'] = this.teamDrillCategoryId;
    data['CategoryDescription'] = this.categoryDescription;
    data['PlanDescription'] = this.planDescription;
    data['PlanNotes'] = this.planNotes;
    data['PlanImageJson'] = this.planImage;
    data['PlanVideoLink'] = this.planVideoLink;
    data['DrillDate'] = this.drillDate;
    data['Duration'] = this.duration;
    data['UserIdNo'] = this.userIdNo;
    data['CreatedTeamIdNo'] = this.teamIdNo;
    return data;
  }
}
