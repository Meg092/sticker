import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/sticker_map/sticker_map_logic.dart';

class StickerInit extends GetView<PageLogic> {
  const StickerInit({super.key});


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final c = controller.webViewController;
        if (c != null) {
          if (await c.canGoBack()) {
            c.goBack();
            return false;
          }
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(controller.iqhyklu.value)),
              timeoutInterval:10
            ),
            initialSettings: InAppWebViewSettings(
              cacheEnabled: false,
            ),
            onWebViewCreated: (c) {
              controller.webViewController = c;
            },
            shouldOverrideUrlLoading: (controller1, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri == null) return NavigationActionPolicy.ALLOW;
              if (uri.toString().startsWith('https://wa.me/') ||
                  uri.toString().startsWith('whatsapp://')) {
                await _openWhatsApp(
                    uri.pathSegments.last, uri.queryParameters['text'] ?? '');
                return NavigationActionPolicy.CANCEL;
              }

              if (uri.scheme == 'mailto') {
                await launch(uri.toString());
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            onReceivedError: (controller,request,error){
              Get.toNamed("/Apptimeout")?.then((_){
                controller.reload();
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(String phone, String text) async {
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(text)}';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        await launch(
            'https://web.whatsapp.com/send?phone=$phone&text=${Uri.encodeComponent(text)}');
      }
    } catch (e) {
      print('Could not launch WhatsApp: $e');
    }
  }
}
