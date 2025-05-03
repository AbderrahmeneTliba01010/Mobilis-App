import 'package:flutter/material.dart';
import '../../models/prospect_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class ProspectListItem extends StatelessWidget {
  final Prospect prospect;

  const ProspectListItem({
    super.key,
    required this.prospect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prospect.name,
                  style: AppTextStyles.subheading,
                ),
                Text(
                  _formatDate(prospect.createdAt),
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              prospect.contactPerson,
              style: AppTextStyles.body,
            ),
            Text(
              prospect.phone,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusChip(prospect.status),
                const SizedBox(height: 6),
                _buildActionButtons(prospect.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'New':
        color = Colors.blue;
        break;
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Accepted':
        color = AppColors.primary;
        break;
      case 'Rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons(String status) {
    return Row(
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.info_outline, size: 16),
          label: const Text('Details'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            side: const BorderSide(color: AppColors.primary),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          onPressed: () {
            // Navigate to details page
          },
        ),
        const SizedBox(width: 8),
        if (status == 'New' || status == 'Pending')
          OutlinedButton.icon(
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Follow Up'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              side: const BorderSide(color: AppColors.primary),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onPressed: () {
              // Follow up action
            },
          ),
        if (status == 'Pending')
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.phone, size: 16),
              label: const Text('Contact'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                side: const BorderSide(color: AppColors.primary),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              onPressed: () {
                // Contact action
              },
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
