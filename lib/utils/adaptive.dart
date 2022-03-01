import 'package:app/utils/size.dart';
import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  return dimension(context).width < 800;
}
