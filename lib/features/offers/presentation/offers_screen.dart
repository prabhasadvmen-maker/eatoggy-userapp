import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';
import '../../cart/cubit/cart_cubit.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final TextEditingController _couponController = TextEditingController();
  String? _errorMessage;

  // Custom premium mockup coupons
  static const Coupon _royalTreat = Coupon(
    code: 'ROYALTREAT50',
    discountPercent: 14.33, // 14.33% of 349 is approx 50.00 saved
    maxDiscount: 50,
    minOrderValue: 100,
    description: 'Flat ₹50 saved on your current box.',
    expiryDate: 'Expires in 5 days',
  );

  static const Coupon _festive60 = Coupon(
    code: 'FESTIVE60',
    discountPercent: 60,
    maxDiscount: 150,
    minOrderValue: 499,
    description: 'Get 60% off up to ₹150 on luxury weekly subscriptions. Valid once per user.',
    expiryDate: 'Expires in 3 days',
  );

  static const Coupon _freeDeluxe = Coupon(
    code: 'FREEDELUXE',
    discountPercent: 11.46, // ~40.00 saved on 349 subtotal
    maxDiscount: 40,
    minOrderValue: 0,
    description: 'Free delivery on all premium bespoke gourmet boxes over Delhi NCR.',
    expiryDate: 'Expires in 7 days',
  );

  final List<Coupon> _mockCoupons = [_festive60, _freeDeluxe];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCustomCoupon(Coupon coupon, CartState cartState) {
    if (cartState.subtotal < coupon.minOrderValue) {
      setState(() {
        _errorMessage = 'Min. Order Value of ₹${coupon.minOrderValue.toInt()} is required!';
      });
      return;
    }
    context.read<CartCubit>().applyCoupon(coupon);
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            final appliedCoupon = cartState.appliedCoupon;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // 1. Header with back button
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF161614),
                        radius: 20.sp,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFFD9A24F), size: 14.sp),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Offers & Coupons',
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xFFF1CC8A),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // 2. Coupon input area
                  Text(
                    'APPLY COUPON CODE',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFD9A24F),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6.5.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF161614),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF2C2721), width: 1.2),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: _couponController,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter coupon code',
                              hintStyle: GoogleFonts.inter(
                                color: const Color(0xFF8E8A82),
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      GestureDetector(
                        onTap: () {
                          final text = _couponController.text.trim().toUpperCase();
                          if (text.isEmpty) return;
                          
                          if (text == 'ROYALTREAT50') {
                            _applyCustomCoupon(_royalTreat, cartState);
                          } else if (text == 'FESTIVE60') {
                            _applyCustomCoupon(_festive60, cartState);
                          } else if (text == 'FREEDELUXE') {
                            _applyCustomCoupon(_freeDeluxe, cartState);
                          } else {
                            setState(() {
                              _errorMessage = 'Invalid coupon code!';
                            });
                          }
                        },
                        child: Container(
                          height: 6.5.h,
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'APPLY',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Applied Success alert box
                  if (appliedCoupon != null) ...[
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2016),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E3F2B), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: const Color(0xFF4CAF50),
                            size: 16.sp,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              '${appliedCoupon.code} applied! ₹${cartState.discountAmount.toInt()} saved on your current box.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF4CAF50),
                                fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF44336),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  SizedBox(height: 2.h),

                  // 3. Available Coupons Section
                  Text(
                    'Available Coupons',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _mockCoupons.length,
                      itemBuilder: (context, index) {
                        final coupon = _mockCoupons[index];
                        final isThisApplied = appliedCoupon?.code == coupon.code;
                        final isFestive = coupon.code == 'FESTIVE60';

                        return Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161614),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF2C2721),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Badge
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isFestive
                                          ? const Color(0x3BFF3333)
                                          : const Color(0x3BD9A24F),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                                    child: Text(
                                      isFestive ? '60% OFF' : 'FREE DELIVERY',
                                      style: GoogleFonts.inter(
                                        color: isFestive
                                            ? const Color(0xFFFF5252)
                                            : const Color(0xFFD9A24F),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Apply/Applied button
                                  GestureDetector(
                                    onTap: () => _applyCustomCoupon(coupon, cartState),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2C2721),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                                      child: Text(
                                        isThisApplied ? 'Applied' : 'Apply',
                                        style: GoogleFonts.inter(
                                          color: isThisApplied
                                              ? const Color(0xFF4CAF50)
                                              : const Color(0xFFD9A24F),
                                          fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.5.h),
                              
                              // Coupon Code Title
                              Text(
                                coupon.code,
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 16.sp, // Strictly between 14.sp to 18.sp
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1.2.h),

                              // Description
                              Text(
                                coupon.description,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF8E8A82),
                                  fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                                  height: 1.35,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              
                              const Divider(color: Color(0xFF2C2721), height: 1),
                              SizedBox(height: 1.5.h),

                              // Details Footer Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Min. Order: ₹${coupon.minOrderValue.toInt()}',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF8E8A82),
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  Text(
                                    coupon.expiryDate,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFD9A24F),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
