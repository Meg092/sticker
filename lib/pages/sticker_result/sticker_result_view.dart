import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'sticker_result_logic.dart';

class StickerResultPage extends GetView<StickerResultLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff4d4d4d),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: <Widget>[
          Expanded(
              child: Image.memory(
            controller.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).padding.bottom + 100,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: <Widget>[
              Image.asset(
                'assets/icon3.webp',
                fit: BoxFit.cover,
              ).gestures(onTap: () {
                controller.addData();
              }),
              const SizedBox(
                width: 50,
              ),
              Image.asset(
                'assets/icon4.webp',
                fit: BoxFit.cover,
              ).gestures(onTap: () {
                Get.back();
              })
            ].toRow(mainAxisAlignment: MainAxisAlignment.center),
          ).decorated(color: Colors.black)
        ].toColumn(),
      ),
    );
  }
}
