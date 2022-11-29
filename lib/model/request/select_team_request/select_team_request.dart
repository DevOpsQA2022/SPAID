class SelectTeamRequest {
  int? userIdNo;

  SelectTeamRequest({this.userIdNo});

  SelectTeamRequest.fromJson(Map<String, dynamic> json)
  {
    userIdNo = json['IDNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDNo'] = this.userIdNo;
    print("Volunteeer" + data.toString());
    return data;
  }
}