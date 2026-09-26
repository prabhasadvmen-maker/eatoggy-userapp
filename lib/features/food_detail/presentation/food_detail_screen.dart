import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/custom_widgets.dart';
import '../../../shared/models/models.dart';
import '../../cart/cubit/cart_cubit.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _qty = 1;
  bool _nutritionExpanded = false;
  bool _garlicNaanChecked = true;
  bool _phirniChecked = false;

  @override
  Widget build(BuildContext context) {
    // Dynamic price calculation matching selected addons
    final double addOnPrice = (_garlicNaanChecked ? 45.0 : 0.0) + (_phirniChecked ? 120.0 : 0.0);
    final double totalPrice = (widget.food.price + addOnPrice) * _qty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Scrollable Area
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Food Image Header
                Stack(
                  children: [
                    widget.food.imageUrl.startsWith('assets/')
                        ? Image.asset(
                            widget.food.imageUrl,
                            height: 35.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.food.imageUrl,
                            height: 35.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              widget.food.isVeg ? 'assets/f1.png' : 'assets/f2.png',
                              height: 35.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                    // Gradient overlay at top for back/share icon readability
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.3],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 2. Details Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Veg Indicator + Title + Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.8.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                  color: widget.food.isVeg ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                                  width: 1.2,
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.food.isVeg ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              widget.food.name,
                              style: GoogleFonts.playfairDisplay(
                                color: const Color(0xFFF1CC8A),
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '₹${widget.food.price.toInt()}',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFD9A24F),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      
                      // Star Rating & Royal Reviews Row
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFD9A24F),
                            size: 16.sp,
                          ),
                          SizedBox(width: 1.5.w),
                          Text(
                            '${widget.food.rating} (2.4K royal ratings)',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD9A24F),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      
                      // Hygiene Verified Badge
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x1F4CAF50),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0x3B4CAF50),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.security,
                              color: const Color(0xFF4CAF50),
                              size: 12.sp,
                            ),
                            SizedBox(width: 1.5.w),
                            Text(
                              'Hygiene Verified',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF4CAF50),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      
                      // Description Paragraph
                      Text(
                        widget.food.description,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8E8A82),
                          fontSize: 14.5.sp, // Font size strictly between 14.sp to 18.sp
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      
                      const Divider(color: Color(0xFF2C2721), height: 1),
                      SizedBox(height: 2.h),
                      
                      // 3. Nutrition & Ingredients Expandable Section
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _nutritionExpanded = !_nutritionExpanded;
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nutrition & Ingredients',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                _nutritionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Collapsible Expansion block
                      if (_nutritionExpanded) ...[
                        SizedBox(height: 1.5.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161614),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF2C2721)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.food.nutrition,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF8E8A82),
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Ingredients:',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Wrap(
                                spacing: 2.w,
                                runSpacing: 1.h,
                                children: widget.food.ingredients.map((ing) {
                                  return Chip(
                                    backgroundColor: const Color(0xFF2C2721),
                                    label: Text(
                                      ing,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFFD9D7D4),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    side: BorderSide.none,
                                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 3.h),
                      
                      // 4. Accompanying Add-ons Section
                      Text(
                        'ACCOMPANYING ADD-ONS',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFD9A24F),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      
                      // Add-on Item 1: Garlic Naan
                      _buildAddOnRow(
                        title: 'Heritage Garlic Naan',
                        price: 45,
                        isChecked: _garlicNaanChecked,
                        onChanged: (val) {
                          setState(() {
                            _garlicNaanChecked = val ?? false;
                          });
                        },
                      ),
                      SizedBox(height: 1.5.h),
                      
                      // Add-on Item 2: Phirni
                      _buildAddOnRow(
                        title: 'Kesari Phirni (Royal Dessert)',
                        price: 120,
                        isChecked: _phirniChecked,
                        onChanged: (val) {
                          setState(() {
                            _phirniChecked = val ?? false;
                          });
                        },
                      ),
                      SizedBox(height: 15.h), // Spacing to ensure content isn't covered by bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 5. Back Navigation Overlay Button
          Positioned(
            top: 4.h,
            left: 5.w,
            child: CircleAvatar(
              backgroundColor: const Color(0xAA11110F),
              radius: 20.sp,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          
          // 6. Share Overlay Button
          Positioned(
            top: 4.h,
            right: 5.w,
            child: CircleAvatar(
              backgroundColor: const Color(0xAA11110F),
              radius: 20.sp,
              child: IconButton(
                icon: const Icon(Icons.ios_share, color: Colors.white),
                onPressed: () {
                  // Share actions
                },
              ),
            ),
          ),
          
          // 7. Bottom Quantity & Add-To-Cart Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF11110F),
              child: SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: const BoxDecoration(
                    color: Color(0xFF11110F),
                    border: Border(
                      top: BorderSide(color: Color(0xFF1E1C18), width: 1.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Capsule Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF161614),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF2C2721)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: const Color(0xFFD9A24F), size: 16.sp),
                              onPressed: () {
                                if (_qty > 1) {
                                  setState(() {
                                    _qty--;
                                  });
                                }
                              },
                            ),
                            Text(
                              '$_qty',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: const Color(0xFFD9A24F), size: 16.sp),
                              onPressed: () {
                                setState(() {
                                  _qty++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      
                      // Gradient Add To Cart button
                      Expanded(
                        child: PrimaryGoldButton(
                          text: 'Add to Cart • ₹${totalPrice.toInt()}',
                          onPressed: () {
                            final int qty = _qty < 1 ? 1 : _qty;
                            context.read<CartCubit>().addToCart(widget.food, quantity: qty);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color(0xFF1E1C1A),
                                content: Text(
                                  '${widget.food.name} (x$qty) Added to Box!',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                            context.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }

  // Row Item Builder for Add-on list
  Widget _buildAddOnRow({
    required String title,
    required int price,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Custom checkbox styling to match mockup gold theme
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isChecked ? const Color(0xFFD9A24F) : const Color(0xFF8E8A82),
                      width: 1.5,
                    ),
                    color: isChecked ? const Color(0xFFD9A24F) : Colors.transparent,
                  ),
                  child: isChecked
                      ? Icon(
                          Icons.check,
                          size: 12.sp,
                          color: Colors.black,
                        )
                      : null,
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: isChecked ? Colors.white : const Color(0xFF8E8A82),
                    fontSize: 14.sp, // Font size strictly between 14.sp to 18.sp
                    fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            Text(
              '+ ₹$price',
              style: GoogleFonts.outfit(
                color: isChecked ? const Color(0xFFD9A24F) : const Color(0xFF8E8A82),
                fontSize: 14.sp, // Font size strictly between 14.sp to 18.sp
                fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
