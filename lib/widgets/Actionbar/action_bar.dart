import 'package:flutter/material.dart';
import 'package:moon_leaf/themes/app_theme.dart';

class ActionbarAction {
  final IconData icon;
  final VoidCallback onPress;

  const ActionbarAction({
    required this.icon,
    required this.onPress,
  });
}

class Actionbar extends StatefulWidget {
  final bool active;
  final List<ActionbarAction> actions;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final Duration animationDuration;
  final Curve animationCurve;
  final double? height;

  const Actionbar({
    super.key,
    required this.active,
    required this.actions,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.height,
  });

  @override
  State<Actionbar> createState() => _ActionbarState();
}

class _ActionbarState extends State<Actionbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    if (widget.active) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(Actionbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                elevation: widget.elevation ?? 1,
                borderRadius: widget.borderRadius ?? 
                  const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  width: screenWidth,
                  height: widget.height ?? (80 + bottomPadding),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? theme.colorScheme.surface,
                    borderRadius: widget.borderRadius ?? 
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: bottomPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: widget.actions.map((action) => _ActionButton(
                      action: action,
                      theme: theme,
                    )).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final ActionbarAction action;
  final ThemeData theme;

  const _ActionButton({
    required this.action,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: theme.colorScheme.primary.withValues(alpha:0.12),
        highlightColor: theme.colorScheme.primary.withValues(alpha: .08),
        onTap: action.onPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            action.icon,
            size: 24,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}