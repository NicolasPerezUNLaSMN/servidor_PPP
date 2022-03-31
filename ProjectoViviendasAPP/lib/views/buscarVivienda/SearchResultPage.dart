import 'package:flutter/material.dart';
import 'package:viviendas/views/buscarVivienda/SearchItem.dart';
import 'package:viviendas/model/model.dart';

class SearchResultPage extends StatelessWidget{
  SearchResultPage(this.viviendas);
  final List<Vivienda> viviendas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado de la Busqueda'),
        centerTitle: true
      ),
      body: viviendas.length > 0 ? 
        SearchList(viviendas) :
        Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info, 
                color: Colors.blue,
                size: 76.0
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'No se encontraron resultados para esta busqueda',
                    style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                      color: Colors.grey[700],
                      fontSize: 28.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]
          ),
        )
    );
  }
}

class SearchList extends StatefulWidget{
  const SearchList(this.viviendas);
  final List<Vivienda> viviendas;

  State<SearchList> createState() => SearchListState(viviendas);
}

class SearchListState extends State<SearchList>{
  SearchListState(this.viviendas);
  final List<Vivienda> viviendas;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      shrinkWrap: true,
      itemCount: viviendas.length,
      itemBuilder: (BuildContext context, int index) {
        return SearchItem(viviendas[index]);
      },
    );
  }
}