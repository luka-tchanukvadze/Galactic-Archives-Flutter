import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/space_scaffold.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'lore/lore_screen.dart';
import 'reviews/reviews_screen.dart';
import 'shop/shop_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    // MediaQuery: shrink the big title on small phones.
    final width = MediaQuery.of(context).size.width;
    final titleSize = width < 500 ? 30.0 : 44.0;

    return SpaceScaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName, style: AppTheme.title(20)),
        actions: [
          if (auth.isLoggedIn) ...[
            Center(
              child: Text(
                auth.user!.name,
                style: const TextStyle(color: AppColors.cyan),
              ),
            ),
            IconButton(
              tooltip: 'Log out',
              icon: const Icon(Icons.logout, color: AppColors.gold),
              onPressed: () => auth.logout(),
            ),
          ] else
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text('LOGIN', style: TextStyle(color: AppColors.gold)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'CHANU WARS',
                textAlign: TextAlign.center,
                style: AppTheme.title(titleSize),
              ),
              const SizedBox(height: 8),
              const Text(
                'A galaxy far, far away',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReviewsScreen()),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red, width: 2),
                ),
                child: const Text('[ REVIEWS ]'),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _HomeCard(
                    icon: Icons.auto_stories,
                    iconColor: AppColors.cyan,
                    title: 'UNLOCK THE HOLOCRON',
                    description:
                        'Access the ancient wisdom of the Jedi and Sith.',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoreScreen()),
                    ),
                  ),
                  _HomeCard(
                    icon: Icons.storefront,
                    iconColor: AppColors.gold,
                    title: 'GALACTIC BAZAAR',
                    description:
                        'Acquire rare artifacts from across the galaxy.',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ShopScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 340,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.panel.withValues(alpha: 0.85),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.6)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 56),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.title(18),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
              child: const Text('EXPLORE'),
            ),
          ],
        ),
      ),
    );
  }
}
