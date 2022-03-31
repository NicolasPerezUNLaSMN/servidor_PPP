import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/generarPdf.dart';
import 'package:viviendas/tools/pdfAvanceObra.dart';

import '../../widgets/PreguntasIntervencionPage.dart';


class HabitabilidadCuestionarioPage extends StatefulWidget {
  HabitabilidadCuestionarioPage(this.vivienda);
  final Vivienda vivienda;
  @override
  State<HabitabilidadCuestionarioPage> createState() => HabitabilidadCuestionarioPageState(vivienda);
}

class HabitabilidadCuestionarioPageState extends State<HabitabilidadCuestionarioPage> {
  final Vivienda vivienda;
  HabitabilidadCuestionarioPageState(this.vivienda);
  bool cuestionarioRespondido = false;
  bool visitaFinal = false;

  List<Obra_intervencion> intervenciones = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Arbolada'),
          centerTitle: true,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'CONDICIONES DE HABITABILIDAD',
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0),),
            ),
            FutureBuilder(
                future: cuestionarioRespondidoGet(),
                builder: (context, snapshot){
                  if (snapshot.hasData) {
                    if(cuestionarioRespondido){
                      return descargarCuestionario();
                    }
                    else{
                      return completarCuestionario();
                    }
                  }
                  else {
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
            )
        ],
        ),
      ),
    );
  }

  Widget completarCuestionario(){
    return
      ElevatedButton(
          onPressed: () async{
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PreguntasIntervencionPage(new Visita(), intervenciones, vivienda.id!, 0, 3)));
          },
          child: Text('Contestar cuestionario',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 2.0))
      );
  }

  Widget descargarCuestionario(){
    return ElevatedButton(
      onPressed: () async{
        await getIntervenciones();
        PdfInvoiceApi pdf = new PdfInvoiceApi(new Visita(), intervenciones, 3, vivienda.id!);
        final pdfFile = await pdf.generate();
        GenerarPdf.openFile(pdfFile);
      },
      child: Text('Descargar condiciones de habitabilidad',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 2.0))
    );
  }

  cuestionarioRespondidoGet() async {
    await getIntervenciones();
    var lista = await vivienda.getRespuestaVisitas()!.toList(preload: true);
    if(lista.isNotEmpty){
      cuestionarioRespondido = true;
    }
    return 'Datos obtenidos';
  }

  getIntervenciones() async {

    final DocumentacionTecnica doc = vivienda.documentaciontecnica;
    final Obra? obra = await Obra().getById(doc.obraId);

    intervenciones = await obra!.getObra_intervencions()!.groupBy('intervencionId').intervencionId.not.isNull().toList(preload: true);
    Obra_intervencion general = new Obra_intervencion();
    general.plIntervencion = Intervencion(id: 0, nombre: 'Condición Generales en Habitantes');
    intervenciones.add(general);

    final visitas = await obra.getVisitas()!.toList();
    var ultimaVisita;
    if(visitas.length > 0) {
      ultimaVisita = visitas[visitas.length - 1];
      if (ultimaVisita.visitaFinal!) {
        visitaFinal = true;
      }
    }
  }
}
