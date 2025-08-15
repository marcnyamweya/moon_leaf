


import 'package:flutter/material.dart';

class RightIcon {
  final IconData iconData;
  final Color? color;
  final VoidCallback onPress;

  const RightIcon({
    required this.iconData,
    this.color,
    required this.onPress,
  });
}

// Placeholder for IconButtonV2 equivalent
class IconButtonV2 extends StatelessWidget {
  final IconData iconData;
  final Color? color;
  final VoidCallback? onPressed;
  final double size;

  const IconButtonV2({
    super.key,
    required this.iconData,
    this.color,
    this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData, color: color),
      onPressed: onPressed,
      iconSize: size,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
    );
  }
}


class Searchbar extends StatefulWidget {
  final String initialText;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final IconData leftIcon;
  final List<RightIcon>? rightIcons;
  final VoidCallback? handleBackAction;
  final VoidCallback? onLeftIconPress;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? rippleColor;

  const Searchbar({
    super.key,
    this.initialText = '',
    required this.placeholder,
    this.onChanged,
    this.onSubmitted,
    required this.leftIcon,
    this.rightIcons,
    this.handleBackAction,
    this.onLeftIconPress,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.rippleColor,
  });

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    _searchText = widget.initialText;
    
    _controller.addListener(() {
      setState(() {
        _searchText = _controller.text;
      });
      widget.onChanged?.call(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _focusSearchbar() {
    _focusNode.requestFocus();
  }

  void _clearSearchbar() {
    _controller.clear();
    setState(() {
      _searchText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final safePadding = mediaQuery.padding;
    
    final marginTop = safePadding.top + 8;
    final marginRight = safePadding.right + 16;
    final marginLeft = safePadding.left + 16;
    
    final surface2Color = widget.backgroundColor ?? 
        theme.colorScheme.surfaceContainer;
    final onSurfaceColor = widget.textColor ?? widget.iconColor ?? 
        theme.colorScheme.onSurface;
    final buttonRippleColor = widget.rippleColor ?? 
        theme.colorScheme.onSurface.withValues(alpha: 0.12);

    return Container(
      margin: EdgeInsets.only(
        top: marginTop,
        right: marginRight,
        left: marginLeft,
        bottom: 12,
      ),
      constraints: const BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        color: surface2Color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _focusSearchbar,
          splashColor: buttonRippleColor,
          highlightColor: buttonRippleColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButtonV2(
                  iconData: widget.handleBackAction != null 
                      ? Icons.arrow_back 
                      : widget.leftIcon,
                  color: onSurfaceColor,
                  onPressed: () {
                    if (widget.handleBackAction != null) {
                      widget.handleBackAction!();
                    } else if (widget.onLeftIconPress != null) {
                      widget.onLeftIconPress!();
                    }
                  },
                ),
                
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: onSurfaceColor,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: TextStyle(color: onSurfaceColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onSubmitted: widget.onSubmitted != null 
                        ? (_) => widget.onSubmitted!() 
                        : null,
                  ),
                ),
                
                if (_searchText.isNotEmpty)
                  IconButtonV2(
                    iconData: Icons.close,
                    color: onSurfaceColor,
                    onPressed: _clearSearchbar,
                  ),
                
                if (widget.rightIcons != null)
                  ...widget.rightIcons!.map((icon) => 
                    IconButtonV2(
                      iconData: icon.iconData,
                      color: icon.color ?? onSurfaceColor,
                      onPressed: icon.onPress,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}