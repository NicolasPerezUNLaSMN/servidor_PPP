import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viviendas/views/login/LoginPage.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();

 //await Servidor.pruebas();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App viviendas',
      theme: ThemeData(
          primarySwatch: new MaterialColor(0xFF31DE8B, {
            50: const Color(0xFF98efc5),
            100: const Color(0xFF83ebb9),
            200: const Color(0xFF6fe8ae),
            300: const Color(0xFF5ae5a2),
            400: const Color(0xFF46e197),
            500: const Color(0xFF31DE8B),
            600: const Color(0xFF2cc87d),
            700: const Color(0xFF27b26f),
            800: const Color(0xFF229b61),
            900: const Color(0xFF1d8553),
          }),
          appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.righteous(color: Colors.white, fontSize: 18.0),
          iconTheme: IconThemeData(color: Colors.white)),
          primaryColor: Colors.white,
          primaryTextTheme:
              TextTheme(headline6: GoogleFonts.righteous(color: Colors.white)),
          primaryIconTheme: const IconThemeData(color: Colors.white),
          sliderTheme: SliderTheme.of(context).copyWith(
              valueIndicatorColor: Colors.transparent,
              inactiveTrackColor: Color(0xFFC4C4C4),
              activeTrackColor: Color(0xFF31DE8B),
              thumbColor: Color(0xFF31DE8B),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
              valueIndicatorTextStyle: TextStyle(color: Colors.transparent)),
          scaffoldBackgroundColor: Color(0xFFFAF8F8)),
      home:  LoginPage()
    );
  }
}
