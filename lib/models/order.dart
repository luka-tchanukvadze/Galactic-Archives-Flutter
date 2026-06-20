import 'cart_item.dart';

class OrderItem {
  const OrderItem({
    required this.sku,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.qty,
  });

  final String sku;
  final String name;
  final String type;
  final String description;
  final int price;
  final int qty;

  factory OrderItem.fromCartItem(CartItem item) {
    return OrderItem(
      sku: item.product.sku,
      name: item.product.name,
      type: item.product.type,
      description: item.product.description,
      price: item.product.price,
      qty: item.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sku': sku,
      'name': name,
      'type': type,
      'description': description,
      'price': price,
      'qty': qty,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      sku: map['sku'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      qty: (map['qty'] as num?)?.toInt() ?? 0,
    );
  }
}

class Order {
  const Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });

  final String id;
  final String date;
  final int total;
  final String status;
  final List<OrderItem> items;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'total': total,
      'status': status,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return Order(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      total: (map['total'] as num?)?.toInt() ?? 0,
      status: map['status'] ?? 'Delivered',
      items: rawItems
          .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}
