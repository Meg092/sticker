import 'package:get/get.dart';

import 'sticker_second_logic.dart';

class StickerSecondBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StickerSecondLogic());
  }
}
