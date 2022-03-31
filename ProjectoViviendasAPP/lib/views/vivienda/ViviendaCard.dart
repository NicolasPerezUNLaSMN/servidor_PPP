import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';

class ViviendaCard extends StatefulWidget {
  final Vivienda vivienda;
  const ViviendaCard(this.vivienda);
  @override
  State<ViviendaCard> createState() => ViviendaCardState(vivienda);
}
class ViviendaCardState extends State<ViviendaCard> {
  ViviendaCardState(this.vivienda);
  Vivienda vivienda;
  String obraEstado = "";
  String organizacion = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:  FutureBuilder(
        future: cargarDatos(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vivienda.ubicacion.region != null ? vivienda.ubicacion.region! : '' + ' - ' + vivienda.ubicacion.provincia!,
                                    style: TextStyle(color: Colors.grey[500])),
                                Text(vivienda.ubicacion.barrio!),
                                Text(vivienda.ubicacion.direccion!,
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  vivienda.aliasRenabap != null ? "Alias: " + vivienda.aliasRenabap! : '',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(vivienda.reubicados! ? 'Familia reubicada' : 'Familia no reubicada'),
                                ),
                              ],
                            )
                          ],),
                          organizacion.isNotEmpty
                          ?
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('OSC:'),
                                Text(organizacion,
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ]
                            ),
                          )
                          :
                          SizedBox()
                      ]
                    )
                  )
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
                    child: Text('Espere por favor...'),
                  )
                ]
            );
          }
        }
      ),
    );
  }

  cargarDatos() async {
    obraEstado = await getObraEnCurso();
    return 'Datos cargados';
  }

  getObraEnCurso() async{
    final int? obraId= vivienda.documentaciontecnica.obraId;
    final Obra? obra = await Obra().getById(obraId);
    final visitas = await obra!.getVisitas()!.toList();
    organizacion = obra.nombreRepresentanteOSC!;
    var ultimaVisita;
    String rta = 'OBRA EN CURSO';
    if(visitas.length > 0){
      ultimaVisita = visitas[visitas.length - 1];
      if(ultimaVisita.visitaFinal!){
        rta = 'OBRA FINALIZADA';
      }
    }
    return rta;
  }
}
