import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            // 페이지 로드 후 데이터를 처리
            try {
              final String jsonResponse = await _controller
                      .runJavaScriptReturningResult("document.body.innerText")
                  as String;
              _handleResponse(jsonResponse);

              // 쿠키 처리
              final String cookies = await _controller
                  .runJavaScriptReturningResult("document.cookie") as String;
              _handleCookies(cookies);
            } catch (e) {
              print("Error: $e");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web View"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  void _handleResponse(String response) {
    try {
      final decodedResponse = json.decode(response);
      if (decodedResponse is String) {
        final Map<String, dynamic> jsonMap = json.decode(decodedResponse);
        String accessToken =
            jsonMap['accessToken']?.split(" ")[1] ?? ''; // "bearer " 이후의 값만 추출
        bool isAuthenticated = jsonMap['auth'] == "true";

        storage.write(key: 'accessToken', value: accessToken); // 순수한 토큰 값만 저장
        Navigator.pop(context, isAuthenticated);
      } else if (decodedResponse is Map<String, dynamic>) {
        String accessToken = decodedResponse['accessToken']?.split(" ")[1] ??
            ''; // "bearer " 이후의 값만 추출
        bool isAuthenticated = decodedResponse['auth'] == "true";

        storage.write(key: 'accessToken', value: accessToken); // 순수한 토큰 값만 저장
        Navigator.pop(context, isAuthenticated);
      }
    } catch (e) {
      print("Error parsing JSON response: $e");
      Navigator.pop(context, false);
    }
  }

  void _handleCookies(String cookies) async {
    // 쿠키에서 refreshToken을 찾아 SecureStorage에 저장
    List<String> cookieList = cookies.split('; ');
    for (var cookie in cookieList) {
      if (cookie.startsWith('refreshToken=')) {
        String refreshToken = cookie.split('=')[1];
        await storage.write(key: 'refreshToken', value: refreshToken);
        break;
      }
    }
  }
}
