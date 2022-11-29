class GetTeamMemberDetailsRequest {
  int? teamIDNo;
  int? userIDNo;
  int? UserRoleId;

  GetTeamMemberDetailsRequest({this.teamIDNo, this.userIDNo});

  GetTeamMemberDetailsRequest.fromJson(Map<String, dynamic> json) {
    teamIDNo = json['TeamIDNo'];
    userIDNo = json['UserIDNo'];
    UserRoleId = json['UserRoleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamIDNo'] = this.teamIDNo;
    data['UserIDNo'] = this.userIDNo;
    data['UserRoleId'] = this.UserRoleId;
    print(data.toString());
    return data;
  }
}
