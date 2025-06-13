import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticker/db_sticker/db_sticker.dart';
import 'package:sticker/pages/no_network/no_network_binding.dart';
import 'package:sticker/pages/no_network/no_network_view.dart';
import 'package:sticker/pages/sticker_add/sticker_add_binding.dart';
import 'package:sticker/pages/sticker_add/sticker_add_view.dart';
import 'package:sticker/pages/sticker_first/sticker_first_binding.dart';
import 'package:sticker/pages/sticker_first/sticker_first_view.dart';
import 'package:sticker/pages/sticker_map/sticker_map_binding.dart';
import 'package:sticker/pages/sticker_map/sticker_map_view.dart';
import 'package:sticker/pages/sticker_result/sticker_result_binding.dart';
import 'package:sticker/pages/sticker_result/sticker_result_view.dart';
import 'package:sticker/pages/sticker_second/sticker_second_binding.dart';
import 'package:sticker/pages/sticker_second/sticker_second_view.dart';
import 'package:sticker/pages/sticker_tab/sticker_tab_binding.dart';
import 'package:sticker/pages/sticker_tab/sticker_tab_view.dart';

import 'db_sticker/sticker_init.dart';

Color primaryColor = const Color(0xffff8084);
Color bgColor = const Color(0xfffafafa);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final defaultImg = prefs.getInt('defaultImg');
  if (defaultImg == null) {
   await prefs.setInt('defaultImg', 0);
   await prefs.setBool('frontCamera', true);
  }
  await Get.putAsync(() => DBSticker().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Stickers,
      initialRoute: '/',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
List<GetPage<dynamic>> Stickers = [
  GetPage(name: '/', page: () => const StickerMapView(), binding: StickerMapBinding()),
  GetPage(name: '/noNetwork', page: () => NoNetworkPage(), binding: NoNetworkBinding()),
  GetPage(name: '/stickerAdd', page: () => const StickerAddPage(), binding: StickerAddBinding()),
  GetPage(name: '/stickerFirst', page: () => StickerFirstPage(), binding: StickerFirstBinding()),
  GetPage(name: '/stickerResult', page: () => StickerResultPage(), binding: StickerResultBinding()),
  GetPage(name: '/stickerHa', page: () => const StickerInit()),
  GetPage(name: '/stickerSecond', page: () => StickerSecondPage(), binding: StickerSecondBinding()),
  GetPage(name: '/stickerTab', page: () => StickerTabPage(), binding: StickerTabBinding()),
];