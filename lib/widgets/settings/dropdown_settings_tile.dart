import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class DropdownSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.items,
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
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: subtitle != null ? Text(
        subtitle!,
        style: Theme.of(context).textTheme.bodyMedium,
      ) : null,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isDense: true,
        ),
      ),
    );
  }
}