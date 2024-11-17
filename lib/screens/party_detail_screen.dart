import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:capstone_v1/service/kakao_map_service.dart';
import 'package:intl/intl.dart';
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

    setState(() {
      _markers = markers;
    });
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
                    height: 300,
                    child: KakaoMap(
                      center: LatLng(37.5665, 126.9780), // 기본 중심 좌표 (서울)
                      onMapCreated: (controller) {
                        _mapController = controller;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 10),
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
