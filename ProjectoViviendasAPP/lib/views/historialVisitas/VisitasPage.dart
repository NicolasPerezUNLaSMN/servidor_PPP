import 'package:flutter/material.dart';
import 'package:viviendas/views/crearVisita/VisitaForm.dart';
import 'package:viviendas/views/historialVisitas/VisitaItem.dart';
import 'package:viviendas/model/model.dart';

class VisitasPage extends StatefulWidget {
  VisitasPage(this.obraId, this.vivienda);
  final int obraId;
  final Vivienda vivienda;
  @override
  State<VisitasPage> createState() => _VisitasPageState(obraId, vivienda);
}

class _VisitasPageState extends State<VisitasPage> {
  _VisitasPageState(this.obraId, this.vivienda);
  Vivienda vivienda;
  int obraId;
  List<Visita> visitas = [];
  // Estara en false cuando ya exista una visita final.
  bool agregarVisita = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Arbolada'),
          centerTitle: true,
        ),
        body:
          FutureBuilder(
              future: cargarVisitas(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                      child: Text(
                        'Historial de visitas',
                        style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 32.0,
                        ),
                      ),
                    ),
                    agregarVisita ?
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            heroTag: 'addVisita',
                            backgroundColor: new Color(0XFFDE3184),
                            onPressed:  () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VisitaAgregar(new Visita(), obraId, visitas.length + 1, vivienda)));
                            } ,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        )):
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.amber[500]),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          "OBRA COMPLETA",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(10.0),
                            shrinkWrap: true,
                            itemCount: visitas.length,
                            itemBuilder: (BuildContext context, int index) {
                              return VisitaItem(visitas[index], vivienda.id!);
                            },
                        ),
                      ),
                    ),
                  ]);
                } else{
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
              }),
    );
  }

  cargarVisitas() async{
    final Obra? obra = await Obra().getById(obraId);
    visitas = await obra!.getVisitas()!.toList(preload: true);

    for(var element in visitas){
      if(element.visitaFinal!){
        agregarVisita = false;
      }
    }

    return 'Visitas cargadas';
  }
}
