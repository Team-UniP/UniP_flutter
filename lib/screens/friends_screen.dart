import 'package:flutter/material.dart';
import 'package:capstone_v1/service/friend_service.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendService _friendService = FriendService();
  late Future<List<dynamic>> _friendsFuture;

  @override
  void initState() {
    super.initState();
    _friendsFuture = _friendService.fetchFriends(); // 친구 데이터를 가져오는 Future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black, size: 30),
              onPressed: () {
                // Add action
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _friendsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('친구 데이터를 가져오는 데 실패했습니다.'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('표시할 친구가 없습니다.'),
            );
          } else {
            final friends = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    child: Text(
                      '친구',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: friends.map((friend) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildFriendCard(
                            friend['name'] ?? 'Unknown',
                            friend['profile_image'] ?? '',
                            friend['status'] ?? '',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFriendCard(String name, String imageUrl, String status) {
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
              Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 40); // 에러 발생 시 기본 아이콘
                },
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
                    color: status == 'BORED' ? Color(0xFF12E51A) : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status == 'BORED' ? '놀아줘' : '바쁨',
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
}
