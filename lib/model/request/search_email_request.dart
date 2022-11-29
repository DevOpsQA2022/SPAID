class SearchUserRequest {
  String? email;

  SearchUserRequest({this.email});

  SearchUserRequest.fromJson(Map<String, dynamic> json) {
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    print(data);
    return data;
  }
}
