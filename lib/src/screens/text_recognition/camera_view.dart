import 'package:agent_ai/src/riverpod/text_recognition_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../core/common/custom_appbar.dart';
import '../../../main.dart';

class CameraView extends ConsumerStatefulWidget {
  const CameraView({
    super.key,
    required this.title,
    required this.customPaint,
    this.text,
    required this.onImage,
    this.initialDirection = CameraLensDirection.back,
  });

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() {
    final cameraStateNotifier = ref.read(cameraProvider.notifier);
    int cameraIndex = -1;

    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) =>
              element.lensDirection == widget.initialDirection &&
              element.sensorOrientation == 90,
        ),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          cameraIndex = i;
          break;
        }
      }
    }

    if (cameraIndex != -1) {
      Future.microtask(() {
        cameraStateNotifier.setCameraIndex(cameraIndex, cameras);
        _startLiveFeed();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        isTitle: true,
        isleading: true,
        leading: widget.title,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.ellipsis_circle),
          ),
        ],
      ),
      body: _liveFeedBody(),
    );
  }

  Widget _liveFeedBody() {
    final cameraState = ref.watch(cameraProvider);

    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          if (widget.customPaint != null) widget.customPaint!,
          Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: Slider(
              value: cameraState.zoomLevel,
              min: cameraState.minZoomLevel,
              max: cameraState.maxZoomLevel,
              onChanged: (newSliderValue) {
                ref
                    .read(cameraProvider.notifier)
                    .updateZoom(zoomLevel: newSliderValue);
                _controller!.setZoomLevel(newSliderValue);
              },
              divisions: (cameraState.maxZoomLevel - 1).toInt() < 1
                  ? null
                  : (cameraState.maxZoomLevel - 1).toInt(),
            ),
          ),
        ],
      ),
    );
  }

  Future _startLiveFeed() async {
    final cameraState = ref.read(cameraProvider);
    final cameraNotifier = ref.read(cameraProvider.notifier);

    if (cameraState.cameraIndex == -1) return;

    final camera = cameras[cameraState.cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.getMinZoomLevel().then((value) {
        cameraNotifier.updateZoom(
          zoomLevel: value > 3 ? 3 : value,
          minZoomLevel: value > 3 ? 3 : value,
        );
      });
      _controller?.getMaxZoomLevel().then((value) {
        cameraNotifier.updateZoom(maxZoomLevel: value);
      });
      _controller?.startImageStream(_processCameraImage);
      // Force rebuild to show camera preview
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final cameraState = ref.read(cameraProvider);
    if (cameraState.cameraIndex == -1) return;

    final camera = cameras[cameraState.cameraIndex];
    final imageRotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    if (imageRotation == null) return;

    final inputImageFormat = InputImageFormatValue.fromRawValue(
      image.format.raw,
    );
    if (inputImageFormat == null) return;

    final inputImageMetadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageMetadata,
    );

    widget.onImage(inputImage);
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }
}
