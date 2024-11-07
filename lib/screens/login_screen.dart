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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(url: naverLoginURL), // WebViewScreen 호출
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              // Google Login Button
              _buildLoginButton(
                icon: 'assets/image/google.png',
                // Replace with your Google icon asset

                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                          url: googleLoginURL), // WebViewScreen 호출
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
