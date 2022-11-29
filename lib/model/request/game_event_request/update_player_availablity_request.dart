class UpdatePlayerSelectionRequest {
  String? eventId;
  List<String>? userId;

  UpdatePlayerSelectionRequest({this.eventId, this.userId});

  UpdatePlayerSelectionRequest.fromJson(Map<String, dynamic> json) {
    eventId = json['EventId'];
    userId = json['UserId'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventId'] = this.eventId;
    data['UserId'] = this.userId;
    print("Update availability"+data.toString());
    return data;
  }
}
