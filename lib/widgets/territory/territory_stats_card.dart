import 'package:flutter/material.dart';
import '../../../theme/text_styles.dart';

class TerritoryStatsCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const TerritoryStatsCard({
    Key? key,
    required this.value,
    required this.label,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}