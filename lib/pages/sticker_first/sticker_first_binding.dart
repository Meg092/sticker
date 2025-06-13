import 'package:get/get.dart';

import 'sticker_first_logic.dart';

class StickerFirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StickerFirstLogic());
  }
}
