import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/views/cuestionarioHabitabilidad/HabitabilidadCuestionarioPage.dart';
import 'package:viviendas/views/historialVisitas/VisitasPage.dart';
import 'package:viviendas/widgets/PreguntasIntervencionPage.dart';
import 'package:viviendas/widgets/ImageUpload.dart';
import 'package:viviendas/widgets/QuestionGroup.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/widgets/QuestionTextField.dart';
import 'package:viviendas/views/crearVisita/UltimaPaginaVisitaForm.dart';

class PreguntasIntervencionForm extends StatefulWidget {
  PreguntasIntervencionForm(this.visita, this.intervenciones, this.contador, this.tipoCuestionario, this.idVivienda );
  final Visita visita;
  final List<Obra_intervencion> intervenciones;
  final int contador;
  final int tipoCuestionario;
  final int idVivienda;
  @override
  State<PreguntasIntervencionForm> createState() => PreguntasIntervencionFormState(visita, intervenciones, contador, tipoCuestionario, idVivienda);
}

class PreguntasIntervencionFormState extends State<PreguntasIntervencionForm>{
  PreguntasIntervencionFormState(this.visita, this.intervenciones, this.contador, this.tipoCuestionario, this.idVivienda );
  Visita visita;
  List<Obra_intervencion> intervenciones;
  List<PreguntaVisita> preguntas = [];
  List<RespuestaVisita> respuestas = [];
  List<RespuestaVisita> respuestasAnteriores = [];
  List<XFile> imageList = [];
  ImageUpload ?imageUpload;
  int contador;
  int idVivienda;
  int cantidadPreguntas = 0;
  /*
  1 = intervencion normal
  2 = pgas
  3 = condiciones de habitabilidad
   */
  int tipoCuestionario;

