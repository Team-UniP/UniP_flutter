import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert'; // for utf8 encoding
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 토큰 저장 라이브러리
import 'package:uri/uri.dart'; // URL 파라미터 파싱을 위한 패키지 (pubspec.yaml에 추가 필요)

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
          Uri uri=Uri.parse(url);
          if(uri.queryParameters.containsKey("code")) {
            String? jsonResponse = await _controller.evaluateJavascript("document.body.innerText");
            if (jsonResponse != null) {
              _handleResponse(jsonResponse);
            }


            // 쿠키를 가져오는 방법
            String cookies =
            await _controller.evaluateJavascript("document.cookie;");
            _handleCookies(cookies);
          }


        },
      ),
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
        // RefreshToken을 SecureStorage에 저장
        await storage.write(key: 'refreshToken', value: refreshToken);
        break;
      }
    }
  }
}
