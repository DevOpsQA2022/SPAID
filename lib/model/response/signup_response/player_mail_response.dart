class PlayerMailResponse {
  int? userId;
  int? teamId;
  String? userEmailId;
  int? playerAvailabilityStatusId;
  int? UserRoleID;
  String? password;
  bool? isUpdatePassword;

  PlayerMailResponse(
      {this.userId,
        this.teamId,
        this.userEmailId,
        this.playerAvailabilityStatusId,
        this.isUpdatePassword,
        this.UserRoleID,
        this.password});

  PlayerMailResponse.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    teamId = json['TeamId'];
    userEmailId = json['UserEmailId'];
    playerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
    password = json['Password'];
    isUpdatePassword = json['isUpdatePassword'];
    UserRoleID = json['UserRoleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['TeamId'] = this.teamId;
    data['UserEmailId'] = this.userEmailId;
    data['PlayerAvailabilityStatusId'] = this.playerAvailabilityStatusId;
    data['Password'] = this.password;
    data['isUpdatePassword'] = this.isUpdatePassword;
    data['UserRoleID'] = this.UserRoleID;
    print("Player Response"+data.toString());
    return data;
  }
}
