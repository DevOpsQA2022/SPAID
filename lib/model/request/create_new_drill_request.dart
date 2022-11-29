class CreateNewDrillPlanRequest {
  int? userIdNo;
  int? teamIdNo;
  String? categoryDescription;
  String? planDescription;
  String? planNotes;
  String? planImage;
  String? planVideoLink;
  String? drillDate;
  int? duration;
  List<int>? planPngImage;

  CreateNewDrillPlanRequest(
      {this.userIdNo,
        this.teamIdNo,
        this.categoryDescription,
        this.planDescription,
        this.planNotes,
        this.planImage,
        this.planVideoLink,
        this.drillDate,
        this.planPngImage,
        this.duration});

  CreateNewDrillPlanRequest.fromJson(Map<String, dynamic> json) {
    userIdNo = json['UserIdNo'];
    teamIdNo = json['CreatedTeamIdNo'];
    categoryDescription = json['CategoryDescription'];
    planDescription = json['PlanDescription'];
    planNotes = json['PlanNotes'];
    planImage = json['PlanImageJson'];
    planPngImage = json['PlanImage'];
    planVideoLink = json['PlanVideoLink'];
    drillDate = json['DrillDate'];
    duration = json['Duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserIdNo'] = this.userIdNo;
    data['CreatedTeamIdNo'] = this.teamIdNo;
    data['CategoryDescription'] = this.categoryDescription;
    data['PlanDescription'] = this.planDescription;
    data['PlanNotes'] = this.planNotes;
    data['PlanImageJson'] = this.planImage;
    data['PlanImage'] = this.planPngImage;
    data['PlanVideoLink'] = this.planVideoLink;
    data['DrillDate'] = this.drillDate;
    data['Duration'] = this.duration;
    print(data.toString());
    return data;
  }
}
