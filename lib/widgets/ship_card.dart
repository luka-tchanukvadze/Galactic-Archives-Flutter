import 'package:flutter/material.dart';

import '../models/ship.dart';
import '../theme/app_colors.dart';

class ShipCard extends StatelessWidget {
  final Ship ship;
  final VoidCallback onTap;

  const ShipCard({super.key, required this.ship, required this.onTap});

  // pick an icon based on the ship's role
  IconData _roleIcon() {
    if (ship.role == ShipRole.starfighter) return Icons.rocket_launch;
    if (ship.role == ShipRole.freighter) return Icons.local_shipping;
    if (ship.role == ShipRole.shuttle) return Icons.flight;
    return Icons.directions_boat_filled;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_roleIcon(), color: AppColors.primary, size: 32),
              const SizedBox(height: 12),
              Text(
                ship.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                ship.shipClass.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shield, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 3),
                  Text('${ship.hull}', style: _statStyle),
                  const SizedBox(width: 10),
                  Icon(Icons.bolt, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 3),
                  Text('${ship.shields}', style: _statStyle),
                  const SizedBox(width: 10),
                  Icon(Icons.speed, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 3),
                  Text('${ship.speed}', style: _statStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const TextStyle _statStyle = TextStyle(
  color: AppColors.textPrimary,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
