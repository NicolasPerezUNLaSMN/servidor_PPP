import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

class ConvertirArchivos{

  static String fileToBase64(File file) {
    List<int> lista = file.readAsBytesSync();
    String base64 = base64Encode(lista);
    return base64;
  }

  static File base64ToFile(String base64) {
    Uint8List uint8List = base64Decode(base64);
    File file = File.fromRawPath(uint8List);
    return file;
  }

  static Uint8List base64ToUint8List(String base64) {
    Uint8List uint8List = base64Decode(base64);
    return uint8List;
  }

  static  String uint8ListToBase64(Uint8List uint8List) {
    List<int> lista = uint8List.toList();
    String base64 = base64Encode(lista);
    return base64;
  }
}