import 'package:app/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

MouseRegion toggleVisiblity(bool visible) {
  return MouseRegion(
    child: Icon(visible ? Icons.visibility_off : Icons.visibility),
    cursor: SystemMouseCursors.click,
  );
}

ButtonWidget toggleEditability(bool editable) {
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
