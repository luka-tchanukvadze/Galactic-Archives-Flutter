import 'package:flutter/material.dart';

import '../models/ship.dart';
import '../theme/app_colors.dart';
import '../widgets/stat_bar.dart';

class ShipDetailScreen extends StatelessWidget {
  final Ship ship;
  // function passed in from the hangar, used to remove this ship from the list
  final void Function(String id) onDelete;

  const ShipDetailScreen({
    super.key,
    required this.ship,
    required this.onDelete,
  });

  // pick an icon based on the ship's role
  IconData _roleIcon() {
    if (ship.role == ShipRole.starfighter) return Icons.rocket_launch;
    if (ship.role == ShipRole.freighter) return Icons.local_shipping;
    if (ship.role == ShipRole.shuttle) return Icons.flight;
    return Icons.directions_boat_filled;
  }

  Future<void> _confirmDelete(BuildContext context) async {
    // ask the user to confirm before deleting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Decommission ${ship.name}?'),
          content: const Text(
            'This ship will be removed from the hangar.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      onDelete(ship.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // smaller padding on phones, bigger on wide screens
    double horizontalPad = 40;
    if (width < 600) {
      horizontalPad = 20;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('SHIP DETAIL')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(_roleIcon(), color: AppColors.primary, size: 48),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ship.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ship.shipClass.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'SPECIFICATIONS',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _InfoRow(label: 'Manufacturer', value: ship.manufacturer),
              _InfoRow(label: 'Class', value: ship.shipClass),
              _InfoRow(label: 'Crew', value: ship.crew.toString()),
              const SizedBox(height: 24),
              const Text(
                'COMBAT PROFILE',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      StatBar(
                        label: 'Hull Integrity',
                        icon: Icons.shield,
                        value: ship.hull,
                      ),
                      const SizedBox(height: 16),
                      StatBar(
                        label: 'Shield Strength',
                        icon: Icons.bolt,
                        value: ship.shields,
                      ),
                      const SizedBox(height: 16),
                      StatBar(
                        label: 'Sublight Speed',
                        icon: Icons.speed,
                        value: ship.speed,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('DECOMMISSION SHIP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
