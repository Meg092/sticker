import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class StickerAddLogic extends GetxController {

  var defaultImg = 0.obs;

  switchSticker() async {
    var selectedImg = defaultImg.value;
    Get.dialog(AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.81),
      content: SizedBox(
        width: 300,
        height: 250,
        child: GetBuilder<StickerAddLogic>(
            id: 'sticker',
            builder: (_) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 96 / 122),
                  itemCount: 6,
                  itemBuilder: (_, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/img$index.webp',
                        fit: BoxFit.cover,
                      ),
                    )
                        .decorated(
                      borderRadius: BorderRadius.circular(13),
                      border: selectedImg == index
                          ? Border.all(color: Colors.white)
                          : null,
                      color: selectedImg == index
                          ? const Color(0xff393939)
                          : Colors.transparent,
                    )
                        .gestures(onTap: () {
                      selectedImg = index;
                      update(['sticker']);
                    });
                  });
            }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            textAlign: TextAlign.center,
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            defaultImg.value = selectedImg;
            Get.back();
          },
          child: const Text(
            'OK',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultImg.value = prefs.getInt('defaultImg')  ??  0;
    super.onInit();
  }

}
