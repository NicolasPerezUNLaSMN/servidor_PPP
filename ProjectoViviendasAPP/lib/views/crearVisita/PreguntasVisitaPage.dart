import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/views/crearVisita/PreguntasVisitaForm.dart';

class PreguntasVisitaPage extends StatelessWidget {
  PreguntasVisitaPage(this.visita, this.intervenciones, this.idVivienda);
  final Visita visita;
  final List<Obra_intervencion> intervenciones;
  final int idVivienda;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Arbolada'),
          centerTitle: true,
        ),
        body: PreguntasVisitaFormulario(visita, intervenciones, idVivienda),
    );
  }
}