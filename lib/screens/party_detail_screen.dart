import 'package:capstone_v1/screens/main_screen.dart';
import 'package:capstone_v1/screens/party_screen.dart';

import 'package:capstone_v1/service/chat_service.dart';

import 'package:capstone_v1/service/friend_service.dart';

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
  final FriendService _friendService = FriendService();
  late Future<List<int>> _myPartyIdsFuture;
  final KakaoMapService _kakaoMapService = KakaoMapService();
  KakaoMapController? _mapController;
  Set<Marker> _markers = {};
  ChatApi chatApi=ChatApi();

  @override
  void initState() {
    super.initState();
    _partyDetailFuture = widget._partyService.fetchPartyDetail(widget.partyId);
    _myPartyIdsFuture = widget._partyService.fetchMyPartyIds();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        details['title'] ?? 'No Title',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FutureBuilder<List<int>>(
                        future: _myPartyIdsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(); // 로딩 중에는 아무것도 표시하지 않음
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return SizedBox(); // 오류 또는 데이터 없음
                          }

                          final myPartyIds = snapshot.data!;
                          if (myPartyIds.contains(widget.partyId)) {
                            return IconButton(
                              icon: Icon(Icons.add, color: Colors.purple),
                              onPressed: () {
                                _showFriendsPopup(
                                  context,
                                );
                              },
                            );
                          } else {
                            return SizedBox(); // 내 파티가 아니면 아무것도 표시하지 않음
                          }
                        },
                      ),
                    ],
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

  void _showFriendsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: FutureBuilder<List<dynamic>>(
            future: _friendService.fetchFriends(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '친구 데이터를 가져오는 데 실패했습니다.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    '표시할 친구가 없습니다.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final friends = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '친구 초대',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: friends.map((friend) {
                              return GestureDetector(
                                onTap: () {
                                  _inviteFriend(friend['id']); // 초대 API 호출
                                  Navigator.of(context).pop(); // 팝업 닫기
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: _buildFriendCard(
                                    friend['id'],
                                    friend['name'] ?? 'Unknown',
                                    friend['profile_image'] ?? '',
                                    friend['status'] ?? '',
                                  ),
                                ),
                              );
                            }).toList(),
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
      },
    );
  }

  /// 친구 초대 API 호출
  void _inviteFriend(int friendId) async {
    try {
      final success = await widget._partyService.inviteFriendToParty(
        widget.partyId,
        friendId,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('친구 초대 성공!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('친구 초대 실패. 다시 시도해주세요.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  /// 친구 카드 UI
  Widget _buildFriendCard(int id, String name, String imageUrl, String status) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
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
