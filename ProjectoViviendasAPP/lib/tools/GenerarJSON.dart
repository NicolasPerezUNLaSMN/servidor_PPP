import 'dart:convert';
import 'dart:developer';

import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/ConvertirArchivos.dart';
import 'package:viviendas/tools/pdfAvanceObra.dart';

class GenerarJson{

  static pruebas()async{
  }

  static getIntervenciones(Visita visita) async{
    List<Obra_intervencion> intervenciones = [];
    List<RespuestaVisita> respuestas = await visita.getRespuestaVisitas()!.toList(preload: true);

    Obra ?obra = await Obra().getById(visita.obraId);
    List<Obra_intervencion> componentesTotales = await obra!.getObra_intervencions()!.groupBy('intervencionId').toList(preload: true);

    for(Obra_intervencion oi in componentesTotales){
      for(RespuestaVisita r in respuestas){
        if(r.nroComponente == oi.nroComponente && r.plPreguntaVisita!.intervencionId == oi.intervencionId){
          intervenciones.add(oi);
          break;
        }
      }
    }

    return intervenciones; 
  }

  static getIntervencionesPgas() async{
    List<Obra_intervencion> intervenciones = [];

    List<Intervencion> intervencionesPgas = await Intervencion().select().esPgas.equals(true).toList();
    for(Intervencion i in intervencionesPgas){
      Obra_intervencion obraInt = new Obra_intervencion();
      obraInt.plIntervencion = i;
      intervenciones.add(obraInt);
    }

    return intervenciones;
  }

  // *******************************  TO JSON   ********************************************

  static visitaToJson(Visita visita, int idVivienda) async {
    final map = <String, dynamic>{};

    List<Obra_intervencion> intervenciones = await getIntervenciones(visita);
    List<Obra_intervencion> intervencionesPgas = [];
    Vivienda ?vivienda = await Vivienda().getById(idVivienda);
    if(vivienda!.preguntasPgas!){
      intervencionesPgas = await getIntervencionesPgas();
    }
    PdfInvoiceApi pdf = new PdfInvoiceApi(visita, intervenciones, 1, idVivienda);
    final pdfFile = await pdf.generateCompleto(intervenciones, intervencionesPgas);

    if (visita.id != null) {
      map['id'] = "${visita.id}";
    }

    if (visita.numVisita != null) {
      map['numVisita'] = "${visita.numVisita}";
    }

    if (visita.informeId != null) {
      map['informeId'] = "${visita.informeId}";
    }

    if(visita.nombreRelevador != null){
      map['nombreRelevador'] = visita.nombreRelevador!;
    }

    if (visita.fecha != null) {
      map['fecha'] = getFecha(visita.fecha!);
    }

    if (visita.observaciones != null) {
      map['observaciones'] = visita.observaciones!;
    }

    if (visita.visitaFinal != null) {
      map['visitaFinal'] = visita.visitaFinal! ? "true": "false";
    }

    if (visita.obraId != null) {
      map['obraId'] = "${visita.obraId!}";
    }

    map['pdfBase64'] = ConvertirArchivos.fileToBase64(pdfFile);

    final mapRespuestas = [];
    List<RespuestaVisita> respuestas = await visita.getRespuestaVisitas()!.toList(preload: true);
    for(RespuestaVisita r in respuestas){
      mapRespuestas.add(await respuestaVisitaToMap(r, visita.obraId!));
    }
    map['respuestas'] = mapRespuestas;

    log(map.toString());

    return json.encode(map);
  }

  static respuestaVisitaToMap(RespuestaVisita respuestaVisita, int viviendaId) async{
    final map = <String, dynamic>{};

    if(respuestaVisita.respuesta != null){
      map['respuesta'] = respuestaVisita.respuesta;
    }
    
    if(respuestaVisita.puntaje != null){
      map['puntaje'] = respuestaVisita.puntaje;
    }

    if(respuestaVisita.pgas != null){
      map['pgas'] = respuestaVisita.pgas;
    }

    if(respuestaVisita.nroComponente != null){
      map['nroComponente'] = respuestaVisita.nroComponente;
    }

    if(respuestaVisita.respuesta != null){
      map['respuesta'] = respuestaVisita.respuesta;
    }

    PreguntaVisita ?preguntaVisita = await respuestaVisita.getPreguntaVisita();
    map['preguntaVisita'] = json.decode(await preguntaVisitaToJson(preguntaVisita!));

    map['vivienda'] = viviendaId;

    return map;
  }

