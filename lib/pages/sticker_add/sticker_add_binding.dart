import 'package:get/get.dart';

import 'sticker_add_logic.dart';

class StickerAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StickerAddLogic());
  }
}
