import 'dart:developer';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:viviendas/model/model.dart';

import 'generarPdf.dart';

class PdfInvoiceApi {
  PdfInvoiceApi(this.visita, this.listaIntervenciones, this.tipoPdf, this.idVivienda);

  int idVivienda;
  Visita visita;
  List<Obra_intervencion> listaIntervenciones;
  Vivienda? vivienda;
  Obra ?obra;
  Ubicacion? ubicacion;
  List<RespuestaVisita> respuestas = [];
  var listaPreguntasPorIntervencion = [];
  int contadorLista = 0;
  // 1 = avance obra // 2 = pgas // 3 = condiciones de habitabilidad
  int tipoPdf;
  double sumaTotalCondicionesHabitabilidad = 0;

  Future<File> generate() async {
    final pdf = Document();
    await cargarInfo();

    pdf.addPage(MultiPage(
      build: (context) =>
      [
        buildTitle(),
        buildInformacionHabitabilidad(),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTablas(),
        tipoPdf == 3
          ? builParteFinalHabitabilidad()
          : buildFilasImagenes(),
      ],

    ));

    return GenerarPdf.saveDocument(name: getNombrePdf(), pdf: pdf);
  }

  Future<File> generateCompleto(intervencionesObra, intervencionesPgas) async {
    final pdf = Document();
    tipoPdf = 1;
    listaIntervenciones = intervencionesObra;
    await cargarInfo();
    Widget imagenesObra = buildFilasImagenes();
    Widget avanceObraCol = buildTablas();

    pdf.addPage(MultiPage(
      build: (context) =>
      [
        buildTitle(),
        buildInformacionObra(),
        SizedBox(height: 3 * PdfPageFormat.cm),
        avanceObraCol,
        imagenesObra
      ],

    ));

    if(vivienda!.preguntasPgas!){
      tipoPdf = 2;
      listaIntervenciones = intervencionesPgas;
      await cargarInfo();
      Widget imagenesPgas = buildFilasImagenes();
      Widget pgasCol = buildTablas();

      pdf.addPage(MultiPage(
        build: (context) =>
        [
          pgasCol,
          imagenesPgas
        ],
      ));
    }

    return GenerarPdf.saveDocument(name: getNombrePdf(), pdf: pdf);
  }

  Future<void> cargarInfo() async {
    vivienda = (await Vivienda().getById(idVivienda))!;
    obra = await Obra().getById(vivienda!.id);
    if(tipoPdf == 3){
      respuestas = await vivienda!.getRespuestaVisitas()!.toList(preload: true);
    }else{
      respuestas = await visita.getRespuestaVisitas()!.toList(preload: true);
    }

    ubicacion = vivienda!.ubicacion;

    List<PreguntaVisita> listaPreguntas = [];
    List<RespuestaVisita> listaRespuestas = [];

    for(var itemObraIntervencion in listaIntervenciones){
      listaPreguntas = [];
      listaRespuestas = [];
      PreguntaVisita preguntaAux;

      if(tipoPdf == 1) {
        for (var itemRespuesta in respuestas) {
          preguntaAux = (await itemRespuesta.getPreguntaVisita())!;
          if ((preguntaAux.intervencionId == itemObraIntervencion.plIntervencion!.id) &&
              (itemRespuesta.pgas == false) && (itemRespuesta.puntaje == -1)
              && itemObraIntervencion.nroComponente == itemRespuesta.nroComponente) {
            listaPreguntas.add(preguntaAux);
            listaRespuestas.add(itemRespuesta);
          }
        }
      }
      if(tipoPdf == 2) {
        for (var itemRespuesta in respuestas) {
          preguntaAux = (await itemRespuesta.getPreguntaVisita())!;
          if ((preguntaAux.intervencionId == itemObraIntervencion.plIntervencion!.id) &&
              (itemRespuesta.pgas == true) && (itemRespuesta.puntaje == -1)) {
            listaPreguntas.add(preguntaAux);
            listaRespuestas.add(itemRespuesta);
          }
        }
      }
      if(tipoPdf == 3) {
        for (var itemRespuesta in respuestas) {
          preguntaAux = (await itemRespuesta.getPreguntaVisita())!;
          if (((preguntaAux.intervencionId == itemObraIntervencion.plIntervencion!.id) || preguntaAux.intervencionId == 0) &&
              (itemRespuesta.pgas == false) && (preguntaAux.cuestionarioHabitabilidad!)
              && itemObraIntervencion.nroComponente == itemRespuesta.nroComponente) {
            listaPreguntas.add(preguntaAux);
            listaRespuestas.add(itemRespuesta);
          }
        }
      }
      listaPreguntasPorIntervencion.add(
          {
            "intervencionId": itemObraIntervencion.plIntervencion!.id,
            "preguntas": listaPreguntas,
            "respuestas": listaRespuestas,
            "cantidad": listaRespuestas.length
          }
      );
    }
  }

