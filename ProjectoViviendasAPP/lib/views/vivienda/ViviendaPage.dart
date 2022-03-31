import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:viviendas/model/model.dart';
import 'package:viviendas/views/vivienda/ViviendaMap.dart';
import 'package:viviendas/views/vivienda/ViviendaCard.dart';
import 'package:viviendas/views/obra/ObraPage.dart';
import 'package:viviendas/views/documentacionTecnica/DocumentacionTecnicaPage.dart';

import '../cuestionarioHabitabilidad/HabitabilidadCuestionarioPage.dart';


class ViviendaPage extends StatefulWidget {
  final Vivienda vivienda;
  ViviendaPage(this.vivienda);

  @override
  State<ViviendaPage> createState() => _ViviendaPageState();
}

class _ViviendaPageState extends State<ViviendaPage> {
  int? idObra;

  List<Widget> bottomPages = [];

  ViviendaCard ?viviendaCard;
  MapController mapController = MapController();
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.file_present), label: 'Tecnico'),
    BottomNavigationBarItem(
      icon: Icon(Icons.construction), label: 'Obra'),
  ];
  bool showDetails = true;

  @override
  void initState(){
    viviendaCard = ViviendaCard(widget.vivienda);
    super.initState();
    if(widget.vivienda.cuestionarioHabitabilidad!){
      bottomItems.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.family_restroom), label: 'Habitabilidad')
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    searchIdObra();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbolada'),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Expanded(
            child: Stack(children: [
              widget.vivienda.ubicacion.latitud != null && widget.vivienda.ubicacion.latitud != 0.0
                ? ViviendaMap(
                  latitud: widget.vivienda.ubicacion.latitud, 
                  longitud: widget.vivienda.ubicacion.longitud,
                  mapController: mapController)
                : ViviendaMap(
                  latitud: -34.735784, 
                  longitud: -58.391199,
                  interaccion: 0,
                  mapController: mapController),
              widget.vivienda.ubicacion.latitud != null && widget.vivienda.ubicacion.latitud != 0.0
                ? Text('')
                : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        color: Colors.red[700],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No hay una direccion guardada',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        heroTag: 'hideButton',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            showDetails = !showDetails;
                          });
                        },
                        child: Icon(Icons.remove_red_eye_outlined,
                            color: new Color(0XFF31DE8B))),
                  ))
            ])),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image:
              /*widget.vivienda.plFotoViviendas != null
                ? DecorationImage(
                    image: MemoryImage(widget.vivienda.plFotoViviendas![0].imagen!),
                    fit: BoxFit.cover)
                : */DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.cover)
            ),
            child: showDetails ? viviendaCard! : Card(child: Row(children:[]), color: Colors.transparent, elevation: 0)
          )
        )
      ]),
      bottomNavigationBar: FutureBuilder(
          future: searchIdObra(),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return BottomNavigationBar(
                onTap: (int index) {
                  bottomPages = [
                    DocumentacionTecnicaPage(widget.vivienda.documentaciontecnica), 
                    ObraPage(idObra!, widget.vivienda), 
                    HabitabilidadCuestionarioPage(widget.vivienda)
                  ];
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => bottomPages[index]))
                      .then((_) => setState(() {
                        if(widget.vivienda.ubicacion.latitud != null && widget.vivienda.ubicacion.latitud != 0.0){
                          mapController.move(LatLng(widget.vivienda.ubicacion.latitud!, 
                            widget.vivienda.ubicacion.longitud!), 13.0);
                        } else{
                          mapController.move(LatLng(-34.735784, -58.391199), 13.0);
                        }
                      }));
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: new Color(0xFF31DE8B),
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white,
                items: bottomItems,
              );
            } else {
              return CircularProgressIndicator();
            }
          }
      ),
    );
  }

  Future<String> searchIdObra () async {
    Obra? obra = await widget.vivienda.documentaciontecnica.getObra();
    idObra = obra!.id;
    return 'Datos cargados correctamente';
  }
}
