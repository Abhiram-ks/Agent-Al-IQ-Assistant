import 'package:agent_ai/src/riverpod/text_recognition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'camera_view.dart';

class TextRecognitionScreen extends ConsumerWidget {
  const TextRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textState = ref.watch(textRecognitionProvider);
    final notifier = ref.read(textRecognitionProvider.notifier);

    return CameraView(
      title: 'Text Recognition',
      customPaint: textState.customPaint,
      text: textState.text,
      onImage: (inputImage) {
        notifier.processImage(inputImage);
      },
    );
  }
}
