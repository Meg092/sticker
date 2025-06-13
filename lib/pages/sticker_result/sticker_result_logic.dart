import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:sticker/db_sticker/db_sticker.dart';
import 'package:sticker/db_sticker/sticker_entity.dart';

import '../sticker_first/sticker_first_logic.dart';

class StickerResultLogic extends GetxController {

  DBSticker dbSticker = Get.find();

  Uint8List image = Get.arguments;

  void addData() async {
    await dbSticker.insertSticker(StickerEntity(id: 0, createdTime: DateTime.now(), image: image));
    Get.until((route) => Get.currentRoute == '/stickerTab');
    StickerFirstLogic firstLogic = Get.find();
    firstLogic.getData();
  }

}
