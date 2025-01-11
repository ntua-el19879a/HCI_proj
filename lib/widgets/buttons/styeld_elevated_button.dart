import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:provider/provider.dart';

class StyledElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const StyledElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeProvider>(context).currentTheme;

    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            return theme.primaryText;
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            return theme.primary;
          },
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
