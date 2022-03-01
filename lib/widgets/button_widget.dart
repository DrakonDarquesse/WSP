import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const ButtonWidget({Key? key, required this.text, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        onPressed: callback,
        child: Text(text),
        padding: const EdgeInsets.all(20),
        color: blue(),
        textColor: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
    );
  }
}
