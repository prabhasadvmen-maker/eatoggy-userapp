import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';
import '../../../core/network/app_repository.dart';

class CustomizeSubscriptionScreen extends StatefulWidget {
  final SubscriptionPlan plan;

  const CustomizeSubscriptionScreen({super.key, required this.plan});

  @override
  State<CustomizeSubscriptionScreen> createState() => _CustomizeSubscriptionScreenState();
}

class _CustomizeSubscriptionScreenState extends State<CustomizeSubscriptionScreen> {
  final List<String> _daysLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _daysValues = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  String _selectedTimeSlot = 'Lunch Box';
  final TextEditingController _allergiesController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'Customize Box',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tailor your daily meal calendar',
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
              // ── Select Delivery Days ─────────────────────────────────────
              Text(
                'Select Delivery Days',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final String label = _daysLabels[index];
                  final String value = _daysValues[index];
                  final bool isSelected = _selectedDays.contains(value);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          if (_selectedDays.length > 3) {
                            _selectedDays.remove(value);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select at least 3 delivery days.')),
                            );
                          }
                        } else {
                          _selectedDays.add(value);
                        }
                      });
                    },
                    child: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryGold : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : const Color(0xFF1E1C18),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF1A0E00) : AppColors.primaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // ── Preferred Time Slot ──────────────────────────────────────
              Text(
                'Preferred Time Slot',
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
                    child: _buildTimeSlotCard(
                      title: 'Lunch Box',
                      deliveryTime: 'Delivered: 12:00 PM - 1:30 PM',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTimeSlotCard(
                      title: 'Dinner Box',
                      deliveryTime: 'Delivered: 7:30 PM - 9:00 PM',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Allergies & Dietary Notes ─────────────────────────────────
              Text(
                'Allergies & Dietary Notes',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _allergiesController,
                maxLines: 3,
                style: TextStyle(fontSize: 14.sp, color: AppColors.primaryText),
                decoration: InputDecoration(
                  hintText: 'E.g., No peanuts, moderate spice levels only...',
                  hintStyle: TextStyle(color: AppColors.muted, fontSize: 14.sp),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E1C18)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 48),

              // ── Submit Button ─────────────────────────────────────────────
              GestureDetector(
                onTap: _isProcessing
                    ? null
                    : () async {
                        setState(() {
                          _isProcessing = true;
                        });
                        final repo = MockAppRepository();
                        final sub = await repo.subscribeToPlan(widget.plan, _selectedDays, 1);
                        if (mounted) {
                          setState(() {
                            _isProcessing = false;
                          });
                          context.push('/subscription-calendar', extra: sub);
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
                            'Review Subscription Box',
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

  Widget _buildTimeSlotCard({required String title, required String deliveryTime}) {
    final bool isSelected = _selectedTimeSlot == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeSlot = title),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : const Color(0xFF1E1C18),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              deliveryTime,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondaryText,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
