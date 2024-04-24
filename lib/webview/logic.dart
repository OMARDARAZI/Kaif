import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewLogic extends GetxController {
  WebViewController controller = WebViewController();
  var loadingPercentage = 0;
  String link = 'https://trustotech.site/demo/Kaif.sa';

  Future<bool> getPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print("Location permission granted");
    } else if (status.isDenied) {
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();  // Open app settings if permission is permanently denied
    }
  }

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

          onWebResourceError: (WebResourceError error) {

          },


          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('whatsapp://')) {
              launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(link));
  }

  void launchURL(String url) async {
    await launch(url);
  }
}
