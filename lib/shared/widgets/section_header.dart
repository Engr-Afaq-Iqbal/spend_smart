// lib/shared/widgets/section_header.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs       = Theme.of(context).colorScheme;
    final subColor = cs.onBackground.withOpacity(0.45);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: AppTextStyles.h3.copyWith(
              fontSize: 16, color: cs.onBackground)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!,
                style: AppTextStyles.labelMedium.copyWith(
                  color: cs.primary, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
