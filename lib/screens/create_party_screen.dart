import 'package:capstone_v1/screens/main_screen.dart';
import 'package:capstone_v1/screens/party_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:capstone_v1/service/party_service.dart';

class CreatePartyScreen extends StatefulWidget {
  @override
  _CreatePartyScreenState createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  final PartyService _partyService = PartyService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  String? _formattedStartTimeForServer;
  String? _formattedEndTimeForServer;

  // 루트 입력 필드와 데이터 저장
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, TextEditingController>> _routeControllers = [];
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _addRouteInput();
  }

  // 새로운 루트 입력 필드를 추가하고 컨트롤러도 추가
  void _addRouteInput() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final contentController = TextEditingController();

    setState(() {
      _routeControllers.add({
        'name': nameController,
        'address': addressController,
        'content': contentController,
      });
    });
  }

  // 루트 입력 필드를 제거
  void _removeRouteInput(int index) {
    setState(() {
      _routeControllers.removeAt(index);
    });
  }

  // 선택된 날짜와 시간을 ISO 형식으로 변환하여 서버에 전송
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

        if (controller == _startTimeController) {
          _formattedStartTimeForServer = isoFormattedDate;
        } else if (controller == _endTimeController) {
          _formattedEndTimeForServer = isoFormattedDate;
        }
      }
    }
  }

  // 데이터를 수집하고 서버로 전송
  void _collectAndSubmitPartyData() async {
    _courses = _routeControllers.map((controllerMap) {
      return {
        'name': controllerMap['name']!.text,
        'address': controllerMap['address']!.text,
        'content': controllerMap['content']!.text,
      };
    }).toList();

    Map<String, dynamic> partyData = {
      "title": _titleController.text,
      "content": _contentController.text,
      "limit": int.tryParse(_limitController.text) ?? 0,
      "partyType": _selectedCategory,
      "startTime": _formattedStartTimeForServer,
      "endTime": _formattedEndTimeForServer,
      "courses": _courses,
    };

    bool success = await _partyService.createParty(partyData);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파티가 성공적으로 생성되었습니다!')),
      );
      MainPage.mainPageKey.currentState?.navigateToPage(2, PartyScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파티 생성에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            _buildFormFields(),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _addRouteInput,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  backgroundColor: Color(0xFFDFBFFF),
                  shape: StadiumBorder(),
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
            Column(
              children: _routeControllers
                  .asMap()
                  .entries
                  .map((entry) => _buildRouteInput(entry.key))
                  .toList(),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: _collectAndSubmitPartyData,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: Color(0xFFDFBFFF),
                  shape: StadiumBorder(),
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
    );
  }

  Widget _buildFormFields() {
    return Container(
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
          _buildFormRow('제목', _titleController, 1, false),
          const SizedBox(height: 15),
          _buildFormRow('인원', _limitController, 1, false),
          const SizedBox(height: 15),
          _buildFormRow('내용', _contentController, 5, true),
          const SizedBox(height: 15),
          _buildDateRow('시작날짜', _startTimeController),
          const SizedBox(height: 15),
          _buildDateRow('종료날짜', _endTimeController),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryButton(
                  '식사', 'assets/image/foodicon.png', 'RESTAURANT'),
              _buildCategoryButton('음주', 'assets/image/drinkicon.png', 'BAR'),
              _buildCategoryButton(
                  '종합', 'assets/image/totalicon.png', 'COMPREHENSIVE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInput(int index) {
    return Container(
      key: UniqueKey(),
      margin: const EdgeInsets.symmetric(vertical: 10),
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
            child: GestureDetector(
              onTap: () => _removeRouteInput(index),
              child: Icon(
                Icons.close,
                color: Color(0xFFDFBFFF),
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildFormRow('이름', _routeControllers[index]['name']!, 1, false),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildFormRow(
                  '주소',
                  _routeControllers[index]['address']!,
                  1,
                  false,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // 주소 검색 로직
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xEF8D1CFF), width: 1),
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
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
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildFormRow('내용', _routeControllers[index]['content']!, 1, false),
        ],
      ),
    );
  }

  Widget _buildFormRow(
      String label, TextEditingController controller, int lines, bool isBoxed) {
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
              controller: controller,
              maxLines: lines,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: isBoxed ? EdgeInsets.all(10) : EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
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

  Widget _buildCategoryButton(String label, String assetPath, String category) {
    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Container(
        width: 110,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        decoration: BoxDecoration(
          color:
              _selectedCategory == category ? Colors.purple[100] : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 90,
              height: 40,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
