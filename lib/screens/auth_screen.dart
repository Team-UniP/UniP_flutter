import 'package:flutter/material.dart';

class AccountVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo and Title
            Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Image.asset(
                  'assets/image/applogo.png', // Update with your logo path
                  width: 213,
                  height: 205,
                ),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 50),

            // Account Verification Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '계정 인증',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '학교 이메일 인증을 시작할게요!\n저희 어플은 신뢰성을 위해 학교 인증을 진행해요',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Email Input with Verification Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '학교 이메일 입력',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        // Action to send verification code
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFB56EFB)),
                        backgroundColor: Color(0xFFFFFBEA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        '인증 번호 받기',
                        style: TextStyle(
                          color: Color(0xFFB56EFB),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Verification Code Input
                Text(
                  '인증번호',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1)),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '인증번호 입력',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),

            // Confirm Button
            Spacer(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Confirm action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDFBFFF),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