  static certificadoToJson(Certificado certificado) {
    final map = <String, String>{};

    if (certificado.monto != null) {
      map['monto'] = "${certificado.monto}";
    }

    if (certificado.fecha != null) {
      map['fecha'] = getFecha(certificado.fecha!);
    }

    if (certificado.pdf != null) {
      map['pdfBase64'] = ConvertirArchivos.uint8ListToBase64(certificado.pdf!);
    }

    if (certificado.obraId != null) {
      map['obraId'] = "${certificado.obraId}";
    }

    return json.encode(map);
  }

  static viviendaToJson(Vivienda vivienda) {
    final map = <String, dynamic>{};

    if(vivienda.id != null) {
      map['id'] = "${vivienda.id}";
    }
    if(vivienda.viviendaId != null) {
      map['viviendaId'] = "${vivienda.viviendaId}";
    }
    if(vivienda.aliasRenabap != null){
      map['aliasRenabap'] = vivienda.aliasRenabap;
    }

    if(vivienda.metrosCuadrados != null) {
      map['metrosCuadrados'] = "${vivienda.metrosCuadrados}";
    }

    if(vivienda.ambientes != null) {
      map['ambientes'] = "${vivienda.ambientes}";
    }

    if(vivienda.directoACalle != null) {
      map['directoACalle'] = vivienda.directoACalle! ? "true": "false";
    }

    if(vivienda.servicioCloacas != null) {
      map['servicioCloacas'] = vivienda.servicioCloacas! ? "true": "false";
    }

    if(vivienda.servicioLuz != null) {
      map['servicioLuz'] = vivienda.servicioLuz! ? "true": "false";
    }

    if(vivienda.servicioAgua != null) {
      map['directoACalle'] = vivienda.servicioAgua! ? "true": "false";
    }

    if(vivienda.servicioGas != null) {
      map['servicioGas'] = vivienda.servicioGas! ? "true": "false";
    }

    if(vivienda.servicioInternet != null) {
      map['servicioInternet'] = vivienda.servicioInternet! ? "true": "false";
    }

    if(vivienda.reubicados != null) {
      map['reubicados'] = vivienda.reubicados! ? "true": "false";
    }

    if(vivienda.titular != null) {
      map['titular'] = "${vivienda.titular}";
    }

    if(vivienda.contactoJefeHogar != null) {
      map['contactoJefeHogar'] = "${vivienda.contactoJefeHogar}";
    }

    if(vivienda.contactoReferencia != null) {
      map['contactoReferencia'] = "${vivienda.contactoReferencia}";
    }

    if(vivienda.jefeHogarNombre != null) {
      map['jefeHogarNombre'] = "${vivienda.jefeHogarNombre}";
    }

    if(vivienda.cantHabitantes != null) {
      map['cantHabitantes'] = "${vivienda.cantHabitantes}";
    }

    if(vivienda.habitantesAdultos != null) {
      map['habitantesAdultos'] = "${vivienda.habitantesAdultos}";
    }

    if(vivienda.habitantesMenores != null) {
      map['habitantesMenores'] = "${vivienda.habitantesMenores}";
    }

    if(vivienda.habitantesMayores != null) {
      map['habitantesMayores'] = "${vivienda.habitantesMayores}";
    }

    if(vivienda.duenosVivienda != null) {
      map['duenosVivienda'] = vivienda.duenosVivienda! ? "true": "false";
    }

    if(vivienda.isDeleted != null){
      map['isDeleted'] = "${vivienda.isDeleted}";
    }

    map['ubicacion'] = ubicacionToMap(vivienda.ubicacion);

    return json.encode(map);
  }

