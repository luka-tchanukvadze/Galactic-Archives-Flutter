import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsive_center.dart';
import '../../core/widgets/space_scaffold.dart';
import '../../data/lore_data.dart';
import '../../models/lore_topic.dart';
import 'api_characters_screen.dart';
import 'fav_characters_screen.dart';

class LoreScreen extends StatelessWidget {
  const LoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceScaffold(
      appBar: AppBar(
        title: Text('STAR WARS LORE', style: AppTheme.title(18)),
        actions: [
          IconButton(
            tooltip: 'Favourite characters',
            icon: const Icon(Icons.people_alt),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FavCharactersScreen(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'API characters',
            icon: const Icon(Icons.public),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ApiCharactersScreen(),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final topic in kLoreTopics) _LoreTile(topic: topic),
          ],
        ),
      ),
    );
  }
}

class _LoreTile extends StatelessWidget {
  const _LoreTile({required this.topic});

  final LoreTopic topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.gold,
          collapsedIconColor: AppColors.gold,
          title: Text(
            topic.title,
            style: AppTheme.title(18),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              topic.description,
              style: const TextStyle(color: AppColors.textLight, height: 1.4),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Why You Can't Miss This",
                textAlign: TextAlign.center,
                style: AppTheme.title(16),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              topic.whyWatch,
              style: const TextStyle(color: AppColors.cyan, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
