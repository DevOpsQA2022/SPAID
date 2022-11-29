
class EditPlayerRequest {
  int? userid;


  EditPlayerRequest(
      {this.userid,
      });

  EditPlayerRequest.fromJson(Map<String, dynamic> json) {
    userid = json['UserIdNo'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserIdNo'] = this.userid;
    return data;
  }
}





