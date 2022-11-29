class ExistingPlayerRequest {
  String? userInput;

  ExistingPlayerRequest({this.userInput});

  ExistingPlayerRequest.fromJson(Map<String, dynamic> json) {
    userInput = json['UserInput'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserInput'] = this.userInput;
    print(data.toString());
    return data;
  }
}
