import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/product_image.dart';
import '../../core/widgets/responsive_center.dart';
import '../../core/widgets/space_scaffold.dart';
import '../../models/order.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return SpaceScaffold(
      appBar: AppBar(title: Text('ORDER HISTORY', style: AppTheme.title(18))),
      body: ResponsiveCenter(
        child: auth.user == null
          ? const Center(
              child: Text(
                'Log in to view your orders.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : StreamBuilder<List<Order>>(
              stream: FirestoreService().ordersStream(auth.user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Could not load orders.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.red),
                    ),
                  );
                }
                final orders = snapshot.data ?? [];
                if (orders.isEmpty) {
                  return const Center(
                    child: Text(
                      "You haven't placed any orders yet.",
                      style: TextStyle(color: AppColors.cyan),
                    ),
                  );
                }
                return _OrderList(orders: orders);
              },
            ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    final totalSpent = orders.fold<int>(0, (sum, o) => sum + o.total);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.panel,
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summary('Orders', '${orders.length}'),
              _summary('Spent', '$totalSpent cr'),
              _summary('Last', orders.first.date),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...orders.map((order) => _OrderTile(order: order)),
      ],
    );
  }

  Widget _summary(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.cyan)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.cyan,
          collapsedIconColor: AppColors.cyan,
          title: Text(
            order.id,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            order.date,
            style: const TextStyle(color: AppColors.cyan),
          ),
          trailing: Text(
            '${order.total} cr',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: order.items
              .map(
                (item) => ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: ProductImage(
                      sku: item.sku,
                      type: item.type,
                      size: 44,
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(color: AppColors.gold),
                  ),
                  subtitle: Text(
                    'Qty: ${item.qty}',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  trailing: Text(
                    '${item.price} cr',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