  String construirFecha(DateTime fecha){
    final meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

    String fechaTexto = fecha.day.toString() + ' de '
        + meses[fecha.month - 1] + ' de '
        + fecha.year.toString();
    return fechaTexto;
  }

  String getNombrePdf(){
    String titulo = 'Informe_de_visita.pdf';
    if(tipoPdf==3){
      titulo = 'condDeHab.pdf';
    }
    return titulo;
  }
  Widget buildInformacionObra() {

    final headers = [
      'Entidad',
      'Provincia',
      'Localidad',
      'Barrio',
      'Vivienda n°',
      'Vivienda alias',
      'Relevador UNLA',
      'Visita n°',
      'Fecha de visita'
    ];
    final data = [
      obra!.nombreRepresentanteOSC == null ? '-' : obra!.nombreRepresentanteOSC!,
      ubicacion!.provincia!,
      ubicacion!.localidad!,
      ubicacion!.barrio!,
      vivienda!.viviendaId == null ? '-' : vivienda!.viviendaId!,
      vivienda!.aliasRenabap == null ? '-' : vivienda!.aliasRenabap,
      visita.nombreRelevador!,
      visita.numVisita.toString(),
      construirFecha(visita.dateCreated!)
    ];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        List.generate(headers.length, (index) {
          final title = headers[index];
          final value = data[index];
          return buildText(title: title, value: value!, width: 500);
        }
        )
    );
  }

  Widget buildInformacionHabitabilidad() {

    final headers = [
      'Entidad',
      'Provincia',
      'Localidad',
      'Barrio',
      'Vivienda n°',
      'Vivienda alias',
      'Fecha'
    ];
    final data = [
      obra!.nombreRepresentanteOSC == null ? '-' : obra!.nombreRepresentanteOSC!,
      ubicacion!.provincia!,
      ubicacion!.localidad!,
      ubicacion!.barrio!,
      vivienda!.viviendaId == null ? '-' : vivienda!.viviendaId!,
      vivienda!.aliasRenabap == null ? '-' : vivienda!.aliasRenabap,
      construirFecha(DateTime.now())
    ];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        List.generate(headers.length, (index) {
          final title = headers[index];
          final value = data[index];
          return buildText(title: title, value: value!, width: 500);
        }
        )
    );
  }

  Widget buildTablas(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(listaIntervenciones.length, (index) {
          Widget lista = buildTitle();
          switch(tipoPdf){
            case 1: lista = buildTablaIntervencionObra(listaIntervenciones[index].plIntervencion!);
              break;
            case 2: lista = buildTablaPgas(listaIntervenciones[index].plIntervencion!);
              break;
            case 3: lista = buildTablaIntervencionHabitabilidad(listaIntervenciones[index].plIntervencion!);
              break;
          }
          return lista;
        })
    );
  }

  Widget buildFilasImagenes(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(listaIntervenciones.length, (index) {
          Widget lista = buildImagenes(listaIntervenciones[index]);
          return lista;
        })
    );
  }

  Widget buildTitle() {
    String titulo = 'INFORME DE VISITA';
    switch(tipoPdf){
      case 1: titulo = 'PLANILLA VERIFICACION DE AVANCE DE OBRA';
      break;
      case 2: titulo = 'Estudio de verificacion del PGAS';
      break;
      case 3: titulo = 'PLANILLA VERIFICACION DE CONDICIONES DE HABITABILIDAD';
      break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titulo,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(),
      ],
    );
  }

  Widget buildTablaIntervencionObra(Intervencion intervencion)  {

    final headers = [
      'Porcentaje de Avance',
      'Tarea',
      'Ejecución',
    ];

    List<String> informacionColumna = [];
    List<List<String>> informacionTabla = [[]];

    for(var i = 0 ; i < listaPreguntasPorIntervencion[contadorLista]["cantidad"]; i++ ){
      PreguntaVisita preguntaAux = listaPreguntasPorIntervencion[contadorLista]["preguntas"][i];
      RespuestaVisita respuestaAux = listaPreguntasPorIntervencion[contadorLista]["respuestas"][i];
      preguntaAux.etapaDeAvance == 0 ?
      informacionColumna.add('')
      : informacionColumna.add('${preguntaAux.etapaDeAvance.toString()}%');
      informacionColumna.add(preguntaAux.pregunta!);
      informacionColumna.add(respuestaAux.respuesta!);
      informacionTabla.add(informacionColumna);
      informacionColumna = [];
    }
    contadorLista++;

    return Wrap(
      children: [
        Text(
          intervencion.nombre!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Wrap(
            children: [
              Table.fromTextArray(
                headers: headers,
                data: informacionTabla,
                border: null,
                headerStyle: TextStyle(fontWeight: FontWeight.bold),
                headerDecoration: BoxDecoration(color: PdfColor.fromHex('b3f17c')),
                cellHeight: 10,
                columnWidths: {
                  0: FlexColumnWidth(2.0),
                  1: FlexColumnWidth(5.0),
                  2: FlexColumnWidth(3.0),
                },
                cellAlignments: {
                  0: Alignment.center,
                  1: Alignment.center,
                  2: Alignment.center,
                },
              ),
              Divider(),
            ],
        )
      ],
    );
  }

  Widget buildTablaPgas(Intervencion intervencion)  {

    final headers = [
      'Medida',
      'Verificación',
    ];

    List<String> informacionColumna = [];
    List<List<String>> informacionTabla = [[]];

    for(var i = 0 ; i < listaPreguntasPorIntervencion[contadorLista]["cantidad"]; i++ ){
      PreguntaVisita preguntaAux = listaPreguntasPorIntervencion[contadorLista]["preguntas"][i];
      RespuestaVisita respuestaAux = listaPreguntasPorIntervencion[contadorLista]["respuestas"][i];
      informacionColumna.add(preguntaAux.pregunta!);
      informacionColumna.add(respuestaAux.respuesta!);
      informacionTabla.add(informacionColumna);
      informacionColumna = [];
    }
    contadorLista++;

    return Wrap(
      children: [
        Text(
          intervencion.nombre!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Wrap(
          children: [
            Table.fromTextArray(
              headers: headers,
              data: informacionTabla,
              border: TableBorder(),
              headerStyle: TextStyle(fontWeight: FontWeight.bold),
              headerDecoration: BoxDecoration(color: PdfColor.fromHex('b3f17c')),
              cellHeight: 10,
              cellPadding: EdgeInsets.all(10),
              columnWidths: {
                0: FlexColumnWidth(6),
                1: FlexColumnWidth(4),
              },
              cellAlignments: {
                0: Alignment.center,
                1: Alignment.center,
              },
            ),
            Divider(),
          ],
        )
      ],
    );
  }

  Widget buildTablaIntervencionHabitabilidad(Intervencion intervencion)  {

    final headers = [
      'Pregunta',
      'Respuesta',
      'Valor',
    ];

    List<String> informacionColumna = [];
    List<List<String>> informacionTabla = [[]];
    double suma = 0 ;


    for(var i = 0 ; i < listaPreguntasPorIntervencion[contadorLista]["cantidad"]; i++ ){
      PreguntaVisita preguntaAux = listaPreguntasPorIntervencion[contadorLista]["preguntas"][i];
      RespuestaVisita respuestaAux = listaPreguntasPorIntervencion[contadorLista]["respuestas"][i];
      informacionColumna.add(preguntaAux.pregunta!);
      informacionColumna.add(respuestaAux.respuesta!);
      informacionColumna.add(respuestaAux.puntaje!.toString());
      informacionTabla.add(informacionColumna);
      informacionColumna = [];
      suma += respuestaAux.puntaje!;
    }
    contadorLista++;
    sumaTotalCondicionesHabitabilidad += suma;

    return Wrap(
      children: [
        Text(
          intervencion.nombre!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Wrap(
          children: [
            Table.fromTextArray(
              headers: headers,
              data: informacionTabla,
              border: TableBorder(),
              headerStyle: TextStyle(fontWeight: FontWeight.bold),
              headerDecoration: BoxDecoration(color: PdfColor.fromHex('b3f17c')),
              cellHeight: 10,
              columnWidths: {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              cellAlignments: {
                0: Alignment.centerLeft,
                1: Alignment.center,
                2: Alignment.center,
              },
            ),
            Divider(),
            Text('Subtotales: $suma', textAlign: TextAlign.left),
          ],
        )
      ],
    );
  }


  Widget builParteFinalHabitabilidad(){
    int respHabitbilidad = 0;
    for(RespuestaVisita rv in respuestas){
      if(rv.puntaje != -1){
        respHabitbilidad += 1;
      }
    }
    double indice = sumaTotalCondicionesHabitabilidad/respHabitbilidad;
    String rta = 'Muy bueno';
    // verde
    PdfColor color =  PdfColor.fromHex('78ff00');
    if(indice > 0.33 && indice<1){
      rta = 'Bueno';
      color = PdfColor.fromHex('fff22d');
    }
    if(indice < 0.33){
      rta = 'Fallido';
      color = PdfColor.fromHex('ff0000');
    }
    return pw.Column(
      children: [
        buildText(title: 'Total',value: sumaTotalCondicionesHabitabilidad.toStringAsFixed(2)),
        buildText(title: 'Indice',value: indice.toStringAsFixed(2)),
        buildText(title: 'INDICE DE MEJORAMIENTO DE CONDICIONES DE HABITABILIDAD',
            value: rta, styleText: TextStyle(fontSize: 18, background: pw.BoxDecoration(color: color)),
            unite: true
        ),
      ],
    );
  }

  buildImagenes(Obra_intervencion obraIntervencion){
    List<FotoVisita> ?fotos = visita.plFotoVisitas;
    List<FotoVisita> fotosIntervencion = [];
    List<pw.ListView> imageRows = [];

    if(fotos != null){
      for(FotoVisita fv in fotos){
        if(fv.intervencionId == obraIntervencion.plIntervencion!.id
          && obraIntervencion.nroComponente == fv.nroComponente){
          fotosIntervencion.add(fv);
        }
      }
    }

    if(fotosIntervencion.isEmpty){
      return Wrap();
    }

    log("ceil value: " + (fotosIntervencion.length/3).ceil().toString());
    for(int i = 0; i < (fotosIntervencion.length/3).ceil(); i++){
      imageRows.add(pw.ListView.builder(
                    direction: Axis.horizontal,
                    spacing: 4,
                    itemBuilder: (context2, index2) {
                      return pw.Container(
                        width: 150,
                        height: 150,
                        child: pw.FittedBox(
                          child: pw.Image(pw.MemoryImage(fotosIntervencion[i * 3 + index2].imagen!)),
                          fit: BoxFit.cover,
                        ),
                      );
                    }, 
                    itemCount: i + 1 == (fotosIntervencion.length/3).ceil() && fotosIntervencion.length % 3 != 0 ?
                      fotosIntervencion.length % 3 : 3
                  ));
      log("item count " + (fotosIntervencion.length % 3).toString());
    }

    return Wrap(
      children: [
        Text(
          obraIntervencion.plIntervencion!.nombre!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Wrap(
          children: imageRows
        ),
        Divider()
      ],
    );
  }

  buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? styleText,
    bool unite = false,
  }) {
    final style = styleText ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  // getEtapaAvance(PreguntaVisita pregunta) {
  //   String texto = '';

  //   if(pregunta.pregunta! == 'Observaciones'){
  //     return '';
  //   }
  //   switch(pregunta.etapaDeAvance){
  //     case 5:
  //     case 30: texto = 'VoBo 1';
  //       break;
  //     case 60: texto = 'VoBo 2';
  //       break;
  //     case 100: texto = 'VoBo 3';
  //       break;
  //     default: texto = 'Final';
  //     break;
  //   }
  //   return texto;
  // }
}
