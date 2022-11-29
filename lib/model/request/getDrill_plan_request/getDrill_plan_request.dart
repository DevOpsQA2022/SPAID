class GetDrillPlanRequest {
  String? iDNo;

  GetDrillPlanRequest({this.iDNo});

  GetDrillPlanRequest.fromJson(Map<String, dynamic> json) {
    iDNo = json['IDNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDNo'] = this.iDNo;
    return data;
  }
}