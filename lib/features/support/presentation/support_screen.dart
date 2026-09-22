import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final SupportTicket _recentOrderTicket = SupportTicket(
    id: 'EAT-88902',
    issue: 'Need help with order #EAT-88902',
    status: 'Open',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    messages: const [
      {'sender': 'User', 'text': 'My delivery was marked as delivered but packaging was damaged.'},
      {'sender': 'Support', 'text': 'Apologies! We are connecting you with a representative to inspect the parcel packaging details.'},
    ],
  );

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
                context.go('/profile');
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
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGold,
          ),
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
              // ── Recent Order Assistance ──────────────────────────────────
              Text(
                'Recent Order Assistance',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push('/ticket-detail', extra: _recentOrderTicket),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need help with order #EAT-88902?',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap to raise issue • Delivered 12 Oct',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.primaryGold,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── FAQ Categories ───────────────────────────────────────────
              Text(
                'FAQ Categories',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              _buildFAQCard(
                title: 'Order Issues',
                icon: Icons.shopping_bag_outlined,
              ),
              _buildFAQCard(
                title: 'Payment & Refund',
                icon: Icons.payment_outlined,
              ),
              _buildFAQCard(
                title: 'Subscription Inquiries',
                icon: Icons.calendar_month_outlined,
              ),
              _buildFAQCard(
                title: 'Delivery Partners',
                icon: Icons.local_shipping_outlined,
              ),
              _buildFAQCard(
                title: 'Account Settings',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 28),

              // ── Contact Us Directly ───────────────────────────────────────
              Text(
                'Contact Us Directly',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      title: 'Chat Support',
                      icon: Icons.chat_bubble_outline,
                      message: 'Connecting to Live Chat...',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildContactCard(
                      title: 'Call Helpline',
                      icon: Icons.phone_outlined,
                      message: 'Calling helpline +1 (800) 9876...',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard({required String title, required IconData icon}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('FAQ topic: "$title" details coming soon!')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1C18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({required String title, required IconData icon, required String message}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.primaryGold,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E1C18), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primaryGold,
              size: 26,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
