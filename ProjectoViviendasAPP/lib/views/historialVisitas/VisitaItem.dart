import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viviendas/widgets/ImageCarousel.dart';
import '../verVisita/VisitaRespuestas.dart';

class VisitaItem extends StatefulWidget {
  VisitaItem(this.visita, this.idVivienda);
  final Visita visita;
  final int idVivienda;

  @override
  State<VisitaItem> createState() => _VisitaItemState(visita);
}

class _VisitaItemState extends State<VisitaItem> {
  _VisitaItemState(this.visita);
  final Visita visita;
  final meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
  List<FittedBox> imagenes = [];

  @override
  void initState(){
    for(FotoVisita fv in visita.plFotoVisitas!.toList()){
      if(fv.intervencionId != null){
        imagenes.add(new FittedBox(
                    child: new Image.memory(fv.imagen!),
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                  ));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('5 de Agosto de 2021'),
        Text(widget.visita.fecha!.day.toString() + ' de ' 
        + meses[widget.visita.fecha!.month - 1] + ' de '
         + widget.visita.fecha!.year.toString()),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: "/VisitaRespuestas"),
                        builder: (context) => VisitaRespuestas(visita, widget.idVivienda)));
                },
                child: Column(
                  children: [
                    ImageCarousel(imagenes),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visita ' + widget.visita.numVisita.toString(),
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline6!
                                      .copyWith(
                                          fontSize: 24.0,
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: Color(0xFF4CAF50)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      'REALIZADA',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('RELEVADOR',
                                    style: GoogleFonts.robotoSlab(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold)),
                                Text(widget.visita.nombreRelevador!,
                                    style: GoogleFonts.robotoSlab(
                                        color: Colors.grey[500]))
                              ],
                            )
                          ]),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
