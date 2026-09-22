import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Authentic Home\nCooked Luxury',
      'description': 'Savor meticulously prepared traditional meals crafted by culinary experts, using heritage recipes and no preservatives.',
      'image': 'assets/o1.png',
    },
    {
      'title': 'Fresh Daily\nCooking',
      'image': 'assets/o2.png',
    },
    {
      'title': 'Seamless Doorstep\nDelivery',
      'description': 'Insulated hot-case delivery system ensures your meal arrives piping hot, exactly at your selected calendar slot.',
      'image': 'assets/o3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentIndex) {
          _pageController.animateToPage(
            state.currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          final currentIndex = state.currentIndex;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                // Top Half: Image & Top Navigation Overlay
                Stack(
                  children: [
                    SizedBox(
                      height: 48.h,
                      width: double.infinity,
                      child: Image.asset(
                        _pages[currentIndex]['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Bottom gradient to blend image into dark background
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 8.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.background.withValues(alpha: 0.6),
                              AppColors.background,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Top Buttons Overlay (Skip/Back)
                    if (currentIndex < 2)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button (Only visible on slide 2)
                            if (currentIndex == 1)
                              GestureDetector(
                                onTap: () {
                                  context.read<OnboardingCubit>().previousPage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Back',
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            
                            // Skip Button
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Skip',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                // Bottom Half: Text Contents & Action Controls
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        // Page Title
                        Text(
                          _pages[currentIndex]['title']!,
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFF1CC8A),
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 2.5.h),
                        
                        // Description / Bullet list depending on the screen
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              context.read<OnboardingCubit>().setPage(index);
                            },
                            itemCount: _pages.length,
                            itemBuilder: (context, index) {
                              if (index == 1) {
                                // Bullet Checklist for Slide 2
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCheckItem("Prepared fresh each morning"),
                                    SizedBox(height: 2.h),
                                    _buildCheckItem("Nutritionist-approved dynamic menus"),
                                    SizedBox(height: 2.h),
                                    _buildCheckItem("Premium farm-sourced organic ingredients"),
                                  ],
                                );
                              } else {
                                // Standard Paragraph Description for Slides 1 and 3
                                return Text(
                                  _pages[index]['description'] ?? '',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFCCCCCC),
                                    fontSize: 15.sp, // font size strictly between 14.sp to 18.sp
                                    height: 1.45,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        
                        // Bottom Buttons & Page Dots Indicators
                        if (currentIndex < 2)
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDotsIndicator(currentIndex),
                                _buildNextButton(context),
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(child: _buildDotsIndicator(currentIndex)),
                                SizedBox(height: 4.h),
                                _buildGetStartedButton(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Bullet point check mark widget helper
  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          color: const Color(0xFFD9A24F),
          size: 18.sp,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFFE5E5E5),
              fontSize: 14.5.sp, // font size strictly between 14.sp to 18.sp
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Dots indicator helper
  Widget _buildDotsIndicator(int currentIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isActive = currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(right: 8),
          width: isActive ? 24 : 8,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive ? const Color(0xFFD9A24F) : const Color(0xFF4A443C),
          ),
        );
      }),
    );
  }

  // Next Button helper
  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<OnboardingCubit>().nextPage();
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF1CC8A),
              Color(0xFFD9A24F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          'Next',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Get Started Button helper
  Widget _buildGetStartedButton() {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF1CC8A),
              Color(0xFFD9A24F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          'Get Started',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
