class OpponentRequest {
  int? teamIDNo;
  int? userIDNo;

  OpponentRequest({this.teamIDNo, this.userIDNo});

  OpponentRequest.fromJson(Map<String, dynamic> json) {
    teamIDNo = json['TeamIDNo'];
    userIDNo = json['UserIDNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamIDNo'] = this.teamIDNo;
    data['UserIDNo'] = this.userIDNo;
    print(data.toString());
    return data;
  }
}
