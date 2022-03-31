import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/views/login/LoginPage.dart';

class UbicacionAgregar extends StatefulWidget {
  UbicacionAgregar(this._ubicacion, this._vivienda);
  final dynamic _ubicacion;
  final dynamic _vivienda;
  @override
  State<StatefulWidget> createState() =>
      UbicacionAddState(_ubicacion as Ubicacion, _vivienda as Vivienda);
}

class UbicacionAddState extends State {
  UbicacionAddState(this.ubicacion, this.vivienda);
  Ubicacion ubicacion;
  Vivienda vivienda;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtRegion = TextEditingController();
  final TextEditingController txtProvincia = TextEditingController();
  final TextEditingController txtBarrio = TextEditingController();
  final TextEditingController txtDireccion = TextEditingController();
  final TextEditingController txtPlanta = TextEditingController();
  final TextEditingController txtLatitud = TextEditingController();
  final TextEditingController txtLongitud = TextEditingController();
  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtRegion.text =
    ubicacion.region == null ? '' : ubicacion.region.toString();
    txtProvincia.text =
    ubicacion.provincia == null ? '' : ubicacion.provincia.toString();
    txtBarrio.text =
    ubicacion.barrio == null ? '' : ubicacion.barrio.toString();
    txtDireccion.text =
    ubicacion.direccion == null ? '' : ubicacion.direccion.toString();
    txtPlanta.text =
    ubicacion.planta == null ? '' : ubicacion.planta.toString();
    txtLatitud.text =
    ubicacion.latitud == null ? '' : ubicacion.latitud.toString();
    txtLongitud.text =
    ubicacion.longitud == null ? '' : ubicacion.longitud.toString();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new ubicacion')
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
                    buildRowRegion(),
                    buildRowProvincia(),
                    buildRowBarrio(),
                    buildRowDireccion(),
                    buildRowPlanta(),
                    buildRowLatitud(),
                    buildRowLongitud(),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
                        }
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowRegion() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Region';
        }
        return null;
      },
      controller: txtRegion,
      decoration: InputDecoration(labelText: 'Region'),
    );
  }

  Widget buildRowProvincia() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Provincia';
        }
        return null;
      },
      controller: txtProvincia,
      decoration: InputDecoration(labelText: 'Provincia'),
    );
  }

  Widget buildRowBarrio() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Barrio';
        }
        return null;
      },
      controller: txtBarrio,
      decoration: InputDecoration(labelText: 'Barrio'),
    );
  }

  Widget buildRowDireccion() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Direccion';
        }
        return null;
      },
      controller: txtDireccion,
      decoration: InputDecoration(labelText: 'Direccion'),
    );
  }

  Widget buildRowPlanta() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Planta';
        }
        return null;
      },
      controller: txtPlanta,
      decoration: InputDecoration(labelText: 'Planta'),
    );
  }

  Widget buildRowLatitud() {
    return TextFormField(
      validator: (value) {
        if (double.tryParse(value!) == null) {
          return 'Please Enter valid number (required)';
        }

        return null;
      },
      controller: txtLatitud,
      decoration: InputDecoration(labelText: 'Latitud'),
    );
  }

  Widget buildRowLongitud() {
    return TextFormField(
      validator: (value) {
        if (double.tryParse(value!) == null) {
          return 'Please Enter valid number (required)';
        }

        return null;
      },
      controller: txtLongitud,
      decoration: InputDecoration(labelText: 'Longitud'),
    );
  }

  Container saveButton() {
    return Container(
      child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          minimumSize: Size(double.infinity,
              30), // double.infinity is the width and 30 is the height
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            save();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()));
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: const Text('GUARDAR VIVIENDA',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          letterSpacing: 2.0)),
                ),
              ],
            )),
      ),
    );
  }

  void save() async {
    ubicacion
      ..region = txtRegion.text
      ..provincia = txtProvincia.text
      ..barrio = txtBarrio.text
      ..direccion = txtDireccion.text
      ..planta = txtPlanta.text
      ..latitud = double.tryParse(txtLatitud.text)
      ..longitud = double.tryParse(txtLongitud.text);
    vivienda.ubicacion = ubicacion;
    await vivienda.save();
    if (vivienda.saveResult!.success) {
      //Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(ubicacion.saveResult.toString(),
          title: 'save Ubicacion Failed!', callBack: () {});
    }
  }
}