class ValidateUserResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  List<SaveErrors>? saveErrors;

  ValidateUserResponse(
      {this.id, this.responseResult, this.responseMessage, this.saveErrors});

  ValidateUserResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    responseResult = json['ResponseResult'];
    responseMessage = json['ResponseMessage'];
    if (json['SaveErrors'] != null) {
      saveErrors = [];
      json['SaveErrors'].forEach((v) {
        saveErrors!.add(new SaveErrors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ResponseResult'] = this.responseResult;
    data['ResponseMessage'] = this.responseMessage;
    if (this.saveErrors != null) {
      data['SaveErrors'] = this.saveErrors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaveErrors {
  String? id;
  String? objectNames;
  String? errorMessage;

  SaveErrors({this.id, this.objectNames, this.errorMessage});

  SaveErrors.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    objectNames = json['ObjectNames'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ObjectNames'] = this.objectNames;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
