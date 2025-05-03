// widgets/chat/conversation_tile.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/conversation_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: _getAvatarColor(conversation.avatarInitials),
        child: Text(
          conversation.avatarInitials,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        conversation.otherUserName,
        style: conversation.hasUnreadMessages
            ? AppTextStyles.subheading
            : AppTextStyles.body,
      ),
      subtitle: Text(
        conversation.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(conversation.lastMessageTime),
            style: AppTextStyles.bodySmall,
          ),
          if (conversation.hasUnreadMessages)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Color _getAvatarColor(String initials) {
    // Generate a color based on initials
    final colors = [
      Colors.blue[700]!,
      AppColors.primary,
      Colors.orange[700]!,
      Colors.purple[700]!,
      Colors.red[700]!,
    ];
    
    int index = 0;
    for (var char in initials.codeUnits) {
      index += char;
    }
    return colors[index % colors.length];
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.year == now.year && time.month == now.month && time.day == now.day) {
      // Today, return time
      return DateFormat('h:mm a').format(time);
    } else if (time.year == now.year && time.month == now.month && time.day == now.day - 1) {
      // Yesterday
      return 'Yesterday';
    } else if (time.year == now.year && now.difference(time).inDays < 7) {
      // Within the last week
      return DateFormat('E').format(time); // Day of week
    } else {
      // Older
      return DateFormat('MMM d').format(time); // Nov 30
    }
  }
}


