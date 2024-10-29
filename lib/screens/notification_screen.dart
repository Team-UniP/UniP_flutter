import 'package:capstone_v1/screens/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Notification icon action
              },
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '알림',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _buildNotificationCard(
              icon: Icons.mail,
              title: '“고구마” 님의 파티초대 알림',
              subtitle: '오후에 두정동에서 술자리 하실분??',
            ),
            const SizedBox(height: 10),
            _buildNotificationCard(
              icon: Icons.mail,
              title: '“고구마” 님의 파티초대 알림',
              subtitle: '오후에 두정동에서 술자리 하실분??',
            ),
            const SizedBox(height: 10),
            _buildNotificationCard(
              icon: Icons.person_add,
              title: '“고구마” 님의 친구요청 알림',
              onTap: () => showFriendRequestDialog(
                  context, "고구마", 'assets/image/profileicon.png'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
        child: Row(
          children: [
            Icon(icon, color: Color(0xFFB56EFB), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFriendRequestDialog(
      BuildContext context, String friendName, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 332,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Friend profile picture and name
                Container(
                  width: 40,
                  height: 59,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 38,
                        child: Text(
                          friendName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage(imageUrl), // Using AssetImage here
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(36.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Friend request message
                Text(
                  '친구요청을 수락하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                // Accept and Decline buttons
                Container(
                  width: 204,
                  height: 28,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Accept button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Accept friend request logic
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '수락',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // Decline button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Decline friend request logic
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '거절',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
        );
      },
    );
  }
}
