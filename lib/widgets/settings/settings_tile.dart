import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? titleColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        icon,
        color: AppColors.secondary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle!,
        style: Theme.of(context).textTheme.bodyMedium,
      ) : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.secondary,
      ),
      onTap: onTap,
    );
  }
}