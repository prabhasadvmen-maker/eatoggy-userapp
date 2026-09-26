import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';
import '../cubit/subscription_cubit.dart';

class SubscriptionCalendarScreen extends StatefulWidget {
  final Subscription subscription;

  const SubscriptionCalendarScreen({super.key, required this.subscription});

  @override
  State<SubscriptionCalendarScreen> createState() => _SubscriptionCalendarScreenState();
}

class _SubscriptionCalendarScreenState extends State<SubscriptionCalendarScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.subscription.plan;
    final bool isMonthly = plan.durationDays == 30;
    final double totalPrice = isMonthly ? 8499.0 : 2299.0;
    final String formattedPrice = totalPrice.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    // Format schedule text dynamically from active subscription schedule days
    final List<String> scheduleDays = widget.subscription.schedule
        .map((d) {
          switch (d.date.weekday) {
            case DateTime.monday:
              return 'Mon';
            case DateTime.tuesday:
              return 'Tue';
            case DateTime.wednesday:
              return 'Wed';
            case DateTime.thursday:
              return 'Thu';
            case DateTime.friday:
              return 'Fri';
            case DateTime.saturday:
              return 'Sat';
            case DateTime.sunday:
              return 'Sun';
            default:
              return '';
          }
        })
        .toSet()
        .toList();

    // Sort days to look natural
    final List<String> weekOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    scheduleDays.sort((a, b) => weekOrder.indexOf(a).compareTo(weekOrder.indexOf(b)));
    
    final String daysText = scheduleDays.join(' to ');
    final String scheduleText = 'Schedule: $daysText • Lunch Delivery Slot';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              } else {
                context.go('/subscription');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF191714),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1E1C18), width: 1.5),
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.primaryText, size: 18),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Plan',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Finalize your royal meal pass',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Selected Plan Card ───────────────────────────────────────
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
                    Text(
                      'SELECTED PLAN',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${plan.name} (Pure Veg)',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      scheduleText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Shipping Address Card ────────────────────────────────────
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
                    Text(
                      'SHIPPING ADDRESS',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Amrita Shergil Marg, New Delhi',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Pricing Card ─────────────────────────────────────────────
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal Plan Cost',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          '₹$formattedPrice',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GST & Premium Surcharge',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          'Included',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF1E1C18), height: 28, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        Text(
                          '₹$formattedPrice',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // ── Subscribe & Pay Button ────────────────────────────────────
              GestureDetector(
                onTap: _isProcessing
                    ? null
                    : () async {
                        setState(() {
                          _isProcessing = true;
                        });
                        // Simulate UPI payment processing delay
                        await Future.delayed(const Duration(seconds: 1));
                        if (mounted) {
                          context.read<SubscriptionCubit>().activateSubscription(widget.subscription);
                          setState(() {
                            _isProcessing = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Subscription activated successfully!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                          context.go('/my-subscription');
                        }
                      },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: _isProcessing ? null : AppColors.goldGradient,
                    color: _isProcessing ? AppColors.muted : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.background,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Subscribe & Pay via UPI',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A0E00),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
