import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/widgets/QuestionGroup.dart';
import 'package:viviendas/widgets/QuestionTextField.dart';
import 'package:viviendas/widgets/PreguntasIntervencionPage.dart';

class PreguntasVisitaFormulario extends StatelessWidget{
  PreguntasVisitaFormulario(this.visita, this.intervenciones, this.idVivienda);
  final Visita visita;
  final int idVivienda;
  final List<Obra_intervencion> intervenciones;

  final List<PreguntaVisita> preguntasVisita = [];
  final List<RespuestaVisita> respuestasVisita = [];
  int numeroPreguntas = 0;
  final List<Container> containerLista = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
            child: FutureBuilder<String>(
              future: obtenerDatos(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                      child: Text(
                        'Preguntas sobre la visita',
                        style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24.0,
                            ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: preguntasVisita.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 36.0),
                            child:
                            preguntasVisita[index].esTexto! ?
                            QuestionTextField(
                              question: preguntasVisita[index], 
                              answer: agregarRespuesta(
                                  preguntasVisita[index].id,
                            )) :
                            QuestionGroup(
                                question: preguntasVisita[index],
                                answer: agregarRespuesta(
                                    preguntasVisita[index].id)
                            ),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        minimumSize: Size(double.infinity,
                            30), // double.infinity is the width and 30 is the height
                      ),
                      onPressed: () {
                        if(numeroPreguntas == getRespuestasContestadas()){
                          save();
                          
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreguntasIntervencionPage(visita, intervenciones, idVivienda)));
                        }
                        else{
                          UITools(context).alertDialog('Debe contestar todas las preguntas',
                              title: 'Error', callBack: () {});
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: const Text('SIGUIENTE PASO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 2.0)),
                              ),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          )),
                    ),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ];
                } else {
                  children = const <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Espere por favor...'),
                    )
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            )
        ),
      ),
    );
  }

  RespuestaVisita agregarRespuesta(idPregunta){
    RespuestaVisita respuesta = new RespuestaVisita(
      preguntaVisitaId: idPregunta,
      nroComponente: 1,
      viviendaId: idVivienda,
      visitaId: visita.id,
    );

    respuestasVisita.add(respuesta);
    return respuesta;
  }

  Future<String> obtenerDatos() async {
    // PREGUNTAS DE LA VISITA
    Future<List<PreguntaVisita>> listaPreguntasVisita = PreguntaVisita().select().toList();
    List <PreguntaVisita> listaAuxiliarUno = await listaPreguntasVisita;
    for(var element in listaAuxiliarUno){
      if((element.intervencionId == 0 || element.intervencionId == null) && element.cuestionarioHabitabilidad == false){
        preguntasVisita.add(element);
      }
    }
    numeroPreguntas = preguntasVisita.length;
    return 'Datos cargados correctamente';
  }

  getRespuestasContestadas(){
    int cont = 0;
    for(RespuestaVisita rv in respuestasVisita){
      if(rv.respuesta != null){
        cont++;
      }
    }
    return cont;
  }
  void save() async {
    for(RespuestaVisita rv in respuestasVisita){
      int? rta =  await rv.save();
    }
  }

}

