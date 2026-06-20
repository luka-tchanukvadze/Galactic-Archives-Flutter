import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'star_field.dart';

// Scaffold with the starfield painted behind the body.
class SpaceScaffold extends StatelessWidget {
  const SpaceScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          const StarField(),
          SafeArea(child: body),
        ],
      ),
    );
  }
}
