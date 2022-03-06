import 'package:app/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Icon ToggleVisiblity(bool visible) {
  if (visible) {
    return const Icon(Icons.visibility_off);
  }
  return const Icon(Icons.visibility);
}

ButtonWidget ToggleEditability(bool editable) {
  if (editable) {
    return ButtonWidget(
      text: 'Edit',
      icon: Icons.edit,
      callback: () {},
    );
  }
  return ButtonWidget(
    text: 'Save',
    icon: Icons.save,
    callback: () {},
  );
}
