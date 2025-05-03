// screens/chat/chat_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/messages/bloc/chat_cubit.dart';
import 'package:mobilis/screens/messages/bloc/chat_state.dart';
import 'package:mobilis/widgets/messages/chat_input.dart';
import 'package:mobilis/widgets/messages/message_bubble.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';


class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String otherUserName;
  final String otherUserId;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    required this.otherUserId,
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        chatService: ChatService(userId: 'current-user-id'), // Replace with actual user ID
        conversationId: widget.conversationId,
        receiverId: widget.otherUserId,
      )..loadMessages(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text(
                  widget.otherUserName.substring(0, 2).toUpperCase(),
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUserName,
                    style: AppTextStyles.subheading,
                  ),
                  const Text(
                    'Last seen today at 10:45 AM',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show more options
              },
            ),
          ],
        ),
        body: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is ChatLoaded) {
              // Scroll to bottom after messages load or when sending new messages
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Date header
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'March 4, 2025',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                // Messages list
                Expanded(
                  child: state is ChatLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is ChatLoaded
                          ? _buildMessagesList(context, state.messages)
                          : state is ChatError
                              ? Center(
                                  child: Text(
                                    'Error: ${state.message}',
                                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                                  ),
                                )
                              : const SizedBox(),
                ),
                // Message input field
                MessageInput(
                  controller: _messageController,
                  onSend: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      context.read<ChatCubit>().sendMessage(_messageController.text.trim());
                      _messageController.clear();
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, List<Message> messages) {
    if (messages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'No messages yet',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 8),
            Text(
              'Start the conversation by sending a message',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isCurrentUser = message.senderId == 'current-user-id'; // Replace with actual user ID check
        
        // Group messages by time
        final showTimestamp = index == 0 || 
            messages[index].timestamp.difference(messages[index - 1].timestamp).inMinutes > 5;
        
        return MessageBubble(
          message: message,
          isCurrentUser: isCurrentUser,
        );
      },
    );
  }
}