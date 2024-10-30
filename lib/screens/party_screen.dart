import 'package:flutter/material.dart';
import 'custom_navigation_bar.dart'; // Import your custom navigation bar

class PartyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
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
                // Add your action for creating a new party
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter options (식사, 음주, 종합)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterOption('식사', 'assets/image/foodicon.png'),
                _buildFilterOption('음주', 'assets/image/drinkicon.png'),
                _buildFilterOption('종합', 'assets/image/totalicon.png'),
              ],
            ),
            SizedBox(height: 20),

            // List of party cards
            _buildPartyCard('assets/image/drinkfilter.png'),
            _buildPartyCard('assets/image/drinkfilter.png'),
            _buildPartyCard('assets/image/drinkfilter.png'),
            _buildPartyCard('assets/image/drinkfilter.png'),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomNavigationBar(), // Custom Bottom Navigation Bar
    );
  }

  // Method to build filter options
  Widget _buildFilterOption(String label, String imagePath) {
    return Column(
      children: [
        // Display the image directly
        Image.asset(
          imagePath,
          width: 90, // Set width as per your requirement
          height: 33, // Set height as per your requirement
          fit: BoxFit.contain, // Adjust how the image is fitted inside the box
        ),
      ],
    );
  }

  // Method to build each party card
  Widget _buildPartyCard(String imagePath) {
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
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/57'),
                  radius: 28,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '고구마',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      '오후에 두정동에서 술자리 하실분??',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0.10,
                        letterSpacing: -0.17,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Image.asset(
                      imagePath,
                      width: 61, // Set width as per your requirement
                      height: 33, // Set height as per your requirement
                      fit: BoxFit
                          .contain, // Adjust how the image is fitted inside the box
                    ),
                    Column(
                      children: [
                        Text(
                          '시작시간',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '종료시간',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          '2024.09.08/1시',
                          style: TextStyle(
                            color: Color(0xEFB46EFB),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '2024.09.09/1시',
                          style: TextStyle(
                            color: Color(0xEFB46EFB),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '1/4',
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
          ],
        ),
      ),
    );
  }
}
