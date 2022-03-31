import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';

class QuestionTextField extends StatefulWidget {
  QuestionTextField({required this.question, required this.answer});
  PreguntaVisita question;
  RespuestaVisita answer;

  @override
  State<QuestionTextField> createState() => QuestionTextFieldState(question, answer);
}

class QuestionTextFieldState extends State<QuestionTextField> {
  QuestionTextFieldState(this.question, this.answer);
  PreguntaVisita question;
  RespuestaVisita answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(question.pregunta!),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Texto corto'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un texto';
            }
            return null;
          },
          onChanged: (String ?value) {
            answer.respuesta = value;
          },
        )
      ],
    );
  }
}

class DropdownOption{
  DropdownOption(this.index, this.value);
  int index;
  String value;
}