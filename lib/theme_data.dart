import 'package:flutter/material.dart';

ThemeData themeData({required ThemeMode themeMode}){
  if(themeMode == ThemeMode.light){
    return ThemeData(
      primaryColor: const Color.fromARGB(255, 247, 243, 247),
      primaryColorLight: const Color.fromARGB(255, 242, 147, 1),
      primaryColorDark: Colors.white,
      cardColor: const Color.fromARGB(255, 213, 217, 228),
      shadowColor: Colors.black,
      focusColor: const Color.fromARGB(255, 242, 147, 1),
      // sun
      dividerColor: Colors.grey, // moon
    );
  }else{
    return
    ThemeData(
      primaryColor: const Color(0xFF283345),
      primaryColorLight: const Color.fromARGB(255, 242, 147, 1),
      primaryColorDark: const Color.fromARGB(100, 83, 90, 108),
      cardColor: const Color.fromARGB(255, 28, 36, 55),
      shadowColor: Colors.white,
      focusColor: Colors.grey,
      // sun
      dividerColor: const Color.fromARGB(255, 242, 147, 1), // moon
    );
  }
}