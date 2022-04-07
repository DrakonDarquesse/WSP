import 'package:app/utils/adaptive.dart';
import 'package:app/network/auth.dart';
import 'package:app/utils/toggles.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/all.dart';
import 'package:app/utils/size.dart';
import 'package:app/utils/colours.dart';
import 'package:app/utils/validate.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _passwordVisible = false;

  void _passwordVisibilityChanged() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget pageTitle = TextWidget(
      text: [
        TextSpan(
          text: 'Login',
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
      alignment: TextAlign.center,
    );

    Widget loginBtn = ButtonWidget(
      text: 'Enter',
      callback: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          await login(_email, _password).then((val) {
            if (val == null) {
              Navigator.pushNamed(context, '/memberSchedule');
            } else {
              //toast
              print(val);
            }
          });
        }
      },
    );

    Widget emailForm = FormWidget(
      info: 'Email',
      validator: (String? value) {
        return checkEmpty(value) ?? validateEmail(value);
      },
      inputType: TextInputType.emailAddress,
      icon: Icons.email_outlined,
      save: (String? value) {
        _email = value!;
      },
    );

    Widget passwordForm = FormWidget(
      info: 'Password',
      validator: (String? value) {
        return checkEmpty(value);
      },
      inputType: TextInputType.text,
      obscureText: _passwordVisible,
      icon: Icons.lock,
      save: (String? value) {
        _password = value!;
      },
      uti: GestureDetector(
        onTap: () {
          _passwordVisibilityChanged();
        },
        child: toggleVisiblity(_passwordVisible),
      ),
    );

    Widget registerLink = TextWidget(
      text: [
        const TextSpan(
          text: 'No account? ',
        ),
        linkWidget('Register now', context, '/register'),
      ],
    );

    return Scaffold(
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                pageTitle,
                emailForm,
                passwordForm,
                loginBtn,
                registerLink,
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
