import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/messages/bloc/conversation_state.dart';
import 'package:mobilis/services/chat_service.dart';


// Cubit
class ConversationsCubit extends Cubit<ConversationsState> {
  final ChatService chatService;
  
  ConversationsCubit(this.chatService) : super(ConversationsInitial());
  
  Future<void> loadConversations() async {
    emit(ConversationsLoading());
    try {
      final conversations = await chatService.getConversations();
      emit(ConversationsLoaded(conversations));
    } catch (e) {
      emit(ConversationsError(e.toString()));
    }
  }
  
  Future<void> refreshConversations() async {
    try {
      final conversations = await chatService.getConversations();
      emit(ConversationsLoaded(conversations));
    } catch (e) {
      emit(ConversationsError(e.toString()));
    }
  }
}