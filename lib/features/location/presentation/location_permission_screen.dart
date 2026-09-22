import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_widgets.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Center Graphic: Circle with Radial Gold Glow & Location Pin
              Center(
                child: Container(
                  width: 54.w,
                  height: 54.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.8,
                      colors: [
                        Color(0x22D9A24F), // Soft gold glow
                        Colors.transparent,
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF161614),
                        border: Border.all(
                          color: const Color(0xFF2C2721),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.location_on_outlined,
                          color: const Color(0xFFD9A24F),
                          size: 14.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              
              // Screen Title
              Text(
                'Enable Location Services',
                style: GoogleFonts.playfairDisplay(
                  color: const Color(0xFFF1CC8A),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              
              // Screen Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  'To discover premium kitchen hub slots near you and ensure flawless gourmet delivery scheduling.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8E8A82),
                    fontSize: 14.5.sp, // Font size strictly between 14.sp to 18.sp
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(),
              
              // Allow Location Access Button (Primary Gold)
              PrimaryGoldButton(
                text: 'Allow Location Access',
                onPressed: () => context.go('/select-location'),
              ),
              SizedBox(height: 2.h),
              
              // Enter Location Manually Button (Outlined Gold)
              GestureDetector(
                onTap: () => context.go('/add-address'),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFD9A24F),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    'Enter Location Manually',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFD9A24F),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
