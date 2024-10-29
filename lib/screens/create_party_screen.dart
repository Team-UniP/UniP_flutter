import 'package:flutter/material.dart';
import 'custom_navigation_bar.dart';

class CreatePartyScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
        title: Text(
          '파티 모집',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormRow('제목', 1, false),
                  const SizedBox(height: 15),
                  _buildFormRow('인원', 1, false),
                  const SizedBox(height: 15),
                  _buildFormRow(
                      '내용', 5, true), // Boxed version for multi-line content
                  const SizedBox(height: 15),
                  _buildFormRow('시작날짜', 1, false),
                  const SizedBox(height: 15),
                  _buildFormRow('종료날짜', 1, false),
                  const SizedBox(height: 15),

                  // Category buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryButton('식사', 'assets/image/foodicon.png'),
                      _buildCategoryButton('음주', 'assets/image/drinkicon.png'),
                      _buildCategoryButton('종합', 'assets/image/totalicon.png'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  // Submit action
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  backgroundColor: Color(0xFFDFBFFF), // Button background color
                  shape: StadiumBorder(), // Rounded border
                ),
                child: Text(
                  '루트 추가',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      color: Color(0xFFDFBFFF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildFormRow('이름', 1, false),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        child: Text(
                          '주소',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 1, color: Color(0xEF8D1CFF)),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Text(
                          '주소 찾기',
                          style: TextStyle(
                            color: Color(0xEF8D1CFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildFormRow('내용', 1, false),
                  const SizedBox(height: 15),

                  // Category buttons
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Submit action
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: Color(0xFFDFBFFF), // Button background color
                  shape: StadiumBorder(), // Rounded border
                ),
                child: Text(
                  '작성',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomNavigationBar(), // Custom Bottom Navigation Bar
    );
  }

  Widget _buildFormRow(String label, int lines, bool isBoxed) {
    return Row(
      crossAxisAlignment:
          lines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: isBoxed
                ? BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  )
                : BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
            child: TextFormField(
              maxLines: lines,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true, // Reduce height of text field
                contentPadding: isBoxed ? EdgeInsets.all(10) : EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build category buttons
  Widget _buildCategoryButton(String label, String assetPath) {
    return Container(
      width: 110,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            width: 90,
            height: 40, // You can adjust the size of the image as needed
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
