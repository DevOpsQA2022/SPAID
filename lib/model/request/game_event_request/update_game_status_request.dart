class UpdateGameStatusRequest {
  int? eventId;
  int? userId;
  int? status;
  bool? IsAllOccurence;

  UpdateGameStatusRequest({this.eventId, this.userId, this.status});

  UpdateGameStatusRequest.fromJson(Map<String, dynamic> json) {
    eventId = json['EventId'];
    userId = json['UserId'];
    status = json['Status'];
    IsAllOccurence = json['IsAllOccurence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventId'] = this.eventId;
    data['UserId'] = this.userId;
    data['Status'] = this.status;
    data['IsAllOccurence'] = this.IsAllOccurence;
    print("Event Cancel"+data.toString());
    return data;
  }
}
