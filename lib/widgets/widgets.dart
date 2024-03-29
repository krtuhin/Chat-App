import 'package:chat_app/shared/constants.dart';
import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
    labelStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w300,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Constants().primaryColor,
        width: 2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Constants().primaryColor,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Constants().primaryColor,
        width: 2,
      ),
    ));

void nextScreen(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
  );
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
  );
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
