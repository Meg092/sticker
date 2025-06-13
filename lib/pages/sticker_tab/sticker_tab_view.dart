import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticker/main.dart';
import 'package:sticker/pages/sticker_add/sticker_add_view.dart';
import 'package:sticker/pages/sticker_first/sticker_first_view.dart';
import 'package:sticker/pages/sticker_second/sticker_second_view.dart';
import 'package:styled_widget/styled_widget.dart';

import '../sticker_first/sticker_first_logic.dart';
import 'sticker_tab_logic.dart';

class StickerTabPage extends GetView<StickerTabLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [StickerFirstPage(), StickerAddPage(), StickerSecondPage()],
      ),
      bottomNavigationBar: Obx(() => _navStickerBars()),
    );
  }

  Widget _navStickerBars() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item0Grey.webp',
            width: 22,
            height: 22,
            fit: BoxFit.cover,
          ),
          activeIcon: Image.asset(
            'assets/item0Light.webp',
            width: 22,
            height: 22,
            fit: BoxFit.cover,
          ),
          label: 'Photo notes',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              'assets/item1Light.webp',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ).decorated(
              color: primaryColor, borderRadius: BorderRadius.circular(30)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item2Grey.webp',
            width: 22,
            height: 22,
            fit: BoxFit.cover,
          ),
          activeIcon: Image.asset(
            'assets/item2Light.webp',
            width: 22,
            height: 22,
            fit: BoxFit.cover,
          ),
          label: 'Other',
        ),
      ],
      currentIndex: controller.currentIndex.value,
      onTap: (index) {
        if (index == 1) {
          Get.toNamed('/stickerAdd')?.then((_) {
            StickerFirstLogic firstLogic = Get.find();
            firstLogic.getData();
          });
        } else {
          controller.currentIndex.value = index;
          controller.pageController.jumpToPage(index);
        }
      },
    );
  }
}
