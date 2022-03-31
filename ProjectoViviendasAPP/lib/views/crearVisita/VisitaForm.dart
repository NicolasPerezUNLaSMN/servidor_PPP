import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/widgets/PreguntasIntervencionPage.dart';
import 'package:viviendas/views/historialVisitas/VisitasPage.dart';
import 'package:viviendas/widgets/QuestionGroupVertical.dart';
import 'package:viviendas/views/vivienda/ViviendaMap.dart';
import 'package:viviendas/widgets/Dragmarker.dart';
import 'package:geolocator/geolocator.dart';

class VisitaAgregar extends StatefulWidget {
  VisitaAgregar(this._visita, this._obraId, this._numeroVisita, this._vivienda);
  final dynamic _visita;
  final int _obraId;
  final int _numeroVisita;
  final Vivienda _vivienda;
  @override
  State<StatefulWidget> createState() => VisitaAgregarEstado(_visita as Visita, _obraId, _numeroVisita, _vivienda);
}

class VisitaAgregarEstado extends State {
  VisitaAgregarEstado(this.visita, this._obraId, this._numeroVisita, this._vivienda);
  Visita visita;
  int _obraId;
  int _numeroVisita;
  Vivienda _vivienda;
  MapController mapController = MapController();
  List<Obra_intervencion> intervenciones = [];
  List<bool> intervencionesElegidas = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtFecha = TextEditingController();
  final TextEditingController txtNombreRelevador = TextEditingController();
  final TextEditingController txtNombreRepresentanteOSC = TextEditingController();
  final TextEditingController txtObservaciones = TextEditingController();
  final TextEditingController txtInformeId = TextEditingController();

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  final DragMarker dragMarker = DragMarker(
    point: LatLng(0, 0),
    width: 80.0,
    height: 80.0,
    builder: (ctx) => Container( child: Icon(Icons.location_pin, size: 50, color: Colors.red[700]) ),
    onDragEnd: (details,point) { log('Finished Drag $details $point'); },
    updateMapNearEdge: true,
    nearEdgeRatio: 2.0,
    nearEdgeSpeed: 1.0,
  );

