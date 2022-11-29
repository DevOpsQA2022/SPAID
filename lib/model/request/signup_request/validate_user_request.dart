class ValidateUserRequest {
  String? userInput;
  String? userPassword;
  bool? isRequestFromMail;

  ValidateUserRequest(
      {this.userInput, this.userPassword, this.isRequestFromMail});

  ValidateUserRequest.fromJson(Map<String, dynamic> json) {
    userInput = json['UserInput'];
    userPassword = json['UserPassword'];
    isRequestFromMail = json['IsRequestFromMail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserInput'] = this.userInput;
    data['UserPassword'] = this.userPassword;
    data['IsRequestFromMail'] = this.isRequestFromMail;
    print(data);
    return data;
  }
}
