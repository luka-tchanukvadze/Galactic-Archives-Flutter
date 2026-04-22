import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GalacticArchivesApp());
}

class GalacticArchivesApp extends StatelessWidget {
  const GalacticArchivesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galactic Archives',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const HomeShell(),
    );
  }
}
