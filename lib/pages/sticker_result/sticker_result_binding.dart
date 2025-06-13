import 'package:get/get.dart';

import 'sticker_result_logic.dart';

class StickerResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StickerResultLogic());
  }
}
