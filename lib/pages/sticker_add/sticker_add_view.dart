import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';
import 'sticker_add_logic.dart';

class StickerAddPage extends StatefulWidget {
  const StickerAddPage({Key? key}) : super(key: key);

  @override
  State<StickerAddPage> createState() => _StickerAddPageState();
}

class _StickerAddPageState extends State<StickerAddPage> {
  final logic = Get.find<StickerAddLogic>();

  late CameraController _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  bool _isWeb = kIsWeb;

  int _currentCameraIndex = 1;

  bool _isRearCameraSelected = true;

  final double _stickerWidth = 350;
  final double _stickerHeight = 550;
  final double _horizontalPadding = 20.0;

  Future<bool> _checkPermissions() async {
    if (!_isWeb) {
      try {
        final statuses = await [
          Permission.camera,
          Permission.microphone,
        ].request();
        final cameraGranted =
            statuses[Permission.camera] == PermissionStatus.granted;
        final micGranted =
            statuses[Permission.microphone] == PermissionStatus.granted;
        return cameraGranted && micGranted;
      } catch (e) {
        print("Permission request exception: $e");
        return false;
      }
    }
    return true;
  }

  void _checkCameraAvailability() async {
    final status = await _checkPermissions();
    if (status) {
      _initializeCamera();
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: const Text('Camera and Microphone permissions required'),
        content: const Text(
            'Please grant camera and microphone permission to get distance'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Setting'),
          ),
        ],
      ),
    );
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || (_cameras?.length ?? 0) < 2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No other cameras were found')));
      return;
    }

    setState(() => _currentCameraIndex = _currentCameraIndex == 0 ? 1 : 0);

    await _controller.dispose();

    _controller = CameraController(
      _cameras![_currentCameraIndex],
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isRearCameraSelected = !_isRearCameraSelected;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Switch camera failed: ${e.toString()}')));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkCameraAvailability();
  }

  Future<void> _initializeCamera() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool frontCamera = prefs.getBool('frontCamera') ?? true;
    _currentCameraIndex = frontCamera ? 1 : 0;
    if (!_isWeb) {
      _cameras = await availableCameras();
      if (_cameras == null || (_cameras?.length ?? 0) < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No other cameras were found')));
        return;
      }
      _controller = CameraController(
          _cameras![_currentCameraIndex], ResolutionPreset.high);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              break;
            default:
              break;
          }
        }
      });
    }
  }

  Widget _buildFixedSticker() {
    return Positioned(
      top: 100,
      left: _horizontalPadding,
      right: _horizontalPadding,
      child: Container(
        width: _stickerWidth,
        height: _stickerHeight,
        child: Obx(() {
          return Image.asset(
            'assets/img${logic.defaultImg.value}.webp',
            width: _stickerWidth,
            height: _stickerHeight,
            fit: BoxFit.fill,
          );
        }),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_cameras == null || (_cameras?.length ?? 0) < 2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No other cameras were found')));
      return;
    }
    try {
      XFile image;
      if (_isWeb) {
        image = (await ImagePicker().pickImage(source: ImageSource.camera))!;
      } else {
        image = await _controller.takePicture();
      }
      setState(() => _capturedImage = image);
      _saveWithSticker();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Widget _getPreview() {
    if (_isWeb) {
      return _capturedImage != null
          ? Image.network(_capturedImage!.path)
          : const Center(child: Text('Take a picture first'));
    } else {
      return _cameras?.isNotEmpty == true
          ? CameraPreview(_controller)
          : <Widget>[
             const Text(
                'No camera available',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              )
            ].toColumn(mainAxisAlignment: MainAxisAlignment.end);
    }
  }

  Future<img.Image> _fixImageOrientation(Uint8List bytes) async {
    img.Image image = img.decodeImage(bytes)!;
    if (bytes.length > 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      int offset = 2;
      while (offset < bytes.length - 1) {
        if (bytes[offset] != 0xFF) break;

        final marker = bytes[offset + 1];
        final length = (bytes[offset + 2] << 8) | bytes[offset + 3];

        if (marker == 0xE1) {
          final exifData = bytes.sublist(offset + 4, offset + 4 + length - 2);
          final orientation = _getOrientationFromExif(exifData);
          image = _applyOrientation(image, orientation);
          break;
        }

        offset += 2 + length;
      }
    }
    return image;
  }

  int _getOrientationFromExif(Uint8List exifData) {
    const orientationTag = 0x0112;
    try {
      if (exifData.length > 6) {
        final byteOrder = exifData[0] == 0x49 ? 'little' : 'big';
        final ifdOffset = _toInt32(exifData.sublist(4, 8), byteOrder);

        final entryCount =
            _toInt16(exifData.sublist(ifdOffset, ifdOffset + 2), byteOrder);

        for (int i = 0; i < entryCount; i++) {
          final entryOffset = ifdOffset + 2 + i * 12;
          final tag = _toInt16(
              exifData.sublist(entryOffset, entryOffset + 2), byteOrder);

          if (tag == orientationTag) {
            final format = _toInt16(
                exifData.sublist(entryOffset + 2, entryOffset + 4), byteOrder);
            final components = _toInt32(
                exifData.sublist(entryOffset + 4, entryOffset + 8), byteOrder);

            if (format == 3 && components == 1) {
              return _toInt16(
                  exifData.sublist(entryOffset + 8, entryOffset + 10),
                  byteOrder);
            }
          }
        }
      }
    } catch (e) {
      print('Error parsing Exif: $e');
    }
    return 1;
  }

  img.Image _applyOrientation(img.Image image, int orientation) {
    switch (orientation) {
      case 2:
        return img.flipHorizontal(image);
      case 3:
        return img.copyRotate(image, angle: 180);
      case 4:
        return img.flipVertical(image);
      case 5:
        return img.copyRotate(img.flipHorizontal(image), angle: -90);
      case 6:
        return img.copyRotate(image, angle: -90);
      case 7:
        return img.copyRotate(img.flipHorizontal(image), angle: 90);
      case 8:
        return img.copyRotate(image, angle: 90);
      default:
        return image;
    }
  }

  int _toInt16(List<int> bytes, String byteOrder) {
    if (byteOrder == 'little') {
      return (bytes[1] << 8) | bytes[0];
    } else {
      return (bytes[0] << 8) | bytes[1];
    }
  }

  int _toInt32(List<int> bytes, String byteOrder) {
    if (byteOrder == 'little') {
      return (bytes[3] << 24) | (bytes[2] << 16) | (bytes[1] << 8) | bytes[0];
    } else {
      return (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
    }
  }

  bool get _isFrontCameraUsed =>
      !kIsWeb &&
      _cameras != null &&
      _cameras![_currentCameraIndex].lensDirection == CameraLensDirection.front;

  Future<void> _saveWithSticker() async {
    if (_capturedImage == null) return;

    try {
      final bytes = await _capturedImage!.readAsBytes();
      img.Image originalImage = await _fixImageOrientation(bytes);

      if (_isFrontCameraUsed) {
        originalImage = img.flipHorizontal(originalImage);
      }

      final ByteData stickerData =
          await rootBundle.load('assets/img${logic.defaultImg.value}.webp');
      final Uint8List stickerBytes = stickerData.buffer.asUint8List();
      img.Image stickerImage = img.decodeImage(stickerBytes)!;

      final previewSize = MediaQuery.of(context).size;
      final imageRatio = originalImage.width / previewSize.width;

      final double actualHorizontalPadding = _horizontalPadding * imageRatio;
      final double actualStickerHeight = _stickerHeight * imageRatio;

      final targetStickerWidth =
          originalImage.width - (2 * actualHorizontalPadding);
      final scaledSticker = img.copyResize(
        stickerImage,
        width: targetStickerWidth.toInt(),
        height:
            (stickerImage.height * (targetStickerWidth / stickerImage.width))
                .toInt(),
      );

      img.Image composite =
          img.copyResize(originalImage, width: originalImage.width);
      final yPosition = (actualStickerHeight * 0.2).toInt();
      img.compositeImage(
        composite,
        scaledSticker,
        dstX: actualHorizontalPadding.toInt(),
        dstY: yPosition,
        blend: img.BlendMode.alpha,
      );

      final Uint8List resultBytes =
          Uint8List.fromList(img.encodePng(composite));
      Get.toNamed('/stickerResult', arguments: resultBytes);
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_cameras != null && (_cameras?.length ?? 0) >= 2) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xff4d4d4d),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: null,
        foregroundColor: Colors.white,
      ),
      body: <Widget>[
        Expanded(
            child: Container(
          child: <Widget>[
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _getPreview(),
            ),
            _buildFixedSticker(),
          ].toStack(),
        )),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).padding.bottom + 100,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: <Widget>[
            Image.asset(
              'assets/icon0.webp',
              fit: BoxFit.cover,
            ).gestures(onTap: () {
              logic.switchSticker();
            }),
            Image.asset(
              'assets/icon1.webp',
              fit: BoxFit.cover,
            ).gestures(onTap: () {
              _takePicture();
            }),
            Image.asset(
              'assets/icon2.webp',
              fit: BoxFit.cover,
            ).gestures(onTap: () {
              if (!_isWeb) {
                _switchCamera();
              }
            }),
          ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ).decorated(color: Colors.black)
      ].toColumn(),
    );
  }
}
