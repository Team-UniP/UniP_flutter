import 'package:capstone_v1/screens/create_party_screen.dart';
import 'package:capstone_v1/screens/main_screen.dart';
import 'package:capstone_v1/screens/party_detail_screen.dart';
import 'package:capstone_v1/screens/routerequest_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/service/party_service.dart';

class PartyScreen extends StatelessWidget {
  final PartyService _partyService = PartyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
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
            SizedBox(
              width: 180,
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Text(
                  'A.I',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onPressed: () {
                // A.I 버튼 클릭 시 동작
                MainPage.mainPageKey.currentState
                    ?.navigateToPage(2, RouteRequestScreen());
              },
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.purple),
              onPressed: () {
                MainPage.mainPageKey.currentState
                    ?.navigateToPage(2, CreatePartyScreen());
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
                      .map((party) => _buildPartyCard(context, party))
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
  Widget _buildPartyCard(BuildContext context, Map<String, dynamic> party) {
    String formatTime(String? time) {
      if (time == null) return '';
      DateTime dateTime = DateTime.parse(time);
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}/${dateTime.hour}시';
    }

    final partyId = party['partyId']; // Get the party ID'
    final name = party['name'];

    return GestureDetector(
      onTap: () {
        // Navigate to the detail screen with partyId
        MainPage.mainPageKey.currentState?.navigateToPage(
            2, PartyDetailScreen(partyId: partyId, name: name));
      },
      child: Padding(
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
                        'https://ssl.pstatic.net/static/pwe/address/img_profile.png'),
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
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                            Text(
                              '종료 시간: ${formatTime(party['endTime'])}',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
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
      ),
    );
  }

  String getPartyTypeImage(String partyType) {
    switch (partyType) {
      case 'BAR':
        return 'assets/image/drinkfilter.png';
      case 'RESTAURANT':
        return 'assets/image/foodfilter.png';
      case 'COMPREHENSIVE':
        return 'assets/image/totalfliter.png';
      default:
        return 'assets/image/drinkfilter.png';
    }
  }
}
