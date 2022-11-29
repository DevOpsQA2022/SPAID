class DynamicLinkRequest {
  DynamicLinkInfo? dynamicLinkInfo;

  DynamicLinkRequest({this.dynamicLinkInfo});

  DynamicLinkRequest.fromJson(Map<String, dynamic> json) {
    dynamicLinkInfo = json['dynamicLinkInfo'] != null
        ? new DynamicLinkInfo.fromJson(json['dynamicLinkInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dynamicLinkInfo != null) {
      data['dynamicLinkInfo'] = this.dynamicLinkInfo!.toJson();
    }
    return data;
  }
}

class DynamicLinkInfo {
  String? domainUriPrefix;
  String? link;
  AndroidInfo? androidInfo;
  IosInfo? iosInfo;

  DynamicLinkInfo(
      {this.domainUriPrefix, this.link, this.androidInfo, this.iosInfo});

  DynamicLinkInfo.fromJson(Map<String, dynamic> json) {
    domainUriPrefix = json['domainUriPrefix'];
    link = json['link'];
    androidInfo = json['androidInfo'] != null
        ? new AndroidInfo.fromJson(json['androidInfo'])
        : null;
    iosInfo =
    json['iosInfo'] != null ? new IosInfo.fromJson(json['iosInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domainUriPrefix'] = this.domainUriPrefix;
    data['link'] = this.link;
    if (this.androidInfo != null) {
      data['androidInfo'] = this.androidInfo!.toJson();
    }
    if (this.iosInfo != null) {
      data['iosInfo'] = this.iosInfo!.toJson();
    }
    return data;
  }
}

class AndroidInfo {
  String? androidPackageName;

  AndroidInfo({this.androidPackageName});

  AndroidInfo.fromJson(Map<String, dynamic> json) {
    androidPackageName = json['androidPackageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['androidPackageName'] = this.androidPackageName;
    return data;
  }
}

class IosInfo {
  String? iosBundleId;

  IosInfo({this.iosBundleId});

  IosInfo.fromJson(Map<String, dynamic> json) {
    iosBundleId = json['iosBundleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iosBundleId'] = this.iosBundleId;
    return data;
  }
}
