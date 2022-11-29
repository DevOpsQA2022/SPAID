class ScoreDetailsResponse {
  String? id;
  int? responseResult;
  String? responseMessage;
  Result? result;

  ScoreDetailsResponse(
      {this.id,
        this.responseResult,
        this.responseMessage,
        this.result,
      });

  ScoreDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  int? matcheId;
  List<ScoreList>? scoreList;

  Result({this.id, this.matcheId, this.scoreList});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    matcheId = json['MatcheId'];
    if (json['ScoreList'] != null) {
      scoreList = <ScoreList>[];
      json['ScoreList'].forEach((v) {
        scoreList!.add(new ScoreList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['MatcheId'] = this.matcheId;
    if (this.scoreList != null) {
      data['ScoreList'] = this.scoreList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScoreList {
  String? id;
  int? scoreCardId;
  int? matchId;
  int? teamId;
  int? team1GameId;
  int? team2GameId;
  int? playerId;
  String? playerName;
  String? jerseyNumber;
  int? scoreTypeId;
  // int assitPlayer1;
  // int assistPlayer2;
  int? penaltyTypeId;
  int? penaltyCallId;
  String? period;
  String? time;
  bool? isUpdated;
  String? penaltyStartTime;
  String? penaltyEndTime;
  String? penaltyServedBy;

  ScoreList(
      {this.id,
        this.scoreCardId,
        this.matchId,
        this.teamId,
        this.team1GameId,
        this.team2GameId,
        this.playerId,
        this.playerName,
        this.jerseyNumber,
        this.scoreTypeId,
        // this.assitPlayer1,
        // this.assistPlayer2,
        this.penaltyTypeId,
        this.penaltyCallId,
        this.period,
        this.time,
        this.penaltyStartTime,
        this.penaltyEndTime,
        this.penaltyServedBy,
        this.isUpdated});

  ScoreList.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    scoreCardId = json['ScoreCardId'];
    matchId = json['MatchId'];
    teamId = json['TeamId'];
    team1GameId = json['Team1GameId'];
    team2GameId = json['Team2GameId'];
    playerId = json['UserId'];
    // playerId = json['PlayerId'];
    playerName = json['PlayerName'];
    jerseyNumber = json['JerseyNumber'];
    scoreTypeId = json['ScoreTypeId'];
    // assitPlayer1 = json['AssitPlayer1'];
    // assistPlayer2 = json['AssistPlayer2'];
    penaltyTypeId = json['PenaltyTypeId'];
    penaltyCallId = json['PenaltyCallId'];
    period = json['Period'];
    time = json['Time'];
    penaltyStartTime = json['PenaltyStartTime'];
    penaltyEndTime = json['PenaltyEndTime'];
    penaltyServedBy = json['PenaltyServedBy'];
    isUpdated = json['IsUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ScoreCardId'] = this.scoreCardId;
    data['MatchId'] = this.matchId;
    data['TeamId'] = this.teamId;
    data['Team1GameId'] = this.team1GameId;
    data['Team2GameId'] = this.team2GameId;
    data['PlayerId'] = this.playerId;
    data['PlayerName'] = this.playerName;
    data['JerseyNumber'] = this.jerseyNumber;
    data['ScoreTypeId'] = this.scoreTypeId;
    // data['AssitPlayer1'] = this.assitPlayer1;
    // data['AssistPlayer2'] = this.assistPlayer2;
    data['PenaltyTypeId'] = this.penaltyTypeId;
    data['PenaltyCallId'] = this.penaltyCallId;
    data['Period'] = this.period;
    data['Time'] = this.time;
    data['PenaltyStartTime'] = this.penaltyStartTime;
    data['PenaltyEndTime'] = this.penaltyEndTime;
    data['PenaltyServedBy'] = this.penaltyServedBy;
    data['IsUpdated'] = this.isUpdated;
    return data;
  }
}
