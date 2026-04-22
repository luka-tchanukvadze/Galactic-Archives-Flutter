import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final int max;

  const StatBar({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) {
    // how full the bar is, between 0 and 1
    double ratio = value / max;
    if (ratio < 0) ratio = 0;
    if (ratio > 1) ratio = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              '$value / $max',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: ratio,
          minHeight: 8,
          backgroundColor: AppColors.surfaceHigh,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }
}
