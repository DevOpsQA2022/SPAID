class RabbitMQMessage {
  String? team1;
  String? team2;

  RabbitMQMessage({this.team1, this.team2});

  RabbitMQMessage.fromJson(Map<dynamic, dynamic> json) {
    team1 = json['team1'];
    team2 = json['team2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team1'] = this.team1;
    data['team2'] = this.team2;
    return data;
  }
}
