enum ShipRole { starfighter, freighter, shuttle, capital }

class Ship {
  final String id;
  final String name;
  final String shipClass;
  final String manufacturer;
  final int crew;
  final int hull;
  final int shields;
  final int speed;
  final ShipRole role;

  const Ship({
    required this.id,
    required this.name,
    required this.shipClass,
    required this.manufacturer,
    required this.crew,
    required this.hull,
    required this.shields,
    required this.speed,
    required this.role,
  });
}
