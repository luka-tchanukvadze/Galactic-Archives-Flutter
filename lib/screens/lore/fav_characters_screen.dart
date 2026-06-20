import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsive_center.dart';
import '../../core/widgets/space_scaffold.dart';
import '../../data/characters_data.dart';
import '../../models/sw_character.dart';

String _slug(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
}

class FavCharactersScreen extends StatelessWidget {
  const FavCharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceScaffold(
      appBar: AppBar(
        title: Text('FAVOURITE CHARACTERS', style: AppTheme.title(16)),
      ),
      body: ResponsiveCenter(
        maxWidth: 800,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final character in kCharacters)
              _CharacterTile(character: character),
          ],
        ),
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile({required this.character});

  final SwCharacter character;

  @override
  Widget build(BuildContext context) {
    final isJedi = character.affiliation == 'Jedi';
    final color = isJedi ? AppColors.jedi : AppColors.sith;
    final imagePath = 'assets/characters/${_slug(character.name)}.jpg';
    final fallbackIcon = isJedi ? Icons.flare : Icons.bolt;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: color,
          collapsedIconColor: color,
          leading: ClipOval(
            child: Image.asset(
              imagePath,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(fallbackIcon, color: color),
              ),
            ),
          ),
          title: Text(
            character.name,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            character.affiliation,
            style: TextStyle(color: color),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  height: 220,
                  color: AppColors.panelLight,
                  alignment: Alignment.center,
                  child: Icon(fallbackIcon, color: color, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              character.description,
              style: const TextStyle(color: AppColors.textLight, height: 1.4),
            ),
            const SizedBox(height: 12),
            _stat('Homeworld', character.homeworld),
            _stat('Birth year', character.birthYear),
            _stat('Gender', character.gender),
            _stat('Height', character.height),
            _stat('Mass', character.mass),
            _stat('Hair', character.hairColor),
            _stat('Skin', character.skinColor),
            _stat('Eyes', character.eyeColor),
            _stat('Midi-chlorians', character.midichlorians),
            const SizedBox(height: 12),
            _chips('Films', character.films, color),
            _chips('TV Series', character.tvSeries, color),
            _chips('Novels', character.novels, color),
            _chips('Comics', character.comics, color),
            _chips('Games', character.games, color),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: AppColors.cyan)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chips(String label, List<String> values, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: values
                .map(
                  (value) => Chip(
                    label: Text(value, style: const TextStyle(fontSize: 12)),
                    backgroundColor: color.withValues(alpha: 0.15),
                    side: BorderSide(color: color.withValues(alpha: 0.4)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
