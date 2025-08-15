import 'package:flutter/material.dart';
import 'package:moon_leaf/sources/source_model.dart';
import 'package:moon_leaf/themes/colors.dart';

class SourceCard extends StatelessWidget {
  final Source source;
  final bool isPinned;
  final VoidCallback onTogglePinSource;
  final VoidCallback onNavigateToSource;
  final VoidCallback onNavigateToLatest;

  const SourceCard({
    super.key,
    required this.source,
    required this.isPinned,
    required this.onTogglePinSource,
    required this.onNavigateToSource,
    required this.onNavigateToLatest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Material(
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: onNavigateToSource,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Source icon and details
              Expanded(
                child: Row(
                  children: [
                    // Source icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.coverPlaceholderColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          source.icon,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              color: AppColors.coverPlaceholderColor,
                              child: Icon(
                                Icons.image,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Source details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            source.sourceName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${source.lang} (ID: ${source.sourceId})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Latest button
                  TextButton(
                    onPressed: onNavigateToLatest,
                    child: Text(
                      'Latest', // You can replace this with localized string
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Pin button
                  IconButton(
                    onPressed: onTogglePinSource,
                    icon: Icon(
                      isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 22,
                      color: isPinned 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}