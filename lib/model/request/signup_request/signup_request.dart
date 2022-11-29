class SignUpRequest {
  String? userFirstName;
  String? userMiddleName;
  String? userLastName;
  String? userEmailID;
  String? userAlternateEmailID;
  String? userDOB;
  String? userGender;
  String? userPassword;
  String? userCountry;
  String? userAddress1;
  String? userAddress2;
  int? userPrimaryPhone;
  int? userAlternatePhone;
  int? UserIDNo;
  int? FamilyUserIDNo;
  String? userCity;
  String? userZip;
  String? userState;
  String? roleIDNo;
  String? FCMTokenID;
  String? googleLoginId;
  String? facebookLoginId;
  List<int>? image;

  SignUpRequest(
      {this.userFirstName,
        this.userMiddleName,
        this.userLastName,
        this.userEmailID,
        this.userAlternateEmailID,
        this.userDOB,
        this.userGender,
        this.userPassword,
        this.userCountry,
        this.userAddress1,
        this.userAddress2,
        this.userPrimaryPhone,
        this.userAlternatePhone,
        this.userCity,
        this.userZip,
        this.UserIDNo,
        this.FamilyUserIDNo,
        this.FCMTokenID,
        this.userState,
        this.image,
        this.googleLoginId,
        this.facebookLoginId,
        this.roleIDNo});

  SignUpRequest.fromJson(Map<String, dynamic> json) {
    userFirstName = json['UserFirstName'];
    userMiddleName = json['UserMiddleName'];
    userLastName = json['UserLastName'];
    userEmailID = json['UserEmailID'];
    userAlternateEmailID = json['UserAlternateEmailID'];
    userDOB = json['UserDOB'];
    userGender = json['UserGender'];
    userPassword = json['UserPassword'];
    userCountry = json['UserCountry'];
    userAddress1 = json['UserAddress1'];
    userAddress2 = json['UserAddress2'];
    userPrimaryPhone = json['UserPrimaryPhone'];
    userAlternatePhone = json['UserAlternatePhone'];
    userCity = json['UserCity'];
    userState = json['UserState'];
    userZip = json['UserZip'];
    roleIDNo = json['RoleIDNo'];
    roleIDNo = json['UserIDNo'];
    roleIDNo = json['FamilyUserIDNo'];
    roleIDNo = json['FCMTokenID'];
    image = json['UserProfileImage'];
    googleLoginId = json['GoogleLoginId'];
    facebookLoginId = json['FacebookLoginId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserFirstName'] = this.userFirstName;
    data['UserMiddleName'] = this.userMiddleName;
    data['UserLastName'] = this.userLastName;
    data['UserEmailID'] = this.userEmailID;
    data['UserAlternateEmailID'] = this.userAlternateEmailID;
    data['UserDOB'] = this.userDOB;
    data['UserGender'] = this.userGender;
    data['UserPassword'] = this.userPassword;
    data['UserCountry'] = this.userCountry;
    data['UserAddress1'] = this.userAddress1;
    data['UserAddress2'] = this.userAddress2;
    data['UserPrimaryPhone'] = this.userPrimaryPhone;
    data['UserAlternatePhone'] = this.userAlternatePhone;
    data['UserCity'] = this.userCity;
    data['UserState'] = this.userState;
    data['UserZip'] = this.userZip;
    data['RoleIDNo'] = this.roleIDNo;
    data['UserIDNo'] = this.UserIDNo;
    data['FamilyUserIDNo'] = this.FamilyUserIDNo;
    data['FCMTokenID'] = this.FCMTokenID;
    data['UserProfileImage'] = this.image;
    data['GoogleLoginId'] = this.googleLoginId;
    data['FacebookLoginId'] = this.facebookLoginId;
    print("Update User"+data.toString());
    return data;
  }
}


