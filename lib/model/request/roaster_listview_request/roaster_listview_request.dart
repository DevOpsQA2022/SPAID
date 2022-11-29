class RoasterListViewRequest {
  String? teamName;
  int? familyUserIDNo;

  RoasterListViewRequest({this.teamName, this.familyUserIDNo});

  RoasterListViewRequest.fromJson(Map<String, dynamic> json) {
    teamName = json['TeamName'];
    familyUserIDNo = json['FamilyUserIDNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamName'] = this.teamName;
    data['FamilyUserIDNo'] = this.familyUserIDNo;
    return data;
  }
}