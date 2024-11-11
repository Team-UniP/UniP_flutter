import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chatlist_screen.dart';
import 'party_screen.dart';
import 'friends_screen.dart';
import 'mypage_screen.dart';
import 'custom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  static final GlobalKey<_MainPageState> mainPageKey =
      GlobalKey<_MainPageState>();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _currentScreen = HomeScreen(); // 초기 화면 설정
  int _selectedIndex = 0;

  // 화면을 직접 전환하는 메서드
  void navigateToPage(int index, Widget page) {
    setState(() {
      _currentScreen = page;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentScreen, // 현재 화면을 표시
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (int index, Widget page) {
          navigateToPage(index, page); // 네비게이션 바에서 선택된 화면으로 전환
        },
      ),
    );
  }
}
