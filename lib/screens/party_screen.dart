import 'package:capstone_v1/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/service/party_service.dart';

class PartyScreen extends StatelessWidget {
  final PartyService _partyService = PartyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '파티 모집',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.purple),
              onPressed: () {
                mainPageKey.currentState?.onItemTapped(2);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _partyService.fetchParties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading parties: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No parties available.'));
          } else {
            print("Loaded Parties: ${snapshot.data}");
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Filter options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterOption('식사', 'assets/image/foodicon.png'),
                      _buildFilterOption('음주', 'assets/image/drinkicon.png'),
                      _buildFilterOption('종합', 'assets/image/totalicon.png'),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Displaying list of party cards
                  ...snapshot.data!
                      .map((party) => _buildPartyCard(party))
                      .toList(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterOption(String label, String imagePath) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 90,
          height: 33,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  // Updated to properly handle data and format times
  Widget _buildPartyCard(Map<String, dynamic> party) {
    // 시간 형식 변경 (ISO 8601에서 가독성 높은 형식으로 변환)
    String formatTime(String? time) {
      if (time == null) return '';
      DateTime dateTime = DateTime.parse(time);
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}/${dateTime.hour}시';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://ssl.pstatic.net/static/pwe/address/img_profile.png'), // Placeholder or party image
                  radius: 28,
                ),
                SizedBox(height: 5),
                Text(
                  party['name'] ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    party['title'] ?? 'No Content',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.17,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        getPartyTypeImage(party['partyType'] ?? ''),
                        width: 61,
                        height: 33,
                        fit: BoxFit.contain,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '시작 시간: ${formatTime(party['startTime'])}',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          Text(
                            '종료 시간: ${formatTime(party['endTime'])}',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '${party['peopleCount'] ?? 0}/${party['limit'] ?? 0}',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 헬퍼 함수: partyType에 따른 이미지 경로 반환
  String getPartyTypeImage(String partyType) {
    switch (partyType) {
      case 'BAR':
        return 'assets/image/drinkfilter.png';
      case 'RESTAURANT':
        return 'assets/image/foodfilter.png';
      case 'COMPREHENSIVE':
        return 'assets/image/totalfliter.png';
      default:
        return 'assets/image/drinkicon.png'; // 기본 아이콘 (기본 이미지 설정)
    }
  }
}
