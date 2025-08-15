import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final IconData? iconData;
  final String? iconText;
  final String description;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? textSize;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyView({
    super.key,
    this.iconData,
    this.iconText,
    required this.description,
    this.iconColor,
    this.textColor,
    this.iconSize = 40,
    this.textSize,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 16,
    this.onAction,
    this.actionText,
  });

  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final outlineColor = iconColor ?? textColor ?? theme.colorScheme.outline;

  return Container(
    width: double.infinity,
    height: 400, // Add a fixed height or use MediaQuery for dynamic height
    padding: padding!,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null || iconText != null) ...[
            iconData != null
                ? Icon(
                    iconData,
                    size: iconSize,
                    color: outlineColor,
                  )
                : Text(
                    iconText!,
                    style: TextStyle(
                      fontSize: iconSize,
                      fontWeight: FontWeight.bold,
                      color: outlineColor,
                    ),
                  ),
            SizedBox(height: spacing),
          ],
          Text(
            description,
            style: TextStyle(
              color: outlineColor,
              fontSize: textSize ?? theme.textTheme.bodyMedium?.fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionText != null) ...[
            SizedBox(height: spacing),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    ),
  );
}
}