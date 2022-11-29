class UpdateDrillPlanRequest {
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
  List<int>? planPngImage;

  UpdateDrillPlanRequest(
      {this.teamDrillPlanId,
        this.teamDrillCategoryId,
        this.categoryDescription,
        this.planDescription,
        this.planNotes,
        this.planImage,
        this.planVideoLink,
        this.drillDate,
        this.duration,
        this.userIdNo,
        this.planPngImage,
        this.teamIdNo});

  UpdateDrillPlanRequest.fromJson(Map<String, dynamic> json) {
    teamDrillPlanId = json['DrillId'];
    teamDrillCategoryId = json['DrillCategoryId'];
    categoryDescription = json['CategoryDescription'];
    planDescription = json['PlanDescription'];
    planNotes = json['PlanNotes'];
    planImage = json['PlanImageJson'];
    planVideoLink = json['PlanVideoLink'];
    drillDate = json['DrillDate'];
    duration = json['Duration'];
    planPngImage = json['PlanImage'];
    userIdNo = json['UserIdNo'];
    teamIdNo = json['TeamIdNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DrillId'] = this.teamDrillPlanId;
    data['DrillCategoryId'] = this.teamDrillCategoryId;
    data['CategoryDescription'] = this.categoryDescription;
    data['PlanDescription'] = this.planDescription;
    data['PlanNotes'] = this.planNotes;
    data['PlanImageJson'] = this.planImage;
    data['PlanVideoLink'] = this.planVideoLink;
    data['DrillDate'] = this.drillDate;
    data['Duration'] = this.duration;
    data['PlanImage'] = this.planPngImage;
    data['UserIdNo'] = this.userIdNo;
    data['TeamIdNo'] = this.teamIdNo;
    print("Update Drill"+data.toString());
    return data;
  }
}
