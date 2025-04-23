
import 'package:flutter/material.dart';

class ToastMessage {
showSnackBarMessage(context, String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message, style: Theme.of(context).textTheme.headlineSmall),
    backgroundColor: Theme.of(context).primaryColor,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}