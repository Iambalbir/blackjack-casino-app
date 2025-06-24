/*===============================Field Checker=================================================*/
import '../../../export_file.dart';

class FieldChecker {
  static String? fieldChecker(String? value, message) {
    if (value == null || value.toString().trim().isEmpty) {
      return "$message cannot be empty";
    }

    return null;
  }

  static String? entryFeeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Entry fee cannot be empty";
    }

    final fee = double.tryParse(value);
    if (fee == null) {
      return "Entry fee must be a valid number";
    }

    if (fee < 20) {
      return "Entry fee must be at least 20";
    }

    if (fee > 20000) {
      return "Entry fee must not exceed 20,000";
    }

    // Check if the fee is an odd number
    if (fee % 2 != 0) {
      return "Entry fee must be an even number";
    }

    return null;
  }

  static String? validateMaxLengthChecker(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return "$message cannot be empty";
    }

    final number = int.tryParse(value.trim());
    if (number != null && number > 5) {
      return "$message cannot be greater than 5";
    }

    return null;
  }

  static String? dobChecker(
    String? value,
    String message,
    DateTime dob, {
    FocusNode? focusNode,
  }) {
    if (value == null || value.toString().trim().isEmpty) {
      if (focusNode != null) {
        focusNode.unfocus();
        focusNode.requestFocus();
      }
      return "$message cannot be empty!";
    } else if (dob
        .isAfter(DateTime.now().subtract(const Duration(days: 365 * 15)))) {
      return "Please enter a date atleast before 15 years ago!";
    }

    return null;
  }
}

class Validator {
  static String? validateEmail(String value) {
    // Basic email regex pattern
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value.isEmpty) {
      return stringEmailNotEmpty;
    } else if (!emailRegex.hasMatch(value.trim())) {
      return strInvalidEmail;
    } else if (value.contains(" ")) {
      return strInvalidEmail;
    }
    return null;
  }

  static String? fieldCheck({required String value, required message}) {
    if (value.toString().trim().isEmpty) {
      return "$message cannot be empty";
    }
    return null;
  }

  static String? firstName(String value) {
    if (value.isEmpty) {
      return strFirstNameIsNotEmpty;
    } else if (value == '') {
      return strFirstNameIsNotEmpty;
    }
    return null;
  }

  static String? cardName(String value) {
    if (value.isEmpty) {
      return strFirstNameIsNotEmpty;
    } else if (value == '') {
      return strFirstNameIsNotEmpty;
    }
    return null;
  }

  static String? lastName(String value) {
    if (value.isEmpty) {
      return strLastNameIsNotEmpty;
    } else if (value == '') {
      return strLastNameIsNotEmpty;
    }
    return null;
  }

  static String? address(String value, String title) {
    if (value.isEmpty) {
      return strAddressIsNotEmpty;
    } else if (value == '') {
      return strAddressIsNotEmpty;
    }
    return null;
  }

  static String? validateFields(String value, String title) {
    if (value == '') {
      return "$title can't be empty!";
    }
    return null;
  }

  static String? validateMinAmount(String value, String title) {
    if (value == '') {
      return "$title can't be empty!";
    } else if (value[0] == '0') {
      return 'Enter valid number';
    }
    return null;
  }

  static String? validateMaxAmount(
      String value, String title, String minAmount) {
    try {
      int valueInt = int.parse(value);
      int minAmountInt = int.parse(minAmount);

      if (valueInt <= minAmountInt) {
        return '$title can not be less than min amount';
      } else if (value[0] == '0') {
        return 'Enter valid number';
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static String? validateQualifications(String value, String title) {
    if (value.isEmpty) {
      return "$title can't be empty!";
    } else if (value == '') {
      return "$title can't be empty!";
    } else if (value == " ") {
      return "Please enter valid details.";
    }
    return null;
  }

  static String? password(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return strPasswordEmpty;
    } else if (value == '') {
      return strPasswordEmpty;
    } else if (value.length < 8) {
      return strPasswordMustRequire;
    } else if (!regex.hasMatch(value)) {
      return strPasswordValidate;
    }
    return null;
  }

  static String? validateConfirmPasswordMatch({value, String? password}) {
    if (value!.isEmpty) {
      return strCPasswordEmpty;
    } else if (value != password) {
      return strPasswordMatc;
    }
    return null;
  }

  static bool validateStrongPassword(value) {
    var pattern =
        "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@\$%^&*-]).{8,}\$";
    RegExp regex = RegExp(pattern);
    return (regex.hasMatch(value)) ? false : true;
  }

  static String? cPassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return strCPasswordEmpty;
    } else if (value == '') {
      return strCPasswordEmpty;
    } else if (value.length < 8) {
      return strPasswordMustRequire;
    } else if (!regex.hasMatch(value)) {
      return strPasswordValidate;
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return strPasswordEmpty;
    } else if (value == '') {
      return strPasswordEmpty;
    }
    return null;
  }

  static String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return strCPasswordEmpty;
    } else if (value == '') {
      return strCPasswordEmpty;
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return strPhoneEmEmpty;
    } else if (value == '') {
      return strPhoneEmEmpty;
    } else if (value.length < 5) {
      return strEnterValidMobileNumber;
    }
    return null;
  }

  static String? validatePhoneNumbers(String value) {
    if (value.isEmpty) {
      return strPhoneEmEmpty;
    } else if (value[0] == '0') {
      return strEnterValidMobileNumber;
    } else if (value == '') {
      return strPhoneEmEmpty;
    } else if (value.length < 5) {
      return strEnterValidMobileNumber;
    }
    return null;
  }

  static bool validateNumber(String value) {
    var pattern = r'^[0-9]+$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}
