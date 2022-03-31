import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/Servidor.dart';
import 'package:viviendas/tools/generarPdf.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/tools/pdfAvanceObra.dart';
import '../../widgets/QuestionGroupVertical.dart';
import 'VerRespuestas.dart';

class VisitaRespuestas extends StatefulWidget {
  VisitaRespuestas(this.visita, this.idVivienda);

  final Visita visita;
  final int idVivienda;
  @override
  State<VisitaRespuestas > createState() => VisitaRespuestasEstado(this.visita, this.idVivienda);
}
class VisitaRespuestasEstado extends State<VisitaRespuestas> {
  VisitaRespuestasEstado(this.visita, this.idVivienda);

  final Visita visita;
  final int idVivienda;
  bool botonGuardadoServidor = false;
  List<Obra_intervencion> intervenciones = [];
  List<bool> intervencionesElegidas = [];

  @override
  Widget build(BuildContext context) {
    botonGuardadoServidor = visita.cargadoServidor!;
    return Scaffold(
        appBar: AppBar(
            title: Text('Ver respuestas de la visita'),
            centerTitle: true
        ),
        body: Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Column(
                      children: <Widget>[
                        Text('Numero de visita: ${visita.numVisita}'),
                        Text('Relevador: ${visita.nombreRelevador}'),
                        Text('Observaciones: ${visita.observaciones}'),
                        visita.visitaFinal! ? Text("VISITA FINAL"): Text("VISITA EVENTUAL"),
                        FutureBuilder(
                            future: cargarIntervenciones(),
                            builder: (context, snapshot){
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: QuestionGroupVertical(
                                      question: 'Ver respuestas de:',
                                      opciones: intervenciones.map((e) => e.plIntervencion!).toList(),
                                      respuesta: intervencionesElegidas),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }
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
                            List<Obra_intervencion> listaIntervencion = obtenerIntervencionesElegidas();
                            if(listaIntervencion.isNotEmpty){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      VerRespuestas(visita, listaIntervencion)));
                            }
                            else{
                              UITools(context).alertDialog('Debe seleccionar aunque sea una opcion',
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
                                    child: const Text('VER INFORMACION',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            letterSpacing: 2.0)),
                                  ),
                                  Icon(Icons.arrow_forward, color: Colors.white),
                                ],
                              )),
                        ),
                        // ElevatedButton(
                        //   onPressed: () async{
                        //     PdfInvoiceApi pdf = new PdfInvoiceApi(visita, intervenciones.sublist(0, intervenciones.length - 1), 1);
                        //     final pdfFile = await pdf.generate();
                        //     GenerarPdf.openFile(pdfFile);
                        //   },
                        //   child: Text('Descargar avance obra',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 14,
                        //           letterSpacing: 2.0)),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () async{
                        //     var nuevaListaIntervenciones = await getIntervenciones(2);
                        //     PdfInvoiceApi pdf = new PdfInvoiceApi(visita, nuevaListaIntervenciones, 2);
                        //     final pdfFile = await pdf.generate();
                        //     GenerarPdf.openFile(pdfFile);
                        //   },
                        //   child: Text('Descargar informacion pgas',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 14,
                        //           letterSpacing: 2.0)),
                        // ),
                        ElevatedButton(
                          onPressed: () async{
                            var intervencionesPgas = await getIntervenciones(2);
                            PdfInvoiceApi pdf = new PdfInvoiceApi(visita, intervencionesPgas, 2, idVivienda);
                            List<Obra_intervencion> intervencionesObra = intervenciones;
                            final pdfFile = await pdf.generateCompleto(intervencionesObra, intervencionesPgas);
                            GenerarPdf.openFile(pdfFile);
                          },
                          child: Text('Descargar informe de visita',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 2.0)),
                        ),
                        botonGuardadoServidor?
                        visitaCargada():
                        botonGuardarServidor()
                      ],
                    )
                )))
    );
  }

  cargarIntervenciones() async{
    final Obra? obra = await visita.getObra();
    intervenciones = await obra!.getObra_intervencions()!.groupBy('intervencionId').intervencionId.not.isNull().toList(preload: true);
    return intervenciones;
  }

  obtenerIntervencionesElegidas(){
    List<Obra_intervencion> listaIntervencion =[];

    for(var i = 0 ; i < intervenciones.length ; i++){
      if(intervencionesElegidas[i]){
        listaIntervencion.add(intervenciones[i]);
      }
    }
    return listaIntervencion;
  }

  getIntervenciones(int tipoCuestionario) async {
    List<Obra_intervencion> nuevaListaIntervenciones = [];
    if(tipoCuestionario == 2){
      List<Intervencion> intervencionesPgas = await Intervencion().select().esPgas.equals(true).toList();
      for(Intervencion i in intervencionesPgas){
        Obra_intervencion obraInt = new Obra_intervencion();
        obraInt.plIntervencion = i;
        nuevaListaIntervenciones.add(obraInt);
      }
    }
    else {
      final Obra? obra = await Obra().getById(visita.obraId);
      nuevaListaIntervenciones = await obra!.getObra_intervencions()!.groupBy('intervencionId').toList(preload: true);
    }
    return nuevaListaIntervenciones;
  }

  botonGuardarServidor() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          padding: MaterialStateProperty.all(EdgeInsets.all(20)),
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30))),
      onPressed: () async{
        Visita? visitaGuardada = await Servidor.createVisita(visita, idVivienda);
        if(visitaGuardada != null){
          visita.cargadoServidor = true;
          await visita.save();
          setState(() {
            botonGuardadoServidor = true;
          });
        }else{
          UITools(context).alertDialog("Hubo un error guardando la visita en el servidor.\nIntentelo de nuevo mas tarde.",
              title: 'Error', callBack: () {});
        }
        if(visita.numVisita == 1){
          Obra ?obra = await visita.getObra();
          DocumentacionTecnica ?docTecnica = await DocumentacionTecnica().select().obraId.equals(obra!.id).toSingle(preload: true);
          Vivienda ?vivienda = await Vivienda().select().id.equals(docTecnica!.toMap()['_id']).toSingle(preload:true);
          await Servidor.updateVivienda(vivienda!);
        }
      },
      child: Text('Guardar en el servidor',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 2.0)),
    );
  }

  visitaCargada() {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(10.0)),
          color: Color.fromRGBO(171, 202, 125, 0.5)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          "Visita cargada en el servidor",
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
