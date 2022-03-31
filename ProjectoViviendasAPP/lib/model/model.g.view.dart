// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

part of 'model.dart';

class ObraAdd extends StatefulWidget {
  ObraAdd(this._obra);
  final dynamic _obra;
  @override
  State<StatefulWidget> createState() => ObraAddState(_obra as Obra);
}

class ObraAddState extends State {
  ObraAddState(this.obra);
  Obra obra;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtNombreRepresentanteOSC =
      TextEditingController();
  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtNombreRepresentanteOSC.text = obra.nombreRepresentanteOSC == null
        ? ''
        : obra.nombreRepresentanteOSC.toString();
    txtDateCreated.text =
        obra.dateCreated == null ? '' : UITools.convertDate(obra.dateCreated!);
    txtTimeForDateCreated.text =
        obra.dateCreated == null ? '' : UITools.convertTime(obra.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (obra.id == null) ? Text('Add a new obra') : Text('Edit obra'),
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
                    buildRowId(),
                    buildRowNombreRepresentanteOSC(),
                    buildRowDateCreated(),
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

  Widget buildRowId() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtId,
      decoration: InputDecoration(labelText: 'Id'),
    );
  }

  Widget buildRowNombreRepresentanteOSC() {
    return TextFormField(
      controller: txtNombreRepresentanteOSC,
      decoration: InputDecoration(labelText: 'NombreRepresentanteOSC'),
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  obra.dateCreated ??
                  DateTime.now();
              obra.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  obra.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    obra.dateCreated ??
                    DateTime.now();
                obra.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text = UITools.convertDate(obra.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    obra.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    obra
      ..id = int.tryParse(txtId.text)
      ..nombreRepresentanteOSC = txtNombreRepresentanteOSC.text
      ..dateCreated = _dateCreated;
    await obra.save();
    if (obra.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(obra.saveResult.toString(),
          title: 'save Obra Failed!', callBack: () {});
    }
  }
}

class ViviendaAdd extends StatefulWidget {
  ViviendaAdd(this._vivienda);
  final dynamic _vivienda;
  @override
  State<StatefulWidget> createState() =>
      ViviendaAddState(_vivienda as Vivienda);
}

class ViviendaAddState extends State {
  ViviendaAddState(this.vivienda);
  Vivienda vivienda;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtAliasRenabap = TextEditingController();
  final TextEditingController txtViviendaId = TextEditingController();
  final TextEditingController txtMetrosCuadrados = TextEditingController();
  final TextEditingController txtAmbientes = TextEditingController();

  final TextEditingController txtTitular = TextEditingController();
  final TextEditingController txtContactoJefeHogar = TextEditingController();
  final TextEditingController txtContactoReferencia = TextEditingController();
  final TextEditingController txtJefeHogarNombre = TextEditingController();
  final TextEditingController txtCantHabitantes = TextEditingController();
  final TextEditingController txtHabitantesAdultos = TextEditingController();
  final TextEditingController txtHabitantesMenores = TextEditingController();
  final TextEditingController txtHabitantesMayores = TextEditingController();

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtAliasRenabap.text =
        vivienda.aliasRenabap == null ? '' : vivienda.aliasRenabap.toString();
    txtViviendaId.text =
        vivienda.viviendaId == null ? '' : vivienda.viviendaId.toString();
    txtMetrosCuadrados.text = vivienda.metrosCuadrados == null
        ? ''
        : vivienda.metrosCuadrados.toString();
    txtAmbientes.text =
        vivienda.ambientes == null ? '' : vivienda.ambientes.toString();

    txtTitular.text =
        vivienda.titular == null ? '' : vivienda.titular.toString();
    txtContactoJefeHogar.text = vivienda.contactoJefeHogar == null
        ? ''
        : vivienda.contactoJefeHogar.toString();
    txtContactoReferencia.text = vivienda.contactoReferencia == null
        ? ''
        : vivienda.contactoReferencia.toString();
    txtJefeHogarNombre.text = vivienda.jefeHogarNombre == null
        ? ''
        : vivienda.jefeHogarNombre.toString();
    txtCantHabitantes.text = vivienda.cantHabitantes == null
        ? ''
        : vivienda.cantHabitantes.toString();
    txtHabitantesAdultos.text = vivienda.habitantesAdultos == null
        ? ''
        : vivienda.habitantesAdultos.toString();
    txtHabitantesMenores.text = vivienda.habitantesMenores == null
        ? ''
        : vivienda.habitantesMenores.toString();
    txtHabitantesMayores.text = vivienda.habitantesMayores == null
        ? ''
        : vivienda.habitantesMayores.toString();

    txtDateCreated.text = vivienda.dateCreated == null
        ? ''
        : UITools.convertDate(vivienda.dateCreated!);
    txtTimeForDateCreated.text = vivienda.dateCreated == null
        ? ''
        : UITools.convertTime(vivienda.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (vivienda.id == null)
            ? Text('Add a new vivienda')
            : Text('Edit vivienda'),
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
                    buildRowId(),
                    buildRowAliasRenabap(),
                    buildRowViviendaId(),
                    buildRowMetrosCuadrados(),
                    buildRowAmbientes(),
                    buildRowDirectoACalle(),
                    buildRowServicioCloacas(),
                    buildRowServicioLuz(),
                    buildRowServicioAgua(),
                    buildRowServicioGas(),
                    buildRowServicioInternet(),
                    buildRowReubicados(),
                    buildRowTitular(),
                    buildRowContactoJefeHogar(),
                    buildRowContactoReferencia(),
                    buildRowJefeHogarNombre(),
                    buildRowCantHabitantes(),
                    buildRowHabitantesAdultos(),
                    buildRowHabitantesMenores(),
                    buildRowHabitantesMayores(),
                    buildRowDuenosVivienda(),
                    buildRowPreguntasPgas(),
                    buildRowCuestionarioHabitabilidad(),
                    buildRowDateCreated(),
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

  Widget buildRowId() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtId,
      decoration: InputDecoration(labelText: 'Id'),
    );
  }

  Widget buildRowAliasRenabap() {
    return TextFormField(
      controller: txtAliasRenabap,
      decoration: InputDecoration(labelText: 'AliasRenabap'),
    );
  }

  Widget buildRowViviendaId() {
    return TextFormField(
      controller: txtViviendaId,
      decoration: InputDecoration(labelText: 'ViviendaId'),
    );
  }

  Widget buildRowMetrosCuadrados() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtMetrosCuadrados,
      decoration: InputDecoration(labelText: 'MetrosCuadrados'),
    );
  }

  Widget buildRowAmbientes() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtAmbientes,
      decoration: InputDecoration(labelText: 'Ambientes'),
    );
  }

  Widget buildRowDirectoACalle() {
    return Row(
      children: <Widget>[
        Text('DirectoACalle?'),
        Checkbox(
          value: vivienda.directoACalle ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.directoACalle = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowServicioCloacas() {
    return Row(
      children: <Widget>[
        Text('ServicioCloacas?'),
        Checkbox(
          value: vivienda.servicioCloacas ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.servicioCloacas = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowServicioLuz() {
    return Row(
      children: <Widget>[
        Text('ServicioLuz?'),
        Checkbox(
          value: vivienda.servicioLuz ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.servicioLuz = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowServicioAgua() {
    return Row(
      children: <Widget>[
        Text('ServicioAgua?'),
        Checkbox(
          value: vivienda.servicioAgua ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.servicioAgua = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowServicioGas() {
    return Row(
      children: <Widget>[
        Text('ServicioGas?'),
        Checkbox(
          value: vivienda.servicioGas ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.servicioGas = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowServicioInternet() {
    return Row(
      children: <Widget>[
        Text('ServicioInternet?'),
        Checkbox(
          value: vivienda.servicioInternet ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.servicioInternet = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowReubicados() {
    return Row(
      children: <Widget>[
        Text('Reubicados?'),
        Checkbox(
          value: vivienda.reubicados ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.reubicados = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowTitular() {
    return TextFormField(
      controller: txtTitular,
      decoration: InputDecoration(labelText: 'Titular'),
    );
  }

  Widget buildRowContactoJefeHogar() {
    return TextFormField(
      controller: txtContactoJefeHogar,
      decoration: InputDecoration(labelText: 'ContactoJefeHogar'),
    );
  }

  Widget buildRowContactoReferencia() {
    return TextFormField(
      controller: txtContactoReferencia,
      decoration: InputDecoration(labelText: 'ContactoReferencia'),
    );
  }

  Widget buildRowJefeHogarNombre() {
    return TextFormField(
      controller: txtJefeHogarNombre,
      decoration: InputDecoration(labelText: 'JefeHogarNombre'),
    );
  }

  Widget buildRowCantHabitantes() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtCantHabitantes,
      decoration: InputDecoration(labelText: 'CantHabitantes'),
    );
  }

  Widget buildRowHabitantesAdultos() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtHabitantesAdultos,
      decoration: InputDecoration(labelText: 'HabitantesAdultos'),
    );
  }

  Widget buildRowHabitantesMenores() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtHabitantesMenores,
      decoration: InputDecoration(labelText: 'HabitantesMenores'),
    );
  }

  Widget buildRowHabitantesMayores() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtHabitantesMayores,
      decoration: InputDecoration(labelText: 'HabitantesMayores'),
    );
  }

  Widget buildRowDuenosVivienda() {
    return Row(
      children: <Widget>[
        Text('DuenosVivienda?'),
        Checkbox(
          value: vivienda.duenosVivienda ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.duenosVivienda = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowPreguntasPgas() {
    return Row(
      children: <Widget>[
        Text('PreguntasPgas?'),
        Checkbox(
          value: vivienda.preguntasPgas ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.preguntasPgas = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowCuestionarioHabitabilidad() {
    return Row(
      children: <Widget>[
        Text('CuestionarioHabitabilidad?'),
        Checkbox(
          value: vivienda.cuestionarioHabitabilidad ?? false,
          onChanged: (bool? value) {
            setState(() {
              vivienda.cuestionarioHabitabilidad = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  vivienda.dateCreated ??
                  DateTime.now();
              vivienda.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  vivienda.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    vivienda.dateCreated ??
                    DateTime.now();
                vivienda.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(vivienda.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    vivienda.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    vivienda
      ..id = int.tryParse(txtId.text)
      ..aliasRenabap = txtAliasRenabap.text
      ..viviendaId = txtViviendaId.text
      ..metrosCuadrados = int.tryParse(txtMetrosCuadrados.text)
      ..ambientes = int.tryParse(txtAmbientes.text)
      ..titular = txtTitular.text
      ..contactoJefeHogar = txtContactoJefeHogar.text
      ..contactoReferencia = txtContactoReferencia.text
      ..jefeHogarNombre = txtJefeHogarNombre.text
      ..cantHabitantes = int.tryParse(txtCantHabitantes.text)
      ..habitantesAdultos = int.tryParse(txtHabitantesAdultos.text)
      ..habitantesMenores = int.tryParse(txtHabitantesMenores.text)
      ..habitantesMayores = int.tryParse(txtHabitantesMayores.text)
      ..dateCreated = _dateCreated;
    await vivienda.save();
    if (vivienda.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(vivienda.saveResult.toString(),
          title: 'save Vivienda Failed!', callBack: () {});
    }
  }
}

class CertificadoAdd extends StatefulWidget {
  CertificadoAdd(this._certificado);
  final dynamic _certificado;
  @override
  State<StatefulWidget> createState() =>
      CertificadoAddState(_certificado as Certificado);
}

class CertificadoAddState extends State {
  CertificadoAddState(this.certificado);
  Certificado certificado;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtMonto = TextEditingController();
  final TextEditingController txtFecha = TextEditingController();
  final TextEditingController txtPdf = TextEditingController();

  List<DropdownMenuItem<int>> _dropdownMenuItemsForObraId =
      <DropdownMenuItem<int>>[];
  int? _selectedObraId;

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtMonto.text =
        certificado.monto == null ? '' : certificado.monto.toString();
    txtFecha.text = certificado.fecha == null
        ? ''
        : UITools.convertDate(certificado.fecha!);
    txtPdf.text = certificado.pdf == null ? '' : certificado.pdf.toString();

    txtDateCreated.text = certificado.dateCreated == null
        ? ''
        : UITools.convertDate(certificado.dateCreated!);
    txtTimeForDateCreated.text = certificado.dateCreated == null
        ? ''
        : UITools.convertTime(certificado.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForObraId() async {
      final dropdownMenuItems =
          await Obra().select().toDropDownMenuInt('nombreRepresentanteOSC');
      setState(() {
        _dropdownMenuItemsForObraId = dropdownMenuItems;
        _selectedObraId = certificado.obraId;
      });
    }

    if (_dropdownMenuItemsForObraId.isEmpty) {
      buildDropDownMenuForObraId();
    }
    void onChangeDropdownItemForObraId(int? selectedObraId) {
      setState(() {
        _selectedObraId = selectedObraId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (certificado.id == null)
            ? Text('Add a new certificado')
            : Text('Edit certificado'),
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
                    buildRowPdf(),
                    buildRowCargadoServidor(),
                    buildRowObraId(onChangeDropdownItemForObraId),
                    buildRowDateCreated(),
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

  Widget buildRowMonto() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && double.tryParse(value) == null) {
          return 'Please Enter valid number';
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
          minTime: DateTime.parse('1900-01-01'), onConfirm: (sqfSelectedDate) {
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
      controller: txtPdf,
      decoration: InputDecoration(labelText: 'Pdf'),
    );
  }

  Widget buildRowCargadoServidor() {
    return Row(
      children: <Widget>[
        Text('CargadoServidor?'),
        Checkbox(
          value: certificado.cargadoServidor ?? false,
          onChanged: (bool? value) {
            setState(() {
              certificado.cargadoServidor = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowObraId(
      void Function(int? selectedObraId) onChangeDropdownItemForObraId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Obra'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedObraId,
                items: _dropdownMenuItemsForObraId,
                onChanged: onChangeDropdownItemForObraId,
                validator: (value) {
                  if ((_selectedObraId != null &&
                      _selectedObraId.toString() != '0')) {
                    return null;
                  } else if (value == null || value == 0) {
                    return 'Please enter Obra';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  certificado.dateCreated ??
                  DateTime.now();
              certificado.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  certificado.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    certificado.dateCreated ??
                    DateTime.now();
                certificado.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(certificado.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    certificado.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    final _fecha = DateTime.tryParse(txtFecha.text);
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    certificado
      ..monto = double.tryParse(txtMonto.text)
      ..fecha = _fecha
      ..pdf = txtPdf.text as Uint8List
      ..obraId = _selectedObraId
      ..dateCreated = _dateCreated;
    await certificado.save();
    if (certificado.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(certificado.saveResult.toString(),
          title: 'save Certificado Failed!', callBack: () {});
    }
  }
}

class VisitaAdd extends StatefulWidget {
  VisitaAdd(this._visita);
  final dynamic _visita;
  @override
  State<StatefulWidget> createState() => VisitaAddState(_visita as Visita);
}

class VisitaAddState extends State {
  VisitaAddState(this.visita);
  Visita visita;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtNumVisita = TextEditingController();
  final TextEditingController txtInformeId = TextEditingController();
  final TextEditingController txtFecha = TextEditingController();
  final TextEditingController txtNombreRelevador = TextEditingController();
  final TextEditingController txtObservaciones = TextEditingController();

  List<DropdownMenuItem<int>> _dropdownMenuItemsForObraId =
      <DropdownMenuItem<int>>[];
  int? _selectedObraId;

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtNumVisita.text =
        visita.numVisita == null ? '' : visita.numVisita.toString();
    txtInformeId.text =
        visita.informeId == null ? '' : visita.informeId.toString();
    txtFecha.text =
        visita.fecha == null ? '' : UITools.convertDate(visita.fecha!);
    txtNombreRelevador.text =
        visita.nombreRelevador == null ? '' : visita.nombreRelevador.toString();
    txtObservaciones.text =
        visita.observaciones == null ? '' : visita.observaciones.toString();

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
    void buildDropDownMenuForObraId() async {
      final dropdownMenuItems =
          await Obra().select().toDropDownMenuInt('nombreRepresentanteOSC');
      setState(() {
        _dropdownMenuItemsForObraId = dropdownMenuItems;
        _selectedObraId = visita.obraId;
      });
    }

    if (_dropdownMenuItemsForObraId.isEmpty) {
      buildDropDownMenuForObraId();
    }
    void onChangeDropdownItemForObraId(int? selectedObraId) {
      setState(() {
        _selectedObraId = selectedObraId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (visita.id == null)
            ? Text('Add a new visita')
            : Text('Edit visita'),
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
                    buildRowNumVisita(),
                    buildRowInformeId(),
                    buildRowFecha(),
                    buildRowNombreRelevador(),
                    buildRowObservaciones(),
                    buildRowVisitaFinal(),
                    buildRowCargadoServidor(),
                    buildRowObraId(onChangeDropdownItemForObraId),
                    buildRowDateCreated(),
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

  Widget buildRowNumVisita() {
    return TextFormField(
      validator: (value) {
        if (int.tryParse(value!) == null) {
          return 'Please Enter valid number (required)';
        }

        return null;
      },
      controller: txtNumVisita,
      decoration: InputDecoration(labelText: 'NumVisita'),
    );
  }

  Widget buildRowInformeId() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtInformeId,
      decoration: InputDecoration(labelText: 'InformeId'),
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

  Widget buildRowNombreRelevador() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter NombreRelevador';
        }
        return null;
      },
      controller: txtNombreRelevador,
      decoration: InputDecoration(labelText: 'NombreRelevador'),
    );
  }

  Widget buildRowObservaciones() {
    return TextFormField(
      controller: txtObservaciones,
      decoration: InputDecoration(labelText: 'Observaciones'),
    );
  }

  Widget buildRowVisitaFinal() {
    return Row(
      children: <Widget>[
        Text('VisitaFinal?'),
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

  Widget buildRowCargadoServidor() {
    return Row(
      children: <Widget>[
        Text('CargadoServidor?'),
        Checkbox(
          value: visita.cargadoServidor ?? false,
          onChanged: (bool? value) {
            setState(() {
              visita.cargadoServidor = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowObraId(
      void Function(int? selectedObraId) onChangeDropdownItemForObraId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Obra'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedObraId,
                items: _dropdownMenuItemsForObraId,
                onChanged: onChangeDropdownItemForObraId,
                validator: (value) {
                  if ((_selectedObraId != null &&
                      _selectedObraId.toString() != '0')) {
                    return null;
                  } else if (value == null || value == 0) {
                    return 'Please enter Obra';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  visita.dateCreated ??
                  DateTime.now();
              visita.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  visita.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    visita.dateCreated ??
                    DateTime.now();
                visita.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text = UITools.convertDate(visita.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    visita.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    final _fecha = DateTime.tryParse(txtFecha.text);
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    visita
      ..numVisita = int.tryParse(txtNumVisita.text)
      ..informeId = int.tryParse(txtInformeId.text)
      ..fecha = _fecha
      ..nombreRelevador = txtNombreRelevador.text
      ..observaciones = txtObservaciones.text
      ..obraId = _selectedObraId
      ..dateCreated = _dateCreated;
    await visita.save();
    if (visita.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(visita.saveResult.toString(),
          title: 'save Visita Failed!', callBack: () {});
    }
  }
}

class PreguntaVisitaAdd extends StatefulWidget {
  PreguntaVisitaAdd(this._preguntavisita);
  final dynamic _preguntavisita;
  @override
  State<StatefulWidget> createState() =>
      PreguntaVisitaAddState(_preguntavisita as PreguntaVisita);
}

class PreguntaVisitaAddState extends State {
  PreguntaVisitaAddState(this.preguntavisita);
  PreguntaVisita preguntavisita;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtTipoRespuestaA = TextEditingController();
  final TextEditingController txtTipoRespuestaB = TextEditingController();
  final TextEditingController txtTipoRespuestaC = TextEditingController();

  final TextEditingController txtPregunta = TextEditingController();

  final TextEditingController txtEtapaDeAvance = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForIntervencionId =
      <DropdownMenuItem<int>>[];
  int? _selectedIntervencionId;

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtTipoRespuestaA.text = preguntavisita.tipoRespuestaA == null
        ? ''
        : preguntavisita.tipoRespuestaA.toString();
    txtTipoRespuestaB.text = preguntavisita.tipoRespuestaB == null
        ? ''
        : preguntavisita.tipoRespuestaB.toString();
    txtTipoRespuestaC.text = preguntavisita.tipoRespuestaC == null
        ? ''
        : preguntavisita.tipoRespuestaC.toString();

    txtPregunta.text = preguntavisita.pregunta == null
        ? ''
        : preguntavisita.pregunta.toString();

    txtEtapaDeAvance.text = preguntavisita.etapaDeAvance == null
        ? ''
        : preguntavisita.etapaDeAvance.toString();
    txtDateCreated.text = preguntavisita.dateCreated == null
        ? ''
        : UITools.convertDate(preguntavisita.dateCreated!);
    txtTimeForDateCreated.text = preguntavisita.dateCreated == null
        ? ''
        : UITools.convertTime(preguntavisita.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForIntervencionId() async {
      final dropdownMenuItems =
          await Intervencion().select().toDropDownMenuInt('nombre');
      setState(() {
        _dropdownMenuItemsForIntervencionId = dropdownMenuItems;
        _selectedIntervencionId = preguntavisita.intervencionId;
      });
    }

    if (_dropdownMenuItemsForIntervencionId.isEmpty) {
      buildDropDownMenuForIntervencionId();
    }
    void onChangeDropdownItemForIntervencionId(int? selectedIntervencionId) {
      setState(() {
        _selectedIntervencionId = selectedIntervencionId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (preguntavisita.id == null)
            ? Text('Add a new preguntavisita')
            : Text('Edit preguntavisita'),
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
                    buildRowId(),
                    buildRowTipoRespuestaA(),
                    buildRowTipoRespuestaB(),
                    buildRowTipoRespuestaC(),
                    buildRowEsTexto(),
                    buildRowPregunta(),
                    buildRowCuestionarioHabitabilidad(),
                    buildRowEtapaDeAvance(),
                    buildRowIntervencionId(
                        onChangeDropdownItemForIntervencionId),
                    buildRowDateCreated(),
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

  Widget buildRowId() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtId,
      decoration: InputDecoration(labelText: 'Id'),
    );
  }

  Widget buildRowTipoRespuestaA() {
    return TextFormField(
      controller: txtTipoRespuestaA,
      decoration: InputDecoration(labelText: 'TipoRespuestaA'),
    );
  }

  Widget buildRowTipoRespuestaB() {
    return TextFormField(
      controller: txtTipoRespuestaB,
      decoration: InputDecoration(labelText: 'TipoRespuestaB'),
    );
  }

  Widget buildRowTipoRespuestaC() {
    return TextFormField(
      controller: txtTipoRespuestaC,
      decoration: InputDecoration(labelText: 'TipoRespuestaC'),
    );
  }

  Widget buildRowEsTexto() {
    return Row(
      children: <Widget>[
        Text('EsTexto?'),
        Checkbox(
          value: preguntavisita.esTexto ?? false,
          onChanged: (bool? value) {
            setState(() {
              preguntavisita.esTexto = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowPregunta() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Pregunta';
        }
        return null;
      },
      controller: txtPregunta,
      decoration: InputDecoration(labelText: 'Pregunta'),
    );
  }

  Widget buildRowCuestionarioHabitabilidad() {
    return Row(
      children: <Widget>[
        Text('CuestionarioHabitabilidad?'),
        Checkbox(
          value: preguntavisita.cuestionarioHabitabilidad ?? false,
          onChanged: (bool? value) {
            setState(() {
              preguntavisita.cuestionarioHabitabilidad = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowEtapaDeAvance() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtEtapaDeAvance,
      decoration: InputDecoration(labelText: 'EtapaDeAvance'),
    );
  }

  Widget buildRowIntervencionId(
      void Function(int? selectedIntervencionId)
          onChangeDropdownItemForIntervencionId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Intervencion'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedIntervencionId,
                items: _dropdownMenuItemsForIntervencionId,
                onChanged: onChangeDropdownItemForIntervencionId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  preguntavisita.dateCreated ??
                  DateTime.now();
              preguntavisita.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  preguntavisita.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    preguntavisita.dateCreated ??
                    DateTime.now();
                preguntavisita.dateCreated = DateTime(d.year, d.month, d.day)
                    .add(Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(preguntavisita.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    preguntavisita.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    preguntavisita
      ..id = int.tryParse(txtId.text)
      ..tipoRespuestaA = txtTipoRespuestaA.text
      ..tipoRespuestaB = txtTipoRespuestaB.text
      ..tipoRespuestaC = txtTipoRespuestaC.text
      ..pregunta = txtPregunta.text
      ..etapaDeAvance = int.tryParse(txtEtapaDeAvance.text)
      ..intervencionId = _selectedIntervencionId
      ..dateCreated = _dateCreated;
    await preguntavisita.save();
    if (preguntavisita.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(preguntavisita.saveResult.toString(),
          title: 'save PreguntaVisita Failed!', callBack: () {});
    }
  }
}

class RespuestaVisitaAdd extends StatefulWidget {
  RespuestaVisitaAdd(this._respuestavisita);
  final dynamic _respuestavisita;
  @override
  State<StatefulWidget> createState() =>
      RespuestaVisitaAddState(_respuestavisita as RespuestaVisita);
}

class RespuestaVisitaAddState extends State {
  RespuestaVisitaAddState(this.respuestavisita);
  RespuestaVisita respuestavisita;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtRespuesta = TextEditingController();
  final TextEditingController txtPuntaje = TextEditingController();

  List<DropdownMenuItem<int>> _dropdownMenuItemsForPreguntaVisitaId =
      <DropdownMenuItem<int>>[];
  int? _selectedPreguntaVisitaId;

  final TextEditingController txtNroComponente = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForViviendaId =
      <DropdownMenuItem<int>>[];
  int? _selectedViviendaId;

  List<DropdownMenuItem<int>> _dropdownMenuItemsForVisitaId =
      <DropdownMenuItem<int>>[];
  int? _selectedVisitaId;

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtRespuesta.text = respuestavisita.respuesta == null
        ? ''
        : respuestavisita.respuesta.toString();
    txtPuntaje.text = respuestavisita.puntaje == null
        ? ''
        : respuestavisita.puntaje.toString();

    txtNroComponente.text = respuestavisita.nroComponente == null
        ? ''
        : respuestavisita.nroComponente.toString();
    txtDateCreated.text = respuestavisita.dateCreated == null
        ? ''
        : UITools.convertDate(respuestavisita.dateCreated!);
    txtTimeForDateCreated.text = respuestavisita.dateCreated == null
        ? ''
        : UITools.convertTime(respuestavisita.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForPreguntaVisitaId() async {
      final dropdownMenuItems =
          await PreguntaVisita().select().toDropDownMenuInt('tipoRespuestaA');
      setState(() {
        _dropdownMenuItemsForPreguntaVisitaId = dropdownMenuItems;
        _selectedPreguntaVisitaId = respuestavisita.preguntaVisitaId;
      });
    }

    if (_dropdownMenuItemsForPreguntaVisitaId.isEmpty) {
      buildDropDownMenuForPreguntaVisitaId();
    }
    void onChangeDropdownItemForPreguntaVisitaId(
        int? selectedPreguntaVisitaId) {
      setState(() {
        _selectedPreguntaVisitaId = selectedPreguntaVisitaId;
      });
    }

    void buildDropDownMenuForViviendaId() async {
      final dropdownMenuItems =
          await Vivienda().select().toDropDownMenuInt('aliasRenabap');
      setState(() {
        _dropdownMenuItemsForViviendaId = dropdownMenuItems;
        _selectedViviendaId = respuestavisita.viviendaId;
      });
    }

    if (_dropdownMenuItemsForViviendaId.isEmpty) {
      buildDropDownMenuForViviendaId();
    }
    void onChangeDropdownItemForViviendaId(int? selectedViviendaId) {
      setState(() {
        _selectedViviendaId = selectedViviendaId;
      });
    }

    void buildDropDownMenuForVisitaId() async {
      final dropdownMenuItems =
          await Visita().select().toDropDownMenuInt('nombreRelevador');
      setState(() {
        _dropdownMenuItemsForVisitaId = dropdownMenuItems;
        _selectedVisitaId = respuestavisita.visitaId;
      });
    }

    if (_dropdownMenuItemsForVisitaId.isEmpty) {
      buildDropDownMenuForVisitaId();
    }
    void onChangeDropdownItemForVisitaId(int? selectedVisitaId) {
      setState(() {
        _selectedVisitaId = selectedVisitaId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (respuestavisita.id == null)
            ? Text('Add a new respuestavisita')
            : Text('Edit respuestavisita'),
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
                    buildRowRespuesta(),
                    buildRowPuntaje(),
                    buildRowPgas(),
                    buildRowPreguntaVisitaId(
                        onChangeDropdownItemForPreguntaVisitaId),
                    buildRowNroComponente(),
                    buildRowViviendaId(onChangeDropdownItemForViviendaId),
                    buildRowVisitaId(onChangeDropdownItemForVisitaId),
                    buildRowDateCreated(),
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

  Widget buildRowRespuesta() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Respuesta';
        }
        return null;
      },
      controller: txtRespuesta,
      decoration: InputDecoration(labelText: 'Respuesta'),
    );
  }

  Widget buildRowPuntaje() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && double.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtPuntaje,
      decoration: InputDecoration(labelText: 'Puntaje'),
    );
  }

  Widget buildRowPgas() {
    return Row(
      children: <Widget>[
        Text('Pgas?'),
        Checkbox(
          value: respuestavisita.pgas ?? false,
          onChanged: (bool? value) {
            setState(() {
              respuestavisita.pgas = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowPreguntaVisitaId(
      void Function(int? selectedPreguntaVisitaId)
          onChangeDropdownItemForPreguntaVisitaId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('PreguntaVisita'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedPreguntaVisitaId,
                items: _dropdownMenuItemsForPreguntaVisitaId,
                onChanged: onChangeDropdownItemForPreguntaVisitaId,
                validator: (value) {
                  if ((_selectedPreguntaVisitaId != null &&
                      _selectedPreguntaVisitaId.toString() != '0')) {
                    return null;
                  } else if (value == null || value == 0) {
                    return 'Please enter PreguntaVisita';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowNroComponente() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtNroComponente,
      decoration: InputDecoration(labelText: 'NroComponente'),
    );
  }

  Widget buildRowViviendaId(
      void Function(int? selectedViviendaId)
          onChangeDropdownItemForViviendaId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Vivienda'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedViviendaId,
                items: _dropdownMenuItemsForViviendaId,
                onChanged: onChangeDropdownItemForViviendaId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowVisitaId(
      void Function(int? selectedVisitaId) onChangeDropdownItemForVisitaId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Visita'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedVisitaId,
                items: _dropdownMenuItemsForVisitaId,
                onChanged: onChangeDropdownItemForVisitaId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  respuestavisita.dateCreated ??
                  DateTime.now();
              respuestavisita.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  respuestavisita.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    respuestavisita.dateCreated ??
                    DateTime.now();
                respuestavisita.dateCreated = DateTime(d.year, d.month, d.day)
                    .add(Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(respuestavisita.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    respuestavisita.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    respuestavisita
      ..respuesta = txtRespuesta.text
      ..puntaje = double.tryParse(txtPuntaje.text)
      ..preguntaVisitaId = _selectedPreguntaVisitaId
      ..nroComponente = int.tryParse(txtNroComponente.text)
      ..viviendaId = _selectedViviendaId
      ..visitaId = _selectedVisitaId
      ..dateCreated = _dateCreated;
    await respuestavisita.save();
    if (respuestavisita.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(respuestavisita.saveResult.toString(),
          title: 'save RespuestaVisita Failed!', callBack: () {});
    }
  }
}

class IntervencionAdd extends StatefulWidget {
  IntervencionAdd(this._intervencion);
  final dynamic _intervencion;
  @override
  State<StatefulWidget> createState() =>
      IntervencionAddState(_intervencion as Intervencion);
}

class IntervencionAddState extends State {
  IntervencionAddState(this.intervencion);
  Intervencion intervencion;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtNombre = TextEditingController();

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtNombre.text =
        intervencion.nombre == null ? '' : intervencion.nombre.toString();

    txtDateCreated.text = intervencion.dateCreated == null
        ? ''
        : UITools.convertDate(intervencion.dateCreated!);
    txtTimeForDateCreated.text = intervencion.dateCreated == null
        ? ''
        : UITools.convertTime(intervencion.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (intervencion.id == null)
            ? Text('Add a new intervencion')
            : Text('Edit intervencion'),
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
                    buildRowId(),
                    buildRowNombre(),
                    buildRowEsPgas(),
                    buildRowDateCreated(),
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

  Widget buildRowId() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtId,
      decoration: InputDecoration(labelText: 'Id'),
    );
  }

  Widget buildRowNombre() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Nombre';
        }
        return null;
      },
      controller: txtNombre,
      decoration: InputDecoration(labelText: 'Nombre'),
    );
  }

  Widget buildRowEsPgas() {
    return Row(
      children: <Widget>[
        Text('EsPgas?'),
        Checkbox(
          value: intervencion.esPgas ?? false,
          onChanged: (bool? value) {
            setState(() {
              intervencion.esPgas = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  intervencion.dateCreated ??
                  DateTime.now();
              intervencion.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  intervencion.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    intervencion.dateCreated ??
                    DateTime.now();
                intervencion.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(intervencion.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    intervencion.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    intervencion
      ..id = int.tryParse(txtId.text)
      ..nombre = txtNombre.text
      ..dateCreated = _dateCreated;
    await intervencion.save();
    if (intervencion.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(intervencion.saveResult.toString(),
          title: 'save Intervencion Failed!', callBack: () {});
    }
  }
}

class FotoVisitaAdd extends StatefulWidget {
  FotoVisitaAdd(this._fotovisita);
  final dynamic _fotovisita;
  @override
  State<StatefulWidget> createState() =>
      FotoVisitaAddState(_fotovisita as FotoVisita);
}

class FotoVisitaAddState extends State {
  FotoVisitaAddState(this.fotovisita);
  FotoVisita fotovisita;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtImagen = TextEditingController();
  List<DropdownMenuItem<int>> _dropdownMenuItemsForVisitaId =
      <DropdownMenuItem<int>>[];
  int? _selectedVisitaId;

  List<DropdownMenuItem<int>> _dropdownMenuItemsForIntervencionId =
      <DropdownMenuItem<int>>[];
  int? _selectedIntervencionId;

  final TextEditingController txtNroComponente = TextEditingController();
  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtImagen.text =
        fotovisita.imagen == null ? '' : fotovisita.imagen.toString();
    txtNroComponente.text = fotovisita.nroComponente == null
        ? ''
        : fotovisita.nroComponente.toString();
    txtDateCreated.text = fotovisita.dateCreated == null
        ? ''
        : UITools.convertDate(fotovisita.dateCreated!);
    txtTimeForDateCreated.text = fotovisita.dateCreated == null
        ? ''
        : UITools.convertTime(fotovisita.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForVisitaId() async {
      final dropdownMenuItems =
          await Visita().select().toDropDownMenuInt('nombreRelevador');
      setState(() {
        _dropdownMenuItemsForVisitaId = dropdownMenuItems;
        _selectedVisitaId = fotovisita.visitaId;
      });
    }

    if (_dropdownMenuItemsForVisitaId.isEmpty) {
      buildDropDownMenuForVisitaId();
    }
    void onChangeDropdownItemForVisitaId(int? selectedVisitaId) {
      setState(() {
        _selectedVisitaId = selectedVisitaId;
      });
    }

    void buildDropDownMenuForIntervencionId() async {
      final dropdownMenuItems =
          await Intervencion().select().toDropDownMenuInt('nombre');
      setState(() {
        _dropdownMenuItemsForIntervencionId = dropdownMenuItems;
        _selectedIntervencionId = fotovisita.intervencionId;
      });
    }

    if (_dropdownMenuItemsForIntervencionId.isEmpty) {
      buildDropDownMenuForIntervencionId();
    }
    void onChangeDropdownItemForIntervencionId(int? selectedIntervencionId) {
      setState(() {
        _selectedIntervencionId = selectedIntervencionId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (fotovisita.id == null)
            ? Text('Add a new fotovisita')
            : Text('Edit fotovisita'),
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
                    buildRowImagen(),
                    buildRowVisitaId(onChangeDropdownItemForVisitaId),
                    buildRowIntervencionId(
                        onChangeDropdownItemForIntervencionId),
                    buildRowNroComponente(),
                    buildRowDateCreated(),
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

  Widget buildRowImagen() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Imagen';
        }
        return null;
      },
      controller: txtImagen,
      decoration: InputDecoration(labelText: 'Imagen'),
    );
  }

  Widget buildRowVisitaId(
      void Function(int? selectedVisitaId) onChangeDropdownItemForVisitaId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Visita'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedVisitaId,
                items: _dropdownMenuItemsForVisitaId,
                onChanged: onChangeDropdownItemForVisitaId,
                validator: (value) {
                  if ((_selectedVisitaId != null &&
                      _selectedVisitaId.toString() != '0')) {
                    return null;
                  } else if (value == null || value == 0) {
                    return 'Please enter Visita';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowIntervencionId(
      void Function(int? selectedIntervencionId)
          onChangeDropdownItemForIntervencionId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Intervencion'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedIntervencionId,
                items: _dropdownMenuItemsForIntervencionId,
                onChanged: onChangeDropdownItemForIntervencionId,
                validator: (value) {
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowNroComponente() {
    return TextFormField(
      validator: (value) {
        if (value!.isNotEmpty && int.tryParse(value) == null) {
          return 'Please Enter valid number';
        }

        return null;
      },
      controller: txtNroComponente,
      decoration: InputDecoration(labelText: 'NroComponente'),
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  fotovisita.dateCreated ??
                  DateTime.now();
              fotovisita.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  fotovisita.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    fotovisita.dateCreated ??
                    DateTime.now();
                fotovisita.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(fotovisita.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    fotovisita.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    fotovisita
      ..imagen = txtImagen.text as Uint8List
      ..visitaId = _selectedVisitaId
      ..intervencionId = _selectedIntervencionId
      ..nroComponente = int.tryParse(txtNroComponente.text)
      ..dateCreated = _dateCreated;
    await fotovisita.save();
    if (fotovisita.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(fotovisita.saveResult.toString(),
          title: 'save FotoVisita Failed!', callBack: () {});
    }
  }
}

class FotoViviendaAdd extends StatefulWidget {
  FotoViviendaAdd(this._fotovivienda);
  final dynamic _fotovivienda;
  @override
  State<StatefulWidget> createState() =>
      FotoViviendaAddState(_fotovivienda as FotoVivienda);
}

class FotoViviendaAddState extends State {
  FotoViviendaAddState(this.fotovivienda);
  FotoVivienda fotovivienda;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtImagen = TextEditingController();

  List<DropdownMenuItem<int>> _dropdownMenuItemsForViviendaId =
      <DropdownMenuItem<int>>[];
  int? _selectedViviendaId;

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtImagen.text =
        fotovivienda.imagen == null ? '' : fotovivienda.imagen.toString();

    txtDateCreated.text = fotovivienda.dateCreated == null
        ? ''
        : UITools.convertDate(fotovivienda.dateCreated!);
    txtTimeForDateCreated.text = fotovivienda.dateCreated == null
        ? ''
        : UITools.convertTime(fotovivienda.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buildDropDownMenuForViviendaId() async {
      final dropdownMenuItems =
          await Vivienda().select().toDropDownMenuInt('aliasRenabap');
      setState(() {
        _dropdownMenuItemsForViviendaId = dropdownMenuItems;
        _selectedViviendaId = fotovivienda.viviendaId;
      });
    }

    if (_dropdownMenuItemsForViviendaId.isEmpty) {
      buildDropDownMenuForViviendaId();
    }
    void onChangeDropdownItemForViviendaId(int? selectedViviendaId) {
      setState(() {
        _selectedViviendaId = selectedViviendaId;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: (fotovivienda.id == null)
            ? Text('Add a new fotovivienda')
            : Text('Edit fotovivienda'),
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
                    buildRowImagen(),
                    buildRowFotoPrincipal(),
                    buildRowViviendaId(onChangeDropdownItemForViviendaId),
                    buildRowDateCreated(),
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

  Widget buildRowImagen() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Imagen';
        }
        return null;
      },
      controller: txtImagen,
      decoration: InputDecoration(labelText: 'Imagen'),
    );
  }

  Widget buildRowFotoPrincipal() {
    return Row(
      children: <Widget>[
        Text('FotoPrincipal?'),
        Checkbox(
          value: fotovivienda.fotoPrincipal ?? false,
          onChanged: (bool? value) {
            setState(() {
              fotovivienda.fotoPrincipal = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowViviendaId(
      void Function(int? selectedViviendaId)
          onChangeDropdownItemForViviendaId) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('Vivienda'),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DropdownButtonFormField(
                value: _selectedViviendaId,
                items: _dropdownMenuItemsForViviendaId,
                onChanged: onChangeDropdownItemForViviendaId,
                validator: (value) {
                  if ((_selectedViviendaId != null &&
                      _selectedViviendaId.toString() != '0')) {
                    return null;
                  } else if (value == null || value == 0) {
                    return 'Please enter Vivienda';
                  }
                  return null;
                },
              ),
            )),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => DatePicker.showDatePicker(context,
              showTitleActions: true,
              theme: UITools.mainDatePickerTheme,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  fotovivienda.dateCreated ??
                  DateTime.now();
              fotovivienda.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  fotovivienda.dateCreated ??
                  DateTime.now(),
              locale: UITools.mainDatePickerLocaleType),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => DatePicker.showTimePicker(context,
                showTitleActions: true, theme: UITools.mainDatePickerTheme,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    fotovivienda.dateCreated ??
                    DateTime.now();
                fotovivienda.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(fotovivienda.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    fotovivienda.dateCreated ??
                    DateTime.now(),
                locale: UITools.mainDatePickerLocaleType),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: ''),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    fotovivienda
      ..imagen = txtImagen.text as Uint8List
      ..viviendaId = _selectedViviendaId
      ..dateCreated = _dateCreated;
    await fotovivienda.save();
    if (fotovivienda.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(fotovivienda.saveResult.toString(),
          title: 'save FotoVivienda Failed!', callBack: () {});
    }
  }
}
