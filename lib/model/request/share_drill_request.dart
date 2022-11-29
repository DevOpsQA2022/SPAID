class ShareDrillRequest {
  String? teamDrillPlanId;
  String? userIdNo;
  String? teamIdNo;

  ShareDrillRequest({this.teamDrillPlanId, this.userIdNo, this.teamIdNo});

  ShareDrillRequest.fromJson(Map<String, dynamic> json) {
    teamDrillPlanId = json['TeamDrillPlanId'];
    userIdNo = json['UserIdNo'];
    teamIdNo = json['TeamIdNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamDrillPlanId'] = this.teamDrillPlanId;
    data['UserIdNo'] = this.userIdNo;
    data['TeamIdNo'] = this.teamIdNo;
    return data;
  }
}
