//convert 0x?????? to #?????? to Color
import 'package:flutter/material.dart';
import 'package:instantgram/extensions/string/remove_all.dart';

extension AsHtmlColorToColor on String{
  Color htmlColorToColor() => Color(
    int.parse(
      removeAll(['0x', '#']).padLeft(8, 'ff'),  //This removes those characters from a string while also adding 'ff' to any string that is not up to 8 characters
      radix: 16,
    ),
  );
}