
import 'package:flutter/material.dart';

class Chip extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const Chip({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final chipBackgroundColor = backgroundColor ?? 
        (isDark 
            ? theme.colorScheme.surface.withValues(alpha: .12)
            : theme.colorScheme.secondaryContainer);
    
    final chipTextColor = textColor ?? 
        (isDark 
            ? theme.colorScheme.onSurface 
            : theme.colorScheme.onSecondaryContainer);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(
          label,
          style: TextStyle(
            color: chipTextColor,
            fontSize: 12,
          ),
        ),
        backgroundColor: chipBackgroundColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}