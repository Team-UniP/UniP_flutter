import 'package:capstone_v1/screens/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.purple, size: 30),
                onPressed: () {
                  // Menu action
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '오후에 술자리 하실분??',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign
                    .left, // Ensures left alignment within the container
              ),
            ),
          ),
          // Add a SizedBox to push down the chat container
          SizedBox(height: 20),
          // Adjust the height as needed
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              padding: const EdgeInsets.all(10.0),
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
              child: ListView(
                children: [
                  _buildMessageRow("고구마", "안녕하세요! 같이 할 분?", true),
                  _buildMessageRow("고구마", "어디서 만날까요?", true),
                  _buildMessageRow("고구마", "두정동에서 뵙죠!", false),
                  _buildMessageRow("고구마", "7시 어때요?", true),
                  _buildMessageRow("고구마", "좋아요!", false),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '메시지 입력',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Send action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC29FF0),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    '입력',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }

  Widget _buildMessageRow(String name, String message, bool isLeftAligned) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:
            isLeftAligned ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeftAligned) _buildProfileIcon(name),
          Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: Color(0xFFE9D7FC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isLeftAligned) _buildProfileIcon(name),
        ],
      ),
    );
  }

  Widget _buildProfileIcon(String name) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/40'),
          radius: 20,
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
