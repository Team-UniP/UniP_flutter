import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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

                onTap: () {
                  // Implement Naver login action
                },
              ),
              const SizedBox(height: 10),

              // Kakao Login Button
              _buildLoginButton(
                icon:
                    'assets/image/kakao.png', // Replace with your Kakao icon asset

                onTap: () {
                  // Implement Kakao login action
                },
              ),
              const SizedBox(height: 10),

              // Google Login Button
              _buildLoginButton(
                icon:
                    'assets/image/google.png', // Replace with your Google icon asset

                onTap: () {
                  // Implement Google login action
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
