import 'package:capstone_v1/screens/main_screen.dart';
import 'package:capstone_v1/screens/party_screen.dart';
import 'package:capstone_v1/service/chat_service.dart';
import 'package:capstone_v1/service/party_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RouteRecommendationScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;

  RouteRecommendationScreen({required this.routeData});

  @override
  _RouteRecommendationScreenState createState() =>
      _RouteRecommendationScreenState();
}

class _RouteRecommendationScreenState extends State<RouteRecommendationScreen> {
  final PartyService _partyService = PartyService();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final ChatApi chatApi=ChatApi();
  String? _formattedStartDate;
  String? _formattedEndDate;

  /// 날짜 선택 함수
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        controller.text =
            DateFormat("yyyy-MM-dd HH:mm:ss").format(combinedDateTime);

        final String isoFormattedDate =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .format(combinedDateTime.toUtc());

        if (controller == _startDateController) {
          _formattedStartDate = isoFormattedDate;
        } else if (controller == _endDateController) {
          _formattedEndDate = isoFormattedDate;
        }
      }
    }
  }

  /// 서버로 데이터 전송
  Future<void> _createParty() async {
    try {
      final partyData = {
        "title": widget.routeData['title'],
        "content": widget.routeData['content'],
        "limit": int.tryParse(_peopleController.text) ?? 0,
        "partyType":"COMPREHENSIVE",
        "startTime": _formattedStartDate,
        "endTime": _formattedEndDate,
        "courses": widget.routeData['courses'],
      };

      print("전송할 데이터: $partyData");
      int partyId = await _partyService.createParty(partyData);

      if(partyId>0) {
        var bool = await chatApi.makeChatRoom(widget.routeData['title'], partyId);
        if(bool){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('파티가 성공적으로 생성되었습니다!')),
          );
          MainPage.mainPageKey.currentState?.navigateToPage(2, PartyScreen());
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파티 생성에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.routeData['title'] ?? '제목 없음';
    final content = widget.routeData['content'] ?? '내용 없음';
    final courses = widget.routeData['courses'] as List<dynamic>? ?? [];
    final summary = widget.routeData['route summary'] ?? '';

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
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: courses.map((course) {
                        return _buildPlaceRecommendation(
                          name: course['name'] ?? '이름 없음',
                          description: course['content'] ?? '내용 없음',
                          rating: course['rating'] ?? '',
                          address: course['address'] ?? '주소 없음',
                        );
                      }).toList(),
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
                    summary,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Information Section with People and Date Picker
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormRow('인원', _peopleController),
                  const SizedBox(height: 10),
                  _buildDateRow('시작 날짜', _startDateController),
                  const SizedBox(height: 10),
                  _buildDateRow('종료 날짜', _endDateController),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Party Creation Button
            Center(
              child: ElevatedButton(
                onPressed: _createParty,
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
      margin: EdgeInsets.only(bottom: 10),
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

  Widget _buildDateRow(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          child: GestureDetector(
            onTap: () => _selectDate(context, controller),
            child: AbsorbPointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '날짜 선택',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormRow(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '인원 수',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
