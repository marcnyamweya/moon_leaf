import 'package:flutter/material.dart';


class ErrorAction {
  final IconData iconData;
  final String title;
  final VoidCallback onPressed;

  const ErrorAction({
    required this.iconData,
    required this.title,
    required this.onPressed,
  });
}

class ErrorScreen extends StatelessWidget {
  final String error;
  final List<ErrorAction>? actions;
  final Color? iconColor;
  final Color? textColor;

  const ErrorScreen({
    super.key,
    required this.error,
    this.actions,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outlineColor = iconColor ?? textColor ?? theme.colorScheme.outline;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ಥ_ಥ',
              style: TextStyle(
                fontSize: 44,
                color: outlineColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                error,
                style: TextStyle(
                  color: outlineColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                children: actions!.map((action) => 
                  TextButton.icon(
                    onPressed: action.onPressed,
                    icon: Icon(
                      action.iconData,
                      size: 20,
                      color: outlineColor,
                    ),
                    label: Text(
                      action.title,
                      style: TextStyle(color: outlineColor),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}