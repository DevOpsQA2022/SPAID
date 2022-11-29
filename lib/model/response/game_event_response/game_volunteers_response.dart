class GetEventVoluenteers {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  GetEventVoluenteers(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  GetEventVoluenteers.fromJson(Map<String, dynamic> json) {
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
  int? eventId;
  int? userId;
  List<VolunteerList>? volunteerList;

  Result({this.id, this.eventId, this.userId, this.volunteerList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventId = json['EventId'];
    userId = json['UserId'];
    if (json['VolunteerList'] != null) {
      volunteerList = <VolunteerList>[];
      json['VolunteerList'].forEach((v) {
        volunteerList!.add(new VolunteerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EventId'] = this.eventId;
    data['UserId'] = this.userId;
    if (this.volunteerList != null) {
      data['VolunteerList'] =
          this.volunteerList!.map((v) => v.toJson()).toList();
    }
    print(data.toString());
    return data;
  }
}

class VolunteerList {
  String? id;
  int? eventVoluenteerTypeIDNo;
  int? volunteerTypeId;
  String? volunteerTypeName;
  int? eventId;
  List<int>? userIDList;
  bool? isDeleted;

  VolunteerList(
      {this.id,
        this.eventVoluenteerTypeIDNo,
        this.volunteerTypeId,
        this.volunteerTypeName,
        this.eventId,
        this.userIDList,
        this.isDeleted});

  VolunteerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventVoluenteerTypeIDNo = json['EventVoluenteerTypeIDNo'];
    volunteerTypeId = json['VolunteerTypeId'];
    volunteerTypeName = json['VolunteerTypeName'];
    eventId = json['EventId'];
    userIDList = json['UserIDList'] != null?json['UserIDList'].cast<int>():[];
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
    print("Volunteer"+data.toString());
    return data;
  }
}
