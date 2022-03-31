import 'package:flutter/material.dart';
import 'package:viviendas/widgets/QuestionDropdown.dart';
import 'package:viviendas/views/buscarVivienda/SearchResultPage.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/tools/Servidor.dart';

import '../../DataSeed.dart';

class SearchPage extends StatefulWidget{
  State<SearchPage> createState () => SearchPageState();
}

class SearchPageState extends State<SearchPage>{
  List<String> regiones = ['Seleccionar region'];
  List<String> provincias = ['Seleccionar provincia'];
  List<String> barrios = ['Seleccionar barrio'];
  List<String> modalidades = ['Seleccionar modalidad'];
  List<String> componentes = ['Seleccionar componentes'];
  List<String> organizaciones = ['Seleccionar organizacion'];
  final TextEditingController txtAlias = TextEditingController();
  QuestionDropdown ?region;
  QuestionDropdown ?provincia;
  QuestionDropdown ?barrio;
  QuestionDropdown ?modalidad;
  QuestionDropdown ?componente;
  QuestionDropdown ?organizacion;
  DropdownOption ?regionOption;
  DropdownOption ?provinciaOption;
  DropdownOption ?barrioOption;
  DropdownOption ?modalidadOption;
  DropdownOption ?componenteOption;
  DropdownOption ?organizacionOption;
  bool loadingSearch = false;
  bool loadingViviendas = false;

