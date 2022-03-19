import 'package:app/models/member.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/toggles.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:app/utils/size.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/validate.dart';
import 'package:app/network/auth.dart';

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
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;

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

  void _passwordVisibilityChanged() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _cpasswordVisibilityChanged() {
    setState(() {
      _cpasswordVisible = !_cpasswordVisible;
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
                  obscureText: _passwordVisible,
                  icon: Icons.lock,
                  save: (String? value) {
                    _password = value!;
                  },
                  helper: isMobile(context)
                      ? _mobilePasswordHelpText
                      : _desktopPasswordHelpText,
                  uti: GestureDetector(
                    onTap: () {
                      _passwordVisibilityChanged();
                    },
                    child: toggleVisiblity(_passwordVisible),
                  ),
                ),
                FormWidget(
                  info: 'Confirm Password',
                  validator: (String? value) {
                    return checkSameValue(_cpassword, _password);
                  },
                  inputType: TextInputType.text,
                  obscureText: _cpasswordVisible,
                  icon: Icons.lock,
                  callback: (val) => _cpasswordChanged(val),
                  uti: GestureDetector(
                    onTap: () {
                      _cpasswordVisibilityChanged();
                    },
                    child: toggleVisiblity(_cpasswordVisible),
                  ),
                ),
                ButtonWidget(
                  text: 'Enter',
                  callback: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await register(_email, _password, _username).then((val) {
                        if (val == null) {
                          Navigator.pushNamed(context, '/home');
                        } else {
                          //toast
                        }
                      });
                    }
                  },
                ),
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
