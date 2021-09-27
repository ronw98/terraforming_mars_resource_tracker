import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/constants.dart';

class EditValueButton extends StatelessWidget {
  EditValueButton({required this.text, required this.onPressed});

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0),
          primary: Colors.teal,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: AppConstants.num_button_font_size),
        ),
      ),
    );
  }
}
