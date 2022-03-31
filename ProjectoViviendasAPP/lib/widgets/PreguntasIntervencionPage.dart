import 'package:flutter/material.dart';
import 'package:viviendas/widgets/PreguntasIntervencionForm.dart';
import 'package:viviendas/model/model.dart';

class PreguntasIntervencionPage extends StatelessWidget {
  PreguntasIntervencionPage(this.visita, this.intervenciones, this.idVivienda, [this.contador = 0, this.tipoCuestionario = 1]);
  final int idVivienda;
  final Visita visita;
  final List<Obra_intervencion> intervenciones;
  final int contador;
  final int tipoCuestionario;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Arbolada'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            tipoCuestionario == 1 ?
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                'PREGUNTAS INTERVENCION',
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24.0,
                ),
              ),
            ) :
            tipoCuestionario == 2 ?
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                'PREGUNTAS PGAS',
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24.0,
                ),
              ),
            ) :            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                'PREGUNTAS Condiciones de Habitabilidad',
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                intervenciones[contador].plIntervencion!.nombre!,
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24.0,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                'Pagina ${contador+1} de ${intervenciones.length}',
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: PreguntasIntervencionForm(visita, intervenciones, contador, tipoCuestionario, idVivienda),
            )
          ]),
        ));
  }
}
