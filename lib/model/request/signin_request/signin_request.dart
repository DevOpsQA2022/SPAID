class SignInRequest {
  String? userEmailID;
  String? userPassword;
  String? FCMTokenID;

  SignInRequest({this.userEmailID, this.userPassword});

  SignInRequest.fromJson(Map<String, dynamic> json) {
    userEmailID = json['Email'];
    userPassword = json['Password'];
    FCMTokenID = json['FCMTokenID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.userEmailID;
    data['Password'] = this.userPassword;
    data['FCMTokenID'] = this.FCMTokenID;
    return data;
  }
}