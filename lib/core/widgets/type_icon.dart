import 'package:flutter/material.dart';

// Maps a product type to an icon (products have no images).
IconData iconForType(String type) {
  switch (type) {
    case 'Ship':
      return Icons.rocket_launch;
    case 'Weapon':
      return Icons.flash_on;
    case 'Armor':
      return Icons.shield;
    case 'Clothing':
      return Icons.checkroom;
    case 'Droid':
      return Icons.smart_toy;
    case 'Medical':
      return Icons.healing;
    case 'Device':
      return Icons.devices_other;
    case 'Equipment':
      return Icons.backpack;
    case 'Collectible':
      return Icons.star;
    case 'Material':
      return Icons.diamond;
    default:
      return Icons.inventory_2;
  }
}
