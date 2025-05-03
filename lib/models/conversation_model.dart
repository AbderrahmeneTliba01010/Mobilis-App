class Conversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;
  final String avatarInitials;

  Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.lastMessageTime,
    this.hasUnreadMessages = false,
    required this.avatarInitials,
  });
  
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      otherUserId: json['otherUserId'],
      otherUserName: json['otherUserName'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      hasUnreadMessages: json['hasUnreadMessages'] ?? false,
      avatarInitials: _getInitials(json['otherUserName']),
    );
  }
  
  static String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0];
      if (names.length > 1) {
        initials += names[1][0];
      }
    }
    return initials.toUpperCase();
  }
}