import 'package:app/provider.dart';
import 'package:app/utils/adaptive.dart';
import 'package:app/utils/toggles.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:app/utils/size.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/validate.dart';
import 'package:app/network/auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends ConsumerStatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
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
    Widget emailForm = FormWidget(
      info: 'Email',
      validator: (String? value) {
        return Validator.checkEmpty(value) ?? Validator.validateEmail(value);
      },
      inputType: TextInputType.emailAddress,
      icon: Icons.email_outlined,
      save: (String? value) {
        _email = value!;
      },
    );

    Widget nameForm = FormWidget(
      info: 'Name',
      validator: (String? value) {
        return Validator.checkEmpty(value);
      },
      inputType: TextInputType.name,
      icon: Icons.account_box_rounded,
      save: (String? value) {
        _username = value!;
      },
    );

    Widget passwordForm = FormWidget(
      info: 'Password',
      validator: (String? value) {
        return isMobile(context)
            ? Validator.validatePasswordStrengthMobile(value)
            : Validator.validatePasswordStrengthDesktop(value);
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
    );

    Widget confirmForm = FormWidget(
      info: 'Confirm Password',
      validator: (String? value) {
        return Validator.checkSameValue(_cpassword, _password);
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
    );

    Widget btnForm = ButtonWidget(
      text: 'Enter',
      callback: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          await register(_email, _password, _username).then((val) {
            print(val);
            if (val != '') {
              Navigator.pushNamed(context, '/memberSchedule');
            } else {
              Fluttertoast.showToast(
                msg: 'Account already exists',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: red(),
                webBgColor: '#888',
                webPosition: 'center',
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        }
      },
    );

    if (ref.watch(sessionProvider) == null) {
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
                  nameForm,
                  emailForm,
                  passwordForm,
                  confirmForm,
                  btnForm,
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
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          ),
        ),
        backgroundColor: lightBlue(),
      );
    }
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed("/memberSchedule");
    });

    return const Scaffold();
  }
}
