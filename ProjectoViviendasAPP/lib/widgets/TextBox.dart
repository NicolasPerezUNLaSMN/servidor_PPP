import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType type;

  TextBox(this.controller, this.label, this.type);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: TextField(
        controller: this.controller,
        keyboardType: type,
        decoration: InputDecoration(
            filled: true,
            labelText: this.label,
            suffix: GestureDetector(
              child: Icon(Icons.close),
              onTap: () {
                controller.clear();
              },
            )),
      ),
    );
  }

}