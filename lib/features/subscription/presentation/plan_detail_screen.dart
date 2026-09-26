import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';

class PlanDetailScreen extends StatefulWidget {
  final SubscriptionPlan plan;

  const PlanDetailScreen({super.key, required this.plan});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  String _selectedMealType = 'Pure Vegetarian';

  @override
  Widget build(BuildContext context) {
    final bool isMonthly = widget.plan.durationDays == 30;
    final double totalPrice = isMonthly ? 8499.0 : 2299.0;
    final String subtitleText = isMonthly
        ? '30 Days of bespoke dining'
        : '7 Days of gourmet exploration';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primaryText, size: 28),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.plan.name,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitleText,
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
              // ── Plan Benefits Card ───────────────────────────────────────
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
                      'PLAN BENEFITS',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem('Premium gold-insulated meal delivery'),
                    _buildBenefitItem('Complete meal control - pause anytime'),
                    _buildBenefitItem('Zero delivery charges on all ${widget.plan.totalMeals} meals'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Choose Meal Type Section ─────────────────────────────────
              Text(
                'Choose Meal Type',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMealTypeSelector('Pure Vegetarian'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMealTypeSelector('Non-Veg & Mixed'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Pricing Breakdown Card ───────────────────────────────────
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
                      'PRICING BREAKDOWN',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                          '₹${totalPrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Taxes & Delivery',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          'FREE',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF1E1C18), height: 28, thickness: 1),
                    Text(
                      '*Pause anytime. Unused meals credited back to next cycle.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.muted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // ── Customize Schedule Button ────────────────────────────────
              GestureDetector(
                onTap: () {
                  context.push('/customize-subscription', extra: widget.plan);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Customize Schedule',
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

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓  ',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              benefit,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryText,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSelector(String type) {
    final bool isSelected = _selectedMealType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedMealType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : const Color(0xFF1E1C18),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primaryGold : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
