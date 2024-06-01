class ChatMessage {
  final int id;
  final int userId;
  final String message;
  final int timestamp;

  ChatMessage(
      {required this.id,
      required this.userId,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      userId: map['userId'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
