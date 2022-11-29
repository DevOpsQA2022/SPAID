
class AddPlayerResponse {
  String? errorMessage;
  int? responseResult;
  String? responseMessage;
  AddPlayerResponse({this.errorMessage, this.responseResult,
    this.responseMessage,});

  AddPlayerResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['ErrorMessage'];
    responseResult = json['ResponseResult'];
    responseMessage = json['ResponseMessage'];  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorMessage'] = this.errorMessage;
    data['ResponseResult'] = this.responseResult;
    data['ResponseMessage'] = this.responseMessage;    return data;
  }
}