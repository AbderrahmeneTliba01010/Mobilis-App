import 'package:flutter/material.dart';
import '../../../models/visit_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_styles.dart';

class VisitTile extends StatelessWidget {
  final Visit visit;
  final VoidCallback? onAddPressed;

  const VisitTile({
    super.key,
    required this.visit,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                visit.id.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit.name,
                  style: AppTextStyles.subheading,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${visit.startTime} - ${visit.endTime}',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.directions_car,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${visit.distance} km${visit.isStartingPoint ? ' (Starting Point)' : ''}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
            onPressed: onAddPressed,
          ),
        ],
      ),
    );
  }
}
