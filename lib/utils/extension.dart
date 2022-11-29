import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';


extension MediaQueryPercentage on num {
  double heightPercentage(BuildContext context) {
    return MediaQuery.of(context).size.height * (this);
  }

  double widthPercentage(BuildContext context) {
    return MediaQuery.of(context).size.width * (this);
  }
}


extension dynamicEndpoints on String {
  String withIds(dynamic ids) {
    String url = this;
    if (ids is String) {
      url = url.replaceAll("{}", ids);
    } else if (ids is List<String>) {
      for (int i = 0; i < ids.length; i++) {
        url = url.replaceFirst("{}", ids[i]);
      }
    }
    return url;
  }
}
extension dynamicStrings on String {
  String withStrings(dynamic ids) {
    String url = this;
    if (ids is String) {
      url = url.replaceAll("{}", ids);
    } else if (ids is List<String>) {
      for (int i = 0; i < ids.length; i++) {
        url = url.replaceFirst("{}", ids[i]);
      }
    }
    return url;
  }
}


extension dateConversion on String {
  String getDateConvert(){
    DateTime date = DateTime.parse(this);
    String dateString;
    var jiffy = Jiffy(date)..add(hours: 7);
    String spaceCheck = jiffy.format("d MMMM yyyy");
    if(spaceCheck[1] ==" "){
      dateString = "0"+jiffy.format("d MMMM yyyy");
    }else{
      dateString = jiffy.format("d MMMM yyyy");
    }
    return dateString;
  }
}
