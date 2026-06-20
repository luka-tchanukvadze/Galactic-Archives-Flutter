import 'product.dart';

class CartItem {
  const CartItem({required this.product, required this.qty});

  final Product product;
  final int qty;

  int get lineTotal => product.price * qty;

  CartItem copyWith({int? qty}) {
    return CartItem(product: product, qty: qty ?? this.qty);
  }
}
