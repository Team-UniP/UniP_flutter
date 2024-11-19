import 'package:capstone_v1/screens/main_screen.dart';
import 'package:capstone_v1/screens/party_screen.dart';
import 'package:capstone_v1/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:capstone_v1/service/kakao_map_service.dart';
import 'package:capstone_v1/service/party_service.dart';

class PartyDetailScreen extends StatefulWidget {
  final int partyId;
  final String name;
  final PartyService _partyService = PartyService();


  PartyDetailScreen({required this.partyId, required this.name});

  @override
  _PartyDetailScreenState createState() => _PartyDetailScreenState();
}

class _PartyDetailScreenState extends State<PartyDetailScreen> {
  int _selectedRouteIndex = 0;
  late Future<Map<String, dynamic>> _partyDetailFuture;
  final KakaoMapService _kakaoMapService = KakaoMapService();
  KakaoMapController? _mapController;
  Set<Marker> _markers = {};
  ChatApi chatApi=ChatApi();

  @override
  void initState() {
    super.initState();
    _partyDetailFuture = widget._partyService.fetchPartyDetail(widget.partyId);
  }

  /// 주소를 이용해 마커를 생성하고 지도에 반영
  Future<void> _loadMarkers(String address) async {
    if (_mapController == null) return;

    final markers = await _kakaoMapService.getMarkersFromAddress(
      _mapController!,
      address,
    );

    if (markers.isNotEmpty) {
      // 맵의 중심을 첫 번째 마커로 설정
      final firstMarker = markers.first.latLng;
      await _mapController!.setCenter(firstMarker);
    }

    setState(() {
      _markers = markers;
    });

    // 마커가 있는 영역에 맞게 맵 줌 조정
    if (_markers.isNotEmpty) {
      final bounds = _markers.map((m) => m.latLng).toList();
      await _mapController?.fitBounds(bounds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _partyDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading details: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!['data'] == null) {
            return Center(child: Text('No details available.'));
          } else {
            final details = snapshot.data!['data'];
            final courses = details['courses'] as List<dynamic>? ?? [];
            final currentCourse = courses.isNotEmpty
                ? courses[_selectedRouteIndex]
                : {'name': '루트 없음', 'content': '내용 없음', 'address': '주소 없음'};
            final currentAddress = currentCourse['address'] ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    details['title'] ?? 'No Title',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/40'),
                              radius: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black12, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                details['content'] ?? 'No Content',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 300,
                    child: KakaoMap(
                      center: LatLng(37.5665, 126.9780), // 기본 중심 좌표 (서울)
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _mapController?.setZoomable(true); // 줌 활성화
                        _loadMarkers(currentAddress); // 지도 생성 후 마커 로드
                      },
                      markers: _markers.toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (courses.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        courses.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRouteIndex = index;
                            });
                            final newAddress = courses[index]['address'] ?? '';
                            _loadMarkers(newAddress); // 새 주소로 마커 업데이트
                          },
                          child: _buildRouteTab(
                              '루트 ${index + 1}', _selectedRouteIndex == index),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(_selectedRouteIndex),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
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
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              currentCourse['name'] ?? '루트 이름 없음',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              currentCourse['content'] ?? '내용 없음',
                              style: TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              currentAddress,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          bool responseData =
                              await PartyService().JoinParty(widget.partyId);

                          if (responseData) {
                            // 결과 화면으로 이동
                            var bool = await chatApi.participateChatRoom(widget.partyId);
                            if(bool){
                              MainPage.mainPageKey.currentState?.navigateToPage(
                                2,
                                PartyScreen(),
                              );
                            }

                            MainPage.mainPageKey.currentState?.navigateToPage(
                              2,
                              PartyScreen(),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('요청 실패. 다시 시도해주세요.')),
                            );
                          }
                        } catch (e) {
                          // 예외 처리
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('오류 발생: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFFBEA),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shadowColor: Colors.black12,
                        elevation: 3,
                      ),
                      child: Text(
                        '파티 참가하기',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildRouteTab(String label, bool isSelected) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFC29FF0) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(4, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
