import 'package:ex_flite_app/recognition_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ex-TFLite',
      debugShowCheckedModeBanner: false,
      home: RecognitionDetectionScreen(),
    );
  }
}
