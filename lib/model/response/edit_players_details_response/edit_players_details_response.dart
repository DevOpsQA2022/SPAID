


import 'package:spaid/model/response/base_response.dart';

class EditPlayerResponse extends BaseResponse{


  String? id;
  User? user;
  String? errorMessage;
  int? status;

  EditPlayerResponse({this.id, this.user, this.errorMessage, this.status});

  EditPlayerResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    errorMessage = json['ErrorMessage'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    data['ErrorMessage'] = this.errorMessage;
    data['Status'] = this.status;
    return data;
  }
}

class User {
  String? id;
  int? userId;
  String? emailId;
  String? altemailId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dateOfBirth;
  int? phoneNo;
  int? altphoneNo;
  int? playerind;
  int? roleid;
  String? gender;
  String? address;
  String? altaddress;
  String? city;
  String? zipcode;

  User(
      {this.id,
        this.userId,
        this.emailId,
        this.altemailId,
        this.firstName,
        this.middleName,
        this.lastName,
        this.dateOfBirth,
        this.phoneNo,
        this.altphoneNo,
        this.playerind,
        this.roleid,
        this.gender,
        this.address,
        this.altaddress,
        this.city,
        this.zipcode,
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userId = json['UserIdNo'];
    emailId = json['UserEmailID'];
    altemailId = json['UserAlternateEmailID'];
    firstName = json['UserFirstName'];
    lastName = json['UserLastName'];
    dateOfBirth = json['UserDOB'];
    gender = json['UserGender'];
    address = json['UserAddress1'];
    altaddress = json['UserAddress2'];
    city = json['UserCity'];
    zipcode = json['UserZip'];
    phoneNo = json['UserPrimaryPhone'];
    altphoneNo = json['UserAlternatePhone'];
    playerind = json['PlayerInd'];
    roleid = json['RoleIdNo'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIdNo'] = this.userId;
    data['UserEmailID'] = this.emailId;
    data['UserAlternateEmailID'] = this.altemailId;
    data['UserFirstName'] = this.firstName;
    data['UserLastName'] = this.lastName;
    data['UserDOB'] = this.dateOfBirth;
    data['UserGender'] = this.gender;
    data['UserAddress1'] = this.address;
    data['UserAddress2'] = this.altaddress;
    data['UserCity'] = this.city;
    data['UserZip'] = this.zipcode;
    data['UserPrimaryPhone'] = this.phoneNo;
    data['UserAlternatePhone'] = this.altphoneNo;
    data['PlayerInd'] = this.playerind;
    data['RoleIdNo'] = this.roleid;
    return data;
  }
}

