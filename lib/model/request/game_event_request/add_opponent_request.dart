class AddOpponentRequest {
  int? duplicateTeamId;
  int? teamIDNo;
  int? userIDNo;
  String? contactPersion;
  String? contactEmail;
  String? contactMobile;
  String? address;
  String? notes;
  String? teamName;
  int? sportIDNo;
  String? teamTimeZone;
  String? teamCountry;
  List<int>? teamProfileImage;
  int? managerIdNo;

  AddOpponentRequest(
      {this.duplicateTeamId,
        this.teamIDNo,
        this.userIDNo,
        this.contactPersion,
        this.contactEmail,
        this.contactMobile,
        this.address,
        this.notes,
        this.teamName,
        this.sportIDNo,
        this.teamTimeZone,
        this.teamCountry,
        this.teamProfileImage,
        this.managerIdNo});

  AddOpponentRequest.fromJson(Map<String, dynamic> json) {
    duplicateTeamId = json['DuplicateTeamId'];
    teamIDNo = json['TeamIDNo'];
    userIDNo = json['UserIDNo'];
    contactPersion = json['ContactPerson'];
    contactEmail = json['ContactEmail'];
    contactMobile = json['ContactMobile'];
    address = json['Address'];
    notes = json['Notes'];
    teamName = json['TeamName'];
    sportIDNo = json['SportIDNo'];
    teamTimeZone = json['TeamTimeZone'];
    teamCountry = json['TeamCountry'];
    teamProfileImage = json['TeamProfileImage'];
    managerIdNo = json['ManagerIdNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DuplicateTeamId'] = this.duplicateTeamId;
    data['TeamIDNo'] = this.teamIDNo;
    data['UserIDNo'] = this.userIDNo;
    data['ContactPerson'] = this.contactPersion;
    data['ContactEmail'] = this.contactEmail;
    data['ContactMobile'] = this.contactMobile;
    data['Address'] = this.address;
    data['Notes'] = this.notes;
    data['TeamName'] = this.teamName;
    data['SportIDNo'] = this.sportIDNo;
    data['TeamTimeZone'] = this.teamTimeZone;
    data['TeamCountry'] = this.teamCountry;
    data['TeamProfileImage'] = this.teamProfileImage;
    data['ManagerIdNo'] = this.managerIdNo;
    return data;
  }
}
