import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key? key}) : super(key: key);

  @override
  State<CustomSlider> createState() => CustomSliderState();
}

class CustomSliderState extends State<CustomSlider> {
  double currentValue = 20;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(2.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Text(currentValue.round().toString(),
              style: TextStyle(color: Color(0xFFDE3184), fontSize: 16.0)),
        ),
      ),
      Slider(
        value: currentValue,
        min: 1,
        max: 100,
        label: currentValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            currentValue = value;
          });
        },
      )
    ]);
  }
}
