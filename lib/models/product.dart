class Product {
  const Product({
    required this.sku,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
  });

  final String sku;
  final String name;
  final String type;
  final String description;
  final int price;
}
