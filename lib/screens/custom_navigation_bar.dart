import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 10), // 아이콘을 아래로 내림
                child: _buildNavItem(Icons.home, '홈', Color(0xFFC29FF0)),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: _buildNavItem(Icons.chat, '채팅', Color(0xFFD1D1D1)),
              )),
              Expanded(child: SizedBox.shrink()), // 가운데 공간 확보를 위해 비워둠
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: _buildNavItem(Icons.people, '친구', Color(0xFFD1D1D1)),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: _buildNavItem(Icons.person, '마이페이지', Color(0xFFD1D1D1)),
              )),
            ],
          ),
          // 가운데 아이콘 위치 조정
          Positioned(
            top: -30, // 원하는 만큼 위로 올리기
            left: screenWidth / 2 - 28, // 중앙 정렬
            child: _buildCenterNavItem(
              Icons.celebration,
              '파티',
              Color(0xFFC29FF0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData iconData, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: color,
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCenterNavItem(IconData iconData, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 6,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
