import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:provider/provider.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const StyledAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeProvider>(context).currentTheme;

    if (leading != null) {
      return AppBar(
        title: Text(title),
        backgroundColor: theme.primary,
        actions: actions,
        leading: leading,
      );
    }

    return AppBar(
      title: Text(title),
      backgroundColor: theme.primary,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
