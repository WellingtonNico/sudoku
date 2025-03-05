import 'package:flutter/material.dart';

Color convertHexStringToColor(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) {
    hex = "FF$hex";
  }
  if (hex.length == 8) {
    return Color(int.parse("0x$hex"));
  }
  return Colors.black;
}
