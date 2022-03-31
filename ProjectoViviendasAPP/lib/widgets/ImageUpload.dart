import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  ImageUpload({Key? key, this.imageFileList}) : super(key: key);
  final imageFileList;
  ImageUploadState ?iuState;

  @override
  State<ImageUpload> createState() {
    iuState = ImageUploadState(imageFileList);
    return iuState!;
  }
}

class ImageUploadState extends State<ImageUpload> {
  ImageUploadState(this._imageFileList);
  final List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    // _imageFileList = value == null ? null : [value];
    if(value != null) _imageFileList!.add(value);
  }

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  void onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    double ?maxWidth;
    double ?maxHeight;
    if (isMultiImage) {
      try {
        final pickedFileList = await _picker.pickMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: 25,
        );
        setState(() {
          _imageFileList!.addAll(pickedFileList!);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: 25,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Center(
            child: GridView.builder(
              key: UniqueKey(),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                // Why network for web?
                // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                return Semantics(
                  label: 'image_picker_example_picked_image',
                  child: FittedBox(
                    child: kIsWeb
                      ? Image.network(_imageFileList![index].path)
                      : Image.file(File(_imageFileList![index].path)),
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                  )
                );
              },
              itemCount: _imageFileList!.length,
            ),
         
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: const Text(
                            'Todavia no seleccionaste ninguna imagen',
                            textAlign: TextAlign.center,
                          ),
                        );
                      case ConnectionState.done:
                        if(_imageFileList!.isNotEmpty){
                          return _previewImages();
                        }
                        else{
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: const Text(
                            'Todavia no seleccionaste ninguna imagen',
                            textAlign: TextAlign.center,
                        ),
                          );
                        }
            
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'Todavia no seleccionaste ninguna imagen',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
              : _previewImages(),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);
