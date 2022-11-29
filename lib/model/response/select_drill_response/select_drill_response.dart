class GetAllDrillPlanResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  GetAllDrillPlanResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  GetAllDrillPlanResponse.fromJson(Map<String, dynamic> json) {
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
  List<AllDrillPlanList>? allDrillPlanList;

  Result({this.id, this.teamIdNo, this.allDrillPlanList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamIdNo = json['TeamIdNo'];
    if (json['AllDrillPlanList'] != null) {
      allDrillPlanList = <AllDrillPlanList>[];
      json['AllDrillPlanList'].forEach((v) {
        allDrillPlanList!.add(new AllDrillPlanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamIdNo'] = this.teamIdNo;
    if (this.allDrillPlanList != null) {
      data['AllDrillPlanList'] =
          this.allDrillPlanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllDrillPlanList {
  String? id;
  int? teamDrillPlanId;
  int? teamDrillCategoryId;
  String? categoryDescription;
  String? planDescription;
  String? sharedDrillPlan;
  String? sharedDrillImage;
  bool? isSelected=false;

  AllDrillPlanList(
      {this.id,
        this.teamDrillPlanId,
        this.teamDrillCategoryId,
        this.categoryDescription,
        this.isSelected,
        this.sharedDrillPlan,
        this.sharedDrillImage,
        this.planDescription});

  AllDrillPlanList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamDrillPlanId = json['DrillId'];
    teamDrillCategoryId = json['DrillCategoryId'];
    categoryDescription = json['CategoryDescription'];
    sharedDrillPlan = json['SharedDrillPlan'];
    planDescription = json['PlanDescription'];
    sharedDrillImage = json['SharedDrillImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['DrillId'] = this.teamDrillPlanId;
    data['DrillCategoryId'] = this.teamDrillCategoryId;
    data['CategoryDescription'] = this.categoryDescription;
    data['PlanDescription'] = this.planDescription;
    data['SharedDrillPlan'] = this.sharedDrillPlan;
    data['SharedDrillImage'] = this.sharedDrillImage;
    return data;
  }
}
