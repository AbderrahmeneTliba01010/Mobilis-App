import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/messages/bloc/conversation_cubit.dart';
import 'package:mobilis/screens/messages/bloc/conversation_state.dart';
import 'package:mobilis/screens/messages/chat_screen.dart';
import 'package:mobilis/widgets/messages/conversation_tile.dart';
import '../../models/conversation_model.dart';
import '../../services/chat_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';


class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationsCubit(
        ChatService(userId: 'current-user-id'), // Replace with actual user ID
      )..loadConversations(),
      child: GestureDetector(
        onTap: () {
          // Remove focus when tapping outside the text field
          if (_searchFocusNode.hasFocus) {
            _searchFocusNode.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Messages'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  // Handle notifications
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text('JD', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _searchFocusNode.unfocus();
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ConversationsCubit, ConversationsState>(
                  builder: (context, state) {
                    if (state is ConversationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ConversationsLoaded) {
                      final filteredConversations = _filterConversations(state.conversations);
                      return _buildConversationsList(context, filteredConversations);
                    } else if (state is ConversationsError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: AppTextStyles.body.copyWith(color: AppColors.error),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () {
              // Handle new message creation
            },
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<Conversation> _filterConversations(List<Conversation> conversations) {
    if (_searchQuery.isEmpty) {
      return conversations;
    }
    
    final query = _searchQuery.toLowerCase();
    return conversations.where((conversation) {
      return conversation.otherUserName.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildConversationsList(BuildContext context, List<Conversation> conversations) {
    if (conversations.isEmpty) {
      if (_searchQuery.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                'No results found for "$_searchQuery"',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                },
                child: const Text('Clear search'),
              ),
            ],
          ),
        );
      }
      
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: AppTextStyles.subheading,
            ),
            SizedBox(height: 8),
            Text(
              'Start a new conversation using the button below',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return context.read<ConversationsCubit>().refreshConversations();
      },
      child: ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ConversationTile(
            conversation: conversation,
            onTap: () {
              // Unfocus search field when navigating to chat detail
              _searchFocusNode.unfocus();
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    conversationId: conversation.id,
                    otherUserName: conversation.otherUserName,
                    otherUserId: conversation.otherUserId,
                  ),
                ),
              ).then((_) {
                // Refresh conversations when returning from chat screen
                context.read<ConversationsCubit>().refreshConversations();
              });
            },
          );
        },
      ),
    );
  }
}