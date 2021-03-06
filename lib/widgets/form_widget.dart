import 'package:app/utils/adaptive.dart';
import 'package:flutter/material.dart';

class FormWidget extends StatefulWidget {
  final String info;
  final String? Function(String?)? validator;
  final void Function(String?)? save;
  final TextInputType inputType;
  final bool obscureText;
  final IconData? icon;
  final String? helper;
  final void Function(String)? callback;
  final String? initialValue;
  final GestureDetector? uti;
  final bool readOnly;

  const FormWidget(
      {Key? key,
      required this.info,
      this.validator,
      this.save,
      this.inputType = TextInputType.text,
      this.obscureText = true,
      this.callback,
      this.icon,
      this.helper,
      this.initialValue,
      this.uti,
      this.readOnly = false})
      : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _textController = TextEditingController();

  void _changeForm() {
    if (widget.callback != null) {
      widget.callback!(_textController.text);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _textController.addListener(_changeForm);
    _textController.text = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = InputDecoration(
      hintText: 'Enter ${widget.info}',
      border: const OutlineInputBorder(),
      prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
      label: Text(
        widget.info,
      ),
      helperText: widget.helper ?? '',
      helperMaxLines: isMobile(context) ? 5 : 3,
      errorMaxLines: isMobile(context) ? 5 : 3,
      suffixIcon: widget.uti,
    );

    TextFormField form = TextFormField(
        controller: _textController,
        validator: widget.validator,
        onSaved: widget.save,
        keyboardType: widget.inputType,
        obscureText: !widget.obscureText,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: inputDecoration,
        readOnly: widget.readOnly);

    return Container(
      child: form,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
    );
  }
}
