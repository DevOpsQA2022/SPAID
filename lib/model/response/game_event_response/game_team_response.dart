class GetGameEventForTeamResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  GetGameEventForTeamResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  GetGameEventForTeamResponse.fromJson(Map<String, dynamic> json) {
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
  int? teamId;
  List<GameOrEventList>? gameOrEventList;

  Result({this.id, this.teamId, this.gameOrEventList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamId = json['TeamId'];
    if (json['GameOrEventList'] != null) {
      gameOrEventList = <GameOrEventList>[];
      json['GameOrEventList'].forEach((v) {
        gameOrEventList!.add(new GameOrEventList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamId'] = this.teamId;
    if (this.gameOrEventList != null) {
      data['GameOrEventList'] =
          this.gameOrEventList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GameOrEventList {
  String? id;
  int? eventId;
  String? type;
  String? name;
  int? sportIDNo;
  String? scheduleDate;
  String? scheduleTime;
  int? teamIDNo;
  int? opponentTeamID;
  int? status;
  bool? repeat;
  int? repeatType;
  String? repeatStartDate;
  String? repeatEndDate;
  List<int>? repeatDays;
  String? repeatDaysString;
  String? locationAddress;
  String? locationDetails;
  String? latitude;
  String? longtitude;
  bool? tDB;
  String? timeZone;
  String? duration;
  String? homeOrAway;
  String? arriveEarly;
  String? flagColor;
  bool? trackAvail;
  String? notes;
  int? userIDNo;
  bool? isNotesRequired;
  int? eventGroupId;
  int? playerAvailabilityStatusId;
  bool? isAllOccurence;
  bool? isGameorEventClosed;
  bool? isCustom;
  List<int>? customMemberList;
  List<VolunteerTypeList>? volunteerTypeList;
  List<TeamEventList>? teamEventList;
  List<VolunteerTypeAvailabilityList>? volunteerTypeAvailabilityList;

  GameOrEventList(
      {this.id,
        this.eventId,
        this.type,
        this.name,
        this.sportIDNo,
        this.scheduleDate,
        this.scheduleTime,
        this.teamIDNo,
        this.opponentTeamID,
        this.status,
        this.repeat,
        this.repeatType,
        this.repeatStartDate,
        this.repeatEndDate,
        this.repeatDays,
        this.repeatDaysString,
        this.locationAddress,
        this.locationDetails,
        this.latitude,
        this.longtitude,
        this.tDB,
        this.timeZone,
        this.duration,
        this.homeOrAway,
        this.arriveEarly,
        this.flagColor,
        this.trackAvail,
        this.notes,
        this.userIDNo,
        this.isNotesRequired,
        this.eventGroupId,
        this.playerAvailabilityStatusId,
        this.isAllOccurence,
        this.isGameorEventClosed,
        this.volunteerTypeList,
        this.teamEventList,
        this.isCustom,
        this.customMemberList,
        this.volunteerTypeAvailabilityList});

  GameOrEventList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventId = json['EventId'];
    type = json['Type'];
    name = json['Name'];
    sportIDNo = json['SportIDNo'];
    scheduleDate = json['ScheduleDate'];
    scheduleTime = json['ScheduleTime'];
    teamIDNo = json['TeamIDNo'];
    opponentTeamID = json['OpponentTeamID'];
    status = json['Status'];
    repeat = json['Repeat'];
    repeatType = json['RepeatType'];
    repeatStartDate = json['RepeatStartDate'];
    repeatEndDate = json['RepeatEndDate'];
    repeatDays = json['RepeatDays'].cast<int>();
    repeatDaysString = json['RepeatDaysString'];
    locationAddress = json['LocationAddress'];
    locationDetails = json['LocationDetails'];
    latitude = json['Latitude'];
    longtitude = json['Longtitude'];
    tDB = json['TDB'];
    timeZone = json['TimeZone'];
    duration = json['Duration'];
    homeOrAway = json['HomeOrAway'];
    arriveEarly = json['ArriveEarly'];
    flagColor = json['FlagColor'];
    trackAvail = json['TrackAvail'];
    notes = json['Notes'];
    userIDNo = json['UserIDNo'];
    isNotesRequired = json['IsNotesRequired'];
    eventGroupId = json['EventGroupId'];
    playerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
    isAllOccurence = json['IsAllOccurence'];
    isCustom = json['IsCustomMember'];
    customMemberList =  json['CustomMemberList'] != null?json['CustomMemberList'].cast<int>():[];
    isGameorEventClosed = json['isGameorEventClosed'];
    if (json['VolunteerTypeList'] != null) {
      volunteerTypeList = <VolunteerTypeList>[];
      json['VolunteerTypeList'].forEach((v) {
        volunteerTypeList!.add(new VolunteerTypeList.fromJson(v));
      });
    }
    if (json['TeamEventList'] != null) {
      teamEventList = <TeamEventList>[];
      json['TeamEventList'].forEach((v) {
        teamEventList!.add(new TeamEventList.fromJson(v));
      });
    }
    if (json['VolunteerTypeAvailabilityList'] != null) {
      volunteerTypeAvailabilityList = <VolunteerTypeAvailabilityList>[];
      json['VolunteerTypeAvailabilityList'].forEach((v) {
        volunteerTypeAvailabilityList!
            .add(new VolunteerTypeAvailabilityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EventId'] = this.eventId;
    data['Type'] = this.type;
    data['Name'] = this.name;
    data['SportIDNo'] = this.sportIDNo;
    data['ScheduleDate'] = this.scheduleDate;
    data['ScheduleTime'] = this.scheduleTime;
    data['TeamIDNo'] = this.teamIDNo;
    data['OpponentTeamID'] = this.opponentTeamID;
    data['Status'] = this.status;
    data['Repeat'] = this.repeat;
    data['RepeatType'] = this.repeatType;
    data['RepeatStartDate'] = this.repeatStartDate;
    data['RepeatEndDate'] = this.repeatEndDate;
    data['RepeatDays'] = this.repeatDays;
    data['RepeatDaysString'] = this.repeatDaysString;
    data['LocationAddress'] = this.locationAddress;
    data['LocationDetails'] = this.locationDetails;
    data['Latitude'] = this.latitude;
    data['Longtitude'] = this.longtitude;
    data['TDB'] = this.tDB;
    data['TimeZone'] = this.timeZone;
    data['Duration'] = this.duration;
    data['HomeOrAway'] = this.homeOrAway;
    data['ArriveEarly'] = this.arriveEarly;
    data['FlagColor'] = this.flagColor;
    data['TrackAvail'] = this.trackAvail;
    data['Notes'] = this.notes;
    data['UserIDNo'] = this.userIDNo;
    data['IsNotesRequired'] = this.isNotesRequired;
    data['EventGroupId'] = this.eventGroupId;
    data['PlayerAvailabilityStatusId'] = this.playerAvailabilityStatusId;
    data['IsAllOccurence'] = this.isAllOccurence;
    data['isGameorEventClosed'] = this.isGameorEventClosed;
    data['IsCustomMember'] = this.isCustom;
    data['CustomMemberList'] = this.customMemberList;
    if (this.volunteerTypeList != null) {
      data['VolunteerTypeList'] =
          this.volunteerTypeList!.map((v) => v.toJson()).toList();
    }
    if (this.teamEventList != null) {
      data['TeamEventList'] =
          this.teamEventList!.map((v) => v.toJson()).toList();
    }
    if (this.volunteerTypeAvailabilityList != null) {
      data['VolunteerTypeAvailabilityList'] =
          this.volunteerTypeAvailabilityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VolunteerTypeList {
  String? id;
  int? eventVoluenteerTypeIDNo;
  int? volunteerTypeId;
  String? volunteerTypeName;
  int? eventId;
  List<int>? userIDList;
  bool? isDeleted;

  VolunteerTypeList(
      {this.id,
        this.eventVoluenteerTypeIDNo,
        this.volunteerTypeId,
        this.volunteerTypeName,
        this.eventId,
        this.userIDList,
        this.isDeleted});

  VolunteerTypeList.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class TeamEventList {
  String? id;
  int? eventId;
  String? eventName;
  int? eventType;
  String? scheduleDate;
  String? scheduleTime;
  String? locationAddress;
  String? locationDetails;
  int? available;
  int? notRespond;
  int? reject;
  int? mailNotSend;
  int? mayBe;
  int? status;

  TeamEventList(
      {this.id,
        this.eventId,
        this.eventName,
        this.eventType,
        this.scheduleDate,
        this.scheduleTime,
        this.locationAddress,
        this.locationDetails,
        this.available,
        this.notRespond,
        this.reject,
        this.mailNotSend,
        this.mayBe,
        this.status});

  TeamEventList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventId = json['EventId'];
    eventName = json['EventName'];
    eventType = json['EventType'];
    scheduleDate = json['ScheduleDate'];
    scheduleTime = json['ScheduleTime'];
    locationAddress = json['LocationAddress'];
    locationDetails = json['LocationDetails'];
    available = json['Available'];
    notRespond = json['NotRespond'];
    reject = json['Reject'];
    mailNotSend = json['MailNotSend'];
    mayBe = json['MayBe'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EventId'] = this.eventId;
    data['EventName'] = this.eventName;
    data['EventType'] = this.eventType;
    data['ScheduleDate'] = this.scheduleDate;
    data['ScheduleTime'] = this.scheduleTime;
    data['LocationAddress'] = this.locationAddress;
    data['LocationDetails'] = this.locationDetails;
    data['Available'] = this.available;
    data['NotRespond'] = this.notRespond;
    data['Reject'] = this.reject;
    data['MailNotSend'] = this.mailNotSend;
    data['MayBe'] = this.mayBe;
    data['Status'] = this.status;
    return data;
  }
}

class VolunteerTypeAvailabilityList {
  String? id;
  int? available;
  int? notRespond;
  int? reject;
  int? mailNotSend;
  int? mayBe;

  VolunteerTypeAvailabilityList(
      {this.id,
        this.available,
        this.notRespond,
        this.reject,
        this.mailNotSend,
        this.mayBe});

  VolunteerTypeAvailabilityList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    available = json['Available'];
    notRespond = json['NotRespond'];
    reject = json['Reject'];
    mailNotSend = json['MailNotSend'];
    mayBe = json['MayBe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['Available'] = this.available;
    data['NotRespond'] = this.notRespond;
    data['Reject'] = this.reject;
    data['MailNotSend'] = this.mailNotSend;
    data['MayBe'] = this.mayBe;
    return data;
  }
}
