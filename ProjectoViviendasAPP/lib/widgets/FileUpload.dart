import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUpload extends StatefulWidget {
  FileUpload(this.files, this.multiPick);
  final List<PlatformFile> files;
  final bool multiPick;

  @override
  _FileUploadState createState() => _FileUploadState(files, multiPick);
}

class _FileUploadState extends State<FileUpload> {
  _FileUploadState(this.files, this.multiPick);
  String? _fileName;
  List<PlatformFile> files;
  String? _directoryPath;
  String? _extension = 'pdf';
  bool _isLoading = false;
  bool multiPick;
  FileType _pickingType = FileType.custom;

  void _pickFiles() async {
    _resetState();

    _directoryPath = null;
    List<PlatformFile>? _tempFiles = (await FilePicker.platform.pickFiles(
      type: _pickingType,
      allowMultiple: multiPick,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))?.files;
    _tempFiles != null ? files.addAll(_tempFiles) : files.clear();
    
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName = files.map((e) => e.name).toString();
    });
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      files.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
          child: ElevatedButton(
                onPressed: () => _pickFiles(),
                child: Text(multiPick ? 'Seleccionar archivos' : 'Seleccionar archivo'),
              ),
        ),
        Builder(
          builder: (BuildContext context) => _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: const CircularProgressIndicator(),
                )
              : _directoryPath != null
                ? ListTile(
                    title: const Text('Directory path'),
                    subtitle: Text(_directoryPath!),
                  )
                : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 
                              files.isNotEmpty
                          ? files.length
                          : 1,
                      itemBuilder: (BuildContext context,
                          int index) {
                        final bool isMultiPath =
                                files.isNotEmpty;
                        final String name =
                                (isMultiPath
                                    ? files
                                        .map((e) => e.name)
                                        .toList()[index]
                                    : _fileName ?? '...');

                        return ListTile(
                          title: Text(
                            name,
                          ),
                        );
                      },
                      separatorBuilder:
                          (BuildContext context,
                                  int index) =>
                              const Divider(),
                    ),
                  ),
      ],
    );
  }
}