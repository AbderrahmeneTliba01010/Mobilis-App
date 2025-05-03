import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? secondValue;
  final String? label;
  final double progress;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.secondValue,
    this.label,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                if (label != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text(
                      '$label $secondValue',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
              ],
            ),
            if (label == null && secondValue != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondValue!,
                  style: AppTextStyles.bodySmall,
                ),
              ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}