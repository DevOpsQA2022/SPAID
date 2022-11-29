class AddGameResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  List<Result>? result;

  AddGameResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  AddGameResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    responseResult = json['ResponseResult'];
    responseMessage = json['ResponseMessage'];
    if (json['Result'] != null) {
      result = <Result>[];
      json['Result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ResponseResult'] = this.responseResult;
    data['ResponseMessage'] = this.responseMessage;
    if (this.result != null) {
      data['Result'] = this.result!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Result {
  String? id;
  int? eventVoluenteerTypeIDNo;
  int? volunteerTypeId;
  String? volunteerTypeName;
  int? eventId;
  List<int>? userIDList;
  bool? isDeleted;

  Result(
      {this.id,
        this.eventVoluenteerTypeIDNo,
        this.volunteerTypeId,
        this.volunteerTypeName,
        this.eventId,
        this.userIDList,
        this.isDeleted});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventVoluenteerTypeIDNo = json['EventVoluenteerTypeIDNo'];
    volunteerTypeId = json['VolunteerTypeId'];
    volunteerTypeName = json['VolunteerTypeName'];
    eventId = json['EventId'];
    userIDList =json['UserIDList'] != null? json['UserIDList'].cast<int>():[];
    isDeleted = json['IsDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EventVoluenteerTypeIDNo'] = this.eventVoluenteerTypeIDNo;
    data['VolunteerTypeId'] = this.volunteerTypeId;
    data['VolunteerTypeName'] = this.volunteerTypeName;
    data['EventId'] = this.eventId;
    data['UserIDList'] = this.userIDList;
    data['IsDeleted'] = this.isDeleted;
    return data;
  }
}





