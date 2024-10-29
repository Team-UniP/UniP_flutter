import 'package:flutter/material.dart';
import 'custom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFEEEDEF), // 배경 색상
        body: SingleChildScrollView(
          // 스크롤 가능하게 설정₩
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 18),
            child: Column(
              children: [
                // 상단에 있는 첫 번째 Row
                Container(
                  width: double.infinity, // 가로 길이를 화면 전체에 맞추기
                  height: 38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 왼쪽 아이콘 섹션

                      const SizedBox(width: 335),
                      // 오른쪽 빈 공간
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 여기에 추가할 위젯
                                IconButton(
                                  icon: Icon(Icons.notifications,
                                      color: Colors.black, size: 30),
                                  onPressed: () {
                                    // Handle notification action
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // 간격 추가

                // 두 번째 프레임
                Container(
                  width: double.infinity, // 가로 길이를 화면 전체에 맞추기
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 첫 번째 요소
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.0), // 왼쪽 여백 설정
                            child: Container(
                              width: 57,
                              height: 59,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://via.placeholder.com/57x59"),
                                  fit: BoxFit.cover,
                                ),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // 간격 추가
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '김병웅',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  letterSpacing: -0.25,
                                ),
                              ),
                              Text(
                                'LV. 1 꿈나무',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xEFB46EFB),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 40), // 간격 추가
                          ElevatedButton(
                            onPressed: () {
                              print("버튼 클릭됨");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFFBEA),
                              fixedSize: Size(135, 41),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              shadowColor: Color(0x0C000000),
                              elevation: 3,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 27.36,
                                  height: 41,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://via.placeholder.com/27x43"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10), // 이미지와 텍스트 사이의 간격
                                Text(
                                  '파티 찾기',
                                  textAlign: TextAlign.center,
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
                          ),
                        ],
                      ),

                      Container(
                        width: 303,
                        height: 65,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 3.0, bottom: 5.0),
                              child: Text(
                                '포인트',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.14,
                                ),
                              ),
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

                      // 두 번째 요소와 세 번째 요소를 여기에 추가할 수 있습니다.
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  // 간격 추가
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '대학교 공식 인싸!\n공주대학교의 파티 랭킹',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      letterSpacing: -0.22,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCard('내장탕', 'LV.12', '32', '94',
                        'https://via.placeholder.com/50', '2.'),

                    // 가운데 카드: Transform으로 높이를 10% 정도 높게 조정
                    Transform.translate(
                      offset: Offset(0, -20), // 10% 정도 위로 이동
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            child: Icon(
                              Icons.crop,
                              color: Colors.amber,
                              size: 36,
                            ),
                          ),
                          buildCard('감자탕', 'LV.12', '32', '94',
                              'https://via.placeholder.com/50', ''),
                        ],
                      ),
                    ),

                    buildCard('수육국밥', 'LV.12', '32', '94',
                        'https://via.placeholder.com/50', '3.'),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '현재 시간되는\n내 친구들 찾아보아요',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.22,
                        ),
                      ),
                      Container(
                        width: 93,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFBEA),
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 1, color: Color(0xEFB46EFB)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 3,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '친구 보러가기',
                          style: TextStyle(
                            color: Color(0xEFB46EFB),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10), // 간격 추가

                // 친구 카드들
                _buildFriendCard('윤병호', 'https://via.placeholder.com/40x40'),
                const SizedBox(height: 10),
                _buildFriendCard('윤병호', 'https://via.placeholder.com/40x40'),
                const SizedBox(height: 10),
                _buildFriendCard('윤병호', 'https://via.placeholder.com/40x40'),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(), // 하단 네비게이션 바
      ),
    );
  }
}

Widget buildCard(String title, String level, String completed, String points,
    String imageUrl, String number) {
  return Column(
    children: [
      Text(
        number,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8D1CFF),
        ),
      ),
      Container(
        width: 120,
        height: 160,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 25,
              child: Container(
                width: 106.54,
                height: 130,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      level,
                      style: TextStyle(
                        color: Color(0xFF8D1CFF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '파티 완료 수',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          completed,
                          style: TextStyle(
                            color: Color(0xFF8D1CFF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '총 포인트',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          points,
                          style: TextStyle(
                            color: Color(0xFF8D1CFF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFE0F7FA),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildFriendCard(String name, String imageUrl) {
  return Container(
    width: 400,
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/image/profileicon.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 13),
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.17,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: Color(0xFFFFFBEA),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(width: 1, color: Color(0xFFB56EFB)),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(0xFF12E51A),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '놀아줘',
                style: TextStyle(
                  color: Color(0xFFB56EFB),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
