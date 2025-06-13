import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageSaver {
  static Future<bool> saveImage(Uint8List imageBytes) async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) return false;
    }
    try {
      final result = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 100,
        name: "my_image_${DateTime.now().millisecondsSinceEpoch}",
      );
      if (result['isSuccess'] == true) {
        Fluttertoast.showToast(msg: 'Saved to album successfully');
      }
      return result['isSuccess'] == true;
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Save failed: $e');
      return false;
    }
  }
}
