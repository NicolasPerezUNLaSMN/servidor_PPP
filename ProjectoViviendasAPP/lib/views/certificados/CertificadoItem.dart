import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/Servidor.dart';
import 'package:viviendas/tools/generarPdf.dart';
import 'package:viviendas/tools/helper.dart';

class CertificadoItem extends StatefulWidget {
  CertificadoItem (this.certificado);

  final Certificado certificado;
  @override
  State<CertificadoItem > createState() => _CertificadosItemState(this.certificado);
}

class _CertificadosItemState extends State<CertificadoItem> {
  _CertificadosItemState(this.certificado);
  Certificado certificado;

  bool botonGuardadoServidor = false;

  @override
  Widget build(BuildContext context) {
    botonGuardadoServidor = certificado.cargadoServidor!;
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MONTO'),
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(180, 238, 177, 0.5)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(certificado.monto.toString()),
                        ),
                      ),
                    ]
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('FECHA'),
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(180, 238, 177, 0.5)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            construirFecha(certificado.fecha!),
                          ),
                        ),
                      ),
                    ]
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Archivo pdf:'),
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(180, 238, 177, 0.5)),
                        child: new GestureDetector(
                          onTap: () async {
                            File pdf = await GenerarPdf.saveDocument(name: 'Informe_de_visita.pdf', pdf: pw.Document(), rawPdf: certificado.pdf!);
                            GenerarPdf.openFile(pdf);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Descargar archivo',
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      botonGuardadoServidor?
                      certificadoCargado():
                      botonGuardarServidor()
                    ]
                ),
              ]
          )
      ),
    );
  }

  Widget certificadoCargado(){
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(10.0)),
          color: Color.fromRGBO(171, 202, 125, 0.5)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          "Certificado cargado en el servidor",
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  Widget botonGuardarServidor(){
    return Container(
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              padding: MaterialStateProperty.all(EdgeInsets.all(20)),
              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30))),
          onPressed: () async{
            Certificado? guardado = await Servidor.createCertificado(certificado);

            if(guardado != null){
              certificado.cargadoServidor = true;
              await certificado.save();
              setState(() {
                botonGuardadoServidor = true;
              });
            }else{
              UITools(context).alertDialog("Hubo un error guardando el certificado en el servidor.\nIntentelo de nuevo mas tarde.",
                  title: 'Error', callBack: () {});
            }
          },
          child: Text('Guardar en el servidor',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 2.0)),
        ),
      ),
    );
  }

  String construirFecha(DateTime fecha){
    final meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

    String fechaTexto = fecha.day.toString() + ' de '
        + meses[fecha.month - 1] + ' de '
        + fecha.year.toString();
    return fechaTexto;
  }
}