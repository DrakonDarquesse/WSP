import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app/utils/colours.dart';

TextSpan linkWidget(String text, BuildContext context, String route) {
  return TextSpan(
    text: text,
    style: TextStyle(color: blue()),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        Navigator.pushNamed(context, route);
      },
  );
}
