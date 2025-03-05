import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x000))
    ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {
          print("Page started loading: $url");
        },
        onPageFinished: (String url) {
          print("Page finished loading: $url");
        },
        onHttpError: (HttpResponseError error) {
          print("HTTP error: ${error.toString()}");
        },
        onWebResourceError: (WebResourceError error) {
          print("Web resource error: ${error.toString()}");
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        }))
    ..loadRequest(Uri.parse("https://pub.dev"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Наш сайт'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