  static ubicacionToMap(Ubicacion ubicacion) {
    final map = <String, String>{};

    if(ubicacion.toMap()['_id'] != null){
      map['id'] = "${ubicacion.toMap()['_id']}";
    }

    if(ubicacion.region != null){
      map['region'] = ubicacion.region!;
    }
    
    if(ubicacion.provincia != null){
      map['provincia'] = ubicacion.provincia!;
    }

    if(ubicacion.localidad != null){
      map['localidad'] = ubicacion.localidad!;
    }
    
    if(ubicacion.barrio != null){
      map['barrio'] = ubicacion.barrio!;
    }

    if(ubicacion.direccion != null){
      map['direccion'] = ubicacion.direccion!;
    }

    if(ubicacion.planta != null){
      map['planta'] = ubicacion.planta!;
    }

    if(ubicacion.latitud != null){
      map['latitud'] = "${ubicacion.latitud}";
    }

    if(ubicacion.longitud != null){
      map['longitud'] = "${ubicacion.longitud}";
    }

    return map;
  }

  static String getFecha(DateTime fecha){
    String month = "${fecha.month}";
    String day ="${fecha.day}";
    if(fecha.day < 10){
      day = "0${fecha.day}";
    }
    if(fecha.month < 10){
      month = "0${fecha.month}";
    }
    String fechaString = "${fecha.year}-$month-$day";
    return fechaString;
  }

  static obraToMap(int obraId) async {
    Obra? obra = await Obra().getById(obraId);
    final map = <String, String>{};
    if (obra!.id != null) {
      map['id'] = "${obra.id}";
    }

    if (obra.nombreRepresentanteOSC != null) {
      map['nombreRepresentanteOSC'] = obra.nombreRepresentanteOSC!;
    }

    return json.encode(map);
  }

  static obraIntervencionToMap(Obra_intervencion obraIntervencion){
    final map = <String, String>{};

    map['nroComponente'] = obraIntervencion.nroComponente.toString();
    map['intervencionId'] = obraIntervencion.intervencionId.toString();
    map['obraId'] = obraIntervencion.obraId.toString();

    return json.encode(map);
  }

  static preguntaVisitaToJson(PreguntaVisita pregunta) async {
    final map = <String, String>{};
    if (pregunta.id != null) {
      map['id'] = "${pregunta.id}";
    }
    if (pregunta.tipoRespuestaA != null) {
      map['tipoRespuestaA'] = pregunta.tipoRespuestaA!;
    }

    if (pregunta.tipoRespuestaB != null) {
      map['tipoRespuestaB'] = pregunta.tipoRespuestaB!;
    }

    if (pregunta.tipoRespuestaC != null) {
      map['tipoRespuestaC'] = pregunta.tipoRespuestaC!;
    }

    if (pregunta.esTexto != null) {
      map['esTexto'] = pregunta.esTexto! ? "true" : "false";
    }

    if (pregunta.pregunta != null) {
      map['pregunta'] = pregunta.pregunta!;
    }

    if (pregunta.cuestionarioHabitabilidad != null) {
      map['cuestionarioHabitabilidad'] = pregunta.cuestionarioHabitabilidad! ? "true" : "false";
    }

    if (pregunta.etapaDeAvance != null) {
      map['etapaDeAvance'] = "${pregunta.etapaDeAvance}";
    }

    if (pregunta.intervencionId != null) {
      map['intervencionId'] = "${pregunta.intervencionId}" ;
    }

    if (pregunta.intervencionId == null) {
      map['intervencionId'] = "0" ;
    }

    if (pregunta.dateCreated != null) {
      map['createdAt'] = getFecha(pregunta.dateCreated!);
    }

    return json.encode(map);
  }
// *******************************  FROM JSON   ********************************************
  static visitaFromMap(Map<String, dynamic> o) async {
    Visita visita = Visita();
    visita.id = int.tryParse(o['id'].toString());
    if (o['numVisita'] != null) {
      visita.numVisita = int.tryParse(o['numVisita'].toString());
    }
    if (o['informeId'] != null) {
      visita.informeId = int.tryParse(o['informeId'].toString());
    }
    if (o['fecha'] != null) {
      visita.fecha = int.tryParse(o['fecha'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['fecha'].toString())!)
          : DateTime.tryParse(o['fecha'].toString());
    }

    if (o['observaciones'] != null) {
      visita.observaciones = o['observaciones'].toString();
    }
    if (o['visitaFinal'] != null) {
      visita.visitaFinal = o['visitaFinal'].toString() == '1' ||
          o['visitaFinal'].toString() == 'true';
    }

    if (o['createdAt'] != null) {
      visita.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }
    visita.isDeleted = false;

    if (o['obraId'] != null) {
      visita.obraId = int.tryParse(o['obraId'].toString());
      visita.plObra = await Obra().getById(visita.obraId);
    }
    return visita;
  }

