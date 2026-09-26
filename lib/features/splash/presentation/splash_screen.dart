import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToHome) {
          context.go(AppRoutes.home);
        } else if (state is SplashNavigateToOnboarding) {
          context.go(AppRoutes.onboarding);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Container(
                color: AppColors.background,
              ),
            ),
            // Centered Radial Glow
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.9,
                    colors: [
                      Color(0x22D9A24F), // Subtle gold glow
                      Colors.transparent,
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 58.w,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 58.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFD9A24F),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: const Color(0xFFD9A24F),
                                  size: 6.w,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Bottom Subtitle & Tagline
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 18.h),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'FEASTBOX',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFD9A24F),
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 1.5.h),
                            SizedBox(
                              width: 16.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                                child: const LinearProgressIndicator(
                                  color: Color(0xFFD9A24F),
                                  backgroundColor: Color(0xFF2A231A),
                                  minHeight: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
