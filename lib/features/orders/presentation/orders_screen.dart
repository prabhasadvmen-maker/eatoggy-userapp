import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../../shared/models/models.dart';
import 'cubit/order_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Active', 'Past', 'Cancelled'];

  List<Order> _filteredOrders(List<Order> orders) {
    final tab = _tabs[_selectedTab];
    if (tab == 'Active') return orders.where((o) => o.status == 'Active').toList();
    if (tab == 'Past') return orders.where((o) => o.status == 'Delivered').toList();
    return orders.where((o) => o.status == 'Cancelled').toList();
  }

  String _formatDate(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month]} ${dt.year} • $hour:$min $ampm';
  }

  Color _statusColor(String status) {
    if (status == 'Cancelled') return AppColors.error;
    if (status == 'Active' || status == 'Delivered') return const Color(0xFF4CAF50);
    return AppColors.primaryGold;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final filtered = _filteredOrders(state.orders);
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orders History',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your journey of royal gastronomic experiences',
                        style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: List.generate(_tabs.length, (i) {
                          final sel = _selectedTab == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedTab = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(right: i < _tabs.length - 1 ? 8 : 0),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: sel ? AppColors.goldGradient : null,
                                color: sel ? null : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                _tabs[i],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: sel ? const Color(0xFF1A0E00) : AppColors.secondaryText,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => _buildOrderCard(filtered[i]),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final itemName = firstItem?.food.name ?? 'Order';
    final extra = order.items.length - 1;
    final displayName = extra > 0 ? '$itemName & $extra more' : itemName;
    final imageUrl = firstItem?.food.imageUrl ?? '';
    final rightBtn = order.status == 'Active'
        ? 'Review'
        : order.status == 'Cancelled'
            ? 'Get Refund'
            : 'Rate Meal';

    return GestureDetector(
      onTap: () => context.push('/order-details', extra: order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDate(order.orderTime),
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                Text(order.status,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(order.status),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl.isNotEmpty
                      ? Image.network(imageUrl,
                          width: 56, height: 56, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imgFallback())
                      : _imgFallback(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('Total: ₹${order.total.toStringAsFixed(0)} • Pay via UPI',
                          style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.background),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(child: _buildBtn('Reorder Pack', () {})),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildBtn(rightBtn, () {
                    if (rightBtn == 'Review') {
                      context.push('/write-review', extra: order);
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildBtn(String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryGold, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGold)),
          ),
        ),
      );

  Widget _imgFallback() => Container(
        width: 56, height: 56,
        decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.restaurant, color: AppColors.muted, size: 24),
      );

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.muted),
            const SizedBox(height: 16),
            Text('No orders here yet',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText)),
            const SizedBox(height: 8),
            Text('Place your first gourmet order!',
                style: TextStyle(fontSize: 14, color: AppColors.secondaryText)),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => context.go('/menu'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(50)),
                child: Text('Order Food Now',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A0E00))),
              ),
            ),
          ],
        ),
      );
}
