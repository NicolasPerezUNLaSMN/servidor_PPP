import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/views/certificados/CertificadoForm.dart';
import 'package:viviendas/views/certificados/CertificadoItem.dart';

class CertificadosPage extends StatefulWidget {
  CertificadosPage(this.idObra);
  final int idObra;

  @override
  State<CertificadosPage> createState() => _CertificadosPageState();
}

class _CertificadosPageState extends State<CertificadosPage> {
  bool agregarCertificadoBoton = true;

  List<Certificado> listaCertificados = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: obtenerCertificados(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Scaffold(
              appBar: AppBar(
                title: const Text('Arbolada'),
                centerTitle: true,
              ),
              body: Column(children: <Widget>[
                Expanded(
                  child:
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: listaCertificados.length,
                      itemBuilder: (BuildContext context, int index) {
                        Text('Certificado ${index+1}:');
                        return CertificadoItem(listaCertificados[index]);

                      }
                  ),
                ),
                Container(
                    child: Stack(children: [
                      agregarCertificadoBoton ?
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                                heroTag: 'addCertificado',
                                backgroundColor: new Color(0XFFDE3184),
                                onPressed: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => 
                                        CertificadoAgregar(new Certificado(), widget.idObra))).then((_) => setState(() {}));
                                },
                                child: Icon(Icons.add, color: Colors.white)),
                          )):
                      Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.amber[500]),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "CERTIFICADOS COMPLETOS",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ])),
              ]),
            );
          }
          else{
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
    );
  }

  Future<String> obtenerCertificados() async {
    Obra? obra = await Obra().getById(widget.idObra);
    listaCertificados = await obra!.getCertificados()!.toList(preload: true);
    if(listaCertificados.length >= 3){
      agregarCertificadoBoton = false;
    }
    return 'Certificados cargados correctamente';
  }
}
