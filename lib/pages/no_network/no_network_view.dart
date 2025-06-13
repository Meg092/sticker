import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'no_network_logic.dart';

class NoNetworkPage extends GetView<NoNetworkLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('No Network'),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/noNetwork.webp',
              width: 157,
              height: 152.5,
              fit: BoxFit.cover,
            ),
            const Text(
              'I was distracted on the Internet',
              style: TextStyle(color: Colors.black45),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 157,
              height: 46,
              alignment: Alignment.center,
              child: const Text('Reload',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xffa5a5a5)),),
            )
                .decorated(
                    borderRadius: BorderRadius.circular(23),
                    color: Colors.white,
                    border: Border.all(color: const Color(0xffa9a9a9), width: 0.5))
                .gestures(onTap: () {
              controller.checkNetwork();
            })
          ].toColumn(),
        ).marginAll(15)),
      ),
    );
  }
}
