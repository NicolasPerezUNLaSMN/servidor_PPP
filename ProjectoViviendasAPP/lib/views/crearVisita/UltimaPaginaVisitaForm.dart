import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/views/historialVisitas/VisitasPage.dart';
import 'package:viviendas/widgets/ImageUpload.dart';
import 'package:image_picker/image_picker.dart';

class UltimaPaginaVisitaForm extends StatefulWidget {
  UltimaPaginaVisitaForm(this._visita, this.idVivienda);
  final dynamic _visita;
  final int idVivienda;
  @override
  State<StatefulWidget> createState() => UltimaPaginaVisita(_visita as Visita, idVivienda);
}

class UltimaPaginaVisita extends State {
  UltimaPaginaVisita(this.visita, this.idVivienda);
  Visita visita;
  int idVivienda;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtObservaciones = TextEditingController();
  List<XFile> imageList = [];
  ImageUpload ?imageUpload;

  @override
  void initState() {
    imageUpload = ImageUpload(imageFileList: imageList);
    txtObservaciones.text = '';
    visita.observaciones == null ? '' : visita.observaciones.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (visita.id == null)
            ? Text('Agregar una nueva visita')
            : Text('Editar visita'),
        centerTitle: true
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildRowObservaciones(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Fotos de la visita',
                        style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18.0,
                        )       
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return ToggleButtons(
                          constraints: BoxConstraints.expand(
                            width: constraints.maxWidth / 2 - 2, height: 50),
                          selectedColor: Colors.white,
                          color: Theme.of(context).colorScheme.primary,
                          selectedBorderColor: Colors.white,
                          fillColor: Theme.of(context).colorScheme.primary,
                          borderColor: Theme.of(context).colorScheme.primary,
                          textStyle: TextStyle(fontSize: 10.0),
                          children: [const Icon(Icons.photo_library), const Icon(Icons.camera_alt)],
                          isSelected: [true, true],
                          onPressed: (int index) {
                            switch(index){
                              case 0:
                                imageUpload!.iuState!.onImageButtonPressed(
                                  ImageSource.gallery,
                                  context: context,
                                  isMultiImage: true,
                                );
                                break;
                              case 1:
                                imageUpload!.iuState!.onImageButtonPressed(ImageSource.camera, context: context);
                                break;
                            }
                          },
                        );
                      }
                    ),
                    imageUpload!,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        minimumSize: Size(double.infinity,
                            30), // double.infinity is the width and 30 is the height
                      ),
                      onPressed: () async {
                        if(imageList.length < 1){
                          UITools(context).alertDialog('Debe cargar por lo menos una imagen',
                            title: 'Error', callBack: () {});
                        }
                        else if (_formKey.currentState!.validate()) {
                          save();
                          Vivienda ?vivienda = await Vivienda().getById(idVivienda);
                          Navigator.of(context).popUntil(ModalRoute.withName('/ViviendaHome'));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisitasPage(visita.obraId!, vivienda!)));
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: const Text('GUARDAR VISITA',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 2.0)),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                imageUpload!.iuState!.onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                imageUpload!.iuState!.onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMultiImage: true,
                );
              },
              heroTag: 'image1',
              tooltip: 'Pick Multiple Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                imageUpload!.iuState!.onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image2',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            )
          )
        ],
      )
    );
  }

  Widget buildRowObservaciones() {
    return TextFormField(
      controller: txtObservaciones,
      decoration: InputDecoration(labelText: 'Observaciones'),
    );
  }

  void save() async {
    visita.observaciones = txtObservaciones.text;
    // Visita? visitaGuardada = await Servidor.createVisita(visita, idVivienda);
    // if(visitaGuardada != null){
    //   visita.cargadoServidor = true;
    // }
    await visita.save();

    for(XFile img in imageList){
      new FotoVisita(
        imagen: await img.readAsBytes(),
        visitaId: visita.id).save();
    }

    if (visita.saveResult!.success) {
      String mensaje = 'La visita se ha guardado corectamente!';
      if(visita.visitaFinal!){
        mensaje += '\nResponda el cuestionario de condiciones de habitabilidad';
      }
      UITools(context).alertDialog(mensaje,
          title: 'Exito');
    } else {
      UITools(context).alertDialog(visita.saveResult.toString(),
          title: 'Hubo un fallo! Intentelo de nuevo', callBack: () {});
    }
  }

}
