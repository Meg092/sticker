import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticker/main.dart';
import 'package:sticker/pages/sticker_first/image_saver.dart';
import 'package:styled_widget/styled_widget.dart';

import 'sticker_first_logic.dart';

class StickerFirstPage extends GetView<StickerFirstLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo notes'),
        backgroundColor: Colors.white,
        actions: [
          Obx(() {
            return Text(
              controller.isEdit.value ? 'Select all' : 'Select',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ).marginOnly(right: 20).gestures(onTap: () {
              if (!controller.isEdit.value) {
                controller.isEdit.value = !controller.isEdit.value;
              } else {
                controller.selectedList.clear();
                controller.selectedList.addAll(controller.list);
              }

              controller.getData();
            });
          }),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: <Widget>[
          Expanded(child: Obx(() {
            return controller.list.value.isEmpty
                ? <Widget>[const Text('No data')]
                    .toColumn(mainAxisAlignment: MainAxisAlignment.center)
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 158 / 212),
                    padding: const EdgeInsets.all(15),
                    itemCount: controller.list.value.length,
                    itemBuilder: (_, index) {
                      final item = controller.list.value[index];
                      return <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            child: Image.memory(item.image,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover),
                          ).decorated(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xffdedede))),
                        ),
                        Positioned(
                            bottom: 15,
                            right: 15,
                            child: const Icon(
                              Icons.save,
                              size: 22,
                              color: Colors.black,
                            ).gestures(onTap: (){
                              ImageSaver.saveImage(item.image);
                            })),
                        Visibility(
                            visible: controller.isEdit.value,
                            child: Positioned(
                              top: 15,
                              right: 15,
                              child: controller.selectedList
                                      .where((e) => e.id == item.id)
                                      .toList()
                                      .isNotEmpty
                                  ? Icon(
                                      Icons.check_box,
                                      size: 16,
                                      color: primaryColor,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                            ))
                      ].toStack().gestures(onTap: () {
                        if (!controller.isEdit.value) {
                          return;
                        }
                        final myselfIds = controller.selectedList
                            .where((e) => e.id == item.id)
                            .toList();
                        if (myselfIds.isEmpty) {
                          controller.selectedList.add(item);
                        } else {
                          controller.selectedList
                              .removeWhere((e) => e.id == item.id);
                        }
                        controller.getData();
                      });
                    });
          })),
          Obx(() {
            return Visibility(
              visible: controller.isEdit.value,
              child: Container(
                width: double.infinity,
                height: 60,
                child: <Widget>[
                  Expanded(
                      child: const Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                  ).gestures(onTap: () {
                    controller.isEdit.value = !controller.isEdit.value;
                    controller.getData();
                  })),
                  Container(
                    width: 1,
                    height: 40,
                  ).decorated(color: Colors.grey.shade200),
                  Expanded(
                      child: Text(
                    'Delete',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: primaryColor),
                  ).gestures(onTap: () {
                    controller.deleteData();
                  }))
                ].toRow(),
              )
                  .decorated(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30))
                  .marginSymmetric(vertical: 10, horizontal: 15),
            );
          })
        ].toColumn(),
      ),
    );
  }
}
