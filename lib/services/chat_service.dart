// services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';
import '../models/conversation_model.dart';

class ChatService {
  final String baseUrl = 'https://your-server-url.com/api';
  final String userId; // Current user ID
  
  ChatService({required this.userId});
  
  // Get all conversations for current user
  Future<List<Conversation>> getConversations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversations'),
        headers: {'User-ID': userId},
      );
      
      if (response.statusCode == 200) {
        final List conversationsJson = jsonDecode(response.body);
        return conversationsJson.map((json) => Conversation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      // Mock data for development
      return [
        Conversation(
          id: '1',
          otherUserId: 'user1',
          otherUserName: 'Ahmed Malik',
          lastMessage: 'Please visit the new store in Kouba...',
          lastMessageTime: DateTime.now(),
          hasUnreadMessages: true,
          avatarInitials: 'AM',
        ),
        Conversation(
          id: '2',
          otherUserId: 'user2',
          otherUserName: 'Sales Team',
          lastMessage: 'Sarah: Don\'t forget the team meeting...',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
          hasUnreadMessages: false,
          avatarInitials: 'ST',
        ),
        // Add more sample conversations
      ];
    }
  }
  
  // Get messages for a specific conversation
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/conversations/$conversationId/messages'),
        headers: {'User-ID': userId},
      );
      
      if (response.statusCode == 200) {
        final List messagesJson = jsonDecode(response.body);
        return messagesJson.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      // Mock data for development
      if (conversationId == '1') {
        return [
          Message(
            id: '1',
            senderId: 'user1',
            receiverId: userId,
            content: 'Good morning John. I hope you\'re doing well.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            isRead: true,
          ),
          Message(
            id: '2',
            senderId: 'user1',
            receiverId: userId,
            content: 'We have a new store opening in Kouba. Could you add it to your visits for today?',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            isRead: true,
          ),
          Message(
            id: '3',
            senderId: userId,
            receiverId: 'user1',
            content: 'Good morning Ahmed. Yes, I can visit the new store today. What\'s the address?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
            isRead: true,
          ),
          Message(
            id: '4',
            senderId: 'user1',
            receiverId: userId,
            content: 'It\'s at 45 Liberty Street, next to the central market. Ask for Mounir when you arrive.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 38)),
            isRead: true,
          ),
          Message(
            id: '5',
            senderId: userId,
            receiverId: 'user1',
            content: 'Got it. I\'ll head there after my visit to Telecom Plus around 2pm.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
            isRead: true,
          ),
          Message(
            id: '6',
            senderId: 'user1',
            receiverId: userId,
            content: 'Perfect. Please take photos of the store setup and make sure they have all our promotional materials.',
            timestamp: DateTime.now(),
            isRead: false,
          ),
        ];
      }
      return [];
    }
  }
  
  // Send a message
  Future<Message> sendMessage(String receiverId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Content-Type': 'application/json',
          'User-ID': userId,
        },
        body: jsonEncode({
          'receiverId': receiverId,
          'content': content,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode == 201) {
        return Message.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      // Mock response for development
      return Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: userId,
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
      );
    }
  }
  
  // Mark messages as read
  Future<void> markAsRead(String conversationId) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/conversations/$conversationId/read'),
        headers: {'User-ID': userId},
      );
    } catch (e) {
      // Ignore in development mode
    }
  }
}