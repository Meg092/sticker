import 'package:get/get.dart';
import 'package:sticker/pages/sticker_first/sticker_first_logic.dart';
import 'package:sticker/pages/sticker_second/sticker_second_logic.dart';

import 'sticker_tab_logic.dart';

class StickerTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StickerTabLogic());
    Get.lazyPut(() => StickerFirstLogic());
    Get.lazyPut(() => StickerSecondLogic());
  }
}
