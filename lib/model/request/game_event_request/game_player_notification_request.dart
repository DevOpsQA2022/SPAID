class EventPlayerNotificationRequest {
  int? eventId;
  List<NotificationMailList>? notificationMailList;

  EventPlayerNotificationRequest({this.eventId, this.notificationMailList});

  EventPlayerNotificationRequest.fromJson(Map<String, dynamic> json) {
    eventId = json['EventId'];
    if (json['NotificationMailList'] != null) {
      notificationMailList = <NotificationMailList>[];
      json['NotificationMailList'].forEach((v) {
        notificationMailList!.add(new NotificationMailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventId'] = this.eventId;
    if (this.notificationMailList != null) {
      data['NotificationMailList'] =
          this.notificationMailList!.map((v) => v.toJson()).toList();
    }
    print("Invite Player"+data.toString());
    return data;
  }
}

class NotificationMailList {
  int? notificationTypeID;
  String? eventVoluenteerTypeIDNo;
  String? volunteerTypeId;
  String? volunteerTypeName;
  String? eventId;
  int? senderId;
  int? recipientId;
  int? referenceTableId;
  String? contentText;
  String? to;
  String? cC;
  String? title;
  String? subject;
  String? coachName;
  String? gameTitle;
  String? acceptLink;
  String? maybeLink;
  String? declineLink;
  String? address;
  String? date;
  String? time;
  String? signin;
  String? resetPassword;
  String? playerName;
  String? managerName;
  String? teamName;
  String? playerMail;
  String? volunteer;
  int? isNotesRequired;

  NotificationMailList(
      {this.notificationTypeID,
        this.senderId,
        this.eventVoluenteerTypeIDNo,
        this.volunteerTypeId,
        this.volunteerTypeName,
        this.eventId,
        this.recipientId,
        this.referenceTableId,
        this.contentText,
        this.to,
        this.cC,
        this.title,
        this.subject,
        this.coachName,
        this.gameTitle,
        this.acceptLink,
        this.maybeLink,
        this.declineLink,
        this.address,
        this.date,
        this.time,
        this.signin,
        this.resetPassword,
        this.playerName,
        this.managerName,
        this.teamName,
        this.playerMail,
        this.volunteer,
        this.isNotesRequired});

  NotificationMailList.fromJson(Map<String, dynamic> json) {
    notificationTypeID = json['NotificationTypeID'];
    eventVoluenteerTypeIDNo = json['EventVoluenteerTypeIDNo'];
    volunteerTypeId = json['VolunteerTypeId'];
    volunteerTypeName = json['VolunteerTypeName'];
    eventId = json['EventId'];
    senderId = json['SenderId'];
    recipientId = json['RecipientId'];
    referenceTableId = json['ReferenceTableId'];
    contentText = json['ContentText'];
    to = json['To'];
    cC = json['CC'];
    title = json['Title'];
    subject = json['Subject'];
    coachName = json['CoachName'];
    gameTitle = json['GameTitle'];
    acceptLink = json['AcceptLink'];
    maybeLink = json['MaybeLink'];
    declineLink = json['DeclineLink'];
    address = json['Address'];
    date = json['Date'];
    time = json['Time'];
    signin = json['Signin'];
    resetPassword = json['ResetPassword'];
    playerName = json['PlayerName'];
    managerName = json['ManagerName'];
    teamName = json['TeamName'];
    playerMail = json['PlayerMail'];
    volunteer = json['Volunteer'];
    isNotesRequired = json['IsNotesRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationTypeID'] = this.notificationTypeID;
    data['EventVoluenteerTypeIDNo'] = this.eventVoluenteerTypeIDNo;
    data['VolunteerTypeId'] = this.volunteerTypeId;
    data['VolunteerTypeName'] = this.volunteerTypeName;
    data['EventId'] = this.eventId;
    data['SenderId'] = this.senderId;
    data['RecipientId'] = this.recipientId;
    data['ReferenceTableId'] = this.referenceTableId;
    data['ContentText'] = this.contentText;
    data['To'] = this.to;
    data['CC'] = this.cC;
    data['Title'] = this.title;
    data['Subject'] = this.subject;
    data['CoachName'] = this.coachName;
    data['GameTitle'] = this.gameTitle;
    data['AcceptLink'] = this.acceptLink;
    data['MaybeLink'] = this.maybeLink;
    data['DeclineLink'] = this.declineLink;
    data['Address'] = this.address;
    data['Date'] = this.date;
    data['Time'] = this.time;
    data['Signin'] = this.signin;
    data['ResetPassword'] = this.resetPassword;
    data['PlayerName'] = this.playerName;
    data['ManagerName'] = this.managerName;
    data['TeamName'] = this.teamName;
    data['PlayerMail'] = this.playerMail;
    data['Volunteer'] = this.volunteer;
    data['IsNotesRequired'] = this.isNotesRequired;
    print("ResendVolunteer"+ data.toString());
    return data;
  }
}
