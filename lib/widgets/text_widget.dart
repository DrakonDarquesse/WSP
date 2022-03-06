import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final List<InlineSpan> text;
  final TextAlign alignment;
  final bool compact;
  const TextWidget(
      {Key? key,
      required this.text,
      this.alignment = TextAlign.start,
      this.compact = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            height: 1.5,
            fontSize: 16,
          ),
          children: text,
        ),
        textAlign: alignment,
      ),
      padding: compact
          ? const EdgeInsets.symmetric(vertical: 4)
          : const EdgeInsets.all(16),
    );
  }
}
