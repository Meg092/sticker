import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

import 'sticker_second_logic.dart';

class StickerSecondPage extends GetView<StickerSecondLogic> {
  Widget _item(int index, BuildContext context) {
    final titles = [
      'Select the default texture',
      'Default front camera',
      'Clear the historical records',
      'Version'
    ];
    return Container(
      color: Colors.transparent,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: <Widget>[
        Text(titles[index]),
        index < 2
            ? (index == 0
                ? <Widget>[
                    Obx(() {
                      return Image.asset(
                        'assets/img${controller.defaultImg.value}.webp',
                        fit: BoxFit.cover,
                      );
                    }),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      size: 20,
                      color: Colors.grey,
                    ).marginOnly(left: 10)
                  ].toRow(mainAxisAlignment: MainAxisAlignment.end)
                : Obx(() {
                    return Switch(
                        value: controller.frontCamera.value,
                        activeTrackColor: Colors.green,
                        onChanged: (v) async {
                          controller.frontCamera.value = v;
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('frontCamera', v);
                        });
                  }))
            : index == 3
                ? const Text(
                    "v1.0.0",
                    style: TextStyle(color: Colors.grey),
                  ).paddingOnly(right: 12)
                : const SizedBox()
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    )
        .decorated(color: Colors.white, borderRadius: BorderRadius.circular(12))
        .marginOnly(bottom: 10)
        .gestures(onTap: () {
      switch (index) {
        case 0:
          controller.switchSticker();
          break;
        case 1:
          break;
        case 2:
          controller.cleanStickerData();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Other"),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: <Widget>[
            <Widget>[
              _item(0, context),
              _item(1, context),
              _item(2, context),
              _item(3, context),
            ].toColumn()
          ].toColumn(),
        ).marginAll(15)),
      ),
    );
  }
}
