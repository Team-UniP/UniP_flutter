import 'package:capstone_v1/screens/create_party_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chatlist_screen.dart';
import 'party_screen.dart';
import 'friends_screen.dart';
import 'mypage_screen.dart';
import 'custom_navigation_bar.dart';

final GlobalKey<_MainPageState> mainPageKey = GlobalKey();

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ChatlistScreen(),
    PartyScreen(),
    FriendsScreen(),
    MyPageScreen(),
    CreatePartyScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
