import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/profile_bloc.dart';
import '../data/repositories/profile_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        profileRepository: ProfileRepositoryImpl(),
      )..add(const FetchProfileEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'My Profile',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGold,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGold,
                ),
              );
            }

            if (state is ProfileFailure) {
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
                          context.read<ProfileBloc>().add(const FetchProfileEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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

            final customer = (state is ProfileLoaded) ? state.customer : null;
            final mobile = customer?.mobile ?? '';
            final role = customer?.role ?? 'Customer';
            final isVerified = customer?.isMobileVerified ?? false;

            return RefreshIndicator(
              color: AppColors.primaryGold,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<ProfileBloc>().add(const RefreshProfileEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      // ── Profile Header Section ─────────────────────────────────────
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryGold, width: 2.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1607990283143-e81e7a2c93ab?fit=crop&w=300&h=300',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mobile.isNotEmpty ? '+91 $mobile' : 'Customer Profile',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isVerified ? Icons.verified : Icons.phone_android,
                            color: isVerified ? Colors.green : AppColors.secondaryText,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isVerified ? 'Verified Customer' : 'Registered Mobile',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isVerified ? Colors.green : AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryGold, width: 1.2),
                        ),
                        child: Text(
                          '${role.toUpperCase()} MEMBER',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Profile Menu List ──────────────────────────────────────────
                      _buildMenuCard(
                        context: context,
                        title: 'My Orders',
                        icon: Icons.history,
                        trailingText: '3 Active',
                        onTap: () => context.go(AppRoutes.orders),
                      ),
                      _buildMenuCard(
                        context: context,
                        title: 'My Subscription',
                        icon: Icons.calendar_month,
                        trailingText: 'Active',
                        onTap: () => context.push(AppRoutes.mySubscription),
                      ),
                      _buildMenuCard(
                        context: context,
                        title: 'Saved Addresses',
                        icon: Icons.location_on,
                        onTap: () => context.push(AppRoutes.savedAddresses),
                      ),
                      _buildMenuCard(
                        context: context,
                        title: 'Help & Support',
                        icon: Icons.help_outline,
                        onTap: () => context.push(AppRoutes.support),
                      ),
                      _buildMenuCard(
                        context: context,
                        title: 'Settings',
                        icon: Icons.settings,
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
        ),
        child: Row(
          children: [
            // Circular Icon Background
            Container(
              width: 40,
              height: 40,
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

            // Title
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

            // Optional Trailing Text & Chevron
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(width: 8),
            ],
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
}
