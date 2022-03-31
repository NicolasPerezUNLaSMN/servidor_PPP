import 'package:flutter/material.dart';

class QuestionDropdown extends StatefulWidget {
  QuestionDropdown(this.name, this.options, this.selected);
  final String name;
  final List<String> options;
  final DropdownOption selected;
  QuestionDropdownState ?qdState;

  @override
  State<QuestionDropdown> createState() => QuestionDropdownState(name, options, selected);
}

class QuestionDropdownState extends State<QuestionDropdown> {
  QuestionDropdownState(this.name, this.options, this.selected);
  final String name;
  List<String> options;
  DropdownOption selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name),
        DropdownButton<String>(
          isExpanded: true,
          value: options[selected.index],
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          underline: Container(
            height: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          onChanged: (String? value) {
            setState(() {
              selected.index = options.indexOf(value!);
              selected.value = value;
            });
          },
          items: options
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ]
    );
  }
}

class DropdownOption{
  DropdownOption(this.index, this.value);
  int index;
  String value;
}