import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../screens/text_recognition/text_recognition_paints.dart';

// State for Text Recognition
class TextRecognitionState {
  final bool canProcess;
  final bool isBusy;
  final CustomPaint? customPaint;
  final String? text;
  final String recognizedTextString;
  final String targetText;

  TextRecognitionState({
    this.canProcess = true,
    this.isBusy = false,
    this.customPaint,
    this.text,
    this.recognizedTextString = '',
    this.targetText = '',
  });

  TextRecognitionState copyWith({
    bool? canProcess,
    bool? isBusy,
    CustomPaint? customPaint,
    String? text,
    String? recognizedTextString,
    String? targetText,
  }) {
    return TextRecognitionState(
      canProcess: canProcess ?? this.canProcess,
      isBusy: isBusy ?? this.isBusy,
      customPaint: customPaint ?? this.customPaint,
      text: text ?? this.text,
      recognizedTextString: recognizedTextString ?? this.recognizedTextString,
      targetText: targetText ?? this.targetText,
    );
  }
}

class TextRecognitionNotifier extends StateNotifier<TextRecognitionState> {
  late final TextRecognizer _textRecognizer;

  TextRecognitionNotifier() : super(TextRecognitionState()) {
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!state.canProcess || state.isBusy) return;

    state = state.copyWith(isBusy: true, text: '');

    try {
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null) {
        final painter = TextRecognitionCamara(
          text: state.targetText,
          recognizedText: recognizedText,
          absoluteImageSize: inputImage.metadata!.size,
          rotation: inputImage.metadata!.rotation,
        );
        state = state.copyWith(
          customPaint: CustomPaint(painter: painter),
          recognizedTextString: recognizedText.text,
        );
      } else {
        state = state.copyWith(
          text: 'Recognized text:\n\n${recognizedText.text}',
          customPaint: null,
          recognizedTextString: recognizedText.text,
        );
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void setCanProcess(bool value) {
    state = state.copyWith(canProcess: value);
  }

  void setTargetText(String value) {
    state = state.copyWith(targetText: value);
  }
}

final textRecognitionProvider =
    StateNotifierProvider.autoDispose<
      TextRecognitionNotifier,
      TextRecognitionState
    >((ref) => TextRecognitionNotifier());

// State for Camera
class CameraState {
  final CameraDescription? camera;
  final int cameraIndex;
  final double zoomLevel;
  final double minZoomLevel;
  final double maxZoomLevel;
  final bool isInitialized;

  CameraState({
    this.camera,
    this.cameraIndex = -1,
    this.zoomLevel = 0.0,
    this.minZoomLevel = 0.0,
    this.maxZoomLevel = 0.0,
    this.isInitialized = false,
  });

  CameraState copyWith({
    CameraDescription? camera,
    int? cameraIndex,
    double? zoomLevel,
    double? minZoomLevel,
    double? maxZoomLevel,
    bool? isInitialized,
  }) {
    return CameraState(
      camera: camera ?? this.camera,
      cameraIndex: cameraIndex ?? this.cameraIndex,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      minZoomLevel: minZoomLevel ?? this.minZoomLevel,
      maxZoomLevel: maxZoomLevel ?? this.maxZoomLevel,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  void setCameraIndex(int index, List<CameraDescription> cameras) {
    if (index >= 0 && index < cameras.length) {
      state = state.copyWith(cameraIndex: index, camera: cameras[index]);
    }
  }

  void updateZoom({
    double? zoomLevel,
    double? minZoomLevel,
    double? maxZoomLevel,
  }) {
    state = state.copyWith(
      zoomLevel: zoomLevel,
      minZoomLevel: minZoomLevel,
      maxZoomLevel: maxZoomLevel,
    );
  }

  void setInitialized(bool value) {
    state = state.copyWith(isInitialized: value);
  }
}

final cameraProvider =
    StateNotifierProvider.autoDispose<CameraNotifier, CameraState>(
      (ref) => CameraNotifier(),
    );
