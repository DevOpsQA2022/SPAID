import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spaid/support/constants.dart';

class ValidateInput {
  static String? validateName(String? value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  // static String validatePassword(String value) {
  //   String pattern =
  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$';
  //   RegExp regExp = new RegExp(pattern);
  //   if (value.length == 0) {
  //     return "Password is Required";
  //   } else if (value.length != 0 && value.length <= 6) {
  //     return "Password must be in the following format: \nMinimum Length: 7\nMinimum Numeric Characters: 1\nMinimum Uppercase Characters: 1\nMinimum Lowercase Characters: 1\nMinimum Special Characters: 1";
  //   } else if (!regExp.hasMatch(value)) {
  //     // return "Strong Password is Required";
  //     return "Password must be in the following format: \nMinimum Length: 7\nMinimum Numeric Characters: 1\nMinimum Uppercase Characters: 1\nMinimum Lowercase Characters: 1\nMinimum Special Characters: 1";
  //   }
  //   return null;
  // }

  static String? validatePassword(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$';
    RegExp regExp = new RegExp(pattern);
    RegExp regExpUppercase = new RegExp('(?=.*?[A-Z])');
    RegExp regExpLowercase = new RegExp('(?=.*?[a-z])');
    RegExp regExpNumber = new RegExp('(?=.*?[0-9])');
    RegExp regExpSpecial = new RegExp(r'(?=.*?[!@#\$&*~])');
    String errorMessage="";
    if (value!.length == 0) {
      return "Password is Required";
    }else if (!regExp.hasMatch(value)){
      if (value.length != 0 && value.length <= 6) {
        errorMessage=errorMessage+ "Minimum Length: 7\n";
    }
     if (!regExpUppercase.hasMatch(value)) {
       errorMessage=errorMessage+"Minimum Uppercase Characters: 1\n";
    }
      if (!regExpLowercase.hasMatch(value)) {
        errorMessage=errorMessage+"Minimum Lowercase Characters: 1\n";
      }
      if (!regExpNumber.hasMatch(value)) {
        errorMessage=errorMessage+"Minimum Numeric Characters: 1\n";
      }
      if (!regExpSpecial.hasMatch(value)) {
        errorMessage=errorMessage+"Minimum Special Characters: 1";
      }
      return errorMessage;
  }
    return null;
  }

  static String? validateSignupPassword(String? value) {
    // Pattern pattern = r'^(?=.*[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    String pattern = r'^[a-zA-Z]\w{5,15}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value!.trim().isEmpty) {
      return 'Enter password';
    } else if (value.length != 0 && value.length <= 7) {
      return "Password contains minimum 8 characters";
    } else if (!regex.hasMatch(value)) {
      return null;
    }
  }

  static String? validateMobile(String? value) {
    String pattern =
        r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Mobile Number';
    }
    else if (value.length < 10) {
      return 'Enter Valid Mobile Number';
    }
    return null;
  }

  static String? validateEmailMobile(String? value) {
    String patttern =
        r'(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})|([0-9]{10})+$/)';
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    RegExp regExp = new RegExp(patttern);
    if (value!.trim().isEmpty) {
      return 'Enter Email Or Mobilenumber';
    } else if (!regex.hasMatch(value)) {
      return 'Enter Email Or Mobilenumber';
    }
    return null;
  }

  static String? validateEmailMobiles(String? value) {
    bool isEmail(String input) => RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(input);
    bool isPhone(String input) => RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(input);

    if (!isEmail(value!) && !isPhone(value)) {
      return 'Enter a valid Email or Phone Number.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value!.trim().isEmpty)
      return 'Enter Email';
    else if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static String? verifyFields(valueOne, String? valueTwo) {
    if (valueOne.length == 0)
      return "Confirm Password is Required";
    else if(valueOne.toString()==valueTwo)
      return null;
    else
      return 'Password and Confirm Password does not match';
  }

  static String? requiredFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Required';
  }

  static String? requiredDrillPlanFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Required Plan Name';
  }
  static String? requiredStartDateFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Start Date';
  }
  static String? requiredEndDateFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'End Date';
  }
  static String? requiredGameFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter Game Name';
  }
  static String? requiredEventFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter Event Name';
  }
  static String? requiredAddressFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter address';
  }
  static String? requiredLocationFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter address';
  }
  static String? requiredTeamFields(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Team Name is required';
  }
  static String? requiredFieldPassword(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter Password';
  }

  static String? requiredFieldsFirstName(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter First Name';
  }

  static String? requiredFieldsLastName(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter Last Name';
  }
  static String? requiredFieldsNoteName(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter Notes';
  }
static String? requiredDrillCategory(String? value) {
    if (Constants.teamDrillCategoryId.isEmpty)
      return null;
    else
      return 'Required';
}
  static String? requiredFieldsTitle(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter Title';
  }
  static String? requiredFieldsDescription(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Enter Description';
  }
  static String? requiredFieldsFile(String? value) {
    if (value!.trim().isNotEmpty)
      return null;
    else
      return 'Select File Path';
  }

  static String? requiredFieldsDate(DateTime? start, DateTime? end, DateTime? dateTime) {
    if (start!.compareTo(dateTime!)>=0 && end!.compareTo(dateTime)>=0) {
      return null;
    } else {
      return 'Select the current or upcoming date.';
    }
  }

  static String? verifyDOB(String? value) {
    try {
      String datePattern = "dd/MM/yyyy";

      // Current time - at this moment
      DateTime today = DateTime.now();

      // Parsed date to check
      DateTime birthDate = DateFormat(datePattern).parse(value!);
      // Date to check but moved 5 years ahead
      DateTime adultDate = DateTime(
            birthDate.year + 1,
            birthDate.month,
            birthDate.day,
          );
      //adultDate.isBefore(today);
      if (value.isNotEmpty) {
            if (adultDate.isBefore(today)) {
              return null;
            } else {
              return 'You must be 1 or older to enter!';
            }
          } else {
            return 'Select Date Of Birth';
          }
    } catch (e) {
      return 'Select Date Of Birth';
    }
  }
}

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class DateFormatters extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
