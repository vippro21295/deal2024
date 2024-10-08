import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//import 'package:flutter/scheduler.dart';

class WebViewDeal extends StatefulWidget {
  final String username;
  final String password;
  const WebViewDeal(
      {super.key, required this.username, required this.password});

  @override
  State<WebViewDeal> createState() => _WebViewDealState();
}

class _WebViewDealState extends State<WebViewDeal> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://sales.phattien.com'))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            executeJavaScript();
          },
        ),
      );
    // setBackgroundColor is not currently supported on macOS.
    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  Future<void> executeJavaScript() async {
    var username = widget.username;
    var password = widget.password;

    await Future.delayed(const Duration(seconds: 3));

    await _controller.runJavaScript(
        "document.getElementsByName('UserName')[0].setAttribute('value','$username');"
        "document.getElementsByName('PassWord')[0].setAttribute('value','$password');"
        "document.getElementsByClassName('submit')[0].click()");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
