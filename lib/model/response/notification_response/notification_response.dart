class NotificationResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  NotificationResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  NotificationResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  List<UserNotificationList>? userNotificationList;

  Result({this.id, this.userId, this.userNotificationList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserId'];
    if (json['UserNotificationList'] != null) {
      userNotificationList = <UserNotificationList>[];
      json['UserNotificationList'].forEach((v) {
        userNotificationList!.add(new UserNotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserId'] = this.userId;
    if (this.userNotificationList != null) {
      data['UserNotificationList'] =
          this.userNotificationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserNotificationList {
  String? id;
  int? notificationId;
  int? notificationTypeId;
  int? senderId;
  int? recipientId;
  int? referenceTableId;
  String? contentText;
  bool? isMailSend;
  bool? isUnread;
  bool? isDelete;
  bool? IsNotesRequired;
  String? createdDateTime;
  String? modifiedDateTime;
  String? fcm;
  String? email;
  String? name;
  String? teamName;
  String? eventName;
  int? eventType;
  int? userID;

  UserNotificationList(
      {this.id,
        this.notificationId,
        this.notificationTypeId,
        this.senderId,
        this.recipientId,
        this.referenceTableId,
        this.contentText,
        this.isMailSend,
        this.isUnread,
        this.isDelete,
        this.IsNotesRequired,
        this.createdDateTime,
        this.fcm,
        this.email,
        this.name,
        this.teamName,
        this.eventName,
        this.eventType,
        this.userID,
        this.modifiedDateTime});

  UserNotificationList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    notificationId = json['NotificationId'];
    notificationTypeId = json['NotificationTypeId'];
    senderId = json['SenderId'];
    recipientId = json['RecipientId'];
    referenceTableId = json['ReferenceTableId'];
    contentText = json['ContentText'];
    isMailSend = json['IsMailSend'];
    isUnread = json['IsUnread'];
    isDelete = json['IsDelete'];
    IsNotesRequired = json['IsNotesRequired'];
    createdDateTime = json['CreatedDateTime'];
    modifiedDateTime = json['ModifiedDateTime'];
    fcm = json['FCM'];
    email = json['Email'];
    name = json['Name'];
    teamName = json['TeamName'];
    eventName = json['EventName'];
    eventType = json['EventType'];
    userID = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['NotificationId'] = this.notificationId;
    data['NotificationTypeId'] = this.notificationTypeId;
    data['SenderId'] = this.senderId;
    data['RecipientId'] = this.recipientId;
    data['ReferenceTableId'] = this.referenceTableId;
    data['ContentText'] = this.contentText;
    data['IsMailSend'] = this.isMailSend;
    data['IsUnread'] = this.isUnread;
    data['IsDelete'] = this.isDelete;
    data['IsNotesRequired'] = this.IsNotesRequired;
    data['CreatedDateTime'] = this.createdDateTime;
    data['ModifiedDateTime'] = this.modifiedDateTime;
    data['FCM'] = this.fcm;
    data['Email'] = this.email;
    data['Name'] = this.name;
    data['TeamName'] = this.teamName;
    data['EventName'] = this.eventName;
    data['EventType'] = this.eventType;
    data['UserId'] = this.userID;
    return data;
  }
}
