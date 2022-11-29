class GetDrillCategoryRequest {
  int? idNo;
  String? email;

  GetDrillCategoryRequest({this.idNo});

  GetDrillCategoryRequest.fromJson(Map<String, dynamic> json) {
    idNo = json['IdNo'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IdNo'] = this.idNo;
    data['Email'] = this.email;
    return data;
  }
}