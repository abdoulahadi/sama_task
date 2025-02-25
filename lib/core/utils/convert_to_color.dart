import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  if (hex.startsWith("Color(")) {
    final int startIndex = hex.indexOf("0x");
    final int endIndex = hex.indexOf(")", startIndex);
    final String colorValueStr = hex.substring(startIndex, endIndex);
    return Color(int.parse(colorValueStr));
  } else {
    String formattedHex = hex.replaceAll('#', '');
    if (formattedHex.length == 6) {
      formattedHex = 'FF$formattedHex';
    }
    return Color(int.parse(formattedHex, radix: 16));
  }
}
