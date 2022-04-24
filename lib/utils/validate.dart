import 'package:app/models/role.dart';

String? checkEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field can\'t be blank';
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePasswordStrengthMobile(String? password) {
  if (passwordLogic(password)) {
    return null;
  }
  return "Your password must contain:\n- At least 6 characters\n- Number\n- Uppercase\n- Lowercase";
}

String? validatePasswordStrengthDesktop(String? password) {
  if (passwordLogic(password)) {
    return null;
  }
  return "Your password must contain: at least 6 characters, number, uppercase and lowercase";
}

bool passwordLogic(String? password) {
  bool containUpperCase = password!.contains(RegExp(r'[A-Z]'));
  bool containLowerCase = password.contains(RegExp(r'[0-9]'));
  bool containNumber = password.contains(RegExp(r'[0-9]'));
  bool lengthMoreThanSix = password.length >= 6;
  return (containUpperCase &&
      containNumber &&
      containLowerCase &&
      lengthMoreThanSix);
}

String? checkSameValue(String? value, String? value2) {
  if (value != value2) {
    return 'Passwords must be same';
  }
  return null;
}

String? checkDuplicate(List<Role> roleList, String name) {
  if (roleList.every((r) => r.name == name)) {
    return 'Already have this role, please use another name';
  }
  return null;
}
