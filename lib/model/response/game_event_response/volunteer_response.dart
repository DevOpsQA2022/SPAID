
class VolunteerResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  VolunteerResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  VolunteerResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    responseResult = json['ResponseResult'];
    responseMessage = json['ResponseMessage'];
    result =
    json['Result'] != null ? new Result.fromJson(json['Result']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ResponseResult'] = this.responseResult;
    data['ResponseMessage'] = this.responseMessage;
    if (this.result != null) {
      data['Result'] = this.result!.toJson();
    }

    return data;
  }
}

class Result {
  String? id;
  List<VoluenteerList>? voluenteerList;

  Result({this.id, this.voluenteerList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    if (json['VoluenteerList'] != null) {
      voluenteerList = <VoluenteerList>[];
      json['VoluenteerList'].forEach((v) {
        voluenteerList!.add(new VoluenteerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.voluenteerList != null) {
      data['VoluenteerList'] =
          this.voluenteerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VoluenteerList {
  String? id;
  int? voluenteerTypeId;
  String? voluenteerTypeName;

  VoluenteerList({this.id, this.voluenteerTypeId, this.voluenteerTypeName});

  VoluenteerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    voluenteerTypeId = json['VolunteerTypeId'];
    voluenteerTypeName = json['VolunteerTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['VolunteerTypeId'] = this.voluenteerTypeId;
    data['VolunteerTypeName'] = this.voluenteerTypeName;
    return data;
  }
}
