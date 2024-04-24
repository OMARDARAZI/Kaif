// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:fl_webview/fl_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'logic.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({super.key});

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  final logic = Get.put(WebviewLogic());

  @override
  void initState() {
    logic.loadController();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    if (await logic.controller.canGoBack()) {
      logic.controller.goBack();
      return Future.value(false);
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to leave?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Permission.camera.request();
    return GetBuilder<WebviewLogic>(
      init: WebviewLogic(),
      builder: (logic) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            child: Stack(
              children: [
                FlWebView(
                    delegate: FlWebViewDelegate(
                      onPageStarted: (controller, url) {
                        if(url!.contains('whatsapp://')){
                          controller.loadUrl(LoadUrlRequest('https://trustotech.site/demo/Kaif.sa/'));
                          logic.launchURL(url);
                          log(controller.getTitle().toString());
                        }
                      },
                      onPageFinished: (controller, url) {
                        log('onPageFinished : $url');
                      },
                      onProgress:
                          (FlWebViewController controller, int progress) {
                        log('onProgress ：$progress');
                      },
                      onSizeChanged: (FlWebViewController controller,
                          WebViewSize webViewSize) {
                        log('onSizeChanged : ${webViewSize.frameSize} --- ${webViewSize.contentSize}');
                      },
                      onScrollChanged: (FlWebViewController controller,
                          WebViewSize webViewSize,
                          Offset offset,
                          ScrollPositioned positioned) {
                        log('onScrollChanged : ${webViewSize.frameSize} --- ${webViewSize.contentSize} --- $offset --- $positioned');
                      },
                      onGeolocationPermissionsShowPrompt: (_, origin) async {
                        log('onGeolocationPermissionsShowPrompt : $origin');

                        return await logic.getPermission(Permission.locationWhenInUse);
                      },
                    ),
                    load:
                        LoadUrlRequest('https://trustotech.site/demo/Kaif.sa'),
                    progressBar: FlProgressBar(color: Colors.red),
                    webSettings: WebSettings(),
                    onWebViewCreated: (FlWebViewController controller) async {
                      logic.requestLocationPermission();
                      String userAgentString = 'userAgentString';
                      final value = await controller.getNavigatorUserAgent();
                      userAgentString = '$value = $userAgentString';
                      final userAgent =
                          await controller.setUserAgent(userAgentString);
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
