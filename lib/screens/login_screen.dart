import 'package:capstone_v1/screens/auth_screen.dart';
import 'package:capstone_v1/screens/home_screen.dart';
import 'package:capstone_v1/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/service/oauth_service.dart';
import 'package:capstone_v1/url/uri.dart';
import 'package:capstone_v1/screens/web_view.dart';

class LoginScreen extends StatelessWidget {
  OAuthService oAuthService = OAuthService();
  final String naverLoginURL =
      '${ApiInfo.mainBaseUrl}' + '${ApiInfo.naverLoginUri}';
  final String googleLoginURL =
      '${ApiInfo.mainBaseUrl}' + '${ApiInfo.googleLoginUri}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Column(
                children: [
                  Image.asset(
                    'assets/image/applogo.png', // Replace with your logo asset
                    width: 213,
                    height: 205,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 100),

              // Naver Login Button
              _buildLoginButton(
                icon:
                    'assets/image/naver.png', // Replace with your Naver icon asset

                onTap: () async {
                  try {
                    // WebViewScreen으로 이동 후, 결과 기다림
                    bool? isAuthenticated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(url: naverLoginURL),
                      ),
                    );

                    // 결과에 따라 화면 전환
                    if (isAuthenticated == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MainPage(key: MainPage.mainPageKey),
                        ),
                      );
                    } else if (isAuthenticated == false) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AccountVerificationScreen(), // AccountVerificationScreen으로 이동
                        ),
                      );
                    } else {
                      // isAuthenticated가 null인 경우 (값을 제대로 받지 못한 경우)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('로그인 결과를 확인할 수 없습니다. 다시 시도해주세요.'),
                          duration: Duration(seconds: 3),
                        ),
                      );

                      // 로그인 페이지로 돌아가기
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(), // 로그인 페이지로 돌아가기
                        ),
                      );
                    }
                  } catch (error) {
                    // 에러 발생 시 SnackBar를 이용하여 에러 메시지 표시
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('오류 발생: 로그인에 실패했습니다. 다시 시도해주세요.'),
                        duration: Duration(seconds: 3),
                      ),
                    );

                    // 로그인 페이지로 돌아가기
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(), // 로그인 페이지로 돌아가기
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),

              // Google Login Button
              _buildLoginButton(
                icon: 'assets/image/google.png',
                // Replace with your Google icon asset

                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(url: "google_login_url"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 310,
      height: 50,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 305,
              height: 48,
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
