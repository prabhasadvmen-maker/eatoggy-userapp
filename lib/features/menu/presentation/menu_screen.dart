import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/menu_cubit.dart';
import '../cubit/menu_state.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  
                  // 1. Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'The Royal Menu',
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xFFF1CC8A),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          BlocBuilder<CartCubit, CartState>(
                            builder: (context, cartState) {
                              final count = cartState.items.fold(0, (sum, item) => sum + item.quantity);
                              return Badge(
                                isLabelVisible: count > 0,
                                label: Text('$count'),
                                backgroundColor: const Color(0xFFD9A24F),
                                textColor: Colors.black,
                                child: Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF161614),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    onPressed: () => context.push('/cart'),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF161614),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.tune,
                                color: const Color(0xFFD9A24F),
                                size: 18.sp,
                              ),
                              onPressed: () {
                                // Filter actions
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // 2. Categories selection row
                  SizedBox(
                    height: 5.5.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final cat = state.categories[index];
                        final isSelected = state.selectedCategory == cat;
                        return GestureDetector(
                          onTap: () {
                            context.read<MenuCubit>().selectCategory(cat);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 3.w),
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFD9A24F) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFD9A24F) : const Color(0xFF2C2721),
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.inter(
                                color: isSelected ? Colors.black : const Color(0xFFD9D7D4),
                                fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // 3. Food items list
                  Expanded(
                    child: state.meals.isEmpty
                        ? Center(
                            child: Text(
                              'No food items available in this category.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8E8A82),
                                fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.meals.length,
                            itemBuilder: (context, index) {
                              return _buildMenuCard(context, state.meals[index]);
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

  // Styled Menu Item Card
  Widget _buildMenuCard(BuildContext context, FoodItem food) {
    return GestureDetector(
      onTap: () => context.push('/food-detail', extra: food),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.5.h),
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
            // Left Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: food.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      food.imageUrl,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      food.imageUrl,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 4.w),
            
            // Right Content Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Veg Icon + Name Row
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: food.isVeg ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                            width: 1.2,
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: food.isVeg ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          food.name,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  
                  // Description
                  Text(
                    food.description,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8E8A82),
                      fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  
                  // Price and Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${food.price.toInt()}',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFD9A24F),
                          fontSize: 15.sp, // Strictly between 14.sp to 18.sp
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<CartCubit>().addToCart(food);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF1E1C1A),
                              content: Text(
                                '${food.name} Added to Box!',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2721),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                          child: Text(
                            'Add',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD9A24F),
                              fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
