import 'package:flutter/material.dart';

Size dimension(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(Size size) {
  return size.height;
}

double displayWidth(Size size) {
  return size.width;
}

double percentWidth(BuildContext context, double percent) {
  return displayWidth(dimension(context)) * percent;
}

double percentHeight(BuildContext context, double percent) {
  return displayHeight(dimension(context)) * percent;
}
