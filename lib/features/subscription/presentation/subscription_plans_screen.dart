import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/subscription_plans_bloc.dart';
import '../data/repositories/subscription_repository.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionPlansBloc>(
      create: (context) => SubscriptionPlansBloc(
        subscriptionRepository: SubscriptionRepositoryImpl(),
      )..add(const FetchSubscriptionPlansEvent()),
      child: const _SubscriptionPlansView(),
    );
  }
}

class _SubscriptionPlansView extends StatefulWidget {
  const _SubscriptionPlansView();

  @override
  State<_SubscriptionPlansView> createState() => _SubscriptionPlansViewState();
}

class _SubscriptionPlansViewState extends State<_SubscriptionPlansView> {
  String? _selectedPlanId;

  String _formatPrice(double price) {
    final intPrice = price.round();
    return intPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
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
      body: BlocConsumer<SubscriptionPlansBloc, SubscriptionPlansState>(
        listener: (context, state) {
          if (state is SubscriptionPlansLoaded && state.plans.isNotEmpty) {
            if (_selectedPlanId == null ||
                !state.plans.any((p) => p.id == _selectedPlanId)) {
              setState(() {
                _selectedPlanId = state.plans.first.id;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is SubscriptionPlansLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            );
          }

          if (state is SubscriptionPlansFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 40.sp,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<SubscriptionPlansBloc>()
                            .add(const FetchSubscriptionPlansEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SubscriptionPlansLoaded) {
            final plans = state.plans;

            if (plans.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primaryGold,
                backgroundColor: AppColors.surface,
                onRefresh: () async {
                  context
                      .read<SubscriptionPlansBloc>()
                      .add(const RefreshSubscriptionPlansEvent());
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 25.h),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lunch_dining_outlined,
                            size: 48.sp,
                            color: AppColors.muted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No meal plans available at the moment.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pull down to refresh',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryGold,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context
                    .read<SubscriptionPlansBloc>()
                    .add(const RefreshSubscriptionPlansEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Effortless luxury meals, delivered daily',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...plans.map((plan) {
                      final bool isSelected = _selectedPlanId == plan.id;
                      final bool isMonthlyOrExtended =
                          plan.planDurationDays >= 14;
                      final String periodLabel =
                          plan.planDurationDays > 0
                              ? '/${plan.planDurationDays} days'
                              : '/plan';
                      final String subtitleText = plan.description.isNotEmpty
                          ? plan.description
                          : '${plan.planDurationDays} Days Gourmet Subscription';

                      return GestureDetector(
                        onTap: () => setState(() => _selectedPlanId = plan.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGold
                                  : const Color(0xFF1E1C18),
                              width: isSelected ? 1.2 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  if (isMonthlyOrExtended)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.primaryGold,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Text(
                                        'POPULAR • ${plan.planDurationDays} DAYS',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryGold,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F2618),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${plan.planDurationDays} DAYS TRIAL',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                subtitleText,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryText,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '₹${_formatPrice(plan.totalPrice)}',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryGold,
                                        ),
                                      ),
                                      Text(
                                        periodLabel,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹${plan.pricePerMeal.toStringAsFixed(0)} per meal',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                              if (plan.items.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                Text(
                                  'INCLUDES',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.muted,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...plan.items.map((item) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 6.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• ',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: AppColors.primaryGold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${item.quantity}x ${item.name}',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: AppColors.primaryText,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  final subscriptionPlan =
                                      plan.toSubscriptionPlan();
                                  if (isMonthlyOrExtended) {
                                    context.push(
                                      '/customize-subscription',
                                      extra: subscriptionPlan,
                                    );
                                  } else {
                                    context.push(
                                      '/plan-detail',
                                      extra: subscriptionPlan,
                                    );
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.goldGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isMonthlyOrExtended
                                          ? 'Customize & Subscribe'
                                          : 'View Plan Details',
                                      style: TextStyle(
                                        fontSize: 14.sp,
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
                    }),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
