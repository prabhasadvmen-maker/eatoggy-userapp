import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../cubit/cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_basket_outlined,
                        size: 60.sp,
                        color: const Color(0xFF8E8A82),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Your Box is Empty',
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xFFF1CC8A),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Text(
                        'Add delicious home-cooked meals to your box.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8E8A82),
                          fontSize: 14.5.sp, // Strictly between 14.sp to 18.sp
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: () => context.go('/menu'),
                        child: Container(
                          width: 50.w,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Explore Menu',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Calculations based on mockup details
            final double subtotal = state.subtotal;
            const double deliveryFee = 40.0;
            final double surchargeTaxes = subtotal * 0.0528; // Dynamic ratio matching ~18.45 for 349 subtotal
            final double discount = state.discountAmount;
            final double grandTotal = subtotal + deliveryFee + surchargeTaxes - discount;

            return Stack(
              children: [
                // Scrollable content area
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        
                        // Title
                        Text(
                          'Your Box',
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFF1CC8A),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Cart Items List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              padding: EdgeInsets.all(3.5.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161614),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF2C2721),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Left Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: item.food.imageUrl.startsWith('assets/')
                                        ? Image.asset(item.food.imageUrl, width: 16.w, height: 16.w, fit: BoxFit.cover)
                                        : Image.network(item.food.imageUrl, width: 16.w, height: 16.w, fit: BoxFit.cover),
                                  ),
                                  SizedBox(width: 4.w),
                                  
                                  // Right details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.food.name,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 0.4.h),
                                        Text(
                                          item.food.description,
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF8E8A82),
                                            fontSize: 13.5.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 1.2.h),
                                        
                                        // Price + Qty Selector Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₹${item.food.price.toInt()}',
                                              style: GoogleFonts.outfit(
                                                color: const Color(0xFFD9A24F),
                                                fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Capsule Quantity selector
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1E1C1A),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: const Color(0xFF2C2721)),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    constraints: const BoxConstraints(),
                                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                                    icon: Icon(Icons.remove, color: const Color(0xFF8E8A82), size: 13.sp),
                                                    onPressed: () {
                                                      context.read<CartCubit>().updateQuantity(item.food, item.quantity - 1);
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                                                    child: Text(
                                                      '${item.quantity}',
                                                      style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    constraints: const BoxConstraints(),
                                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                                    icon: Icon(Icons.add, color: const Color(0xFF8E8A82), size: 13.sp),
                                                    onPressed: () {
                                                      context.read<CartCubit>().updateQuantity(item.food, item.quantity + 1);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 2.h),

                        // Check Offer / Apply Coupon
                        GestureDetector(
                          onTap: () => context.push('/offers'),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 1.8.h),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD9A24F),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              state.appliedCoupon != null
                                  ? 'Coupon Applied: ${state.appliedCoupon!.code}'
                                  : 'Check Offer',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFD9A24F),
                                fontSize: 14.5.sp, // Strictly between 14.sp to 18.sp
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                       
                        SizedBox(height: 4.h),

                        // Luxury Bill Summary Headers
                        Text(
                          'LUXURY BILL SUMMARY',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFD9A24F),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 2.h),

                        // Pricing invoice breakdown
                        _buildSummaryItem('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
                        if (discount > 0)
                          _buildSummaryItem('Discount Applied', '-₹${discount.toStringAsFixed(2)}', isDiscount: true),
                        _buildSummaryItem('Insulated Hot-Case Delivery', '₹${deliveryFee.toStringAsFixed(2)}'),
                        _buildSummaryItem('Surcharge & Taxes', '₹${surchargeTaxes.toStringAsFixed(2)}'),
                        
                        SizedBox(height: 1.5.h),
                        const Divider(color: Color(0xFF2C2721), height: 1),
                        SizedBox(height: 1.5.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16.sp, // Strictly between 14.sp to 18.sp
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${grandTotal.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD9A24F),
                                fontSize: 16.sp, // Strictly between 14.sp to 18.sp
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h), // Spacing for bottom bar overlay
                      ],
                    ),
                  ),
                ),

                // Bottom Checkout Button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: const Color(0xFF11110F),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        child: GestureDetector(
                          onTap: () => context.push('/checkout'),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 1.8.h),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Proceed to Checkout',
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 15.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  // Helper invoice item row
  Widget _buildSummaryItem(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF8E8A82),
              fontSize: 14.sp, // Strictly between 14.sp to 18.sp
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: isDiscount ? const Color(0xFF4CAF50) : Colors.white,
              fontSize: 14.sp, // Strictly between 14.sp to 18.sp
            ),
          ),
        ],
      ),
    );
  }}
