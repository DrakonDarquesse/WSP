import 'package:flutter/material.dart';
import 'package:app/utils/colours.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final IconData? icon;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.callback,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        onPressed: callback,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white),
            children: icon != null
                ? [
                    WidgetSpan(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 16,
                      ),
                    )),
                    TextSpan(text: text)
                  ]
                : [TextSpan(text: text)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        color: blue(),
        minWidth: 0,
      ),
      padding: const EdgeInsets.all(16),
    );
  }
}