  static certificadoFromMap(Map<String, dynamic> o) async {
    Certificado certificado = Certificado();

    certificado.id = int.tryParse(o['id'].toString());
    if (o['monto'] != null) {
      certificado.monto = double.tryParse(o['monto'].toString());
    }
    if (o['fecha'] != null) {
      certificado.fecha = int.tryParse(o['fecha'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['fecha'].toString())!)
          : DateTime.tryParse(o['fecha'].toString());
    }
    if (o['pdfBase64'] != null) {
      certificado.pdf = ConvertirArchivos.base64ToUint8List(o['pdfBase64']);
    }
    certificado.obraId = int.tryParse(o['obraId'].toString());

    if (o['createdAt'] != null) {
      certificado.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }
    certificado.isDeleted = false;

    // RELATIONSHIPS FromMAP
    certificado.plObra = await Obra().getById(certificado.obraId);
    // END RELATIONSHIPS FromMAP
    return certificado;
  }

  static Future<Vivienda>viviendaFromMap(Map<String, dynamic> o) async {
    Vivienda vivienda = Vivienda();

    if (o['id'] != null) {
      vivienda.id = int.tryParse(o['id'].toString());
    }

    if (o['viviendaId'] != null) {
      vivienda.viviendaId = o['viviendaId'].toString();
    }

    if (o['aliasRenabap'] != null) {
      vivienda.aliasRenabap = o['aliasRenabap'].toString();
    }

    vivienda.metrosCuadrados = 0;
    if (o['metrosCuadrados'] != null) {
      vivienda.metrosCuadrados = int.tryParse(o['metrosCuadrados'].toString());
    }
    vivienda.ambientes = 0;
    if (o['ambientes'] != null) {
      vivienda.ambientes = int.tryParse(o['ambientes'].toString());
    }
    if (o['directoACalle'] != null) {
      vivienda.directoACalle = o['directoACalle'].toString() == '1' ||
          o['directoACalle'].toString() == 'true';
    }
    if (o['servicioCloacas'] != null) {
      vivienda.servicioCloacas = o['servicioCloacas'].toString() == '1' ||
          o['servicioCloacas'].toString() == 'true';
    }
    if (o['servicioLuz'] != null) {
      vivienda.servicioLuz = o['servicioLuz'].toString() == '1' ||
          o['servicioLuz'].toString() == 'true';
    }
    if (o['servicioAgua'] != null) {
      vivienda.servicioAgua = o['servicioAgua'].toString() == '1' ||
          o['servicioAgua'].toString() == 'true';
    }
    if (o['servicioGas'] != null) {
      vivienda.servicioGas = o['servicioGas'].toString() == '1' ||
          o['servicioGas'].toString() == 'true';
    }
    if (o['servicioInternet'] != null) {
      vivienda.servicioInternet = o['servicioInternet'].toString() == '1' ||
          o['servicioInternet'].toString() == 'true';
    }
    if (o['reubicados'] != null) {
      vivienda.reubicados = o['reubicados'].toString() == '1' ||
          o['reubicados'].toString() == 'true';
    }
    if (o['titular'] != null) {
      vivienda.titular = o['titular'].toString();
    }
    if (o['contactoJefeHogar'] != null) {
      vivienda.contactoJefeHogar = o['contactoJefeHogar'].toString();
    }
    if (o['contactoReferencia'] != null) {
      vivienda.contactoReferencia = o['contactoReferencia'].toString();
    }
    if (o['jefeHogarNombre'] != null) {
      vivienda.jefeHogarNombre = o['jefeHogarNombre'].toString();
    }
    if (o['cantHabitantes'] != null) {
      vivienda.cantHabitantes = int.tryParse(o['cantHabitantes'].toString());
    }
    if (o['habitantesAdultos'] != null) {
      vivienda.habitantesAdultos = int.tryParse(o['habitantesAdultos'].toString());
    }
    if (o['habitantesMenores'] != null) {
      vivienda.habitantesMenores = int.tryParse(o['habitantesMenores'].toString());
    }
    if (o['habitantesMayores'] != null) {
      vivienda.habitantesMayores = int.tryParse(o['habitantesMayores'].toString());
    }
    if (o['duenosVivienda'] != null) {
      vivienda.duenosVivienda = o['duenosVivienda'].toString() == '1' ||
          o['duenosVivienda'].toString() == 'true';
    }

    if (o['preguntasPgas'] != null) {
      vivienda.preguntasPgas = o['preguntasPgas'].toString() == '1' ||
          o['preguntasPgas'].toString() == 'true';
    }

    if (o['cuestionarioHabitabilidad'] != null) {
      vivienda.cuestionarioHabitabilidad = o['cuestionarioHabitabilidad'].toString() == '1' ||
          o['cuestionarioHabitabilidad'].toString() == 'true';
    }


    if (o['createdAt'] != null) {
      vivienda.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }
    vivienda.isDeleted = false;

    vivienda.ubicacion = await ubicacionFromMap(o['ubicacion']);
    vivienda.documentaciontecnica = await documentacionFromMap(o['documentacionTecnica']);
    return vivienda;
  }
  static Future<Ubicacion>ubicacionFromMap(Map<String, dynamic> o) async {
    Ubicacion ubicacion = Ubicacion();

    if (o['region'] != null) {
      ubicacion.region = o['region'].toString();
    }
    if (o['provincia'] != null) {
      ubicacion.provincia = o['provincia'].toString();
    }
    if (o['localidad'] != null) {
      ubicacion.localidad = o['localidad'].toString();
    }
    if (o['barrio'] != null) {
      ubicacion.barrio = o['barrio'].toString();
    }
    if (o['direccion'] != null) {
      ubicacion.direccion = o['direccion'].toString();
    }
    if (o['planta'] != null) {
      ubicacion.planta = o['planta'].toString();
    }
    if (o['latitud'] != null) {
      ubicacion.latitud = double.tryParse(o['latitud'].toString());
    }
    if (o['longitud'] != null) {
      ubicacion.longitud = double.tryParse(o['longitud'].toString());
    }

    if (o['createdAt'] != null) {
      ubicacion.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }
    return ubicacion;
  }

