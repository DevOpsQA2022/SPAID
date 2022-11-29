class GetAllDrillPlanRequest {
  int? iDNo;

  GetAllDrillPlanRequest({this.iDNo});

  GetAllDrillPlanRequest.fromJson(Map<String, dynamic> json) {
    iDNo = json['TeamId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamId'] = this.iDNo;
    print(data.toString());
    return data;
  }
}