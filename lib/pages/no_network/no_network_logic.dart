
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoNetworkLogic extends GetxController {

  void checkNetwork() async {
    final hadNetwork = await InternetConnectionChecker.instance.hasConnection;
    if (!hadNetwork) {
      Fluttertoast.showToast(msg: 'Check the network and try again');
    } else {
      Fluttertoast.showToast(msg: 'You are connected to the internet');
      Get.back();
    }
  }

}