  static Future<DocumentacionTecnica> documentacionFromMap(Map<String, dynamic> o) async {
    DocumentacionTecnica documentacion = DocumentacionTecnica();

    if (o['datos'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['datos']);
      documentacion.datos = o['datos'];
    }
    if (o['computo'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['computo']);
      documentacion.computo = o['computo'];
    }
    if (o['planosDeObra'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['planosDeObra']);
      documentacion.planosDeObra = o['planosDeObra'];
    }
    if (o['cuadrillaDeTrabajadores'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['cuadrillaDeTrabajadores']);
      documentacion.cuadrillaDeTrabajadores = o['cuadrillaDeTrabajadores'];
    }
    if (o['sintesisDiagnosticoDeViviendas'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['sintesisDiagnosticoDeViviendas']);
      documentacion.sintesisDiagnosticoDeViviendas =
      o['sintesisDiagnosticoDeViviendas'];
    }
    if (o['certificadoAvanceObra'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['certificadoAvanceObra']);
      documentacion.certificadoAvanceObra = o['certificadoAvanceObra'];
    }
    if (o['planDeObra'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['planDeObra']);
      documentacion.planDeObra = o['planDeObra'];
    }
    if (o['diagramaGantt'] != null) {
      //documentacion.datos = ConvertirArchivos.base64ToUint8List(o['diagramaGantt']);
      documentacion.diagramaGantt = o['diagramaGantt'];
    }

    if (o['createdAt'] != null) {
      documentacion.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }
    documentacion.isDeleted = false;

    // RELATIONSHIPS FromMAP
    Obra obra = await obraFromMap(o['obra']);
    documentacion.plObra = obra;
    documentacion.obraId = obra.id;

    return documentacion;
  }

