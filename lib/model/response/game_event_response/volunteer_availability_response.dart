class VolunteerAvailabilityResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  VolunteerAvailabilityResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  VolunteerAvailabilityResponse.fromJson(Map<String, dynamic> json) {
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
  List<AvailableVolunteerList>? availableVolunteerList;
  List<NotRespondVolunteerList>? notRespondVolunteerList;
  List<RejectVolunteerList>? rejectVolunteerList;
  List<MayBeVolunteerList>? mayBeVolunteerList;
  List<MailNotSendVolunteerList>? mailNotSendVolunteerList;

  Result(
      {this.id,
        this.eventId,
        this.availableVolunteerList,
        this.notRespondVolunteerList,
        this.rejectVolunteerList,
        this.mayBeVolunteerList,
        this.mailNotSendVolunteerList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventId = json['EventId'];
    if (json['AvailableVolunteerList'] != null) {
      availableVolunteerList = <AvailableVolunteerList>[];
      json['AvailableVolunteerList'].forEach((v) {
        availableVolunteerList!.add(new AvailableVolunteerList.fromJson(v));
      });
    }
    if (json['NotRespondVolunteerList'] != null) {
      notRespondVolunteerList = <NotRespondVolunteerList>[];
      json['NotRespondVolunteerList'].forEach((v) {
        notRespondVolunteerList!.add(new NotRespondVolunteerList.fromJson(v));
      });
    }
    if (json['RejectVolunteerList'] != null) {
      rejectVolunteerList = <RejectVolunteerList>[];
      json['RejectVolunteerList'].forEach((v) {
        rejectVolunteerList!.add(new RejectVolunteerList.fromJson(v));
      });
    }
    if (json['MayBeVolunteerList'] != null) {
      mayBeVolunteerList = <MayBeVolunteerList>[];
      json['MayBeVolunteerList'].forEach((v) {
        mayBeVolunteerList!.add(new MayBeVolunteerList.fromJson(v));
      });
    }
    if (json['MailNotSendVolunteerList'] != null) {
      mailNotSendVolunteerList = <MailNotSendVolunteerList>[];
      json['MailNotSendVolunteerList'].forEach((v) {
        mailNotSendVolunteerList!.add(new MailNotSendVolunteerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EventId'] = this.eventId;
    if (this.availableVolunteerList != null) {
      data['AvailableVolunteerList'] =
          this.availableVolunteerList!.map((v) => v.toJson()).toList();
    }
    if (this.notRespondVolunteerList != null) {
      data['NotRespondVolunteerList'] =
          this.notRespondVolunteerList!.map((v) => v.toJson()).toList();
    }
    if (this.rejectVolunteerList != null) {
      data['RejectVolunteerList'] =
          this.rejectVolunteerList!.map((v) => v.toJson()).toList();
    }
    if (this.mayBeVolunteerList != null) {
      data['MayBeVolunteerList'] =
          this.mayBeVolunteerList!.map((v) => v.toJson()).toList();
    }
    if (this.mailNotSendVolunteerList != null) {
      data['MailNotSendVolunteerList'] =
          this.mailNotSendVolunteerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableVolunteerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  int? eventVolunteerTypeIDNo;
  String? availabilityStatus;
  String? notes;
  String? volunteerJobName;

  AvailableVolunteerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.eventVolunteerTypeIDNo,
        this.availabilityStatus,
        this.volunteerJobName,
        this.notes});

  AvailableVolunteerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    eventVolunteerTypeIDNo = json['EventVolunteerTypeIDNo'];
    availabilityStatus = json['AvailabilityStatus'];
    notes = json['Notes'];
    volunteerJobName = json['VolunteerJobName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['EventVolunteerTypeIDNo'] = this.eventVolunteerTypeIDNo;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.notes;
    data['VolunteerJobName'] = this.volunteerJobName;
    return data;
  }
}

class NotRespondVolunteerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  int? eventVolunteerTypeIDNo;
  String? availabilityStatus;
  String? notes;
  String? volunteerJobName;

  NotRespondVolunteerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.eventVolunteerTypeIDNo,
        this.availabilityStatus,
        this.volunteerJobName,
        this.notes});

  NotRespondVolunteerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    eventVolunteerTypeIDNo = json['EventVolunteerTypeIDNo'];
    availabilityStatus = json['AvailabilityStatus'];
    notes = json['Notes'];
    volunteerJobName = json['VolunteerJobName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['EventVolunteerTypeIDNo'] = this.eventVolunteerTypeIDNo;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.notes;
    data['VolunteerJobName'] = this.volunteerJobName;
    return data;
  }
}

class RejectVolunteerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  int? eventVolunteerTypeIDNo;
  String? availabilityStatus;
  String? notes;
  String? volunteerJobName;

  RejectVolunteerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.eventVolunteerTypeIDNo,
        this.availabilityStatus,
        this.volunteerJobName,
        this.notes});

  RejectVolunteerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    eventVolunteerTypeIDNo = json['EventVolunteerTypeIDNo'];
    availabilityStatus = json['AvailabilityStatus'];
    notes = json['Notes'];
    volunteerJobName = json['VolunteerJobName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['EventVolunteerTypeIDNo'] = this.eventVolunteerTypeIDNo;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.notes;
    data['VolunteerJobName'] = this.volunteerJobName;
    return data;
  }
}

class MayBeVolunteerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  int? eventVolunteerTypeIDNo;
  String? availabilityStatus;
  String? notes;
  String? volunteerJobName;

  MayBeVolunteerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.eventVolunteerTypeIDNo,
        this.availabilityStatus,
        this.volunteerJobName,
        this.notes});

  MayBeVolunteerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    eventVolunteerTypeIDNo = json['EventVolunteerTypeIDNo'];
    availabilityStatus = json['AvailabilityStatus'];
    notes = json['Notes'];
    volunteerJobName = json['VolunteerJobName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['EventVolunteerTypeIDNo'] = this.eventVolunteerTypeIDNo;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.notes;
    data['VolunteerJobName'] = this.volunteerJobName;
    return data;
  }
}

class MailNotSendVolunteerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  int? eventVolunteerTypeIDNo;
  String? availabilityStatus;
  String? notes;
  String? volunteerJobName;

  MailNotSendVolunteerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.eventVolunteerTypeIDNo,
        this.availabilityStatus,
        this.volunteerJobName,
        this.notes});

  MailNotSendVolunteerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    eventVolunteerTypeIDNo = json['EventVolunteerTypeIDNo'];
    availabilityStatus = json['AvailabilityStatus'];
    notes = json['Notes'];
    volunteerJobName = json['VolunteerJobName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['EventVolunteerTypeIDNo'] = this.eventVolunteerTypeIDNo;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.notes;
    data['VolunteerJobName'] = this.volunteerJobName;
    return data;
  }
}