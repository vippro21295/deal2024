import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
          onPageFinished: (String url) {
            if (url == "https://sales.phattien.com/User/Login" ||
                url == "https://sales.phattien.com/User/Login?ReturnUrl=%2f") {
              executeJavaScriptLogin();
            }
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> executeJavaScriptLogin() async {
    var username = widget.username;
    var password = widget.password;

    await Future.delayed(const Duration(seconds: 1));
    await _controller.runJavaScript(
        "document.getElementsByName('UserName')[0].setAttribute('value','$username');");
    await Future.delayed(const Duration(seconds: 1));
    await _controller.runJavaScript(
        "document.getElementsByName('PassWord')[0].setAttribute('value','$password');");
    await Future.delayed(const Duration(seconds: 1));
    await _controller.runJavaScript(
        "document.getElementsByName('PassWord')[0].setAttribute('value','$password');");
    await Future.delayed(const Duration(seconds: 1));
    await _controller
        .runJavaScript("document.getElementsByClassName('submit')[0].click()");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trang chủ",
          style: TextStyle(
            color: Color.fromARGB(255, 41, 34, 246),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 183, 183),
      ),
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reload();
        },
        backgroundColor: const Color.fromARGB(255, 167, 216, 251),
        child: const Icon(Icons.replay),
      ),
    );
  }
}
