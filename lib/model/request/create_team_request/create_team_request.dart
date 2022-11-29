class CreateTeamRequest {
  String? UserIDNo;
  String? teamName;
  String? sportIdNo;
  String? teamCountry;
  String? teamTimeZone;
  List<int>? image;
  int? RoleIdNo;

  CreateTeamRequest(
      {
        this.UserIDNo,
        this.teamName,
        this.sportIdNo,
        this.teamCountry,
        this.RoleIdNo,
        this.image,
        this.teamTimeZone});

  CreateTeamRequest.fromJson(Map<String, dynamic> json) {
    UserIDNo = json['UserIDNo'];
    teamName = json['TeamName'];
    sportIdNo = json['SportIdNo'];
    teamCountry = json['TeamCountry'];
    RoleIdNo = json['RoleIdNo'];
    image = json['TeamProfileImage'];
    teamTimeZone = json['TeamTimeZone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserIDNo'] = this.UserIDNo;
    data['TeamName'] = this.teamName;
    data['SportIdNo'] = this.sportIdNo;
    data['TeamCountry'] = this.teamCountry;
    data['TeamTimeZone'] = this.teamTimeZone;
    data['TeamProfileImage'] = this.image;
    data['RoleIdNo'] = this.RoleIdNo;
    print(data.toString());
    return data;
  }
}