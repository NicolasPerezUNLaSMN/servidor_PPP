import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/widgets/FileUpload.dart';

class CertificadoAgregar extends StatefulWidget {
  CertificadoAgregar(this._certificado, this.obraId);
  final dynamic _certificado;
  final int obraId;
  @override
  State<StatefulWidget> createState() =>
      CertificadoAddState(_certificado as Certificado, obraId);
}

class CertificadoAddState extends State {
  CertificadoAddState(this.certificado, this.obraId);
  Certificado certificado;
  int obraId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtMonto = TextEditingController();
  final TextEditingController txtFecha = TextEditingController();
  final TextEditingController txtPdf = TextEditingController();
  List<PlatformFile> files = [];

  @override
  void initState() {
    txtMonto.text =
    certificado.monto == null ? '' : certificado.monto.toString();
    txtFecha.text = certificado.fecha == null
        ? ''
        : UITools.convertDate(certificado.fecha!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: (certificado.id == null)
            ? Text('Agregar un nuevo certificado')
            : Text('Editar certificado'),
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
                    buildRowMonto(),
                    buildRowFecha(),
                    FileUpload(files, false),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          save();
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

  Widget buildRowMonto() {
    return TextFormField(
      validator: (value) {
        if (double.tryParse(value!) == null) {
          return 'Ingrese un numero valido (requerido)';
        }

        return null;
      },
      controller: txtMonto,
      decoration: InputDecoration(labelText: 'Monto'),
    );
  }

  Widget buildRowFecha() {
    return TextFormField(
      onTap: () => DatePicker.showDatePicker(context,
          showTitleActions: true,
          theme: UITools.mainDatePickerTheme,
          minTime: DateTime.parse('1900-01-01'),
          onConfirm: (sqfSelectedDate) {
            txtFecha.text = UITools.convertDate(sqfSelectedDate);
            setState(() {
              certificado.fecha = sqfSelectedDate;
            });
          },
          currentTime: DateTime.tryParse(txtFecha.text) ??
              certificado.fecha ??
              DateTime.now(),
          locale: UITools.mainDatePickerLocaleType),
      controller: txtFecha,
      decoration: InputDecoration(labelText: 'Fecha'),
    );
  }

  Widget buildRowPdf() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el archivo correspondiente';
        }
        return null;
      },
      controller: txtPdf,
      decoration: InputDecoration(labelText: 'Pdf'),
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
        await save();
        Navigator.pop(context);
      },
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: const Text('GUARDAR',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 2.0)),
              ),

            ],
          )),
    );
  }

  save() async {
    final _fecha = DateTime.tryParse(txtFecha.text);
    if(files.isEmpty){
      return UITools(context).alertDialog(certificado.saveResult.toString(),
          title: 'guardar Certificado Failed!', callBack: () {});
    }

    certificado
      ..monto = double.tryParse(txtMonto.text)
      ..fecha = _fecha
      ..pdf = File(files.first.path!).readAsBytesSync()
      ..obraId = obraId;

    await certificado.save();
    if (certificado.saveResult!.success) {
      log('Certificado guardado correctamente');
    } else {
      UITools(context).alertDialog(certificado.saveResult.toString(),
          title: 'guardar Certificado Failed!', callBack: () {});
    }
  }
}