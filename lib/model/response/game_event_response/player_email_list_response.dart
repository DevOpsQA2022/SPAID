class GetTeamMembersEmailResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  GetTeamMembersEmailResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  GetTeamMembersEmailResponse.fromJson(Map<String, dynamic> json) {
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
  int? teamIDNo;
  List<UserMailList>? userMailList;

  Result({this.id, this.teamIDNo, this.userMailList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamIDNo = json['TeamIDNo'];
    if (json['UserMailList'] != null) {
      userMailList = <UserMailList>[];
      json['UserMailList'].forEach((v) {
        userMailList!.add(new UserMailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamIDNo'] = this.teamIDNo;
    if (this.userMailList != null) {
      data['UserMailList'] = this.userMailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserMailList {
  String? id;
  int? userIDNo;
  String? email;
  String? FCMTokenID;
  String? name;
  int? rollId;
  bool? isEnable=false;

  UserMailList({this.id, this.userIDNo, this.email, this.rollId,this.isEnable});

  UserMailList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userIDNo = json['UserIDNo'];
    email = json['Email'];
    rollId = json['RollId'];
    FCMTokenID = json['FCMTokenID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIDNo'] = this.userIDNo;
    data['Email'] = this.email;
    data['RollId'] = this.rollId;
    data['FCMTokenID'] = this.FCMTokenID;
    data['Name'] = this.name;
    return data;
  }
}


class UserMailListTemp {
  String? id;
  int? userIDNo;
  String? email;
  String? FCMTokenID;
  String? name;
  int? rollId;
  bool? isEnable=false;

  UserMailListTemp({this.id, this.userIDNo, this.email, this.rollId,this.isEnable});

  UserMailListTemp.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    userIDNo = json['UserIDNo'];
    email = json['Email'];
    rollId = json['RollId'];
    FCMTokenID = json['FCMTokenID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['UserIDNo'] = this.userIDNo;
    data['Email'] = this.email;
    data['RollId'] = this.rollId;
    data['FCMTokenID'] = this.FCMTokenID;
    data['Name'] = this.name;
    return data;
  }
}
