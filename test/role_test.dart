// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/utils/validate.dart';

void main() {
  test('validate password', () async {
    expect(
        Validator.validatePasswordStrengthDesktop('Strong password 1'), null);
  });
  test('validate password error', () async {
    expect(Validator.validatePasswordStrengthDesktop('weak password'),
        'Your password must contain: at least 6 characters, number, uppercase and lowercase');
  });

  test('validate confirm password', () async {
    expect(Validator.checkSameValue('password', 'password'), null);
  });

  test('validate empty', () async {
    expect(Validator.checkEmpty(''), 'This field can\'t be blank');
  });

  test('validate email error', () async {
    expect(Validator.validateEmail('email'), 'Enter a valid email address');
  });

  test('validate email', () async {
    expect(Validator.validateEmail('email@gmail.com'), null);
  });
}
