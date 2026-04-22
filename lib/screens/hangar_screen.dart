import 'package:flutter/material.dart';

import '../data/dummy_ships.dart';
import '../models/ship.dart';
import '../theme/app_colors.dart';
import '../widgets/ship_card.dart';
import 'add_ship_screen.dart';
import 'ship_detail_screen.dart';

class HangarScreen extends StatefulWidget {
  const HangarScreen({super.key});

  @override
  State<HangarScreen> createState() => _HangarScreenState();
}

class _HangarScreenState extends State<HangarScreen> {
  // copy of the dummy list, so ships can be added or removed
  final List<Ship> _ships = List.of(dummyShips);

  void _deleteShip(String id) {
    setState(() {
      _ships.removeWhere((s) => s.id == id);
    });
  }

  void _openDetail(Ship ship) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShipDetailScreen(ship: ship, onDelete: _deleteShip),
      ),
    );
  }

  Future<void> _openAddShip() async {
    // AddShipScreen returns a Ship when Save is pressed, or null if user backs out
    final newShip = await Navigator.push<Ship>(
      context,
      MaterialPageRoute(builder: (_) => const AddShipScreen()),
    );
    if (newShip != null) {
      setState(() {
        _ships.add(newShip);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${newShip.name} added to hangar')),
        );
      }
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
      appBar: AppBar(
        title: const Text('HANGAR'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '${_ships.length} ships',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // pick number of columns based on screen width
            int columns = 3;
            if (constraints.maxWidth < 600) {
              columns = 1;
            } else if (constraints.maxWidth < 900) {
              columns = 2;
            }

            if (_ships.isEmpty) {
              return const _EmptyHangar();
            }

            // aspect ratio = width / height; bigger = shorter card
            // tuned per column count so card height stays similar across sizes
            double cardRatio = 2.0;
            if (columns == 2) cardRatio = 3.0;
            if (columns == 1) cardRatio = 2.2;

            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: cardRatio,
              padding: EdgeInsets.fromLTRB(
                horizontalPad,
                16,
                horizontalPad,
                96,
              ),
              children: _ships.map((ship) {
                return ShipCard(ship: ship, onTap: () => _openDetail(ship));
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddShip,
        icon: const Icon(Icons.add),
        label: const Text('ADD SHIP'),
      ),
    );
  }
}

class _EmptyHangar extends StatelessWidget {
  const _EmptyHangar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.rocket_launch_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Hangar empty',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap ADD SHIP to register your first vessel.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
