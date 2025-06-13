import 'package:get/get.dart';

import 'sticker_map_logic.dart';

class StickerMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PageLogic(),
      permanent: true,
    );
  }
}
