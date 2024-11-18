import 'dart:convert';
import 'package:capstone_v1/url/api_uri.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/dto/chat_log.dart';
import 'package:capstone_v1/dto/chat_room.dart';
import 'package:capstone_v1/service/chat_service.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';


class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom; // ChatRoom 필드

  ChatScreen({required this.chatRoom});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StompClient stompClient;
  List<ChatLog> messages = []; // 메시지 리스트
  ChatApi chatApi = ChatApi();
  int page = 0; // 페이지 번호
  bool isLoading = false; // 로딩 상태 체크

  TextEditingController _messageController = TextEditingController(); // TextEditingController 추가
  final ScrollController _scrollController = ScrollController();

  // 메시지 가져오기
  Future<void> fetchMessages() async {
    print("isLoading=$isLoading");
    if (isLoading) return; // 로딩 중에는 중복 호출 방지
    setState(() {
      isLoading = true;
    });

    try {
      String roomId = widget.chatRoom.id;
      // API에서 ChatLog 객체 리스트 가져오기
      List<ChatLog> fetchedMessages = await chatApi.getChatLogs(roomId, page);

      // 상태 업데이트
      setState(() {
        messages.addAll(fetchedMessages); // 새로운 메시지를 뒤에 추가
        page++; // 페이지 번호 증가
      });
    } catch (error) {
      print("API 호출 중 오류 발생: $error");
    } finally {
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
  }

  // 스크롤이 최상단에 도달했을 때 호출되는 메서드
  void _onScroll() {
    // ListView의 스크롤 위치가 최상단에 도달하면 더 많은 메시지를 로드
    if (isLoading) return; // 로딩 중이면 추가 API 호출 방지

    final scrollPosition = _scrollController.position;
    double threshold = 100.0; // 최상단에 도달하기 전에 여유를 두는 픽셀 값

    if (scrollPosition.pixels <= threshold) {
      fetchMessages();
    }
  }

  void initializeWebSocket() {
    stompClient = StompClient(
      config: StompConfig(
        // URL 스키마를 'ws://'로 변경
        url: 'ws://${ApiInfo.domainUrl}/ws',  // http 대신 ws 사용
        onConnect: (StompFrame frame) {
          print('웹소켓 연결 성공!');

          // 채팅방 구독
          stompClient.subscribe(
            destination: '/topic/room/${widget.chatRoom.id}',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                print('새 메시지 수신: ${frame.body}');
                try {
                  // JSON을 ChatLog 객체로 변환
                  final Map<String, dynamic> jsonData = jsonDecode(frame.body!);
                  ChatLog newMessage = ChatLog.fromJson(jsonData);

                  setState(() {
                    messages.insert(0, newMessage);
                  });
                } catch (e) {
                  print('메시지 파싱 에러: $e');
                }
              }
            },
          );
        },
        onDisconnect: (StompFrame frame) {
          print('웹소켓 연결 종료');
        },
        beforeConnect: () async {
          print('웹소켓 연결 시도 중...');
        },
        onWebSocketError: (dynamic error) {
          print('웹소켓 에러: ${error.toString()}');
        },
        onStompError: (dynamic error) {
          print('STOMP 에러: ${error.toString()}');
        },
      ),
    );

    stompClient.activate();
  }



  @override
  void initState() {
    super.initState();
    fetchMessages();
    initializeWebSocket();
    _scrollController.addListener(_onScroll); // 스크롤 이벤트 리스너 추가
  }

  @override
  void dispose() {
    _messageController.dispose(); // 화면 종료 시 컨트롤러 해제
    _scrollController.removeListener(_onScroll); // 리스너 제거
    _scrollController.dispose();
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.purple, size: 30),
                onPressed: () {
                  // 메뉴 액션
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.chatRoom.title, // chatRoom의 제목 필드 사용
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left, // 좌측 정렬
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              padding: const EdgeInsets.all(10.0),
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
              child: ListView.builder(
                controller: _scrollController, // 스크롤 컨트롤러 연결
                reverse: true, // 리스트 역순으로 표시
                itemCount: messages.length + 1, // +1: 로딩 인디케이터를 위한 공간
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    // 마지막 아이템일 때, 로딩 인디케이터를 보여줌
                    return isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink(); // 로딩 중이 아닐 때 빈 공간 표시
                  } else {
                    // 일반 메시지
                    return _buildMessageRow(
                        messages[index].sender,
                        messages[index].content,
                        messages[index].senderImage,
                        true);
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: _messageController, // controller 추가
                      decoration: InputDecoration(
                        hintText: '메시지 입력',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    // 메시지 전송 액션
                    String message = _messageController.text;
                    String roomId=widget.chatRoom.id;
                    if(await chatApi.sendMessage(message,roomId)){
                      _messageController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC29FF0),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    '입력',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  // 메시지 행을 생성하는 메서드
  Widget _buildMessageRow(
      String name, String message, String profileImage, bool isLeftAligned) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:
            isLeftAligned ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeftAligned) _buildProfileIcon(name, profileImage),
          Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: Color(0xFFE9D7FC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isLeftAligned) _buildProfileIcon(name, profileImage),
        ],
      ),
    );
  }

  // 프로필 아이콘을 생성하는 메서드
  Widget _buildProfileIcon(String name, String profileImage) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(profileImage),
          radius: 20,
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
