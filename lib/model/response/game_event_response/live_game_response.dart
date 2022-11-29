class LiveGameResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  LiveGameResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  LiveGameResponse.fromJson(Map<String, dynamic> json) {
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
  int? teamId;
  int? userId;
  List<OnGoingGameList>? onGoingGameList;

  Result({this.id, this.teamId, this.userId, this.onGoingGameList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    teamId = json['TeamId'];
    userId = json['UserId'];
    if (json['OnGoingGameList'] != null) {
      onGoingGameList = <OnGoingGameList>[];
      json['OnGoingGameList'].forEach((v) {
        onGoingGameList!.add(new OnGoingGameList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['TeamId'] = this.teamId;
    data['UserId'] = this.userId;
    if (this.onGoingGameList != null) {
      data['OnGoingGameList'] =
          this.onGoingGameList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OnGoingGameList {
  String? id;
  int? matcheId;
  int? team1GameId;
  int? team2GameId;
  String? eventName;
  String? eventDate;
  String? eventScheduledTime;
  String? locationAddress;
  int? teamId;
  String? teamName;
  String? teamImage;
  int? opponentTeamId;
  String? opponentTeamName;
  String? opponentTeamImage;

  OnGoingGameList(
      {this.id,
        this.matcheId,
        this.team1GameId,
        this.team2GameId,
        this.eventName,
        this.eventDate,
        this.eventScheduledTime,
        this.locationAddress,
        this.teamId,
        this.teamName,
        this.teamImage,
        this.opponentTeamId,
        this.opponentTeamName,
        this.opponentTeamImage});

  OnGoingGameList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    matcheId = json['MatcheId'];
    team1GameId = json['Team1GameId'];
    team2GameId = json['Team2GameId'];
    eventName = json['EventName'];
    eventDate = json['EventDate'];
    eventScheduledTime = json['EventScheduledTime'];
    locationAddress = json['LocationAddress'];
    teamId = json['TeamId'];
    teamName = json['TeamName'];
    teamImage = json['TeamImage'];
    opponentTeamId = json['OpponentTeamId'];
    opponentTeamName = json['OpponentTeamName'];
    opponentTeamImage = json['OpponentTeamImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['MatcheId'] = this.matcheId;
    data['Team1GameId'] = this.team1GameId;
    data['Team2GameId'] = this.team2GameId;
    data['EventName'] = this.eventName;
    data['EventDate'] = this.eventDate;
    data['EventScheduledTime'] = this.eventScheduledTime;
    data['LocationAddress'] = this.locationAddress;
    data['TeamId'] = this.teamId;
    data['TeamName'] = this.teamName;
    data['TeamImage'] = this.teamImage;
    data['OpponentTeamId'] = this.opponentTeamId;
    data['OpponentTeamName'] = this.opponentTeamName;
    data['OpponentTeamImage'] = this.opponentTeamImage;
    return data;
  }
}
