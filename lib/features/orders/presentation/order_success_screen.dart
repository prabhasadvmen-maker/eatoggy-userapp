import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Scrollable body ────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Gold outlined check circle
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGold,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: AppColors.primaryGold,
                          size: 42,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Title
                    Text(
                      'Order Placed Successfully!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGold,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Subtitle
                    Text(
                      'Your order #${order.id} has been secured and dispatched to the imperial kitchen hub.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Info card ──────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          // Row 1: Estimated Delivery Slot
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estimated Delivery Slot',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  'Today, ${order.eta}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.background,
                          ),

                          // Row 2: Insulated Delivery System
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Insulated Delivery System',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  'Active Hot-Case',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),

            // ── Bottom buttons ─────────────────────────────────────────
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Track Your Order button
                    GestureDetector(
                      onTap: () => context.go('/tracking', extra: order),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD9A24F), Color(0xFFF1CC8A)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Track Your Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A0E00),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF1A0E00),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Back to Gourmet Home
                    GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Text(
                        'Back to Gourmet Home',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Home indicator
                    Container(
                      width: 120,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

