class IndividualProfileResponse {
  int? statusCode;
  String? status;
  String? message;
  IndividualProfileData? data;

  IndividualProfileResponse(
      {this.statusCode, this.status, this.message, this.data});

  IndividualProfileResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new IndividualProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class IndividualProfileData {
  User? user;

  IndividualProfileData({this.user});

  IndividualProfileData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  Address? address;
  Loc? loc;
  String? name;
  String? profilePic;
  String? username;
  String? mobile;
  String? countryCode;
  String? email;
  List<String>? roles;
  int? points;
  int? reviews;
  String? rating;
  String? token;
  String? referrer;
  String? referralCode;
  String? customReferralCode;
  String? dateOfBirth;
  int? age;
  String? gender;
  String? otp;
  bool? status;
  bool? isNewUser;
  String? sId;
  String? password;
  Plan? plan;
  List<Talents>? talents;
  List<Null>? gurus;
  List<PointsDetail>? pointsDetail;
  String? createdAt;
  int? iV;

  User(
      {this.address,
        this.loc,
        this.name,
        this.profilePic,
        this.username,
        this.mobile,
        this.countryCode,
        this.email,
        this.roles,
        this.points,
        this.reviews,
        this.rating,
        this.token,
        this.referrer,
        this.referralCode,
        this.customReferralCode,
        this.dateOfBirth,
        this.age,
        this.gender,
        this.otp,
        this.status,
        this.isNewUser,
        this.sId,
        this.password,
        this.plan,
        this.talents,
        this.gurus,
        this.pointsDetail,
        this.createdAt,
        this.iV});

  User.fromJson(Map<String, dynamic> json) {
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    loc = json['loc'] != null ? new Loc.fromJson(json['loc']) : null;
    name = json['name'];
    profilePic = json['profilePic'];
    username = json['username'];
    mobile = json['mobile'];
    countryCode = json['countryCode'];
    email = json['email'];
    roles = json['roles'].cast<String>();
    points = json['points'];
    reviews = json['reviews'];
    rating = json['rating'];
    token = json['token'];
    referrer = json['referrer'];
    referralCode = json['referralCode'];
    customReferralCode = json['customReferralCode'];
    dateOfBirth = json['dateOfBirth'];
    age = json['age'];
    gender = json['gender'];
    otp = json['otp'];
    status = json['status'];
    isNewUser = json['isNewUser'];
    sId = json['_id'];
    password = json['password'];
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
    if (json['talents'] != null) {
      talents = <Talents>[];
      json['talents'].forEach((v) {
        talents!.add(new Talents.fromJson(v));
      });
    }
    // if (json['gurus'] != null) {
    //   gurus = new List<Null>();
    //   json['gurus'].forEach((v) {
    //     gurus.add(new Null.fromJson(v));
    //   });
    // }
    if (json['pointsDetail'] != null) {
      pointsDetail = <PointsDetail>[];
      json['pointsDetail'].forEach((v) {
        pointsDetail!.add(new PointsDetail.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.loc != null) {
      data['loc'] = this.loc!.toJson();
    }
    data['name'] = this.name;
    data['profilePic'] = this.profilePic;
    data['username'] = this.username;
    data['mobile'] = this.mobile;
    data['countryCode'] = this.countryCode;
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['points'] = this.points;
    data['reviews'] = this.reviews;
    data['rating'] = this.rating;
    data['token'] = this.token;
    data['referrer'] = this.referrer;
    data['referralCode'] = this.referralCode;
    data['customReferralCode'] = this.customReferralCode;
    data['dateOfBirth'] = this.dateOfBirth;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['otp'] = this.otp;
    data['status'] = this.status;
    data['isNewUser'] = this.isNewUser;
    data['_id'] = this.sId;
    data['password'] = this.password;
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    if (this.talents != null) {
      data['talents'] = this.talents!.map((v) => v.toJson()).toList();
    }
    // if (this.gurus != null) {
    //   data['gurus'] = this.gurus.map((v) => v.toJson()).toList();
    // }
    if (this.pointsDetail != null) {
      data['pointsDetail'] = this.pointsDetail!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Address {
  String? country;
  String? doorNo;
  String? street;
  String? locality;
  String? landmark;
  String? town;
  String? state;
  String? pin;

  Address(
      {this.country,
        this.doorNo,
        this.street,
        this.locality,
        this.landmark,
        this.town,
        this.state,
        this.pin});

  Address.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    doorNo = json['doorNo'];
    street = json['street'];
    locality = json['locality'];
    landmark = json['landmark'];
    town = json['town'];
    state = json['state'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['doorNo'] = this.doorNo;
    data['street'] = this.street;
    data['locality'] = this.locality;
    data['landmark'] = this.landmark;
    data['town'] = this.town;
    data['state'] = this.state;
    data['pin'] = this.pin;
    return data;
  }
}

class Loc {
  String? type;
  List<Null>? coordinates;

  Loc({this.type, this.coordinates});

  Loc.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    // if (json['coordinates'] != null) {
    //   coordinates = new List<Null>();
    //   json['coordinates'].forEach((v) {
    //     coordinates.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    // if (this.coordinates != null) {
    //   data['coordinates'] = this.coordinates.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Plan {
  String? plan;
  String? planId;
  String? subscriptionId;
  String? status;
  String? startedAt;
  String? validTill;

  Plan(
      {this.plan,
        this.planId,
        this.subscriptionId,
        this.status,
        this.startedAt,
        this.validTill});

  Plan.fromJson(Map<String, dynamic> json) {
    plan = json['plan'];
    planId = json['planId'];
    subscriptionId = json['subscriptionId'];
    status = json['status'];
    startedAt = json['startedAt'];
    validTill = json['validTill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan'] = this.plan;
    data['planId'] = this.planId;
    data['subscriptionId'] = this.subscriptionId;
    data['status'] = this.status;
    data['startedAt'] = this.startedAt;
    data['validTill'] = this.validTill;
    return data;
  }
}

class Talents {
  String? sId;
  String? talent;

  Talents({this.sId, this.talent});

  Talents.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    talent = json['talent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['talent'] = this.talent;
    return data;
  }
}

class PointsDetail {
  String? sId;
  String? name;
  String? point;
  String? type;
  String? expDate;
  String? refId;

  PointsDetail(
      {this.sId, this.name, this.point, this.type, this.expDate, this.refId});

  PointsDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    point = json['point'];
    type = json['type'];
    expDate = json['expDate'];
    refId = json['refId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['point'] = this.point;
    data['type'] = this.type;
    data['expDate'] = this.expDate;
    data['refId'] = this.refId;
    return data;
  }
}
