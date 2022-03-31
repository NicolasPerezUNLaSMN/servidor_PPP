import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viviendas/views/login/LoginForm.dart';

import '../buscarVivienda/SearchPage.dart';
import 'HomePage.dart';

class LoginPage extends StatelessWidget {
  bool usuarioSesionIniciada = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: sesionIniciada(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(!usuarioSesionIniciada){
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 64.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Image(image: AssetImage('assets/logo.png')),
                          Text(
                            'Arbolada',
                            style: TextStyle(
                              fontSize: 32.0,
                              color: Colors.grey[500],
                            ),
                          ),
                        ]),
                      ),
                      LoginForm()
                    ],
                  ),
                ),
              );
            }
            else{
              return HomePage();
            }
          }else{
            return Card(
                child: Column(
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
                ));
          }
        });

  }
  sesionIniciada() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString("token") != null){
      if(preferences.getString("token")!.isNotEmpty){
        usuarioSesionIniciada = true;
      }
    }
    return "Info cargada";
  }
}
