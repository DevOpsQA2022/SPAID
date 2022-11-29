class AddGameRequest {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  AddGameRequest(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  AddGameRequest.fromJson(Map<String, dynamic> json) {
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
  int? eventId;
  int? type;
  String? name;
  int? sportIDNo;
  String? scheduleDate;
  String? scheduleTime;
  String? venue;
  int? teamIDNo;
  int? opponentTeamID;
  int? status;
  int? repeat;
  bool? repeats;
  int? repeatType;
  String? repeatStartDate;
  String? repeatEndDate;
  String? repeatDaysString;
  String? locationAddress;
  String? latitude;
  String? longtitude;
  String? locationDetails;
  bool? tDB;
  String? timeZone;
  String? duration;
  String? homeOrAway;
  String? arriveEarly;
  String? flagColor;
  int? trackAvail;
  bool? trackAvails;
  bool? IsNotesRequired;
  bool? isAllOccurence;
  bool? isCustom;
  String? notes;
  int? userIDNo;
  int? EventGroupId;
  List<int>? repeatDays;
  List<int>? customMemberList;
  List<VolunteerTypeList>? volunteerTypeList;

  Result(
      {this.eventId,
        this.type,
        this.name,
        this.sportIDNo,
        this.scheduleDate,
        this.scheduleTime,
        this.venue,
        this.teamIDNo,
        this.opponentTeamID,
        this.status,
        this.repeat,
        this.repeatType,
        this.repeatStartDate,
        this.repeatEndDate,
        this.repeatDaysString,
        this.locationAddress,
        this.latitude,
        this.longtitude,
        this.locationDetails,
        this.tDB,
        this.timeZone,
        this.homeOrAway,
        this.duration,
        this.arriveEarly,
        this.flagColor,
        this.trackAvail,
        this.notes,
        this.userIDNo,
        this.repeatDays,
        this.isCustom,
        this.customMemberList,
        this.IsNotesRequired,
        this.EventGroupId,
        this.isAllOccurence,
        this.volunteerTypeList});

  Result.fromJson(Map<String, dynamic> json) {
    eventId = json['EventId'];
    type = json['Type'];
    name = json['Name'];
    sportIDNo = json['SportIDNo'];
    scheduleDate = json['ScheduleDate'];
    scheduleTime = json['ScheduleTime'];
    venue = json['Venue'];
    teamIDNo = json['TeamIDNo'];
    opponentTeamID = json['OpponentTeamID'];
    status = json['Status'];
    repeats = json['Repeat'];
    repeatType = json['RepeatType'];
    repeatStartDate = json['RepeatStartDate'];
    repeatEndDate = json['RepeatEndDate'];
    repeatDaysString = json['RepeatDaysString'];
    locationAddress = json['LocationAddress'];
    latitude = json['Latitude'];
    longtitude = json['Longtitude'];
    locationDetails = json['LocationDetails'];
    duration = json['Duration'];
    tDB = json['TDB'];
    timeZone = json['TimeZone'];
    homeOrAway = json['HomeOrAway'];
    arriveEarly = json['ArriveEarly'];
    flagColor = json['FlagColor'];
    trackAvails = json['TrackAvail'];
    IsNotesRequired = json['IsNotesRequired'];
    notes = json['Notes'];
    userIDNo = json['UserIDNo'];
    isAllOccurence = json['IsAllOccurence'];
    EventGroupId = json['EventGroupId'];
    isCustom = json['IsCustomMember'];
    repeatDays = json['RepeatDays'].cast<int>();
    customMemberList =  json['CustomMemberList'] != null?json['CustomMemberList'].cast<int>():[];
    if (json['VolunteerTypeList'] != null) {
      volunteerTypeList = <VolunteerTypeList>[];
      json['VolunteerTypeList'].forEach((v) {
        volunteerTypeList!.add(new VolunteerTypeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventId'] = this.eventId;
    data['Type'] = this.type;
    data['Name'] = this.name;
    data['SportIDNo'] = this.sportIDNo;
    data['ScheduleDate'] = this.scheduleDate;
    data['ScheduleTime'] = this.scheduleTime;
    data['Venue'] = this.venue;
    data['TeamIDNo'] = this.teamIDNo;
    data['OpponentTeamID'] = this.opponentTeamID;
    data['Status'] = this.status;
    data['Repeat'] = this.repeat;
    data['RepeatType'] = this.repeatType;
    data['RepeatStartDate'] = this.repeatStartDate;
    data['RepeatEndDate'] = this.repeatEndDate;
    data['RepeatDaysString'] = this.repeatDaysString;
    data['LocationAddress'] = this.locationAddress;
    data['Latitude'] = this.latitude;
    data['Longtitude'] = this.longtitude;
    data['LocationDetails'] = this.locationDetails;
    data['Duration'] = this.duration;
    data['TDB'] = this.tDB;
    data['TimeZone'] = this.timeZone;
    data['HomeOrAway'] = this.homeOrAway;
    data['ArriveEarly'] = this.arriveEarly;
    data['FlagColor'] = this.flagColor;
    data['TrackAvail'] = this.trackAvail;
    data['IsNotesRequired'] = this.IsNotesRequired;
    data['Notes'] = this.notes;
    data['UserIDNo'] = this.userIDNo;
    data['RepeatDays'] = this.repeatDays;
    data['IsAllOccurence'] = this.isAllOccurence;
    data['EventGroupId'] = this.EventGroupId;
    data['IsCustomMember'] = this.isCustom;
    data['CustomMemberList'] = this.customMemberList;
    if (this.volunteerTypeList != null) {
      data['VolunteerTypeList'] =
          this.volunteerTypeList!.map((v) => v.toJson()).toList();
    }
    print("Event API"+data.toString());
    return data;
  }
}

class VolunteerTypeList {
  int? eventVoluenteerTypeIDNo;
  int? volunteerTypeId;
  String? volunteerTypeName;
  int? eventId;
  List<int>? userIDList;
  int? isDeleted;
  bool? isDelete;

  VolunteerTypeList(
      {this.eventVoluenteerTypeIDNo,
        this.volunteerTypeId,
        this.volunteerTypeName,
        this.eventId,
        this.userIDList,
        this.isDeleted});

  VolunteerTypeList.fromJson(Map<String, dynamic> json) {
    eventVoluenteerTypeIDNo = json['EventVoluenteerTypeIDNo'];
    volunteerTypeId = json['VolunteerTypeId'];
    volunteerTypeName = json['VolunteerTypeName'];
    eventId = json['EventId'];
    userIDList = json['UserIDList'] != null?json['UserIDList'].cast<int>():[];
    isDelete = json['IsDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventVoluenteerTypeIDNo'] = this.eventVoluenteerTypeIDNo;
    data['VolunteerTypeId'] = this.volunteerTypeId;
    data['VolunteerTypeName'] = this.volunteerTypeName;
    data['EventId'] = this.eventId;
    data['UserIDList'] = this.userIDList;
    data['IsDeleted'] = this.isDeleted;
    return data;
  }
}
