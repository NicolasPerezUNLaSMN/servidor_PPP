import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viviendas/model/model.dart';
import 'GenerarJSON.dart';

class Servidor{

  static String urlServidor = "http://10.0.2.2:8081";

  static pruebas()async{
  }

  static Future<bool> conexion() async {
    bool internetConexion = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetConexion = true;
      }
    } on Exception catch (_) {
    }
    return internetConexion;
  }
  static Future<bool> conexionServidor() async{
    bool conexion = false;
    try{
      final response = await http.get(Uri.parse("$urlServidor"));
      if((response.statusCode < 400) || (response.statusCode == 403)){
        conexion = true;
      }
    }on Exception catch (_) {}

    return conexion;
  }
  // GET

  static getViviendas()async{
    String token = await checkToken();
    final response = await http.get(Uri.parse("$urlServidor/vivienda"),
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    List<Future<Vivienda>> listaFuture = (responseJson as List).map((e) async => await GenerarJson.viviendaFromMap(e)).toList();
    List<Vivienda> lista = [];
    for(var element in listaFuture){
      lista.add(await element);
    }
    if(response.statusCode == 200){
      log("RESPONSE OK getViviendas lista : ${lista.length}");
    }
    return lista;
  }

  static getPreguntas()async{
    String token = await checkToken();
    final response = await http.get(Uri.parse("$urlServidor/pregunta"),
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    List<Future<PreguntaVisita>> listaFuture= (responseJson as List).map((e) async => await GenerarJson.preguntaVisitaFromMap(e)).toList();
    List<PreguntaVisita> lista = [];
    for(var element in listaFuture){
      lista.add(await element);
    }
    if(response.statusCode == 200){
      log("RESPONSE OK getPreguntas lista : ${lista.length}");
    }
    return lista;
  }

  static getVisitas()async{
    String token = await checkToken();
    final response = await http.get(Uri.parse("$urlServidor/visita"),
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    List<Future<Visita>> listaFuture= (responseJson as List).map((e) async => await GenerarJson.visitaFromMap(e) as Visita).toList();
    List<Visita> lista = [];
    for(var element in listaFuture){
      lista.add(await element);
    }
    if(response.statusCode == 200){
      log(" RESPONSE OK getVisitas");
    }
    return lista;
  }

  static getIntervenciones()async{
    String token = await checkToken();
    final response = await http.get(Uri.parse("$urlServidor/intervencion"),
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    List<Future<Intervencion>> listaFuture= (responseJson as List).map((e) async => await GenerarJson.intervencionFromMap(e)).toList();
    List<Intervencion> lista = [];
    for(var element in listaFuture){
      lista.add(await element);
    }
    if(response.statusCode == 200){
      log(" RESPONSE OK getIntervenciones lista : ${lista.length}");
    }
    return lista;
  }

  // POST

  static Future<Visita?> createVisita(Visita visita, int idVivienda) async{
    String token = await checkToken();
    final response = await http.post(Uri.parse("$urlServidor/visita"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
        body: await GenerarJson.visitaToJson(visita, idVivienda)
    );
    if(response.statusCode == 201){
      log("RESPONSE OK createVisita");
    }else{
      print(response.statusCode);
      return null;
    }
    return await GenerarJson.visitaFromMap(json.decode(response.body));
  }

  static Future<Certificado?> createCertificado(Certificado certificado) async{
    String token = await checkToken();
    final response = await http.post(Uri.parse("$urlServidor/certificado"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
        body: await GenerarJson.certificadoToJson(certificado)
    );
    if(response.statusCode == 201){
      log("RESPONSE OK createCertificado");
    }else{
      return null;
    }
    return await GenerarJson.certificadoFromMap(json.decode(response.body));
  }

  static Future<Vivienda?> updateVivienda(Vivienda vivienda) async{
    String token = await checkToken();
    final response = await http.post(Uri.parse("$urlServidor/vivienda"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
        body: await GenerarJson.viviendaToJson(vivienda)
    );
    if(response.statusCode == 200){
      log(" RESPONSE OK updateVivienda");
    }else{
      return null;
    }
    return await GenerarJson.viviendaFromMap(json.decode(response.body));
  }

  static Future<bool> logIn(String email, String clave) async {
    bool logInOk = false;
    Map<String,String> userInfo = {
      "email": email,
      "clave": clave
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse("$urlServidor/auth/login/"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(userInfo)
    );
    Map<String,dynamic> infoResponse = jsonDecode(response.body);
    if(response.statusCode == 200){

      preferences.setString("nombre","${infoResponse["body"]["nombre"].toString()} ${infoResponse["body"]["apellido"].toString()}");
      preferences.setString("token", infoResponse["headers"]["jwt"][0].toString());
      preferences.setString("email", email);
      preferences.setString("clave", clave);

      logInOk = true;
      log("RESPONSE OK logIn");
    }
    return logInOk;
  }

  static getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = "Bearer ${preferences.getString("token")}";
    return token;
  }

  static checkToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = "Bearer ${preferences.getString("token")}";
    final response = await http.get(Uri.parse("$urlServidor/auth/me"),
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if(response.statusCode == 401){
      var logInOk = await logIn(preferences.getString("email")!, preferences.getString("clave")!);
      if(logInOk){
        token = "Bearer ${preferences.getString("token")}";
      }
    }
    return token;
  }
}