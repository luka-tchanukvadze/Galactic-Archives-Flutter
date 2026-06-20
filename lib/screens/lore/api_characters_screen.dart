import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsive_center.dart';
import '../../core/widgets/space_scaffold.dart';
import '../../models/api_character.dart';
import '../../providers/api_characters_provider.dart';

class ApiCharactersScreen extends StatelessWidget {
  const ApiCharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // i scope the provider to this screen and load right away.
    return ChangeNotifierProvider(
      create: (_) => ApiCharactersProvider()..load(),
      child: const _ApiCharactersView(),
    );
  }
}

class _ApiCharactersView extends StatelessWidget {
  const _ApiCharactersView();

  @override
  Widget build(BuildContext context) {
    return SpaceScaffold(
      appBar: AppBar(title: Text('API CHARACTERS', style: AppTheme.title(16))),
      body: Consumer<ApiCharactersProvider>(
        builder: (context, provider, _) {
          switch (provider.status) {
            case ApiStatus.loading:
              return _loading();
            case ApiStatus.error:
              return _error(provider);
            case ApiStatus.done:
              return _grid(context, provider.characters);
          }
        },
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Lottie.asset('assets/lottie/loading.json'),
          ),
          const Text(
            'Scanning the galaxy...',
            style: TextStyle(color: AppColors.cyan),
          ),
        ],
      ),
    );
  }

  Widget _error(ApiCharactersProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: AppColors.red, size: 56),
            const SizedBox(height: 12),
            const Text(
              'Could not reach the holonet.',
              style: TextStyle(color: AppColors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.load,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, List<ApiCharacter> characters) {
    // MediaQuery decides how many columns fit the current screen.
    final width = MediaQuery.of(context).size.width;
    final columns = width >= 1100
        ? 4
        : width >= 800
        ? 3
        : width >= 550
        ? 2
        : 1;

    return ResponsiveCenter(
      maxWidth: 1200,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisExtent: 200,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: characters.length,
        itemBuilder: (context, index) =>
            _CharacterCard(character: characters[index]),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({required this.character});

  final ApiCharacter character;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.panel,
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // swapi has no images, so i use an icon header instead.
            Container(
              height: 64,
              width: double.infinity,
              color: AppColors.panelLight,
              child: const Icon(Icons.person, color: AppColors.cyan, size: 34),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_cap(character.gender)} - ${_show(character.birthYear)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Height: ${_withUnit(character.height, 'cm')}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Mass: ${_withUnit(character.mass, 'kg')}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.panel,
      isScrollControlled: true,
      builder: (context) => _DetailSheet(character: character),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  const _DetailSheet({required this.character});

  final ApiCharacter character;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: Text(character.name, style: AppTheme.title(20))),
          const SizedBox(height: 16),
          _row('Gender', _cap(character.gender)),
          _row('Birth year', _show(character.birthYear)),
          _row('Height', _withUnit(character.height, 'cm')),
          _row('Mass', _withUnit(character.mass, 'kg')),
          _row('Hair', _cap(character.hairColor)),
          _row('Skin', _cap(character.skinColor)),
          _row('Eyes', _cap(character.eyeColor)),
          _row('Films', '${character.films}'),
          _row('Starships', '${character.starships}'),
          _row('Vehicles', '${character.vehicles}'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
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
}

String _cap(String s) =>
    s.isEmpty ? 'Unknown' : s[0].toUpperCase() + s.substring(1);

// swapi uses "unknown" / "n/a" a lot, so i clean those up for display.
String _show(String value) {
  final v = value.trim();
  if (v.isEmpty || v.toLowerCase() == 'unknown' || v.toLowerCase() == 'n/a') {
    return 'Unknown';
  }
  return v;
}

String _withUnit(String value, String unit) {
  final shown = _show(value);
  return shown == 'Unknown' ? shown : '$shown $unit';
}
