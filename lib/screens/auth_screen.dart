import 'package:capstone_v1/screens/home_screen.dart';
import 'package:capstone_v1/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/service/univ_verification.dart';

class AccountVerificationScreen extends StatefulWidget {
  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _authCodeController = TextEditingController();
  final UnivVerificationService _verificationService =
      UnivVerificationService();

  bool _isLoading = false;

  void _sendVerificationCode() async {
    setState(() => _isLoading = true);

    try {
      await _verificationService.verifyUniv(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호가 이메일로 전송되었습니다.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호 전송 실패: $error')),
      );
    }

    setState(() => _isLoading = false);
  }

  void _verifyAuthCode() async {
    setState(() => _isLoading = true);

    try {
      await _verificationService.verifyAuthCode(
        _emailController.text,
        _authCodeController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 성공!')),
      );
      // 인증 성공 시 다음 화면으로 이동 또는 홈 화면으로 리다이렉트
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(key: MainPage.mainPageKey),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 실패: $error')),
      );
    }

    setState(() => _isLoading = false);
  }

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
                SizedBox(height: 120),
                Image.asset(
                  'assets/image/applogo.png',
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  '학교 이메일 인증을 시작할게요!\n저희 어플은 신뢰성을 위해 학교 인증을 진행해요',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: '학교 이메일 입력',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _isLoading ? null : _sendVerificationCode,
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1)),
                  ),
                  child: TextField(
                    controller: _authCodeController,
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
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyAuthCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDFBFFF),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
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
