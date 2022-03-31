import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';

class QuestionCheckbox extends StatefulWidget {
  final PreguntaVisita question;
  final RespuestaVisita answer;
  const QuestionCheckbox({Key? key, required this.question, required this.answer}) : super(key: key);
  @override
  State<QuestionCheckbox> createState() => QuestionCheckboxState(question, answer);
}

class QuestionCheckboxState extends State<QuestionCheckbox> {
  final PreguntaVisita question;
  final RespuestaVisita answer;
  QuestionCheckboxState(this.question, this.answer);
  bool isChecked = false;
  
  @override
  void initState(){
    answer.respuesta = question.tipoRespuestaB;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return Theme.of(context).colorScheme.primary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(question.pregunta!)),
          Checkbox(
              value: isChecked,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                  if(isChecked){
                    answer.respuesta = question.tipoRespuestaA;
                  } 
                  else{
                    answer.respuesta = question.tipoRespuestaB;
                  }
                });
              })
        ],
      ),
    );
  }
}
