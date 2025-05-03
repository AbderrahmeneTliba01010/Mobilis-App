import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/message_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isCurrentUser ? AppColors.primary.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrentUser 
                    ? AppColors.primary.withOpacity(0.3) 
                    : AppColors.divider,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isCurrentUser 
                        ? AppColors.primary.withOpacity(0.7) 
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}