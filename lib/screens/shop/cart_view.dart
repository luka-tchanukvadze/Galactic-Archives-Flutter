import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/product_image.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/firestore_service.dart';
import 'order_history_screen.dart';

class CartView extends StatefulWidget {
  const CartView({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final FirestoreService _firestore = FirestoreService();
  bool _placing = false;
  bool _confirmed = false;

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    if (cart.totalItems == 0 || auth.user == null) return;

    setState(() => _placing = true);
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now().toIso8601String().substring(0, 10),
      total: cart.totalPrice,
      status: 'Delivered',
      items: cart.items.map(OrderItem.fromCartItem).toList(),
    );

    try {
      await _firestore.placeOrder(auth.user!.uid, order);
      cart.clear();
      if (!mounted) return;
      setState(() => _confirmed = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not place order: $e')),
      );
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmed) {
      return _ConfirmationView(onContinue: widget.onContinue);
    }

    final cart = context.watch<CartProvider>();
    if (cart.items.isEmpty) {
      return const Center(
        child: Text(
          'Your cart is empty.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...cart.items.map((item) => _CartLine(item: item)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.panel,
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Items: ${cart.totalItems}',
                    style: const TextStyle(color: AppColors.cyan),
                  ),
                  Text(
                    'Total: ${cart.totalPrice} cr',
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _placing ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _placing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final product = item.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ProductImage(sku: product.sku, type: product.type, size: 48),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${product.price} cr',
                  style: const TextStyle(color: AppColors.cyan, fontSize: 12),
                ),
              ],
            ),
          ),
          DropdownButton<int>(
            value: item.qty,
            dropdownColor: AppColors.panelLight,
            style: const TextStyle(color: Colors.white),
            items: List.generate(20, (i) => i + 1)
                .map((q) => DropdownMenuItem(value: q, child: Text('$q')))
                .toList(),
            onChanged: (value) {
              if (value != null) cart.setQty(product.sku, value);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.red),
            onPressed: () => cart.remove(product.sku),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationView extends StatelessWidget {
  const _ConfirmationView({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Thank you for your order.',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your items will be delivered to your starship soon!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.cyan),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              ),
              child: const Text('Check Order History'),
            ),
            TextButton(
              onPressed: onContinue,
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
