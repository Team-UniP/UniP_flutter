import 'package:capstone_v1/screens/chatlist_screen.dart';
import 'package:capstone_v1/screens/friends_screen.dart';
import 'package:capstone_v1/screens/home_screen.dart';
import 'package:capstone_v1/screens/mypage_screen.dart';
import 'package:capstone_v1/screens/party_screen.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int, Widget) onItemTapped;

  CustomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

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
                child: GestureDetector(
                  onTap: () => onItemTapped(0, HomeScreen()),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _buildNavItem(
                      Icons.home,
                      '홈',
                      selectedIndex == 0
                          ? Color(0xFFC29FF0)
                          : Color(0xFFD1D1D1),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onItemTapped(1, ChatlistScreen()),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _buildNavItem(
                      Icons.chat,
                      '채팅',
                      selectedIndex == 1
                          ? Color(0xFFC29FF0)
                          : Color(0xFFD1D1D1),
                    ),
                  ),
                ),
              ),
              Expanded(child: SizedBox.shrink()), // 중앙 공간 확보
              Expanded(
                child: GestureDetector(
                  onTap: () => onItemTapped(3, FriendsScreen()),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _buildNavItem(
                      Icons.people,
                      '친구',
                      selectedIndex == 3
                          ? Color(0xFFC29FF0)
                          : Color(0xFFD1D1D1),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onItemTapped(4, MyPageScreen()),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _buildNavItem(
                      Icons.person,
                      '마이페이지',
                      selectedIndex == 4
                          ? Color(0xFFC29FF0)
                          : Color(0xFFD1D1D1),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: -30,
            left: screenWidth / 2 - 28,
            child: GestureDetector(
              onTap: () => onItemTapped(2, PartyScreen()),
              child: _buildCenterNavItem(
                Icons.celebration,
                '파티',
                selectedIndex == 2 ? Color(0xFFC29FF0) : Color(0xFFD1D1D1),
              ),
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
