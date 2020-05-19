import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String yes;
  final String cancel;
  final Function yesOnPressed;
  final Function cancelOnPressed;

  BaseAlertDialog(
      {this.title,
      this.content,
      this.yesOnPressed,
      this.cancelOnPressed,
      this.yes = "Yes",
      this.cancel = "Cancel"});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      actions: <Widget>[
        FlatButton(
          child: Text(this.yes),
          onPressed: () {
            this.yesOnPressed();
          },
        ),
        FlatButton(
          child: Text(this.cancel),
          onPressed: () {
            this.cancelOnPressed();
          },
        ),
      ],
    );
  }
}
