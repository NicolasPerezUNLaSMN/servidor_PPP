import 'package:flutter/material.dart';
import 'package:viviendas/tools/Servidor.dart';
import 'package:viviendas/tools/helper.dart';
import 'package:viviendas/views/buscarVivienda/SearchPage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:viviendas/views/login/HomePage.dart';
import '../../DataSeed.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginFormEstado();
}

class LoginFormEstado extends State {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtClave = TextEditingController();

  String sesionIniciada = "";
  bool loadingLogin = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
              child:
                  sesionIniciada != "" ? mostrarMensaje(): iniciarSesion(),
                ),
          ),
        );
  }

  Widget iniciarSesion(){
    return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Porfavor ingrese su email';
                }
                return null;
              },
              controller: txtEmail,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                }
                return null;
              },
              controller: txtClave,
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
                    loadingLogin = true;
                  });
                  if(!(await Servidor.conexionServidor())){
                    UITools(context).alertDialog("El servidor no responde!",
                        title: 'Error', callBack: () {});
                  }
                  else{
                    _userLogin(context);
                  }
                  setState(() {
                    loadingLogin = false;
                  });
                },
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loadingLogin ? SizedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                          width: 25,
                          height: 25,
                        ) : Text(''),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: const Text('ENTRAR',
                              style: TextStyle(color: Colors.white, fontSize: 16)
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ],
        ));
  }
  Widget mostrarMensaje(){
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(10.0)),),
      child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text( sesionIniciada,
                style: TextStyle(
                  fontSize: 15.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: new LinearPercentIndicator(
                width: 250,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 180000,//3 minutos
                percent: 1,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.green,
              ),
            ),
          ]
      ),
    );
  }

  Future<void> _userLogin(BuildContext context) async {
    bool logInOk = await Servidor.logIn(txtEmail.text, txtClave.text);

    if(logInOk){
      setState(() {
        sesionIniciada = "Sesion iniciada correctamente. Aguarde un instante mientras se carga la informacion.";
      });
      await correrPruebaAgregarDatos();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }else{
      UITools(context).alertDialog("Usuario o Contraseña incorrectos",
          title: 'Intentelo de nuevo', callBack: () {});
    }
  }

}
