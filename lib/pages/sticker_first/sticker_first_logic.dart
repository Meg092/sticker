
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sticker/db_sticker/db_sticker.dart';

import '../../db_sticker/sticker_entity.dart';

class StickerFirstLogic extends GetxController {
  DBSticker dbSticker = Get.find<DBSticker>();

  var list = <StickerEntity>[].obs;

  var isEdit = false.obs;

  List<StickerEntity> selectedList = [];

  getData() async {
    list.value = await dbSticker.getStickerAllData();
  }

  void deleteData() async {
    if (selectedList.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select data!');
      return;
    }
    await dbSticker.deleteStickers(selectedList);
    selectedList.clear();
    await getData();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }
}
