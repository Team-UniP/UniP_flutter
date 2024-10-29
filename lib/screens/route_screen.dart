import 'package:capstone_v1/screens/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class RouteRecommendationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI 루트 추천',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Hint Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFEE500),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'ex : 두정동 추천해줘, 두정동 술집만 추천해줘',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 20),

            // Route Recommendation List
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '천안 두정동 맛집 루트 추천',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        // Restaurant Recommendations
                        _buildPlaceRecommendation(
                          name: '칠성포장마차',
                          description: '맛있는 한식 맛집',
                          rating: '4.5/5',
                          address: '천안시 서북구 두정로 49',
                        ),
                        const SizedBox(height: 10),
                        _buildPlaceRecommendation(
                          name: '카페 라떼아트',
                          description: '아늑한 분위기의 커피숍',
                          rating: '4.5/5',
                          address: '천안시 서북구 두정마을6길 12',
                        ),
                        const SizedBox(height: 10),
                        _buildPlaceRecommendation(
                          name: '만다린 차이나 레스토랑',
                          description: '정통 중국 음식 레스토랑',
                          rating: '4.5/5',
                          address: '천안시 서북구 두정로 71',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '설명',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '두정동 중심에서 시작하면 먼저 칠성포장마차에서 맛있는 한식을 즐긴 후, 가까운 카페 라떼아트에서 커피 한잔의 여유를 만끽하세요',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Information Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoField('인원'),
                  const SizedBox(height: 10),
                  _buildInfoField('시작날짜'),
                  const SizedBox(height: 10),
                  _buildInfoField('종료날짜'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Party Creation Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Party creation action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDFBFFF),
                  padding: EdgeInsets.symmetric(horizontal: 120, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '파티만들기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }

  Widget _buildPlaceRecommendation({
    required String name,
    required String description,
    required String rating,
    required String address,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(description, style: TextStyle(fontSize: 14)),
          const SizedBox(height: 5),
          Text('평점: $rating', style: TextStyle(fontSize: 11)),
          const SizedBox(height: 5),
          Text(address, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              isDense: true, // Reduces the height of the input field
              border: UnderlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
