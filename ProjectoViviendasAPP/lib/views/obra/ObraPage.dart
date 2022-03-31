import 'package:flutter/material.dart';
import 'package:viviendas/model/model.dart';
import 'package:viviendas/views/historialVisitas/VisitasPage.dart';
import 'package:viviendas/views/obra/ObraForm.dart';

import '../certificados/CertificadosPage.dart';

class ObraPage extends StatelessWidget {
  ObraPage(this.idObra, this.vivienda);
  final int idObra;
  final Vivienda vivienda;
  @override
  Widget build(BuildContext context) {
    List<Widget> bottomPages = [VisitasPage(idObra, vivienda), CertificadosPage(idObra)];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Arbolada'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                'Informacion de Obra',
                style: Theme.of(context).primaryTextTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 32.0,
                ),
                textAlign: TextAlign.center
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: ObraForm(vivienda),
            )
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => bottomPages[index]));
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: new Color(0xFF31DE8B),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted_outlined),
                label: 'Visitas'),
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist), label: 'Certificados'),
          ],
        ));
  }
}
