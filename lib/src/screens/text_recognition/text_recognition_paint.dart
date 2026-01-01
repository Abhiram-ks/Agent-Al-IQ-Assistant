import 'package:agent_ai/core/app_manage/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

class TextRecognitionCamara extends StatelessWidget {
  final String text;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final RecognizedText recognizedText;
  const TextRecognitionCamara({super.key, required this.text, required this.absoluteImageSize, required this.rotation, required this.recognizedText});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..color =  AppPalette.red;

    final Paint background = Paint()..color =  Color(0x99000000);

    for(final textBlocks in recognizedText.blocks) {
      for(final line in textBlocks.lines) {
        for (final element in line.elements) {
           final ParagraphBuilder builder = ParagraphBuilder(
            ParagraphStyle(
              textAlign: .left,
              fontSize: 16,
              textDirection: .ltr,
            ),
           );
           builder.pushStyle(
            ui.TextStyle(color: AppPalette.red, background: background)
           );
           builder.addText(element.text);
           builder.pop();
        }
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}