import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_styles.dart';

class MapLayerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final Function(bool) onToggle;

  const MapLayerItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.0,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 8.0),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Switch(
            value: isActive,
            onChanged: onToggle,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}