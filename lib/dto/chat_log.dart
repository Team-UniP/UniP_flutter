class ChatLog{
  final String sender;
  final String content;
  final String senderImage;

  ChatLog({
    required this.sender,
    required this.content,
    required this.senderImage,
  });

  factory ChatLog.fromJson(Map<String,dynamic> json){
    return ChatLog(
        sender: json['sender'],
        content: json['content'],
        senderImage: json['participantImageUrl'],
    );
  }
}