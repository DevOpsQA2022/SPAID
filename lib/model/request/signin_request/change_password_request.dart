class ChangePasswordRequest {
  int? userId;
  String? email;
  String? password;

  ChangePasswordRequest({this.userId, this.email, this.password});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    email = json['Email'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['Email'] = this.email;
    data['Password'] = this.password;
    return data;
  }
}
