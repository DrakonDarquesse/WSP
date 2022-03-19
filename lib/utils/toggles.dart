import 'package:flutter/material.dart';

MouseRegion toggleVisiblity(bool visible) {
  return MouseRegion(
    child: Icon(visible ? Icons.visibility_off : Icons.visibility),
    cursor: SystemMouseCursors.click,
  );
}
