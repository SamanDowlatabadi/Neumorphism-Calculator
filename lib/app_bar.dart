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
    title: Padding(
      padding: const EdgeInsets.all(10),
      child: themeChangerModeButton,
    ),
  );
}
