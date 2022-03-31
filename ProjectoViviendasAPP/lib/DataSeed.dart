import 'dart:developer';

import 'package:viviendas/tools/Servidor.dart';

import 'model/model.dart';

Future<bool> correrPruebaAgregarDatos() async {
  //await eliminarInformacion();
  await agregarIntervenciones();
  await agregarPreguntas();
  await agregarViviendas();

  return true;
}

Future<void> eliminarInformacion() async {
  await PreguntaVisita().select().id.greaterThan(0).delete();
  await Visita().select().id.greaterThan(0).delete();
  await RespuestaVisita().select().id.greaterThan(0).delete();
  await Vivienda().select().id.greaterThan(0).delete();
  await Obra_intervencion().select().intervencionId.greaterThan(0).delete();
  await Intervencion().select().id.greaterThan(0).delete();
  await Obra().select().id.greaterThan(0).delete();
}

Future<void> agregarViviendas() async {
  DateTime comienzo = DateTime.now();
  // Las obras y las obra_intervenciones se guardan dentro de este metodo.
  List<Vivienda> listaViviendas = await Servidor.getViviendas();
  int creadas = 0;

  // await Vivienda().upsertAll(listaViviendas);
  for(var vivienda in listaViviendas){
    Vivienda ?viviendaExists = await Vivienda().getById(vivienda.id!);
    if(viviendaExists == null){
      int? id = await vivienda.save();
      log("${vivienda.saveResult.toString()} $id");
      creadas++;
    }
  }
  log('DataSeed: Viviendas cargadas correctamente - Cantidad: ${listaViviendas.length}, Creadas: $creadas - Duracion: ${comienzo.difference(DateTime.now()).inSeconds}');
  return;
}

Future<void> agregarIntervenciones() async {
  final intervencion = await Intervencion().select().toSingle();
  if (intervencion == null) {
    List <Intervencion> intervenciones = await Servidor.getIntervenciones();
    for(var intervencion in intervenciones){
      int? id = await intervencion.save();
      log('Resultado intervencion: ${intervencion.saveResult}');
    }
    log('DataSeed: Intervenciones cargadas correctamente - Cantidad: ${intervenciones.length}');
  } else {
    print('Ya hay intervenciones en la bd, este metodo no se va a correr');
  }
}

Future<void> agregarPreguntas() async {
  var pregunta = await PreguntaVisita().select().toSingle();

  if (pregunta == null) {
    List <PreguntaVisita> preguntas = await Servidor.getPreguntas();
    for(var elemento in preguntas){
      await elemento.save();
    }
    log('DataSeed: Preguntas cargadas correctamente - Cantidad: ${preguntas.length}');
  } else {
    print('Ya hay Preguntas en la bd, este metodo no se va a correr');
  }
}

Future<void> printViviendas(bool getIsDeleted) async {
  final lista= await Vivienda().select(getIsDeleted: getIsDeleted).toList();
  print('IMPRIMIENDO VIVIENDAS -> VIVIENDA().select().toList()');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${lista.length} matches found:');
  for (int i = 0; i < lista.length; i++) {
    print(lista[i].toMap());
    Ubicacion ubicacion = lista[i].ubicacion;
    DocumentacionTecnica doc = lista[i].documentaciontecnica;
    print(' Ubicacion: ${ubicacion.toMap()} \n Doc tecnica: ${doc.toMap()}');
  }
  print('---------------------------------------------------------------\n\n');
}

Future<void> printIntervenciones(bool getIsDeleted) async {
  final lista= await Intervencion().select().toList();
  print('IMPRIMIENDO Intervenciones');
  // PRINT RESULTS TO DEBUG CONSOLE
  print('${lista.length} matches found:');
  for (int i = 0; i < lista.length; i++) {
    print(lista[i].toMap());
  }

  print('---------------------------------------------------------------\n\n');
}


Future<void> printRespuestas(bool getIsDeleted) async {

  List<RespuestaVisita> rtas = await RespuestaVisita().select(getIsDeleted: getIsDeleted).toList(preload : true);

  List<Visita> visitas = await Visita().select().toList(preload: true);
  print('${visitas.length} visitas found:');
  for(var element in visitas){
    print('Visita id : ${element.id} + es visita final ${element.visitaFinal}');
  }

  print('${rtas.length} rtas found:');
  for (int i = 0; i < rtas.length; i++) {
    PreguntaVisita? p = await rtas[i].getPreguntaVisita();
    print(' id visita: ${rtas[i].visitaId} -- pregunta: ${p!.pregunta} -- respuesta: ${rtas[i].respuesta}');
  }
  print('---------------------------------------------------------------\n\n');
}

Future<void> printPreguntas(bool getIsDeleted) async {

  List<PreguntaVisita> preguntas = await PreguntaVisita().select().toList();

  print('${preguntas.length} PREGUNTAS found:');
  for (int i = 0; i < preguntas.length; i++) {
    print(preguntas[i].toMap());
  }
  print('---------------------------------------------------------------\n\n');
}

