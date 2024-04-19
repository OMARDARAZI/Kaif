import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewLogic extends GetxController {
  WebViewController controller = WebViewController();
  var loadingPercentage = 0;
  String link = 'https://trustotech.site/demo/Kaif.sa';

  loadController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            loadingPercentage = 0;
            update();
          },
          onProgress: (progress) {
            loadingPercentage = progress;
            update();
          },
          onPageFinished: (url) {
            loadingPercentage = 100;
            update();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('whatsapp://')) {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(link));
  }

  void _launchURL(String url) async {
    await launch(url);
  }
}