  @override
  void initState(){
    imageUpload = ImageUpload(imageFileList: imageList);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: cargarPreguntas(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          itemCount: preguntas.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 36.0),
                                  child:
                                  preguntas[index].esTexto! ?
                                  QuestionTextField(
                                    question: preguntas[index], 
                                    answer: agregarRespuesta(
                                        preguntas[index].id,
                                    ),
                                  )
                                  :
                                  QuestionGroup(
                                      question: preguntas[index],
                                      answer: agregarRespuesta(
                                        preguntas[index].id
                                      ),
                                      respuestaAnterior: respuestasAnteriores.isEmpty 
                                      ? null
                                      : (respuestasAnteriores.indexWhere((r) => r.preguntaVisitaId == preguntas[index].id) != -1
                                        ? respuestasAnteriores.firstWhere((r) => r.preguntaVisitaId == preguntas[index].id) 
                                        : null)
                                      
                                  ),
                                ));},
                        ),
                        (tipoCuestionario != 3) ?
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return ToggleButtons(
                              constraints: BoxConstraints.expand(
                                width: constraints.maxWidth / 2 - 2, height: 50),
                              selectedColor: Colors.white,
                              color: Theme.of(context).colorScheme.primary,
                              selectedBorderColor: Colors.white,
                              fillColor: Theme.of(context).colorScheme.primary,
                              borderColor: Theme.of(context).colorScheme.primary,
                              textStyle: TextStyle(fontSize: 10.0),
                              children: [const Icon(Icons.photo_library), const Icon(Icons.camera_alt)],
                              isSelected: [true, true],
                              onPressed: (int index) {
                                switch(index){
                                  case 0:
                                    imageUpload!.iuState!.onImageButtonPressed(
                                      ImageSource.gallery,
                                      context: context,
                                      isMultiImage: true,
                                    );
                                    break;
                                  case 1:
                                    imageUpload!.iuState!.onImageButtonPressed(ImageSource.camera, context: context);
                                    break;
                                }
                              },
                            );
                          }
                        ) : SizedBox(),
                        tipoCuestionario != 3 ? imageUpload! : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: siguientePasoBoton(),
                        ),
                      ],
                    )),
              ),
            );
          }
          else{
            return Column(
                children: const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Espere por favor...'),
                  )
                ]
            );
          }
        }
    );
  }

  Widget siguientePasoBoton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        minimumSize: Size(double.infinity,
            30), // double.infinity is the width and 30 is the height
      ),
      onPressed: () async {
        if(cantidadPreguntas != await getRespuestasContestadas()){
          UITools(context).alertDialog('Debe contestar todas las preguntas',
              title: 'Error', callBack: () {});
        }
        else{
          await save();
          contador++;
          Vivienda vivienda = await getVivienda();
           
          if(contador == intervenciones.length && tipoCuestionario == 1 && vivienda.preguntasPgas!) {
            // Va a la pagina de PGAS
            await getIntervenciones(2);
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => PreguntasIntervencionPage(visita, intervenciones, idVivienda, 0, 2)));
          }
          else if(contador >= intervenciones.length && (tipoCuestionario == 2 || !vivienda.preguntasPgas!)) {
            // Va a la pagina ultima pagina de la visita
            showAlertDialog(context);
          }
          else if(contador == intervenciones.length && tipoCuestionario == 3) {
            // Va a la pagina ultima pagina de la visita
            Navigator.of(context).popUntil(ModalRoute.withName('/ViviendaHome'));
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => HabitabilidadCuestionarioPage(vivienda)));
          }
          else{
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => PreguntasIntervencionPage(visita, intervenciones, idVivienda, contador, tipoCuestionario)));
          }
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
    );
  }

  getRespuestasContestadas() async{
    int cont = 0;
    for(RespuestaVisita rv in respuestas){
      if(rv.respuesta != null){
        cont++;
      }
      else{
        PreguntaVisita ?pv = await rv.getPreguntaVisita();
        if(pv!.pregunta == 'Observaciones'){
          cont++;
        }
      }
    }
    return cont;
  }

  cargarPreguntas() async {
    switch(tipoCuestionario){
      // INTERVENCIONES POR OBRA
      case 1:
        preguntas = await PreguntaVisita().select().intervencionId.equals(intervenciones[contador].plIntervencion!.id).
          and.cuestionarioHabitabilidad.equals(false).toList();
        cantidadPreguntas = preguntas.length;
        for(PreguntaVisita pv in preguntas){
          RespuestaVisitaFilterBuilder ?rvFilter = pv.getRespuestaVisitas();
          if(rvFilter != null){
            List<RespuestaVisita> rvList = await rvFilter.viviendaId.equals(idVivienda).and.nroComponente.equals(intervenciones[contador].nroComponente)
              .orderBy("dateCreated").toList(preload: true);
            
            if(rvList.isNotEmpty){
              respuestasAnteriores.add(rvList.last);
            }
          }
        }
      break;
      // CUESTIONARIO PGAS

      case 2:
        preguntas = await PreguntaVisita().select().intervencionId.equals(intervenciones[contador].plIntervencion!.id).and.cuestionarioHabitabilidad.equals(false).toList();
              cantidadPreguntas = preguntas.length;
        break;
        // CUSTIONARIO CONDICIONES DE HABITABILIDAD
      case 3:
        if(intervenciones[contador].plIntervencion!.id == 0){
          preguntas = await PreguntaVisita().select().intervencionId.equals(0).and.cuestionarioHabitabilidad.equals(true).toList();
        }
        else{
          preguntas = await PreguntaVisita().select().intervencionId.equals(intervenciones[contador].plIntervencion!.id).and.cuestionarioHabitabilidad.equals(true).toList();
        }
        cantidadPreguntas = preguntas.length;
        break;
    }
    return 'Preguntas agregadas';
  }

  agregarRespuesta(idPregunta){
    RespuestaVisita r = new RespuestaVisita(
        preguntaVisitaId: idPregunta,
        nroComponente: intervenciones[contador].nroComponente,
        viviendaId: idVivienda,
        visitaId: visita.id);

    if(tipoCuestionario == 2){
      r.pgas = true;
    }

    if(tipoCuestionario == 3){
      r = new RespuestaVisita(
          preguntaVisitaId: idPregunta,
          nroComponente: intervenciones[contador].nroComponente,
          viviendaId: idVivienda);
    }
    respuestas.add(r);

    return r;
  }

  getVivienda() async {
    Vivienda? vivienda = await Vivienda().getById(idVivienda);
    return vivienda;
  }

  getIntervenciones(int tipoCuestionario) async {
    intervenciones = [];
    if(tipoCuestionario == 2){
      List<Intervencion> intervencionesPgas = await Intervencion().select().esPgas.equals(true).toList();
      for(Intervencion i in intervencionesPgas){
        Obra_intervencion obraIntervencion = new Obra_intervencion(nroComponente: 1);
        obraIntervencion.plIntervencion = i;
        intervenciones.add(obraIntervencion);
      }
    }
    else {
      final Obra? obra = await Obra().getById(visita.obraId);
      intervenciones = await obra!.getObra_intervencions()!.groupBy('intervencionId').toList(preload: true);
    }
  }

  save() async {
    for(var elemento in respuestas){
      if(tipoCuestionario != 3){
        elemento.puntaje = -1;
      }
      await elemento.save();
    }

    for(XFile img in imageList){
      new FotoVisita(
        imagen: await img.readAsBytes(),
        visitaId: visita.id,
        intervencionId: intervenciones[contador].plIntervencion!.id,
        nroComponente: intervenciones[contador].nroComponente).
      save();
      log("Foto de visita guardada, intervencion id: " + intervenciones[contador].plIntervencion!.id.toString());
    }

  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop(true);
        contador--;
      },
    );
    Widget confirmButton = TextButton(
      child: Text("Confirmar"),
      onPressed: () async {
        saveVisita();
        Vivienda ?vivienda = await Vivienda().getById(widget.idVivienda);
        Navigator.of(context).pop(true);
        Navigator.of(context).popUntil(ModalRoute.withName('/ViviendaHome'));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VisitasPage(widget.visita.obraId!, vivienda!)));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Guardar visita"),
      content: Text("Desea confirmar la informacion ingresada y guardar la visita?"),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void saveVisita() async {
    await widget.visita.save();

    if (widget.visita.saveResult!.success) {
      String mensaje = 'La visita se ha guardado corectamente!';
      if(widget.visita.visitaFinal!){
        mensaje += '\nResponda el cuestionario de condiciones de habitabilidad';
      }
      UITools(context).alertDialog(mensaje,
          title: 'Exito');
    } else {
      UITools(context).alertDialog(widget.visita.saveResult.toString(),
          title: 'Hubo un fallo! Intentelo de nuevo', callBack: () {});
    }
  }
}
