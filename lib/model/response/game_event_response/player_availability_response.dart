class GetPlayerAvailabilityResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  GetPlayerAvailabilityResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  GetPlayerAvailabilityResponse.fromJson(Map<String, dynamic> json) {
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
  List<AvailablePlayerList>? availablePlayerList;
  List<NotRespondPlayerList>? notRespondPlayerList;
  List<RejectPlayerList>? rejectPlayerList;
  List<MayBePlayerList>? mayBePlayerList;
  List<MailNotSendPlayerList>? mailNotSendPlayerList;

  Result(
      {this.id,
        this.eventId,
        this.availablePlayerList,
        this.notRespondPlayerList,
        this.rejectPlayerList,
        this.mayBePlayerList,
        this.mailNotSendPlayerList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    eventId = json['EventId'];
    if (json['AvailablePlayerList'] != null) {
      availablePlayerList = <AvailablePlayerList>[];
      json['AvailablePlayerList'].forEach((v) {
        availablePlayerList!.add(new AvailablePlayerList.fromJson(v));
      });
    }
    if (json['NotRespondPlayerList'] != null) {
      notRespondPlayerList = <NotRespondPlayerList>[];
      json['NotRespondPlayerList'].forEach((v) {
        notRespondPlayerList!.add(new NotRespondPlayerList.fromJson(v));
      });
    }
    if (json['RejectPlayerList'] != null) {
      rejectPlayerList = <RejectPlayerList>[];
      json['RejectPlayerList'].forEach((v) {
        rejectPlayerList!.add(new RejectPlayerList.fromJson(v));
      });
    }
    if (json['MailNotSendPlayerList'] != null) {
      mailNotSendPlayerList = <MailNotSendPlayerList>[];
      json['MailNotSendPlayerList'].forEach((v) {
        mailNotSendPlayerList!.add(new MailNotSendPlayerList.fromJson(v));
      });
    }
    if (json['MayBePlayerList'] != null) {
      mayBePlayerList = <MayBePlayerList>[];
      json['MayBePlayerList'].forEach((v) {
        mayBePlayerList!.add(new MayBePlayerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['EventId'] = this.eventId;
    if (this.availablePlayerList != null) {
      data['AvailablePlayerList'] =
          this.availablePlayerList!.map((v) => v.toJson()).toList();
    }
    if (this.notRespondPlayerList != null) {
      data['NotRespondPlayerList'] =
          this.notRespondPlayerList!.map((v) => v.toJson()).toList();
    }
    if (this.rejectPlayerList != null) {
      data['RejectPlayerList'] =
          this.rejectPlayerList!.map((v) => v.toJson()).toList();
    }
    if (this.mailNotSendPlayerList != null) {
      data['MailNotSendPlayerList'] =
          this.mailNotSendPlayerList!.map((v) => v.toJson()).toList();
    }
    if (this.mayBePlayerList != null) {
      data['MayBePlayerList'] =
          this.mayBePlayerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailablePlayerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  String? availabilityStatus;
  String? Notes;
  bool? playerSelectionStatus;

  AvailablePlayerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.Notes,
        this.playerSelectionStatus,
        this.availabilityStatus});

  AvailablePlayerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    availabilityStatus = json['AvailabilityStatus'];
    playerSelectionStatus = json['PlayerSelectionStatus'];
    Notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['PlayerSelectionStatus'] = this.playerSelectionStatus;
    data['Notes'] = this.Notes;
    return data;
  }
}
class NotRespondPlayerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  String? availabilityStatus;
  String? Notes;

  NotRespondPlayerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.Notes,
        this.availabilityStatus});

  NotRespondPlayerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    availabilityStatus = json['AvailabilityStatus'];
    Notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.Notes;
    return data;
  }
}

class RejectPlayerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  String? availabilityStatus;
  String? Notes;

  RejectPlayerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.Notes,
        this.availabilityStatus});

  RejectPlayerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    availabilityStatus = json['AvailabilityStatus'];
    Notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.Notes;
    return data;
  }
}

class MailNotSendPlayerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  String? availabilityStatus;
  String? Notes;

  MailNotSendPlayerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.Notes,
        this.availabilityStatus});

  MailNotSendPlayerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    availabilityStatus = json['AvailabilityStatus'];
    Notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.Notes;
    return data;
  }
}


class MayBePlayerList {
  String? id;
  int? userId;
  String? userName;
  String? userProfileImage;
  String? email;
  int? availabilityStatusId;
  String? availabilityStatus;
  String? Notes;

  MayBePlayerList(
      {this.id,
        this.userId,
        this.userName,
        this.userProfileImage,
        this.email,
        this.availabilityStatusId,
        this.Notes,
        this.availabilityStatus});

  MayBePlayerList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    userName = json['UserName'];
    userProfileImage = json['UserProfileImage'];
    email = json['Email'];
    availabilityStatusId = json['AvailabilityStatusId'];
    availabilityStatus = json['AvailabilityStatus'];
    Notes = json['Notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserProfileImage'] = this.userProfileImage;
    data['Email'] = this.email;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['AvailabilityStatus'] = this.availabilityStatus;
    data['Notes'] = this.Notes;
    return data;
  }
}
