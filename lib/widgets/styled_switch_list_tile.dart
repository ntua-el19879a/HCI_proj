import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:provider/provider.dart';

class StyledSwitchListTile extends StatelessWidget {
  final bool value;
  final String title;
  final ValueChanged<bool> onChanged;

  const StyledSwitchListTile(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.value});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeProvider>(context).currentTheme;

    return SwitchListTile(
        title: Text(title),
        activeColor: theme.primary,
        value: value,
        onChanged: (value) {
          HapticFeedback.mediumImpact();
          onChanged(value);
        });
  }
}
