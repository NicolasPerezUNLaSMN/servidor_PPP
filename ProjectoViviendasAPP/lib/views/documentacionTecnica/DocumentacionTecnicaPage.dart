import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/generarPdf.dart';
import 'package:viviendas/tools/helper.dart';

class DocumentacionTecnicaPage extends StatefulWidget {
  DocumentacionTecnicaPage(this.documentacion);
  final DocumentacionTecnica documentacion;
  @override
  State<DocumentacionTecnicaPage> createState() =>
      DocumentacionTecnicaPageState(documentacion);
}

class DocumentacionTecnicaPageState extends State<DocumentacionTecnicaPage> {
  DocumentacionTecnicaPageState(this.documentacion);
  DocumentacionTecnica documentacion;
  List<Uint8List?> documentos = [];
  List<String> nombres = [];

  @override
  void initState(){
    List<Uint8List?> documentosTemp = [documentacion.datos, documentacion.computo, documentacion.planosDeObra,
      documentacion.cuadrillaDeTrabajadores, documentacion.sintesisDiagnosticoDeViviendas, 
      documentacion.certificadoAvanceObra, documentacion.planDeObra, documentacion.diagramaGantt];
    List<String> nombresTemp = ['Datos', 'Computo de Materiales', 'Planos de Obra',
      'Cuadrilla de Trabajadores', 'Sintesis Diagnostico de Vivienda',
      'Certificado de Avance de Obra', 'Plan de Obra', 'Diagrama Gantt'];

    for(int i = 0; i < documentosTemp.length; i++){
      if(documentosTemp[i] != null){
        documentos.add(documentosTemp[i]);
        nombres.add(nombresTemp[i]);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbolada'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                child: Text(
                  'Documentacion Tecnica',
                  style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32.0,
                      ),
                ),
              ),
              documentos.isEmpty
              ?
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info, 
                      color: Colors.blue,
                      size: 54.0
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'No se encontraron documentos para esta obra',
                          style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                            color: Colors.grey[700],
                            fontSize: 24.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ]
                ),
              )
              :
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: ListView.builder(
                  key: UniqueKey(),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        try{
                          Directory directory = await getApplicationDocumentsDirectory();
                          String path = directory.path;
                          File downloadPdf = await File(path + nombres[index] + UniqueKey().toString() + '.pdf').writeAsBytes(documentos[index]!);
                          GenerarPdf.openFile(downloadPdf);
                        } catch(e){
                          UITools(context).alertDialog(e.toString(),
                            title: 'Hubo un fallo! Intentelo de nuevo', callBack: () {});
                        }
                      },
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.file_present_sharp),
                          title: Text(nombres[index]),
                          trailing: Icon(Icons.file_download_outlined),
                        ),
                      ),
                    );
                  },
                  itemCount: documentos.length,
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}