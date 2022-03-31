import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/views/historialVisitas/VisitasPage.dart';
import 'package:viviendas/widgets/PreguntasIntervencionPage.dart';
import 'package:viviendas/widgets/ImageUpload.dart';
import 'package:viviendas/widgets/QuestionGroup.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/widgets/QuestionTextField.dart';
import 'package:viviendas/views/crearVisita/UltimaPaginaVisitaForm.dart';

class PreguntasPGAS extends StatefulWidget {
  PreguntasPGAS(this.visita, this.intervenciones, this.contador, this.idVivienda);
  final Visita visita;
  final List<Obra_intervencion> intervenciones;
  final int contador;
  final int idVivienda;
  @override
  State<PreguntasPGAS> createState() => PreguntasPGASState(visita, intervenciones, contador, idVivienda);
}

class PreguntasPGASState extends State<PreguntasPGAS>{
  PreguntasPGASState(this.visita, this.intervenciones, this.contador, this.idVivienda);
  Visita visita;
  List<Obra_intervencion> intervenciones;
  int idVivienda;
  List<PreguntaVisita> preguntas = [];
  List<RespuestaVisita> respuestas = [];
  List<XFile> imageList = [];
  ImageUpload ?imageUpload;
  int contador;

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
                                      ))
                                      :
                                  QuestionGroup(
                                      question: preguntas[index],
                                      answer: agregarRespuesta(
                                          preguntas[index].id)
                                  ),
                                ));},
                        ),
                        LayoutBuilder(
                            builder: (context, constraints) {
                              return ToggleButtons(
                                constraints: BoxConstraints.expand(
                                    width: constraints.maxWidth / 3 - 2, height: 50),
                                selectedColor: Colors.white,
                                color: Theme.of(context).colorScheme.primary,
                                selectedBorderColor: Colors.white,
                                fillColor: Theme.of(context).colorScheme.primary,
                                borderColor: Theme.of(context).colorScheme.primary,
                                textStyle: TextStyle(fontSize: 10.0),
                                children: [const Icon(Icons.photo), const Icon(Icons.photo_library), const Icon(Icons.camera_alt)],
                                isSelected: [true, true, true],
                                onPressed: (int index) {
                                  setState(() {
                                    switch(index){
                                      case 0:
                                        imageUpload!.iuState!.onImageButtonPressed(ImageSource.gallery, context: context);
                                        break;
                                      case 1:
                                        imageUpload!.iuState!.onImageButtonPressed(
                                          ImageSource.gallery,
                                          context: context,
                                          isMultiImage: true,
                                        );
                                        break;
                                      case 2:
                                        imageUpload!.iuState!.onImageButtonPressed(ImageSource.camera, context: context);
                                        break;
                                    }
                                  });
                                },
                              );
                            }
                        ),
                        imageUpload!,
                        Padding(
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
                              save();
                              Route route = MaterialPageRoute(builder: (context) => PreguntasIntervencionPage(visita, intervenciones, contador));
                              if(contador==intervenciones.length) {
                                showAlertDialog(context);
                              }
                              else{
                                Navigator.push(context, route);
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
                        ),
                      ],
                    )),
              ),
            );
          }
          else{
            return CircularProgressIndicator();
          }
        }
    );
  }

  cargarPreguntas() async {
    preguntas = await PreguntaVisita().select().intervencionId.equals(intervenciones[contador].plIntervencion!.id).toList();
    return 'Preguntas agregadas';
  }

  agregarRespuesta(idPregunta){
    RespuestaVisita r = new RespuestaVisita(
        preguntaVisitaId: idPregunta,
        nroComponente: 1,
        visitaId: visita.id);
    respuestas.add(r);

    return r;
  }

  void save() async {

    for(var elemento in respuestas){
      await elemento.save();
    }

    for(XFile img in imageList){
      new FotoVisita(
          imagen: await img.readAsBytes(),
          visitaId: visita.id).save();
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