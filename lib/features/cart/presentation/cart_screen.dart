import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/theme/app_colors.dart';
import '../cubit/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().fetchCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            // -----------------------------
            // Loading State
            // -----------------------------
            if (state.isLoading && state.items.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGold,
                ),
              );
            }

            // -----------------------------
            // Empty Cart State
            // -----------------------------
            if (state.items.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primaryGold,
                backgroundColor: const Color(0xFF161614),
                onRefresh: () {
                  return context.read<CartCubit>().fetchCart();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 80.h,
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
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8E8A82),
                              fontSize: 14.5.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          GestureDetector(
                            onTap: () {
                              context.go('/menu');
                            },
                            child: Container(
                              width: 50.w,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
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
                  ),
                ),
              );
            }

            // -----------------------------
            // Bill Calculations
            // -----------------------------
            final double subtotal = state.subtotal;
            final double discount = state.discountAmount;

            final double grandTotal = subtotal - discount;

            return RefreshIndicator(
              color: AppColors.primaryGold,
              backgroundColor: const Color(0xFF161614),
              onRefresh: () {
                return context.read<CartCubit>().fetchCart();
              },
              child: Stack(
                children: [
                  // =========================================================
                  // SCROLLABLE CONTENT
                  // =========================================================
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      top: 2.h,
                      bottom: 22.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -----------------------------
                        // Title
                        // -----------------------------
                        Text(
                          'Your Box',
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFF1CC8A),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // =================================================
                        // CART ITEMS
                        // =================================================
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // -----------------------------
                                  // Food Image
                                  // -----------------------------
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: _buildFoodImage(item),
                                  ),

                                  SizedBox(width: 4.w),

                                  // -----------------------------
                                  // Food Details
                                  // -----------------------------
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.food.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                context
                                                    .read<CartCubit>()
                                                    .removeFromCart(item);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 2.w),
                                                child: Icon(
                                                  Icons.close,
                                                  color: const Color(0xFF8E8A82),
                                                  size: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 0.4.h),

                                        Text(
                                          item.food.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF8E8A82),
                                            fontSize: 13.5.sp,
                                          ),
                                        ),

                                        SizedBox(height: 1.2.h),

                                        // -----------------------------
                                        // Price + Quantity
                                        // -----------------------------
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₹${item.food.price.toInt()}',
                                              style: GoogleFonts.outfit(
                                                color: const Color(0xFFD9A24F),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            // Quantity Selector
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1E1C1A),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF2C2721),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    constraints:
                                                        const BoxConstraints(),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 2.w,
                                                      vertical: 0.5.h,
                                                    ),
                                                    icon: Icon(
                                                      item.quantity == 1
                                                          ? Icons.delete_outline
                                                          : Icons.remove,
                                                      color: item.quantity == 1
                                                          ? const Color(0xFFE57373)
                                                          : const Color(
                                                              0xFF8E8A82,
                                                            ),
                                                      size: 13.sp,
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<CartCubit>()
                                                          .updateQuantity(
                                                            item,
                                                            item.quantity - 1,
                                                          );
                                                    },
                                                  ),

                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 1.w,
                                                    ),
                                                    child: Text(
                                                      '${item.quantity}',
                                                      style:
                                                          GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),

                                                  IconButton(
                                                    constraints:
                                                        const BoxConstraints(),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 2.w,
                                                      vertical: 0.5.h,
                                                    ),
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: const Color(
                                                        0xFFD9A24F,
                                                      ),
                                                      size: 13.sp,
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<CartCubit>()
                                                          .updateQuantity(
                                                            item,
                                                            item.quantity + 1,
                                                          );
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

                        // =================================================
                        // APPLY COUPON
                        // =================================================
                        GestureDetector(
                          onTap: state.appliedCoupon == null
                              ? () {
                                  // TODO: Navigate/open coupon selection
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
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
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0x28D9A24F),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.percent,
                                    color: const Color(0xFFD9A24F),
                                    size: 16.sp,
                                  ),
                                ),

                                SizedBox(width: 3.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Apply Coupon',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14.5.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 0.3.h),
                                      Text(
                                        state.appliedCoupon != null
                                            ? '${state.appliedCoupon!.code} applied'
                                            : 'Select from available vouchers',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF8E8A82),
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Coupon Remove / Arrow
                                if (state.appliedCoupon != null)
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<CartCubit>()
                                          .removeCoupon();
                                    },
                                    child: Text(
                                      'Remove',
                                      style: GoogleFonts.inter(
                                        color: Colors.redAccent,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: const Color(0xFF8E8A82),
                                    size: 12.sp,
                                  ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // =================================================
                        // BILL SUMMARY
                        // =================================================
                        Text(
                          'Bill Summary',
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFF1CC8A),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 1.5.h),

                        Container(
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
                            children: [
                              _buildSummaryItem(
                                'Item Subtotal',
                                '₹${subtotal.toInt()}',
                              ),

                              if (discount > 0)
                                _buildSummaryItem(
                                  'Discount',
                                  '-₹${discount.toInt()}',
                                  isDiscount: true,
                                ),

                              const Divider(
                                color: Color(0xFF2C2721),
                                height: 24,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Grand Total',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '₹${grandTotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFFD9A24F),
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Space for fixed bottom checkout panel
                        SizedBox(height: 14.h),
                      ],
                    ),
                  ),

                  // =========================================================
                  // FIXED BOTTOM CHECKOUT PANEL
                  // =========================================================
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161614),
                        border: const Border(
                          top: BorderSide(
                            color: Color(0xFF2C2721),
                            width: 1.2,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // -----------------------------
                          // Total
                          // -----------------------------
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'TO PAY',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF8E8A82),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.3.h),
                              Text(
                                '₹${grandTotal.toStringAsFixed(2)}',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFD9A24F),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 6.w),

                          // -----------------------------
                          // Checkout Button
                          // -----------------------------
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.push('/checkout');
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 1.6.h,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Proceed to Checkout',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontSize: 14.5.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                        ],
                      ),
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

  // =========================================================
  // FOOD IMAGE
  // =========================================================

  Widget _buildFoodImage(dynamic item) {
    final String imageUrl = item.food.imageUrl;
    final String fallbackImage =
        item.food.isVeg ? 'assets/f1.png' : 'assets/f2.png';

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 16.w,
        height: 16.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Image.asset(
            fallbackImage,
            width: 16.w,
            height: 16.w,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      imageUrl.isNotEmpty ? imageUrl : fallbackImage,
      width: 16.w,
      height: 16.w,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          fallbackImage,
          width: 16.w,
          height: 16.w,
          fit: BoxFit.cover,
        );
      },
    );
  }

  // =========================================================
  // BILL SUMMARY ITEM
  // =========================================================

  Widget _buildSummaryItem(
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF8E8A82),
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            value,
            style: GoogleFonts.inter(
              color: isDiscount
                  ? const Color(0xFF4CAF50)
                  : Colors.white,
              fontSize: 14.sp,
              fontWeight: isDiscount
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
