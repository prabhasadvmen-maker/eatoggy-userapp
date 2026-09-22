import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/subscription_cubit.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  String? _selectedPlanId;

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().loadPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Royal Meal Plans',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: AppColors.primaryGold),
            onPressed: () => context.push('/my-subscription'),
          ),
        ],
      ),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
          }
          if (state.plans.isEmpty) {
            return Center(
              child: Text(
                'No plans loaded.',
                style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
              ),
            );
          }

          if (_selectedPlanId == null && state.plans.isNotEmpty) {
            final recPlan = state.plans.firstWhere((p) => p.isRecommended, orElse: () => state.plans.first);
            _selectedPlanId = recPlan.id;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Royal Meal Plans',
                  //   style: TextStyle(
                  //     fontFamily: 'Georgia',
                  //     fontSize: 18.sp,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.primaryGold,
                  //   ),
                  // ),
                  
                  const SizedBox(height: 4),
                  Text(
                    'Effortless luxury meals, delivered daily',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...state.plans.map((plan) {
                    final bool isMonthly = plan.durationDays == 30;
                    final bool isSelected = _selectedPlanId == plan.id;
                    final int totalPrice = isMonthly ? 8499 : 2299;
                    final String periodLabel = isMonthly ? '/month' : '/week';
                    final String subtitleText = isMonthly
                        ? '30 Days Culinary Journey'
                        : '7 Days Trial Subscription';
                    
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPlanId = plan.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGold : const Color(0xFF1E1C18),
                            width: isSelected ? 1.2 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  plan.name,
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ),
                              if (isMonthly)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.primaryGold, width: 1.0),
                                  ),
                                  child: Text(
                                    'POPULAR • SAVE 30%',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryGold,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F2618),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'SAVE 15%',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitleText,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '₹${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryGold,
                                    ),
                                  ),
                                  Text(
                                    periodLabel,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '₹${plan.pricePerMeal.toStringAsFixed(0)} per elite meal',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'INCLUDES',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.muted,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...plan.benefits.map((benefit) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '• ',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primaryText,
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
                          }).toList(),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              if (isMonthly) {
                                context.push('/customize-subscription', extra: plan);
                              } else {
                                context.push('/plan-detail', extra: plan);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  isMonthly ? 'Customize & Subscribe' : 'View Plan Details',
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
                      ),
                    ),
                  );
                }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
