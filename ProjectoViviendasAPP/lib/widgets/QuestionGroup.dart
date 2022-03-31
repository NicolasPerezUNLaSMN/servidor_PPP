import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';

class QuestionGroup extends StatefulWidget {
  final PreguntaVisita question;
  final RespuestaVisita answer;
  final RespuestaVisita ?respuestaAnterior;
  const QuestionGroup({Key? key, required this.question, required this.answer, this.respuestaAnterior}) : super(key: key);

  @override
  State<QuestionGroup> createState() => QuestionGroupState(question, answer, respuestaAnterior);
}

class QuestionGroupState extends State<QuestionGroup> {
  PreguntaVisita question;
  RespuestaVisita answer;
  RespuestaVisita ?respuestaAnterior;
  QuestionGroupState(this.question, this.answer, this.respuestaAnterior);

  List<bool> estado = [];
  List<Text> listaButtons = [];
  int estadoAnterior = -1;

  @override
  void initState(){
    if(question.tipoRespuestaB == null){
      question.tipoRespuestaB = '-';
    }
    listaButtons.add(Text(question.tipoRespuestaA!));
    listaButtons.add(Text(question.tipoRespuestaB!));
    if(respuestaAnterior != null){
      estado.add(respuestaAnterior!.respuesta == question.tipoRespuestaA);
      estado.add(respuestaAnterior!.respuesta == question.tipoRespuestaB);
      
      if(question.tipoRespuestaC != null){
        listaButtons.add(Text(question.tipoRespuestaC!));
        estado.add(respuestaAnterior!.respuesta == question.tipoRespuestaC);
      }

      if(respuestaAnterior!.respuesta == question.tipoRespuestaA){
        answer.respuesta = question.tipoRespuestaA;
        answer.puntaje = listaButtons.length == 2 ? -1 : 1;
        estadoAnterior = 0;
      }
      else if(respuestaAnterior!.respuesta == question.tipoRespuestaB){
        answer.respuesta = question.tipoRespuestaB;
        answer.puntaje = listaButtons.length == 2 ? -1 : 0.5;
        estadoAnterior = 1;
      }
      else{
        answer.respuesta = question.tipoRespuestaC;
        answer.puntaje = 0;
        estadoAnterior = 2;
      }
    }
    else{
      estado.add(false);
      estado.add(false);
      if(question.tipoRespuestaC != null){
        listaButtons.add(Text(question.tipoRespuestaC!));
        estado.add(false);
      }
    }
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(question.pregunta!),
        ),
        LayoutBuilder(builder: (context, constraints) {
          return ToggleButtons(
            constraints: BoxConstraints.expand(
                width: constraints.maxWidth / listaButtons.length - 2, height: 35),
            selectedColor: Colors.white,
            color: Theme.of(context).colorScheme.primary,
            selectedBorderColor: Theme.of(context).colorScheme.primary,
            fillColor: Theme.of(context).colorScheme.primary,
            borderColor: Theme.of(context).colorScheme.primary,
            textStyle: TextStyle(fontSize: 10.0),
            children: listaButtons,
            isSelected: estado,
            onPressed: (int index) {
              setState(() {
                if(estadoAnterior != 0){
                  for (int i = 0; i < estado.length; i++) {
                    estado[i] = index == i;
                    if(estado[i]){
                      if(i == 0){
                        answer.respuesta = question.tipoRespuestaA;
                        answer.puntaje = listaButtons.length == 2 ? -1 : 1;
                      }
                      else if(i == 1){
                        answer.respuesta = question.tipoRespuestaB;
                        answer.puntaje = listaButtons.length == 2 ? -1 : 0.5;
                      }
                      else if(i == 2){
                        answer.respuesta = question.tipoRespuestaC;
                        answer.puntaje = 0;
                      }
                    }
                  }
                }
              });
            },
          );
        })
      ],
    );
  }
}
