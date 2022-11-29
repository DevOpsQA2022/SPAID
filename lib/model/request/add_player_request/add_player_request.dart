class AddPlayerRequest {
  String? emailId;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  int? contactNo;
  String? jerseyNo;
  String? position;
  String? address;
  String? city;
  String? state;
  String? gender;
  String? zipCode;
  int? isManager;
  int? isNonPlayer;
  String? middleName = "";
  String? altEmailId;
  String? country = "US";
  String? altAddress;
  int? altContactNo;
  String? teamName = "";
  String? pass = "";
  int? createdby;
  int? UserIDNo;
  int? PlayerAvailabilityStatusId;
  int? TeamIDNo;
  int? UserRoleId;
  int? managerIdNo;
  List<int>? image;
  String? shoot;
  String? medicalNote;
  String? note;

  AddPlayerRequest(
      {this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.jerseyNo,
      this.position,
      this.emailId,
      this.altEmailId,
      this.contactNo,
      this.altContactNo,
      this.address,
      this.altAddress,
      this.city,
      this.state,
      this.zipCode,
      this.gender,
      this.isManager,
      this.isNonPlayer,
      this.UserIDNo,
      this.TeamIDNo,
      this.PlayerAvailabilityStatusId,
      this.image,
      this.createdby,
      this.UserRoleId,
        this.shoot,
        this.medicalNote,
        this.note,
      this.teamName});

  AddPlayerRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['UserFirstName'];
    middleName = json['UserMiddleName'];
    lastName = json['UserLastName'];
    emailId = json['UserEmailID'];
    altEmailId = json['UserAlternateEmailID'];
    dateOfBirth = json['UserDOB'];
    gender = json['UserGender'];
    country = json['UserCountry'];
    address = json['UserAddress1'];
    altAddress = json['UserAddress2'];
    contactNo = json['UserPrimaryPhone'];
    altContactNo = json['UserAlternatePhone'];
    city = json['UserCity'];
    state = json['UserState'];
    zipCode = json['UserZip'];
    teamName = json['TeamName'];
    isManager = json['RoleIDNo'];
    jerseyNo = json['UserJerseyNumber'];
    isNonPlayer = json['PlayerInd'];
    pass = json['UserPassword'];
    createdby = json['FamilyUserIDNo'];
    UserIDNo = json['UserIDNo'];
    TeamIDNo = json['TeamIDNo'];
    image = json['UserProfileImage'];
    position = json['Positions'];
    UserRoleId = json['UserRoleId'];
    PlayerAvailabilityStatusId = json['PlayerAvailabilityStatusId'];
    shoot = json['Shoot'];
    medicalNote = json['MedicalNote'];
    note = json['Note'];
    managerIdNo = json['ManagerIdNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserFirstName'] = this.firstName;
    data['UserMiddleName'] = this.middleName;
    data['UserLastName'] = this.lastName;
    data['UserEmailID'] = this.emailId;
    data['UserAlternateEmailID'] = this.altEmailId;
    data['UserDOB'] = this.dateOfBirth;
    data['UserGender'] = this.gender;
    data['UserCountry'] = this.country;
    data['UserAddress1'] = this.address;
    data['UserAddress2'] = this.altAddress;
    data['UserPrimaryPhone'] = this.contactNo;
    data['UserAlternatePhone'] = this.altContactNo;
    data['UserCity'] = this.city;
    data['UserState'] = this.state;
    data['UserZip'] = this.zipCode;
    data['TeamName'] = this.teamName;
    data['RoleIDNo'] = this.isManager;
    data['UserJerseyNumber'] = this.jerseyNo;
    data['PlayerInd'] = this.isNonPlayer;
    data['UserPassword'] = this.pass;
    data['FamilyUserIDNo'] = this.createdby;
    data['UserIDNo'] = this.UserIDNo;
    data['TeamIDNo'] = this.TeamIDNo;
    data['UserProfileImage'] = this.image;
    data['Positions'] = this.position;
    data['UserRoleId'] = this.UserRoleId;
    data['PlayerAvailabilityStatusId'] = this.PlayerAvailabilityStatusId;
    data['Shoot'] = this.shoot;
    data['MedicalNote'] = this.medicalNote;
    data['Note'] = this.note;
    data['ManagerIdNo'] = this.managerIdNo;
    print("Add Player"+data.toString());
    return data;
  }
}
