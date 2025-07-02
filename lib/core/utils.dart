import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (ScaffoldMessenger.maybeOf(context) != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(content)));
    } else {
      debugPrint("ScaffoldMessenger not found in context");
    }
  });
}
