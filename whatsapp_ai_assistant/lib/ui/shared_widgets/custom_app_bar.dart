// lib/ui/shared_widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart'; // Ensure material_symbols_icons is in pubspec.yaml

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      // You can add more styling here
      // backgroundColor: Theme.of(context).primaryColor,
      // foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}