  @override
  void initState() {
    txtFecha.text =
    visita.fecha == null ? '' : UITools.convertDate(visita.fecha!);
    txtObservaciones.text =
    visita.observaciones == null ? '' : visita.observaciones.toString();
    txtInformeId.text =
    visita.informeId == null ? '' : visita.informeId.toString();
    txtDateCreated.text = visita.dateCreated == null
        ? ''
        : UITools.convertDate(visita.dateCreated!);
    txtTimeForDateCreated.text = visita.dateCreated == null
        ? ''
        : UITools.convertTime(visita.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(ModalRoute.withName('/ViviendaHome'));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VisitasPage(_obraId, _vivienda)));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: (visita.id == null)
              ? Text('Agregar una nueva visita')
              : Text('Editar visita'),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _vivienda.ubicacion.latitud == null || _vivienda.ubicacion.latitud == 0.0?
                      elegirUbicacion():
                      Text(''),
                      buildRowFecha(),
                      buildRowInformeId(),
                      _numeroVisita != 1 ?
                      buildRowVisitaFinal():
                      buildRowPrimerVisita(),
                      FutureBuilder(
                          future: cargarIntervenciones(),
                          builder: (context, snapshot){
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: QuestionGroupVertical(
                                    question: 'Componentes de intervencion',
                                    opciones: intervenciones.map((e) => e.plIntervencion!).toList(),
                                    respuesta: intervencionesElegidas),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                          saveButton(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget buildRowInformeId() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el id del informe';
        }
        return null;
      },
      controller: txtInformeId,
      decoration: InputDecoration(labelText: 'Informe Id'),
    );
  }

  Widget buildRowFecha() {
    return TextFormField(
      onTap: () => DatePicker.showDatePicker(context,
          showTitleActions: true,
          theme: UITools.mainDatePickerTheme,
          minTime: DateTime.parse('2021-01-01'),
          maxTime: DateTime.now().add(Duration(days: 30)),
          onConfirm: (sqfSelectedDate) {
            txtFecha.text = UITools.convertDate(sqfSelectedDate);
            setState(() {
              visita.fecha = sqfSelectedDate;
            });
          },
          currentTime: DateTime.tryParse(txtFecha.text) ??
              visita.fecha ??
              DateTime.now(),
          locale: UITools.mainDatePickerLocaleType),
      controller: txtFecha,
      decoration: InputDecoration(labelText: 'Fecha'),
    );
  }

  Widget buildRowVisitaFinal() {
    return Row(
      children: <Widget>[
        Text('Es visita final?'),
        Checkbox(
          value: visita.visitaFinal ?? false,
          onChanged: (bool? value) {
            setState(() {
              visita.visitaFinal = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowPrimerVisita() {
    return Row(
      children: [
        Text('Primer visita'),
        Checkbox(
          value: true,
          fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.primary),
          onChanged: null
        )
      ]
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        minimumSize: Size(double.infinity,
            30), // double.infinity is the width and 30 is the height
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          List<Obra_intervencion> listaIntervencion = obtenerIntervencionesElegidas();
          if(listaIntervencion.isNotEmpty) {
            await save();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreguntasIntervencionPage(visita, listaIntervencion, _vivienda.id!)));
          }
          else{
            UITools(context).alertDialog('Debe seleccionar aunque sea un componente de intervencion',
              title: 'Error', callBack: () {});
          }
        }
      },
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: const Text('SIGUIENTE PASO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 2.0)),
              ),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          )),
    );
  }

  Future<void> save() async {
    final _fecha = DateTime.tryParse(txtFecha.text);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    visita
      ..numVisita = _numeroVisita
      ..fecha = _fecha
      ..informeId = int.parse(txtInformeId.text)
      ..nombreRelevador = preferences.getString("nombre")
      ..observaciones = 'Sin observaciones'
      ..obraId = _obraId;
    int? id = await visita.save();

    if (visita.saveResult!.success) {
      visita.id = id;
      if(_vivienda.ubicacion.latitud == null || _vivienda.ubicacion.latitud == 0.0){
        _vivienda.ubicacion
          ..latitud = dragMarker.point.latitude
          ..longitud = dragMarker.point.longitude;
        await _vivienda.save();

        if(!_vivienda.saveResult!.success){
          UITools(context).alertDialog(_vivienda.saveResult.toString(),
              title: 'Hubo un fallo! Intentelo de nuevo', callBack: () {});
        }
      }
    } else {
      UITools(context).alertDialog(visita.saveResult.toString(),
          title: 'Hubo un fallo! Intentelo de nuevo', callBack: () {});
    }
  }

  cargarIntervenciones() async{
    final Obra? obra = await Obra().getById(_obraId);
    intervenciones = await obra!.getObra_intervencions()!.groupBy('intervencionId').toList(preload: true);

    for(Obra_intervencion oi in intervenciones){
      log("nroComponente: ${oi.nroComponente}");
    }

    return intervenciones;
  }

  obtenerIntervencionesElegidas(){
    List<Obra_intervencion> listaIntervencion =[];

    for(var i = 0 ; i < intervenciones.length ; i++){
      if(intervencionesElegidas[i]){
        listaIntervencion.add(intervenciones[i]);
      }
    }
    return listaIntervencion;
  }

  Future<List<double>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    List<double> coordenadas =[];
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      UITools(context).alertDialog("Los servicios de ubicación están deshabilitados.",
          title: 'Error', callBack: () {});
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        UITools(context).alertDialog("Los permisos de ubicación estan bloqueados.",
            title: 'Error', callBack: () {});
        return Future.error('Los permisos de ubicación estan bloqueados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      UITools(context).alertDialog("Los permisos de ubicación fueron rechazados permanentemente, no podemos solicitar permisos.",
          title: 'Error', callBack: () {});
      return Future.error(
          'Los permisos de ubicación fueron rechazados permanentemente, no podemos solicitar permisos.');
    }

    Position position = await Geolocator.getCurrentPosition();
    coordenadas.add(position.latitude);
    coordenadas.add(position.longitude);
    return coordenadas;
  }

  Widget elegirUbicacion(){
    return FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<double> coordenadas = snapshot.data as List<double>;
            return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Seleccionar ubicacion',
                      style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    child: ViviendaMap(
                        latitud: coordenadas[0],
                        longitud: coordenadas[1],
                        dragable: true,
                        dragMarker: dragMarker,
                        mapController: mapController),
                  )
                ]
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
                    child: Text('Cargando mapa para poder\nseleccionar su ubicacion...\n\nSi el proceso tarda revise si tiene activado los\npermisos de ubicacion en su dispositivo'),
                  )
                ]
            );
          }
        });
  }
}