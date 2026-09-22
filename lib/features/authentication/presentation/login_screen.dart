import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.requiresOtp && state.phoneNumber != null) {
              context.go('/otp', extra: state.phoneNumber);
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.error,
                  content: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        // Top Centered Logo
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 42.w,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        
                        // Welcome Header
                        Text(
                          'Welcome to EATOGGY',
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFF1CC8A),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        
                        // Subtitle
                        Text(
                          'Enter your mobile number to unlock luxurious\nhome-cooked dining',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8E8A82),
                            fontSize: 14.5.sp, // font size strictly between 14.sp to 18.sp
                            height: 1.45,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        
                        // Input Label
                        Text(
                          'MOBILE NUMBER',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFD9A24F),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        
                        // Phone Input Field Box
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF161614),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF2C2721),
                              width: 1.5,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                          child: Row(
                            children: [
                              Text(
                                '🇮🇳 +91',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Container(
                                width: 1.5,
                                height: 24,
                                color: const Color(0xFF4A443C),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (val) {
                                    setState(() {}); // Rebuild to update continue button visibility
                                  },
                                  maxLength: 10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: "",
                                    hintText: 'Enter 10-digit number',
                                    hintStyle: GoogleFonts.inter(
                                      color: const Color(0xFF66625C),
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Continue Button (Visible only when valid input is present)
                        AnimatedOpacity(
                          opacity: _phoneController.text.length == 10 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          child: _phoneController.text.length == 10
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 2.h),
                                  child: PrimaryGoldButton(
                                    text: 'Continue',
                                    isLoading: state.isLoading,
                                    onPressed: () {
                                      context.read<AuthCubit>().sendOtp(_phoneController.text);
                                    },
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        
                        // Footer Disclaimer & Terms of Service Link
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Column(
                              children: [
                                Text(
                                  'By continuing, you agree to our',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF77736D),
                                    fontSize: 11.sp,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    // Action for terms of service
                                  },
                                  child: Text(
                                    'Terms of Service & Privacy Policy',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFD9A24F),
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
