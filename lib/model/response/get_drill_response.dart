class GetDrillCategoryResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  GetDrillCategoryResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  GetDrillCategoryResponse.fromJson(Map<String, dynamic> json) {
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
  int? teamIdNo;
  List<DrillCategoryList>? drillCategoryList;

  Result({this.id, this.teamIdNo, this.drillCategoryList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamIdNo = json['TeamIdNo'];
    if (json['DrillCategoryList'] != null) {
      drillCategoryList = <DrillCategoryList>[];
      json['DrillCategoryList'].forEach((v) {
        drillCategoryList!.add(new DrillCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamIdNo'] = this.teamIdNo;
    if (this.drillCategoryList != null) {
      data['DrillCategoryList'] =
          this.drillCategoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DrillCategoryList {
  String? id;
  int? drillCategoryId;
  String? description;
  int? teamIdNo;
  int? userIdNo;
  int? teamDrillCategoryId;

  DrillCategoryList(
      {this.id,
        this.drillCategoryId,
        this.description,
        this.teamIdNo,
        this.userIdNo,
        this.teamDrillCategoryId});

  DrillCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    drillCategoryId = json['DrillCategoryId'];
    description = json['Description'];
    teamIdNo = json['TeamIdNo'];
    userIdNo = json['UserIdNo'];
    teamDrillCategoryId = json['TeamDrillCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['DrillCategoryId'] = this.drillCategoryId;
    data['Description'] = this.description;
    data['TeamIdNo'] = this.teamIdNo;
    data['UserIdNo'] = this.userIdNo;
    data['TeamDrillCategoryId'] = this.teamDrillCategoryId;
    return data;
  }
}