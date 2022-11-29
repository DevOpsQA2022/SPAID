class ShareDrillRequest {
  String? userIDNo;
  String? sharedTeamIdNo;
  String? sharedDrillPlan;
  List<DrillPlanList>? drillPlanList;

  ShareDrillRequest({this.userIDNo, this.sharedTeamIdNo, this.drillPlanList});

  ShareDrillRequest.fromJson(Map<String, dynamic> json) {
    userIDNo = json['UserIDNo'];
    sharedTeamIdNo = json['SharedTeamIdNo'];
    sharedDrillPlan = json['SharedDrillPlan'];
    if (json['DrillPlanList'] != null) {
      drillPlanList = <DrillPlanList>[];
      json['DrillPlanList'].forEach((v) {
        drillPlanList!.add(new DrillPlanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserIDNo'] = this.userIDNo;
    data['SharedTeamIdNo'] = this.sharedTeamIdNo;
    data['SharedDrillPlan'] = this.sharedDrillPlan;
    if (this.drillPlanList != null) {
      data['DrillPlanList'] =
          this.drillPlanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DrillPlanList {
  int? drillPlanId;
  String? drillId;
  String? description;
  String? drillImage;

  DrillPlanList(
      {this.drillPlanId, this.drillId, this.description, this.drillImage});

  DrillPlanList.fromJson(Map<String, dynamic> json) {
    drillPlanId = json['DrillPlanId'];
    drillId = json['DrillId'];
    description = json['Description'];
    drillImage = json['DrillImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DrillPlanId'] = this.drillPlanId;
    data['DrillId'] = this.drillId;
    data['Description'] = this.description;
    data['DrillImage'] = this.drillImage;
    return data;
  }
}
