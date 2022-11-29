class SendEmailRequest {
  int? notificationTypeID;
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
  String? gameNo;
  int? isNotesRequired;

  SendEmailRequest(
      {this.notificationTypeID,
        this.senderId,
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
        this.gameNo,
        this.isNotesRequired});

  SendEmailRequest.fromJson(Map<String, dynamic> json) {
    notificationTypeID = json['NotificationTypeID'];
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
    gameNo = json['GameNo'];
    isNotesRequired = json['IsNotesRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationTypeID'] = this.notificationTypeID;
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
    data['GameNo'] = this.gameNo;
    data['IsNotesRequired'] = this.isNotesRequired;
    print("Invite Player"+data.toString());
    return data;
  }
}
class SendNormalEmailRequest {
  List<String>? to;
  List<String>? cC;
  String? title;
  String? subject;
  String? notificationTypeID;
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

  SendNormalEmailRequest(
      {this.to,
        this.cC,
        this.title,
        this.subject,
        this.notificationTypeID,
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
        this.volunteer});

  SendNormalEmailRequest.fromJson(Map<String, dynamic> json) {
    to = json['To'].cast<String>();
    cC = json['CC'].cast<String>();
    title = json['Title'];
    subject = json['Subject'];
    notificationTypeID = json['NotificationTypeID'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['To'] = this.to;
    data['CC'] = this.cC;
    data['Title'] = this.title;
    data['Subject'] = this.subject;
    data['NotificationTypeID'] = this.notificationTypeID;
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
    print(data);
    return data;
  }
}
