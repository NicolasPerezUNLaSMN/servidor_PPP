import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';

class QuestionGroupVertical extends StatefulWidget {
  final String question;
  final List<Intervencion> opciones;
  final List<bool> respuesta;
  const QuestionGroupVertical({Key? key, 
    required this.question, 
    required this.opciones,
    required this.respuesta
  }) : super(key: key);

  @override
  State<QuestionGroupVertical> createState() => QuestionGroupVerticalState(question, opciones, respuesta);
}

class QuestionGroupVerticalState extends State<QuestionGroupVertical> {
  String question;
  List<Intervencion> opciones;
  List<bool> respuesta;
  List<Text> opcionesText = [];

  QuestionGroupVerticalState(this.question, this.opciones, this.respuesta){
    for(Intervencion inter in opciones){
      opcionesText.add(Text(inter.nombre!, style: TextStyle(fontSize: 16.0)));
      respuesta.add(false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            question,
            style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
              color: Theme.of(context).colorScheme.primaryVariant,
              fontSize: 16.0,
            ),
          ),
        ),
        LayoutBuilder(builder: (context, constraints) {
          return ToggleButtons(
            constraints: BoxConstraints.expand(
                width: constraints.maxWidth - 2, height: 45),
            direction: Axis.vertical,
            selectedColor: Colors.white,
            color: Theme.of(context).colorScheme.primary,
            selectedBorderColor: Theme.of(context).colorScheme.primary,
            fillColor: Theme.of(context).colorScheme.primary,
            borderColor: Theme.of(context).colorScheme.primary,
            textStyle: TextStyle(fontSize: 10.0),
            children: opcionesText,
            isSelected: respuesta,
            onPressed: (int index) {
              setState(() {
                respuesta[index] = !respuesta[index];
              });
            },
          );
        })
      ],
    );
  }
}
