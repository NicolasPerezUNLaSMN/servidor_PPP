import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viviendas/views/buscarVivienda/SearchPage.dart';
import 'package:viviendas/views/login/LoginPage.dart';
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageEstado();
}

class HomePageEstado extends State {
  bool logOut = false;
  Map<String,String> userInfo = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('INICIO'), centerTitle: true),
      body: Padding(padding: const EdgeInsets.all(24.0), child: menu()),
    );
  }

  Widget menu() {
    return FutureBuilder(
        future: obtenerDatosUsuario(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        child: Icon(Icons.person_rounded),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(userInfo["nombre"]!, style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(userInfo["email"]!, style: TextStyle(fontSize: 20)),
                  ],
                ),
                Padding(
                padding: const EdgeInsets.all(30.0),
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new ListTile(
                        leading: Icon(Icons.search),
                        title: Text("BUSCAR VIVIENDAS"),
                        onTap: () {
                          buscarViviendas();
                        },
                      ),
                      new ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("CERRAR SESION"),
                        onTap: () async{
                          await cerrarSesion();
                        },
                      )
                    ],
                  ),),
              ],
            );
          } else {
            return Card(
                child: Column(children: const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Espere por favor...'),
                  )
                ]));
          }
        });
  }

  buscarViviendas(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  cerrarSesion() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  obtenerDatosUsuario() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userInfo = {
      "email": preferences.getString("email")!,
      "nombre": preferences.getString("nombre")!
    };
    return 'Ok';
  }
}
