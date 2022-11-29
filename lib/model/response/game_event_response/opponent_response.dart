class OpponentResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  OpponentResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  OpponentResponse.fromJson(Map<String, dynamic> json) {
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
  int? currentTeamId;
  int? currentUserId;
  List<OpponentTeamList>? opponentTeamList;

  Result(
      {this.id, this.currentTeamId, this.currentUserId, this.opponentTeamList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    currentTeamId = json['CurrentTeamId'];
    currentUserId = json['CurrentUserId'];
    if (json['OpponentTeamList'] != null) {
      opponentTeamList = <OpponentTeamList>[];
      json['OpponentTeamList'].forEach((v) {
        opponentTeamList!.add(new OpponentTeamList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['CurrentTeamId'] = this.currentTeamId;
    data['CurrentUserId'] = this.currentUserId;
    if (this.opponentTeamList != null) {
      data['OpponentTeamList'] =
          this.opponentTeamList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OpponentTeamList {
  String? id;
  String? teamName;
  String? country;
  int? teamId;
  String? teamProfileImage;

  OpponentTeamList(
      {this.id,
        this.teamName,
        this.country,
        this.teamId,
        this.teamProfileImage});

  OpponentTeamList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamName = json['Team_Name'];
    country = json['Country'];
    teamId = json['TeamId'];
    teamProfileImage = json['TeamProfileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['Team_Name'] = this.teamName;
    data['Country'] = this.country;
    data['TeamId'] = this.teamId;
    data['TeamProfileImage'] = this.teamProfileImage;
    return data;
  }
}
