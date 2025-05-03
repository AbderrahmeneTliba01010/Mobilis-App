import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/models/message_model.dart';
import 'package:mobilis/screens/messages/bloc/chat_state.dart';
import 'package:mobilis/services/chat_service.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService chatService;
  final String conversationId;
  final String receiverId;
  
  ChatCubit({
    required this.chatService,
    required this.conversationId,
    required this.receiverId,
  }) : super(ChatInitial());
  
  Future<void> loadMessages() async {
    emit(ChatLoading());
    try {
      final messages = await chatService.getMessages(conversationId);
      emit(ChatLoaded(messages));
      
      // Mark messages as read
      await chatService.markAsRead(conversationId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
  
  Future<void> sendMessage(String content) async {
    try {
      final message = await chatService.sendMessage(receiverId, content);
      
      final currentState = state;
      if (currentState is ChatLoaded) {
        final updatedMessages = List<Message>.from(currentState.messages)..add(message);
        emit(ChatLoaded(updatedMessages));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}