  @override
  void initState(){
    regionOption = DropdownOption(0, regiones[0]);
    provinciaOption = DropdownOption(0, provincias[0]);
    barrioOption = DropdownOption(0, barrios[0]);
    modalidadOption = DropdownOption(0, modalidades[0]);
    componenteOption = DropdownOption(0, componentes[0]);
    organizacionOption = DropdownOption(0, organizaciones[0]);
    txtAlias.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Arbolada'),
          centerTitle: true,
          automaticallyImplyLeading: false
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                  child: Text(
                    'Buscar Viviendas',
                    style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 32.0,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Filtrar por localizacion'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: getRegiones(),
                    builder: (context, snapshot){
                      region = QuestionDropdown('Region', regiones, regionOption!);
                      return region!;
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: getProvincias(),
                    builder: (context, snapshot){
                      provincia = QuestionDropdown('Provincia', provincias, provinciaOption!);
                      return provincia!;
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: getBarrios(),
                    builder: (context, snapshot){
                      barrio = QuestionDropdown('Barrio', barrios, barrioOption!);
                      return barrio!;
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Filtrar por obra'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: getComponentes(),
                    builder: (context, snapshot){
                      componente = QuestionDropdown('Componente', componentes, componenteOption!);
                      return componente!;
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Filtrar por Organizacion'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FutureBuilder(
                    future: getOrganizaciones(),
                    builder: (context, snapshot){
                      organizacion = QuestionDropdown('Organizacion', organizaciones, organizacionOption!);
                      return organizacion!;
                    }
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Filtrar por ALIAS'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: txtAlias,
                    decoration: InputDecoration(
                        labelText: 'Alias vivienda',
                        border: OutlineInputBorder(),
                        hintText: 'MV2021_0000000'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      minimumSize: Size(double.infinity,
                          30), // double.infinity is the width and 30 is the height
                    ),
                    onPressed: () async {
                      setState(() {
                        loadingViviendas = true;
                      });

                      if(await Servidor.conexionServidor()){
                        try{
                          await correrPruebaAgregarDatos();
                          UITools(context).alertDialog("Las viviendas se actualizaron correctamente.",
                            title: 'Exito!', callBack: () {});
                        } catch(e){
                          UITools(context).alertDialog("Hubo un error en la comunicación con el servidor.\nIntentelo de nuevo mas tarde.",
                            title: 'Error', callBack: () {});
                        }
                      }
                      else{
                        UITools(context).alertDialog("No tiene conexión a internet.\nIntentelo de nuevo mas tarde.",
                          title: 'Error', callBack: () {});
                      }
                                        
                      setState(() {
                        loadingViviendas = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loadingViviendas ? SizedBox(
                            child: CircularProgressIndicator(),
                            width: 25,
                            height: 25,
                          ) : Icon(Icons.refresh),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Text('ACTUALIZAR VIVIENDAS',
                              style: TextStyle(fontSize: 16)
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      minimumSize: Size(double.infinity,
                          30), // double.infinity is the width and 30 is the height
                    ),
                    onPressed: () async {
                      setState(() {
                        loadingSearch = true;
                      });
                      List<Vivienda> viviendas = await getViviendas();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchResultPage(viviendas)),
                      );
                      setState(() {
                        loadingSearch = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loadingSearch ? SizedBox(
                            child: CircularProgressIndicator(color: Colors.white),
                            width: 25,
                            height: 25,
                          ) : Text(''),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Text('BUSCAR',
                              style: TextStyle(color: Colors.white, fontSize: 16)
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  getRegiones() async {
    List<Ubicacion> groupByRegion = await Ubicacion().select(columnsToSelect: 
      [UbicacionFields.region.toString()]).groupBy('region').toList();

    final fst = regiones.first;
    regiones.clear();
    regiones.add(fst);
    regiones.addAll(groupByRegion.map((e) => e.region!).toList());

    return 'Regiones cargadas';
  }

  getProvincias() async {
    List<Ubicacion> groupByProvincia = await Ubicacion().select(columnsToSelect: 
      [UbicacionFields.provincia.toString()]).groupBy('provincia').toList();
    
    final fst = provincias.first;
    provincias.clear();
    provincias.add(fst);
    provincias.addAll(groupByProvincia.map((e) => e.provincia!).toList());
  }

  getBarrios() async {
    List<Ubicacion> groupByBarrio = await Ubicacion().select(columnsToSelect: 
      [UbicacionFields.barrio.toString()]).groupBy('barrio').toList();

    final fst = barrios.first;
    barrios.clear();
    barrios.add(fst);
    barrios.addAll(groupByBarrio.map((e) => e.barrio!).toList());
  }

  getComponentes() async {
    List<Intervencion> groupByComponente = await Intervencion().select().esPgas.equals(false).toList();
    final fst = componentes.first;
    componentes.clear();
    componentes.add(fst);
    componentes.addAll(groupByComponente.map((e) => e.nombre!).toList());
  }

  getOrganizaciones() async {
    List<Obra> groupByOrganizacion = await Obra().select(columnsToSelect: 
      [ObraFields.nombreRepresentanteOSC.toString()]).groupBy('nombreRepresentanteOSC').toList();
    final fst = organizaciones.first;
    organizaciones.clear();
    organizaciones.add(fst);
    organizaciones.addAll(groupByOrganizacion.map((e) => e.nombreRepresentanteOSC!).toList());
  }

  getViviendas() async {
    List<Vivienda> resultado = [];
    if(txtAlias.text != ""){
      Vivienda? viviendaAlias = await Vivienda().select().aliasRenabap.equals(txtAlias.text).toSingle();
      if(viviendaAlias != null){
        resultado.add(viviendaAlias);
      }
    }
    else{
      List<Vivienda> viviendas = await Vivienda().select().toList(preload: true);
      String ?regionQuery = regionOption!.index > 0 ? regionOption!.value : null;
      String ?provinciaQuery = provinciaOption!.index > 0 ? provinciaOption!.value : null;
      String ?barrioQuery = barrioOption!.index > 0 ? barrioOption!.value : null;
      String ?componenteQuery = componenteOption!.index > 0 ? componenteOption!.value : null;
      String ?organizacionQuery = organizacionOption!.index > 0 ? organizacionOption!.value : null;
      if(txtAlias.text == ""){
        for(Vivienda v in viviendas){
          Obra ?vObra= await v.documentaciontecnica.getObra();
          List<Obra_intervencion> vObraIntervencion = await vObra!.getObra_intervencions()!.toList(preload: true);
          List<Intervencion> vIntervenciones = vObraIntervencion.map((e) => e.plIntervencion!).toList();
          bool regionFilter = regionQuery != null ? v.ubicacion.region! == regionQuery : true;
          bool provinciaFilter = provinciaQuery != null ? v.ubicacion.provincia! == provinciaQuery : true;
          bool barrioFilter = barrioQuery != null ? v.ubicacion.barrio! == barrioQuery : true;
          bool componenteFilter = componenteQuery != null ?
            vIntervenciones.map((e) => e.nombre).contains(componenteQuery) : true;
          bool organizacionFilter = organizacionQuery != null ? vObra.nombreRepresentanteOSC == organizacionQuery : true;
          if(regionFilter && provinciaFilter && barrioFilter
            && componenteFilter && organizacionFilter){
            resultado.add(v);
          }
        }
      }
    }

    return resultado;
  }
}