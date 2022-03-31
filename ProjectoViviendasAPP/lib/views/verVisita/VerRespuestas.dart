import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';


class VerRespuestas extends StatefulWidget {
  VerRespuestas(this.visita, this.intervenciones, [this.contador = 0]);
  final Visita visita;
  final List<Obra_intervencion> intervenciones;
  final int contador;

  @override
  State<VerRespuestas> createState() =>
      VerRespuestasState(visita, intervenciones, contador);
}

class VerRespuestasState extends State<VerRespuestas> {
  VerRespuestasState(this.visita, this.intervenciones, this.contador);

  Visita visita;
  List<Obra_intervencion> intervenciones;
  int contador;
  Map<String, dynamic> preguntasYRespuestas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbolada'),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            minimumSize: Size(double.infinity,
                30), // double.infinity is the width and 30 is the height
          ),
          onPressed: () {
            contador++;
            if (contador == intervenciones.length) {
              Navigator.of(context)
                  .popUntil(ModalRoute.withName('/VisitaRespuestas'));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VerRespuestas(visita, intervenciones, contador)));
            }
          },
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: const Text('CONTINUAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 2.0)),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              )),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: FutureBuilder(
                future: cargarPreguntasYRespuestas(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              titulo(),
                              preguntasYRespuestas["cantidad"] == 0
                                  ? sinRespuestas()
                                  : listaRespuestas()
                            ]),
                      ),
                    );
                  } else {
                    return Column(children: const <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Espere por favor...'),
                      )
                    ]);
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget titulo(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Text(
          'Respuestas de ${intervenciones[contador].plIntervencion!.nombre}',
          style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 24.0,
          ),
          textAlign: TextAlign.center
      ),
    );
  }

  Widget listaRespuestas(){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: preguntasYRespuestas["cantidad"],
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return preguntaRespuestaItem(index);
      },
    );
  }

  Widget sinRespuestas(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              Icons.info,
              color: Colors.blue,
              size: 48.0
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'No se registran respuestas de esta opcion aun',
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                  color: Colors.grey[700],
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  cargarPreguntasYRespuestas() async {

    List<RespuestaVisita> respuestas = await visita.getRespuestaVisitas()!.toList(preload: true);
    List<PreguntaVisita> listaPreguntas = [];
    List<RespuestaVisita> listaRespuestas = [];

    PreguntaVisita preguntaAux;
    for(RespuestaVisita element in respuestas){
      preguntaAux = (await element.getPreguntaVisita())!;
      if((preguntaAux.intervencionId == intervenciones[contador].plIntervencion!.id)
          && (element.pgas == false) && (element.puntaje == -1)
          && element.nroComponente == intervenciones[contador].nroComponente){
        listaPreguntas.add(preguntaAux);
        listaRespuestas.add(element);
      }
    }
    preguntasYRespuestas = {
      "preguntas": listaPreguntas,
      "respuestas": listaRespuestas,
      "cantidad": listaRespuestas.length
    };

    return 'Preguntas y respuestas agregadas';
  }

  Widget preguntaRespuestaItem(int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
          children: [
            Expanded(
              child:
              Padding(
                padding: const EdgeInsets.only(right: 64.0),
                child: Text(
                    preguntasYRespuestas['preguntas'][index].pregunta,
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ),
            ),
            Text(
              preguntasYRespuestas['respuestas'][index].respuesta,
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
            ),
          ]
      ),
    );
  }

}
