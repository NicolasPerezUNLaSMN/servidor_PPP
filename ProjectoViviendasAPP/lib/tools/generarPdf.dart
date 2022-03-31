import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class GenerarPdf {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
    Uint8List ?rawPdf
  }) async {
    final bytes = rawPdf == null ? await pdf.save() : rawPdf;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}