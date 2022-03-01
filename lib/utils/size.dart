import 'package:flutter/material.dart';

Size dimension(BuildContext context) {
  debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(Size size) {
  debugPrint('Height = ' + size.height.toString());
  return size.height;
}

double displayWidth(Size size) {
  debugPrint('Width = ' + size.width.toString());
  return size.width;
}

double percentWidth(BuildContext context, double percent) {
  return displayWidth(dimension(context)) * percent;
}

double percentHeight(BuildContext context, double percent) {
  return displayHeight(dimension(context)) * percent;
}
