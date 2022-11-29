class ScoreRequest {
  int? iDNo;
  bool? isGuestUser;

  ScoreRequest({this.iDNo,this.isGuestUser});

  ScoreRequest.fromJson(Map<String, dynamic> json) {
    iDNo = json['MatchId'];
    isGuestUser  = json['isGuestUser '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MatchId'] = this.iDNo;
    data['isGuestUser '] = this.isGuestUser ;
    return data;
  }
}