  static Future<Obra> obraFromMap(Map<String, dynamic> o) async {
    Obra obra = Obra();

    if (o['id'] != null) {
      obra.id = int.tryParse(o['id'].toString());
    }
    if (o['nombreRepresentanteOSC'] != null) {
      obra.nombreRepresentanteOSC = o['nombreRepresentanteOSC'].toString();
    }
    if (o['createdAt'] != null) {
      obra.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }

    int? id = await obra.save();
    List<Obra_intervencion> listaObraIntervencion = [];
    if(o['intervenciones'] != null){
      List<Future<Obra_intervencion>> listaFuture= (o['intervenciones'] as List).map((e) async => await GenerarJson.obraIntervencionFromMap(e)).toList();
      for(var element in listaFuture){
        Obra_intervencion oi = await element;
        listaObraIntervencion.add(oi);
      }
    }

    if(listaObraIntervencion.isNotEmpty){
      for(var element in listaObraIntervencion){
        element.obraId = id;
        await element.save();
      }
    }
    return obra;
  }

  static Future<Obra_intervencion>obraIntervencionFromMap(Map<String, dynamic> o) async {
    Obra_intervencion obraIntervencion = Obra_intervencion();
    obraIntervencion.nroComponente = int.tryParse(o['nroComponente'].toString());
    Intervencion? intervencion = (await Intervencion().select().nombre.equals(o['intervencion']['nombre'].toString()).toList()).first;
    obraIntervencion.intervencionId = intervencion.id;
    return obraIntervencion;
  }

  static Future<Intervencion>intervencionFromMap(Map<String, dynamic> o) async {
    Intervencion intervencion = Intervencion();

    if (o['id'] != null) {
      intervencion.id = int.tryParse(o['id'].toString());
    }
    if (o['nombre'] != null) {
      intervencion.nombre = o['nombre'].toString();
    }
    if (o['esPgas'] != null) {
      intervencion.esPgas = o['esPgas'].toString() == '1' ||
        o['esPgas'].toString() == 'true';
    }
    if (o['createdAt'] != null) {
      intervencion.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }
    intervencion.isDeleted = false;
    return intervencion;
  }

  static Future<PreguntaVisita>preguntaVisitaFromMap(Map<String, dynamic> o) async {
    PreguntaVisita preguntaVisita = PreguntaVisita();

    if (o['id'] != null) {
      preguntaVisita.id = int.tryParse(o['id'].toString());
    }
    if (o['tipoRespuestaA'] != null) {
      preguntaVisita.tipoRespuestaA = o['tipoRespuestaA'].toString();
    }
    if (o['tipoRespuestaB'] != null) {
      preguntaVisita.tipoRespuestaB = o['tipoRespuestaB'].toString();
    }
    if (o['tipoRespuestaC'] != null) {
      preguntaVisita.tipoRespuestaC = o['tipoRespuestaC'].toString();
    }
    if (o['esTexto'] != null) {
      preguntaVisita.esTexto =
          o['esTexto'].toString() == '1' || o['esTexto'].toString() == 'true';
    }
    if (o['pregunta'] != null) {
      preguntaVisita.pregunta = o['pregunta'].toString();
    }

    if (o['cuestionarioHabitabilidad'] != null) {
      preguntaVisita.cuestionarioHabitabilidad =
          o['cuestionarioHabitabilidad'].toString() == '1' ||
              o['cuestionarioHabitabilidad'].toString() == 'true';
    }
    if (o['etapaDeAvance'] != null) {
      preguntaVisita.etapaDeAvance = int.tryParse(o['etapaDeAvance'].toString());
    }

    if (o['createdAt'] != null) {
      preguntaVisita.dateCreated = int.tryParse(o['createdAt'].toString()) != null
          ? DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(o['createdAt'].toString())!)
          : DateTime.tryParse(o['createdAt'].toString());
    }

    preguntaVisita.intervencionId = int.tryParse(o['intervencionId'].toString());
    Intervencion? intervencion;
    if(preguntaVisita.intervencionId != 0){
      intervencion = (await Intervencion().getById(preguntaVisita.intervencionId));
    }
    // RELATIONSHIPS FromMAP
    preguntaVisita.plIntervencion = intervencion;
    // END RELATIONSHIPS FromMAP
    return preguntaVisita;
  }

}