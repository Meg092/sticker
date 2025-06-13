import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticker/db_sticker/db_sticker.dart';
import 'package:sticker/pages/sticker_first/sticker_first_logic.dart';
import 'package:styled_widget/styled_widget.dart';

class StickerSecondLogic extends GetxController {
  DBSticker dbSticker = Get.find<DBSticker>();

  var defaultImg = 0.obs;
  var frontCamera = true.obs;

  switchSticker() async {
    var selectedImg = defaultImg.value;
    Get.dialog(AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.81),
      content: SizedBox(
        width: 300,
        height: 250,
        child: GetBuilder<StickerSecondLogic>(
            id: 'second',
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
                      update(['second']);
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
          onPressed: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('defaultImg', selectedImg);
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

  cleanStickerData() async {
    Get.dialog(AlertDialog(
      title: const Text('Warm reminder'),
      content: const Text('Do you want to clean all records?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            await dbSticker.cleanStickerData();
            StickerFirstLogic firstLogic = Get.find();
            firstLogic.isEdit.value = false;
            firstLogic.selectedList.clear();
            firstLogic.getData();
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ));
  }

  aboutStickerUS(BuildContext context) async {
    var info = await PackageInfo.fromPlatform();
    showAboutDialog(
      applicationName: info.appName,
      applicationVersion: info.version,
      applicationIcon: Image.asset(
        'assets/launcher.webp',
        width: 71,
        height: 71,
      ),
      children: [
        const Text("""We can provide you with sticker photography"""),
      ],
      context: context,
    );
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultImg.value = prefs.getInt('defaultImg') ?? 0;
    frontCamera.value = prefs.getBool('frontCamera') ?? true;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }
}
