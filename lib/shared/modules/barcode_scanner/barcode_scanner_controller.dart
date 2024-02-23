import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payflow/shared/modules/barcode_scanner/barcone_scanner_status.dart';

class BarcodeScannerController {
  final statusNotifier =
      ValueNotifier<BarcodeScannerStatus>(BarcodeScannerStatus());
  BarcodeScannerStatus get status => statusNotifier.value;
  set status(BarcodeScannerStatus status) => statusNotifier.value = status;

  var barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  CameraController? cameraController;

  InputImage? imagePicker;

  void getAvailableCameras() async {
    try {
      final response = await availableCameras();
      final camera = response.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      cameraController =
          CameraController(camera, ResolutionPreset.max, enableAudio: false);
      await cameraController!.initialize();
      scanWithCamera();
      listenCamera();
    } catch (e) {
      status = BarcodeScannerStatus.error(e.toString());
    }
  }

  Future<void> scannerBarCode(InputImage inputImage) async {
    try {
      final barcodes = await barcodeScanner.processImage(inputImage);

      var barcode;
      for (Barcode item in barcodes) {
        barcode = item.displayValue;
      }

      if (barcode != null && status.barcode.isEmpty) {
        status = BarcodeScannerStatus.barcode(barcode);
        cameraController!.dispose();
        await barcodeScanner.close();
      }

      return;
    } catch (e) {
      print("ERRO DA LEITURA $e");
    }
  }

  void scanWithImagePicker() async {
    final response = await ImagePicker().pickImage(source: ImageSource.gallery);
    final inputImage = InputImage.fromFilePath(response!.path);
    scannerBarCode(inputImage);
  }

  void scanWithCamera() {
    status = BarcodeScannerStatus.available();
    Future.delayed(Duration(seconds: 20)).then((value) {
      if (status.hasBarcode == false)
        status = BarcodeScannerStatus.error("Timeout de leitura de boleto");
    });
  }

  void listenCamera() {
    if (!cameraController!.value.isStreamingImages) {
      cameraController!.startImageStream((CameraImage cameraImage) async {
        if (status.stopScanner == false) {
          try {
            final InputImageRotation imageRotation =
                InputImageRotation.rotation0deg;
            const InputImageFormat inputImageFormat = InputImageFormat.nv21;

            final WriteBuffer allBytes = WriteBuffer();
            for (Plane plane in cameraImage.planes) {
              allBytes.putUint8List(plane.bytes);
            }
            final Uint8List bytes = allBytes.done().buffer.asUint8List();

            final InputImageMetadata inputImageData = InputImageMetadata(
              size: Size(
                  cameraImage.width.toDouble(), cameraImage.height.toDouble()),
              rotation: InputImageRotation.rotation0deg,
              format: InputImageFormat.nv21,
              bytesPerRow: 0,
            );

            final InputImage inputImageCamera = InputImage.fromBytes(
              bytes: bytes,
              metadata: inputImageData,
            );

            scannerBarCode(inputImageCamera);
          } catch (e) {
            print(e);
          }
        }
      });
    }
  }

  void dispose() {
    statusNotifier.dispose();
    barcodeScanner.close();
    if (status.showCamera) {
      cameraController!.dispose();
    }
  }
}
