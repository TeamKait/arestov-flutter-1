import 'package:flutter/material.dart';

void ShowSnackBar(context, content, IconData icon, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Row(
        spacing: 5,
      
        children: <Widget>[
          // add your preferred icon here
          Icon(
            icon,
            color: Colors.white,
          ),
          // add your preferred text content here
          Text(content),
        ],
      ),
      duration: Duration(seconds: 3),
    ),
  );
}

void SuccessSnackBar(context, content) {
  ShowSnackBar(context, content, Icons.check, Colors.greenAccent);
}

void WarningSnackBar(context, content) {
  ShowSnackBar(context, content, Icons.warning, Colors.amber);
}

void ErrorSnackBar(context, content) {
  ShowSnackBar(context, content, Icons.error, Colors.redAccent);
}
