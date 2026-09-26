import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Determine status text and color
    final bool isPreparing = order.status == 'Active' &&
        DateTime.now().difference(order.orderTime).inMinutes < 10;
    
    final String statusText = order.status == 'Active'
        ? (isPreparing ? 'Preparing' : 'Out for Delivery')
        : order.status;

    final Color statusColor = statusText == 'Cancelled'
        ? AppColors.error
        : (statusText == 'Preparing' || statusText == 'Delivered')
            ? AppColors.success
            : AppColors.primaryGold;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Main Card (Order Info & Status) ──────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORDER ID',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.secondaryText,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '#${order.id}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: statusColor, width: 1.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Items list in card
                    ...order.items.map((item) {
                      final isLast = order.items.indexOf(item) == order.items.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: item.food.imageUrl.isNotEmpty
                                  ? Image.network(
                                      item.food.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _imgFallback(),
                                    )
                                  : _imgFallback(),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: item.food.isVeg ? Colors.green : Colors.red,
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: item.food.isVeg ? Colors.green : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item.food.name,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryText,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Qty: ${item.quantity} • Insulated Box Delivery',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryGold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    // Active order Countdown & Tracking
                    if (order.status == 'Active') ...[
                      const Divider(color: Color(0xFF1E1C18), height: 32, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ETA Countdown',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          Text(
                            '${order.eta.toLowerCase().contains('min') ? order.eta : '${order.eta} remaining'}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 6,
                          backgroundColor: Color(0xFF11110F),
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => context.push('/tracking', extra: order),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGold.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Track Live Order',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A0E00),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Delivery Address Card ────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${order.address.name} (${order.address.type})',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.address.flatHouse}, ${order.address.street}, ${order.address.city} - ${order.address.pincode}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Bill Details Card ────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_outlined, color: AppColors.primaryGold, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Receipt Breakdown',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBreakdownRow('Subtotal', '₹${order.subtotal.toStringAsFixed(0)}'),
                    _buildBreakdownRow('Discount', '-₹${order.discount.toStringAsFixed(0)}', isDiscount: true),
                    _buildBreakdownRow('Delivery Fee', '₹${order.deliveryFee.toStringAsFixed(0)}'),
                    const Divider(color: Color(0xFF1E1C18), height: 24, thickness: 1),
                    _buildBreakdownRow('Total Amount', '₹${order.total.toStringAsFixed(0)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgFallback() => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.restaurant, color: AppColors.muted, size: 24),
      );

  Widget _buildBreakdownRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15.sp : 14.sp,
              color: isTotal ? AppColors.primaryText : AppColors.secondaryText,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              color: isDiscount
                  ? AppColors.success
                  : (isTotal ? AppColors.primaryGold : AppColors.primaryText),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
