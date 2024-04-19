// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return GetBuilder<WebviewLogic>(
      init: WebviewLogic(),
      builder: (logic) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(
                  controller: logic.controller,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
