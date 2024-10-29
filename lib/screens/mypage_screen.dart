import 'package:flutter/material.dart';
import 'custom_navigation_bar.dart'; // Import your navigation bar

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove the back button
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 35.0), // Adjust this value to move it down
                child: Text(
                  '마이페이지',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Spacer(), // Pushes the notification icon to the right
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black, size: 30),
                onPressed: () {
                  // Handle notification action
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 18),
        child: Column(
          children: [
            // Profile card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile picture
                      Container(
                        width: 57,
                        height: 57,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                                NetworkImage('https://via.placeholder.com/57'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Name and info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                '김병웅',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 23,
                              ),
                              Text(
                                'playgrounm@gmail.com',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LV. 1 꿈나무',
                                  style: TextStyle(
                                    color: Color(0xEFB46EFB),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '공주대학교',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFBEA),
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: Color(0xFFB56EFB)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF12E51A),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '놀아줘',
                                        style: TextStyle(
                                          color: Color(0xFFB56EFB),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                      const SizedBox(width: 5),
                      // Email and University

                      Spacer(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '포인트',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 31,
                    decoration: BoxDecoration(
                      color: Color(0xE5FFFBEA),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 10,
                          offset: Offset(4, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 배경의 검정색 바
                        Positioned(
                          left: 28.0,
                          top: 11.0,
                          child: Container(
                            width: 205.85,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        // 보라색 바
                        Positioned(
                          left: 28.0,
                          top: 11.0,
                          child: Container(
                            width: 177.94,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Color(0xEFB46EFB),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        // 오른쪽의 '200P' 텍스트
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              '200P',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // University and Points Bar

            // Menu buttons
            _buildMenuButton('파티 내역'),
            const SizedBox(height: 10),
            _buildMenuButton('이름 변경하기'),
            const SizedBox(height: 10),
            _buildMenuButton('프로필 이미지 변경하기'),
            const SizedBox(height: 10),
            _buildMenuButton('문의하기'),
            const SizedBox(height: 10),
            _buildMenuButton('로그아웃'),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }

  // Helper method to build the menu buttons
  Widget _buildMenuButton(String label) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Add your button logic here
        },
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFFBEA),
          foregroundColor: Colors.black, // Button background color
          shape: StadiumBorder(), // Rounded border
          elevation: 3, // Shadow
          textStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.14,
          ),
        ),
      ),
    );
  }
}
