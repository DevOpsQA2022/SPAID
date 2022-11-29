
class NotificationRequest {
  String? emailId;


  NotificationRequest(
      {this.emailId,
      });

  NotificationRequest.fromJson(Map<String, dynamic> json) {
    emailId = json['Email_Id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email_Id'] = this.emailId;
    return data;
  }
}





