
class BaseResponse {
  String? errorMessage;
  int? status;

  BaseResponse({this.errorMessage, this.status});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['ErrorMessage'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorMessage'] = this.errorMessage;
    data['Status'] = this.status;
    return data;
  }
}