import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Sorted copy so the cart order stays stable.
  List<CartItem> get items {
    final sorted = [..._items];
    sorted.sort((a, b) => a.product.sku.compareTo(b.product.sku));
    return sorted;
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.qty);

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.lineTotal);

  bool contains(String sku) => _items.any((i) => i.product.sku == sku);

  void add(Product product) {
    final index = _items.indexWhere((i) => i.product.sku == product.sku);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(qty: _items[index].qty + 1);
    } else {
      _items.add(CartItem(product: product, qty: 1));
    }
    notifyListeners();
  }

  void setQty(String sku, int qty) {
    final index = _items.indexWhere((i) => i.product.sku == sku);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(qty: qty);
      notifyListeners();
    }
  }

  void remove(String sku) {
    _items.removeWhere((i) => i.product.sku == sku);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
