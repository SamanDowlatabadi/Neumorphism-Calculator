import 'package:flutter/material.dart';

AppBar myAppBar({
  required BuildContext context,
  required Widget themeChangerModeButton,
}) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
    primary: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: themeChangerModeButton,
        ),
        Text('width  : ${MediaQuery.of(context).size.width} height : ${MediaQuery.of(context).size.height}'),
      ],
    ),
  );
}
