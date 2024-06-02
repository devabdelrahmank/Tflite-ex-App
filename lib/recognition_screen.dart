import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class RecognitionDetectionScreen extends StatefulWidget {
  const RecognitionDetectionScreen({super.key});

  @override
  _RecognitionDetectionScreenState createState() =>
      _RecognitionDetectionScreenState();
}

class _RecognitionDetectionScreenState
    extends State<RecognitionDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;

  var _recognitions;
  var v = "";
  @override
  void initState() {
    super.initState();
    loaddmodel().then((value) {
      setState(() {});
    });
  }

  loaddmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detecttimage(file!);
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future detecttimage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions!.last;

      v = recognitions.toString();
    });
    debugPrint(_recognitions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          'Object Detection via TFLITE',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              const Text('Pick an image to identify'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 20),
            Text(v),
          ],
        ),
      ),
    );
  }
}
