import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsive_center.dart';
import '../../core/widgets/space_scaffold.dart';
import '../../data/products_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../auth/login_screen.dart';
import 'cart_view.dart';
import 'order_history_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _viewCart = false;
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.loading) {
      return const SpaceScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!auth.isLoggedIn) {
      return SpaceScaffold(
        appBar: AppBar(title: Text(AppConstants.shopName, style: AppTheme.title(20))),
        body: _buildGate(context),
      );
    }

    final cart = context.watch<CartProvider>();

    return SpaceScaffold(
      appBar: AppBar(
        title: Text(AppConstants.shopName, style: AppTheme.title(20)),
        actions: [
          IconButton(
            tooltip: 'Order history',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
          ),
          _cartButton(cart),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ResponsiveCenter(
        maxWidth: 1100,
        // Implicit animation: AnimatedSwitcher cross-fades when I flip
        // between the product grid and the cart.
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _viewCart
              ? CartView(
                  key: const ValueKey('cart'),
                  onContinue: () => setState(() => _viewCart = false),
                )
              : KeyedSubtree(
                  key: const ValueKey('products'),
                  child: _buildProductGrid(cart),
                ),
        ),
      ),
    );
  }

  Widget _cartButton(CartProvider cart) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          tooltip: _viewCart ? 'View products' : 'View cart',
          icon: Icon(_viewCart ? Icons.storefront : Icons.shopping_cart),
          onPressed: () => setState(() => _viewCart = !_viewCart),
        ),
        if (cart.totalItems > 0 && !_viewCart)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '${cart.totalItems}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGate(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, color: AppColors.gold, size: 64),
            const SizedBox(height: 16),
            Text('ACCESS RESTRICTED', style: AppTheme.title(22)),
            const SizedBox(height: 8),
            const Text(
              'You must log in to enter the Galactic Bazaar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black,
              ),
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(CartProvider cart) {
    const perPage = AppConstants.itemsPerPage;
    final totalPages = (kProducts.length / perPage).ceil();
    final start = (_page - 1) * perPage;
    final end = (start + perPage).clamp(0, kProducts.length);
    final pageItems = kProducts.sublist(start, end);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'GALACTIC MARKETPLACE',
            textAlign: TextAlign.center,
            style: AppTheme.title(22),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 3 cards per row on wide screens, then 2, then 1.
              final width = constraints.maxWidth;
              final columns = width >= 1000 ? 3 : (width >= 600 ? 2 : 1);
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisExtent: 300,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: pageItems.length,
                itemBuilder: (context, index) {
                  final product = pageItems[index];
                  return ProductCard(
                    product: product,
                    inCart: cart.contains(product.sku),
                    onAdd: () => cart.add(product),
                  );
                },
              );
            },
          ),
        ),
        _pagination(totalPages),
      ],
    );
  }

  Widget _pagination(int totalPages) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.gold),
            onPressed: _page > 1 ? () => setState(() => _page--) : null,
          ),
          Text(
            'Page $_page of $totalPages',
            style: const TextStyle(color: AppColors.gold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.gold),
            onPressed: _page < totalPages ? () => setState(() => _page++) : null,
          ),
        ],
      ),
    );
  }
}
