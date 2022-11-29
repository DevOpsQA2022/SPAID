class UpdateVolunteerRequest {
  int? volunteerTypeId;
  String? volunteerTypeName;

  UpdateVolunteerRequest({this.volunteerTypeId, this.volunteerTypeName});

  UpdateVolunteerRequest.fromJson(Map<String, dynamic> json) {
    volunteerTypeId = json['VolunteerTypeId'];
    volunteerTypeName = json['VolunteerTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VolunteerTypeId'] = this.volunteerTypeId;
    data['VolunteerTypeName'] = this.volunteerTypeName;
    print("VolunteerJob"+data.toString());
    return data;
  }
}
