import 'package:app/models/member.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/functions/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:app/utils/size.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/validate.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _mobilePasswordHelpText =
      "Your password must contain:\n- At least 6 characters\n- Number\n- Uppercase\n- Lowercase";
  final _desktopPasswordHelpText =
      "Your password must contain: at least 6 characters, number, uppercase and lowercase";
  String _email = '';
  String _username = '';
  String _password = '';
  String _cpassword = '';

  void _passwordChanged(String password) {
    setState(() {
      _password = password;
    });
  }

  void _cpasswordChanged(String cpassword) {
    setState(() {
      _cpassword = cpassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextWidget(
                  text: [
                    TextSpan(
                      text: 'Register',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                  alignment: TextAlign.center,
                ),
                FormWidget(
                  info: 'Name',
                  validator: (String? value) {
                    return checkEmpty(value);
                  },
                  inputType: TextInputType.name,
                  icon: Icons.account_box_rounded,
                  save: (String? value) {
                    _username = value!;
                  },
                ),
                FormWidget(
                  info: 'Email',
                  validator: (String? value) {
                    return checkEmpty(value) ?? validateEmail(value);
                  },
                  inputType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  save: (String? value) {
                    _email = value!;
                  },
                ),
                FormWidget(
                  info: 'Password',
                  validator: (String? value) {
                    return isMobile(context)
                        ? validatePasswordStrengthMobile(value)
                        : validatePasswordStrengthDesktop(value);
                  },
                  callback: (val) => _passwordChanged(val),
                  inputType: TextInputType.text,
                  obscureText: true,
                  icon: Icons.lock,
                  save: (String? value) {
                    _password = value!;
                  },
                  helper: isMobile(context)
                      ? _mobilePasswordHelpText
                      : _desktopPasswordHelpText,
                ),
                FormWidget(
                  info: 'Confirm Password',
                  validator: (String? value) {
                    return checkSameValue(_cpassword, _password);
                  },
                  inputType: TextInputType.text,
                  obscureText: true,
                  icon: Icons.lock,
                  callback: (val) => _cpasswordChanged(val),
                ),
                ButtonWidget(
                    text: 'Enter',
                    callback: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Member user = Member(
                            email: _email,
                            password: _password,
                            name: _username);
                        register(user);
                        checkSignedIn().then((isSignedIn) {
                          if (isSignedIn) {
                            Navigator.pushNamed(context, '/home');
                          }
                        });
                      }
                    }),
                TextWidget(
                  text: [
                    const TextSpan(
                      text: 'Have an account? ',
                    ),
                    linkWidget('Login now', context, '/login'),
                  ],
                )
              ],
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
          color: Colors.white,
          width: isMobile(context)
              ? percentWidth(context, 0.8)
              : percentWidth(context, 0.4),
          padding: const EdgeInsets.all(30),
        ),
      ),
      backgroundColor: lightBlue(),
    );
  }
}
