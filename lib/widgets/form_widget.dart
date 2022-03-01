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

  const FormWidget(
      {Key? key,
      required this.info,
      this.validator,
      this.save,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.callback,
      this.icon,
      this.helper})
      : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  String _data = '';
  final _textController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _channgeForm() {
    setState(() {
      _data = _textController.text;
    });
    if (widget.callback != null) {
      widget.callback!(_data);
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
    _textController.addListener(_channgeForm);
    _textController.text = _data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            key: _formKey,
            decoration: InputDecoration(
              hintText: 'Enter ${widget.info}',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(widget.icon),
              label: Text(
                widget.info,
              ),
              helperText: widget.helper ?? '',
              helperMaxLines: isMobile(context) ? 5 : 3,
              helperStyle: isMobile(context)
                  ? const TextStyle(fontSize: 12)
                  : const TextStyle(fontSize: 14),
              errorMaxLines: isMobile(context) ? 5 : 3,
              errorStyle: isMobile(context)
                  ? const TextStyle(fontSize: 12)
                  : const TextStyle(fontSize: 14),
              suffixIcon: Icon(widget.icon),
            ),
            controller: _textController,
            validator: widget.validator,
            onSaved: widget.save,
            keyboardType: widget.inputType,
            obscureText: widget.obscureText,
            textAlignVertical: TextAlignVertical.bottom,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }
}
