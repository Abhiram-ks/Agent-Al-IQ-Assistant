import 'package:agent_ai/core/app_manage/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

class TextRecognitionCamara extends CustomPainter {
  final String text;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final RecognizedText recognizedText;
  const TextRecognitionCamara({
    required this.text,
    required this.absoluteImageSize,
    required this.rotation,
    required this.recognizedText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = AppPalette.red;

    final Paint background = Paint()..color = Color(0x99000000);

    for (final textBlocks in recognizedText.blocks) {
      for (final line in textBlocks.lines) {
        for (final element in line.elements) {
          final ParagraphBuilder builder = ParagraphBuilder(
            ParagraphStyle(textAlign: .left, fontSize: 16, textDirection: .ltr),
          );
          builder.pushStyle(
            ui.TextStyle(color: AppPalette.red, background: background),
          );
          builder.addText(element.text);
          builder.pop();

          final left = translateX(
            element.boundingBox.left,
            rotation,
            size,
            absoluteImageSize,
          );
          final top = translateY(
            element.boundingBox.top,
            rotation,
            size,
            absoluteImageSize,
          );
          final right = translateX(
            element.boundingBox.right,
            rotation,
            size,
            absoluteImageSize,
          );
          final bottom = translateY(
            element.boundingBox.bottom,
            rotation,
            size,
            absoluteImageSize,
          );

          if (element.text.toLowerCase().contains(text.toLowerCase())) {
            canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);

            canvas.drawParagraph(
              builder.build()
              ..layout(ParagraphConstraints(width: right - left)),
              Offset(left, top),
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(TextRecognitionCamara oldDelegate) {
    return oldDelegate.recognizedText != recognizedText;
  }
}

double translateX(
  double x,
  InputImageRotation rotation,
  Size size,
  Size absoluteImageSize,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x *
          size.width /
          (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.rotation270deg:
      return size.width -
          x *
              size.width /
              (Platform.isIOS
                  ? absoluteImageSize.width
                  : absoluteImageSize.height);
    default:
      return x * size.width / absoluteImageSize.width;
  }
}

double translateY(
  double y,
  InputImageRotation rotation,
  Size size,
  Size absoluteImageSize,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return y * size.height / absoluteImageSize.height;
  }
}
