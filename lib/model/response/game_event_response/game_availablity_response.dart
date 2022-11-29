class GetGameAvailablityResponse {
  String? id;
  int? teamId;
  List<TeamEventList>? teamEventList;

  GetGameAvailablityResponse({this.id, this.teamId, this.teamEventList});

  GetGameAvailablityResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamId = json['TeamId'];
    if (json['TeamEventList'] != null) {
      teamEventList = <TeamEventList>[];
      json['TeamEventList'].forEach((v) {
        teamEventList!.add(new TeamEventList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamId'] = this.teamId;
    if (this.teamEventList != null) {
      data['TeamEventList'] =
          this.teamEventList!.map((v) => v.toJson()).toList();
    }
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
  String? LocationAddress;
  int? Status;
  int? available;
  int? notRespond;
  int? reject;
  int? mailNotSend;
  int? MayBe;

  TeamEventList(
      {this.id,
        this.eventId,
        this.eventName,
        this.eventType,
        this.scheduleDate,
        this.scheduleTime,
        this.available,
        this.notRespond,
        this.reject,
        this.LocationAddress,
        this.MayBe,
        this.Status,
        this.mailNotSend});

  TeamEventList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventId = json['EventId'];
    eventName = json['EventName'];
    eventType = json['EventType'];
    scheduleDate = json['ScheduleDate'];
    scheduleTime = json['ScheduleTime'];
    available = json['Available'];
    notRespond = json['NotRespond'];
    reject = json['Reject'];
    mailNotSend = json['MailNotSend'];
    LocationAddress = json['LocationAddress'];
    MayBe = json['MayBe'];
    Status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EventId'] = this.eventId;
    data['EventName'] = this.eventName;
    data['EventType'] = this.eventType;
    data['ScheduleDate'] = this.scheduleDate;
    data['ScheduleTime'] = this.scheduleTime;
    data['Available'] = this.available;
    data['NotRespond'] = this.notRespond;
    data['Reject'] = this.reject;
    data['MailNotSend'] = this.mailNotSend;
    data['LocationAddress'] = this.LocationAddress;
    data['MayBe'] = this.MayBe;
    data['Status'] = this.Status;
    return data;
  }
}
