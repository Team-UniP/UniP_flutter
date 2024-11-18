class ChatLog{
  final String sender;
  final String content;
  final String senderImage;
  final bool isLeft;

  ChatLog({
    required this.sender,
    required this.content,
    required this.senderImage,
    required this.isLeft
  });

  factory ChatLog.fromJson(Map<String,dynamic> json){
    return ChatLog(
        sender: json['sender'],
        content: json['content'],
        senderImage: json['participantImageUrl'],
        isLeft: json['isLeft']
    );
  }
}