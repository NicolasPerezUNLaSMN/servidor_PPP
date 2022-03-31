import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';

class ObraForm extends StatelessWidget {
  ObraForm(this.vivienda);
  final Vivienda vivienda;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: filaInformacion('Cantidad de habitantes', vivienda.cantHabitantes.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('Cantidad de habitantes entre de 18 y 65', vivienda.habitantesAdultos.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('Cantidad de habitantes menores de 18', vivienda.habitantesMenores.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('Cantidad de habitantes mayores de 65', vivienda.habitantesMayores.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('Son dueños de la vivienda, cuentan con certificado? ', textoBool(vivienda.duenosVivienda!)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('Reubicación de la familia', textoBool(vivienda.reubicados!)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('El conjunto habitacional tiene relación directa con la calle', textoBool(vivienda.directoACalle!)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('Metros cuadrados habitables cubiertos', vivienda.metrosCuadrados.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, top: 32.0),
                  child: filaInformacion('Ambientes de la vivienda', vivienda.ambientes.toString()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 18.0),
                      child: Text(
                        'Servicios disponibles',
                        style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ]
                ),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Center(child: Text('Agua', style: TextStyle(fontWeight: FontWeight.bold))),
                        Center(child: Text('Luz', style: TextStyle(fontWeight: FontWeight.bold))),
                        Center(child: Text('Gas', style: TextStyle(fontWeight: FontWeight.bold))),
                        Center(child: Text('Cloacas', style: TextStyle(fontWeight: FontWeight.bold))),
                        Center(child: Text('Internet', style: TextStyle(fontWeight: FontWeight.bold))),
                      ]
                    ),
                    TableRow(
                      children: [
                        SizedBox(height: 16.0),
                        SizedBox(height: 16.0),
                        SizedBox(height: 16.0),
                        SizedBox(height: 16.0),
                        SizedBox(height: 16.0),
                      ]
                    ),
                    TableRow(
                      children: [
                        Center(child: Text(textoBool(vivienda.servicioAgua!))),
                        Center(child: Text(textoBool(vivienda.servicioLuz!))),
                        Center(child: Text(textoBool(vivienda.servicioGas!))),
                        Center(child: Text(textoBool(vivienda.servicioCloacas!))),
                        Center(child: Text(textoBool(vivienda.servicioInternet!))),
                      ]
                    ),
                  ],
                ),
              ],
            )),
    );
  }

  Widget filaInformacion(String descripcion, String informacion){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 48.0),
              child: Text(
                descripcion,
                style: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
          ),
          Text(
            informacion,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ]
    );
  }
  String textoBool(bool estado){
    String texto = estado ? 'Si' : 'No';
    return texto;
  }

}
