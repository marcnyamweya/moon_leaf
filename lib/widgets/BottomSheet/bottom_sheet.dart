import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomSheet {

  static void show(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
  }) {
    showMaterialModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      builder: (context) => SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}