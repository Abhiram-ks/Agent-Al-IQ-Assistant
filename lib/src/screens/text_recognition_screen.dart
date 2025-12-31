import 'package:agent_ai/core/common/custom_appbar.dart';
import 'package:flutter/material.dart';

class TextRecognitionScreen extends StatelessWidget {
  final String recognitionText;
  const TextRecognitionScreen({super.key, required this.recognitionText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Text Recognition', isTitle: true),
    );
  }
}