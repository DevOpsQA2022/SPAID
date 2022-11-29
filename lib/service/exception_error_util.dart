
import 'dart:io';

import 'package:spaid/model/response/base_response.dart';

class ExceptionErrorUtil {
  static BaseResponse handleErrors(dynamic error) {
    BaseResponse response = BaseResponse();
    try {
      if (error is FormatException) {
        response.status = 0;
        response.errorMessage = "Check your input Format";
      } else if (error is IOException) {
        response.status = 0;
        response.errorMessage = "Check your input Format";
      } else if (error is ArgumentError) {
        response.status = 0;
        response.errorMessage = "No data Found";
      }
    } catch (exception) {
      response.status = 0;
      response.errorMessage = "No data Found";
    }

    return response;
  }
}
