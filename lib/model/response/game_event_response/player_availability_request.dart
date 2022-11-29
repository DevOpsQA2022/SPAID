class UpdatePlayerAvailability {
  int? referenceTableId;
  int? userId;
  int? availabilityStatusId;
  int? notificationTypeId;
  String? notes;
  int? isDeleted;

  UpdatePlayerAvailability(
      {this.referenceTableId,
        this.userId,
        this.availabilityStatusId,
        this.notificationTypeId,
        this.notes,
        this.isDeleted});

  UpdatePlayerAvailability.fromJson(Map<String, dynamic> json) {
    referenceTableId = json['ReferenceTableId'];
    userId = json['UserId'];
    availabilityStatusId = json['AvailabilityStatusId'];
    notificationTypeId = json['NotificationTypeId'];
    notes = json['Notes'];
    isDeleted = json['IsDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReferenceTableId'] = this.referenceTableId;
    data['UserId'] = this.userId;
    data['AvailabilityStatusId'] = this.availabilityStatusId;
    data['NotificationTypeId'] = this.notificationTypeId;
    data['Notes'] = this.notes;
    data['IsDeleted'] = this.isDeleted;
    return data;
  }
}
