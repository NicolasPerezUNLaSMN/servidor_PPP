import 'package:flutter/material.dart';
import 'package:viviendas/views/vivienda/ViviendaPage.dart';
import 'package:viviendas/model/model.dart';

class SearchItem extends StatelessWidget {
  SearchItem(this.vivienda);
  final Vivienda vivienda;
  String obraEstado = 'OBRA EN CURSO';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cargarEstado(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(
                      settings: RouteSettings(name: "/ViviendaHome"),
                      builder: (context) => ViviendaPage(vivienda)));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 125,
                      height: 125,
                      child: FittedBox(
                        child:
                          //vivienda.plFotoViviendas!.isNotEmpty
                          //Image(image: MemoryImage(vivienda.plFotoViviendas!.first.imagen!)):
                          Image(image: AssetImage('assets/logo.png')),
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vivienda.ubicacion.region != null ? vivienda.ubicacion.region! : '' 
                              + ' - ' + vivienda.ubicacion.provincia!,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            vivienda.ubicacion.barrio!,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            vivienda.ubicacion.direccion!,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            vivienda.aliasRenabap != null ? "Alias: " + vivienda.aliasRenabap! : '',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                color: obraEstado == 'OBRA EN CURSO' 
                                  ? Colors.amber[500]
                                  : Color(0xFF4CAF50)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                obraEstado,
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                ),
            ),
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

  cargarEstado() async{
    final int? obraId= vivienda.documentaciontecnica.obraId;
    final Obra? obra = await Obra().getById(obraId);
    final visitas = await obra!.getVisitas()!.toList();

    if(visitas.length > 0){
      if(visitas[visitas.length - 1].visitaFinal!){
        obraEstado = 'OBRA FINALIZADA';
      }
    }

    return obraEstado;
  }
}
