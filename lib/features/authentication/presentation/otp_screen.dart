import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../widgets/custom_widgets.dart';
import '../bloc/otp_bloc.dart';
import '../data/repositories/auth_repository.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 45;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpBloc>(
      create: (context) => OtpBloc(authRepository: AuthRepositoryImpl()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              if (state is OtpVerificationSuccess) {
                Helpers.showSuccessSnackbar('Success', state.message);
                context.go(AppRoutes.locationPermission);
              } else if (state is OtpFailure) {
                Helpers.showErrorSnackbar('Error', state.error);
              } else if (state is OtpResentSuccess) {
                Helpers.showSuccessSnackbar('Success', state.message);
                setState(() {
                  _secondsRemaining = 45;
                });
                _startTimer();
              }
            },
            builder: (context, state) {
              final isLoading = state is OtpLoading;
              final minutes = (_secondsRemaining ~/ 60).toString();
              final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
              final timeText = "$minutes:$seconds";

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Title
                    Text(
                      'Verify Code',
                      style: GoogleFonts.playfairDisplay(
                        color: const Color(0xFFF1CC8A),
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Subtitle
                    RichText(
                      text: TextSpan(
                        text: 'We have sent a 6-digit verification code to ',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8E8A82),
                          fontSize: 14.5.sp,
                          height: 1.45,
                        ),
                        children: [
                          TextSpan(
                            text: '+91 ${widget.phoneNumber}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Styled 6-digit OTP Inputs
                    OtpInputWidget(
                      controller: _otpController,
                      length: 6,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Timer / Resend Indicator
                    Center(
                      child: _secondsRemaining > 0
                          ? RichText(
                              text: TextSpan(
                                text: 'Resend code in ',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF77736D),
                                  fontSize: 11.5.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: timeText,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFD9A24F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.5.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      context.read<OtpBloc>().add(
                                        ResendOtpEvent(
                                          mobile: widget.phoneNumber,
                                        ),
                                      );
                                    },
                              child: Text(
                                'Resend Code',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFD9A24F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 2.h),

                    // Change mobile link
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: Text(
                          'Change Mobile Number',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8E8A82),
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Verify & Proceed Action Button
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: PrimaryGoldButton(
                        text: 'Verify & Proceed',
                        isLoading: isLoading,
                        onPressed: _otpController.text.length == 6
                            ? () {
                                context.read<OtpBloc>().add(
                                  VerifyOtpSubmitEvent(
                                    mobile: widget.phoneNumber,
                                    otp: _otpController.text,
                                  ),
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Custom OTP Input Layout with Blinking Caret Support
class OtpInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final int length;
  final ValueChanged<String> onChanged;

  const OtpInputWidget({
    super.key,
    required this.controller,
    this.length = 6,
    required this.onChanged,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Stack(
        children: [
          // Hidden input field for native processing
          Opacity(
            opacity: 0.0,
            child: SizedBox(
              height: 1,
              width: 1,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: widget.length,
                onChanged: widget.onChanged,
                showCursor: false,
                decoration: const InputDecoration(
                  counterText: "",
                ),
              ),
            ),
          ),

          // Row of styled verification code boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (index) {
              final text = widget.controller.text;
              final hasChar = index < text.length;
              final char = hasChar ? text[index] : "";
              final isFocused = _focusNode.hasFocus && text.length == index;

              final boxWidth = widget.length == 6 ? 12.8.w : 18.w;
              final boxHeight = widget.length == 6 ? 14.w : 18.w;
              final fontSize = widget.length == 6 ? 18.sp : 22.sp;

              return Container(
                width: boxWidth,
                height: boxHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF161614),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFFD9A24F)
                        : const Color(0xFF2C2721),
                    width: isFocused ? 2.0 : 1.5,
                  ),
                ),
                child: Center(
                  child: isFocused
                      ? const BlinkingCursor()
                      : Text(
                          char,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Dynamic Blinking Line Caret Indicator
class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2.0,
        height: 24.0,
        color: const Color(0xFFD9A24F),
      ),
    );
  }
}
