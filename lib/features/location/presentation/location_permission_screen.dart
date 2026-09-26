import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/custom_widgets.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationBloc(),
      child: const _LocationPermissionView(),
    );
  }
}

class _LocationPermissionView extends StatelessWidget {
  const _LocationPermissionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationSuccess) {
            Helpers.showSuccessSnackbar(
              'Location Detected',
              'Delivering to ${state.address}',
            );
            context.go(AppRoutes.home);
          } else if (state is LocationSkipped) {
            context.go(AppRoutes.home);
          } else if (state is LocationFailure) {
            Helpers.showErrorSnackbar('Location Access', state.message);

            if (state.isServiceDisabled) {
              context.read<LocationBloc>().add(const OpenLocationSettingsEvent());
            } else if (state.isPermissionPermanentlyDenied) {
              context.read<LocationBloc>().add(const OpenAppSettingsEvent());
            }
          }
        },
        builder: (context, state) {
          final bool isLoading = state is LocationLoading;
          final String loadingMessage =
              state is LocationLoading ? state.message : '';

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Center Graphic: Radial Gold Glow & Location Pin Icon
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

                  // Title
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

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      isLoading && loadingMessage.isNotEmpty
                          ? loadingMessage
                          : 'To discover premium kitchen hub slots near you and ensure flawless gourmet delivery scheduling.',
                      style: GoogleFonts.inter(
                        color: isLoading
                            ? const Color(0xFFD9A24F)
                            : const Color(0xFF8E8A82),
                        fontSize: 14.5.sp,
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(),

                  // Primary Button: Allow Location Access
                  PrimaryGoldButton(
                    text: 'Allow Location Access',
                    isLoading: isLoading,
                    onPressed: () {
                      context
                          .read<LocationBloc>()
                          .add(const RequestCurrentLocationEvent());
                    },
                  ),
                  SizedBox(height: 2.h),

                  // Secondary Button: Enter Location Manually
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                            context
                                .read<LocationBloc>()
                                .add(const SkipLocationEvent());
                          },
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
          );
        },
      ),
    );
  }
}
