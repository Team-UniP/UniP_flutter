import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert'; // for utf8 encoding
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 토큰 저장 라이브러리

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView(); // Android에서 SurfaceWebView 사용
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web View"),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (String url) async {
          // 페이지가 로드된 후 처리할 코드
          String? jsonResponse =
              await _controller.evaluateJavascript("document.body.innerText");
          if (jsonResponse != null) {
            _handleResponse(jsonResponse);
          }

          // 쿠키를 가져오는 방법
          String cookies =
              await _controller.evaluateJavascript("document.cookie;");
          _handleCookies(cookies);
        },
      ),
    );
  }

  void _handleResponse(String response) {
    try {
      // JSON 문자열 파싱
      final Map<String, dynamic> jsonMap = json.decode(response);
      String accessToken = jsonMap['accessToken'];

      // AccessToken을 SecureStorage에 저장
      storage.write(key: 'accessToken', value: accessToken);
    } catch (e) {
      print("Error parsing JSON response: $e");
    }
  }

  void _handleCookies(String cookies) async {
    // 쿠키에서 refreshToken을 찾아 SecureStorage에 저장
    List<String> cookieList = cookies.split('; ');
    for (var cookie in cookieList) {
      if (cookie.startsWith('refreshToken=')) {
        String refreshToken = cookie.split('=')[1];
        // RefreshToken을 SecureStorage에 저장
        await storage.write(key: 'refreshToken', value: refreshToken);
        break;
      }
    }
  }
}
