import 'package:flutter/material.dart';
import 'package:prioritize_it/widgets/sidebar.dart';
import 'package:prioritize_it/widgets/styled_app_bar.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  BaseLayout({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyledAppBar(
        title: title,
      ),
      drawer: Sidebar(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
