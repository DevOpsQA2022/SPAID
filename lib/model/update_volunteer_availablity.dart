class UpdateVolunteerAvailability {
  String? eventVoluenteerTypeIDNo;
  String? volunteerTypeId;
  String? volunteerTypeName;
  String? eventId;
  String? userId;
  String? availabilityStatusId;

  UpdateVolunteerAvailability(
      {this.eventVoluenteerTypeIDNo,
        this.volunteerTypeId,
        this.volunteerTypeName,
        this.eventId,
        this.userId,
        this.availabilityStatusId});

  UpdateVolunteerAvailability.fromJson(Map<String, dynamic> json) {
    eventVoluenteerTypeIDNo = json['EventVoluenteerTypeIDNo'];
    volunteerTypeId = json['VolunteerTypeId'];
    volunteerTypeName = json['VolunteerTypeName'];
    eventId = json['EventId'];
    userId = json['UserId'];
    availabilityStatusId = json['AvailabilityStatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventVoluenteerTypeIDNo'] = this.eventVoluenteerTypeIDNo;
    data['VolunteerTypeId'] = this.volunteerTypeId;
    data['VolunteerTypeName'] = this.volunteerTypeName;
    data['EventId'] = this.eventId;
    data['UserId'] = this.userId;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    print("UpdateVolunteerStatus"+ data.toString());
    return data;
  }
}
