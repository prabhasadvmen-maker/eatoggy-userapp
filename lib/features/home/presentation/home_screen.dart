import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Premium Thali';

  // Mock meals to exactly match mockup design details and assets
  final List<FoodItem> _mockMeals = [
    const FoodItem(
      id: 'f1_mock',
      name: 'Shahi Paneer Thali',
      description: 'Rich cottage cheese cubes cooked in light spiced cashew cream gravy, accompanied by 2 Butter Roti, Jeera Rice, and Dal Makhani.',
      price: 349.0,
      imageUrl: 'assets/f1.png',
      category: 'Premium Thali',
      rating: 4.9,
      isVeg: true,
      nutrition: 'Calories: 680 kcal | Protein: 22g | Carbs: 85g | Fat: 28g',
      ingredients: ['Cottage Cheese', 'Cashew Paste', 'Wheat Flour', 'Basmati Rice', 'Black Lentils'],
    ),
    const FoodItem(
      id: 'f2_mock',
      name: 'Awadhi Rogan Thali',
      description: 'Traditional slow-cooked Mughlai special curry seasoned with exotic herbs and spices, served with fresh naan and saffron rice.',
      price: 489.0,
      imageUrl: 'assets/f2.png',
      category: 'Premium Thali',
      rating: 4.8,
      isVeg: false,
      nutrition: 'Calories: 780 kcal | Protein: 32g | Carbs: 75g | Fat: 34g',
      ingredients: ['Mutton/Chicken', 'Rogan Gravy', 'Wheat Flour', 'Saffron Rice'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header Address & Notifications
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location Info Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: const Color(0xFFD9A24F),
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 1.5.w),
                                  Text(
                                    "LUTYENS' DELHI",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFFD9A24F),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: const Color(0xFFD9A24F),
                                    size: 16.sp,
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Amrita Shergil Marg, New Delhi',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Cart / Box Icon
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
                        // Notification Bell
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF161614),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Search Box
                  GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF161614),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF2C2721),
                            width: 1.2,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: const Color(0xFF8E8A82),
                              size: 16.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Search for meals, restaurants...',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF66625C),
                                fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // 3. Festive Hero Banner
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 22.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/b1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0x9911110F),
                                Color(0xEE11110F),
                              ],
                            ),
                          ),
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC83C3C),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                                child: Text(
                                  'FESTIVE OFFER',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Royal Feast Thali',
                                style: GoogleFonts.playfairDisplay(
                                  color: const Color(0xFFF1CC8A),
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Subscribe today & get 20% off your first luxury weekly pack',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFD9D7D4),
                                  fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // 4. Curated Collections
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      'Curated Collections',
                      style: GoogleFonts.playfairDisplay(
                        color: const Color(0xFFF1CC8A),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  SizedBox(
                    height: 5.5.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      children: [
                        _buildCategoryChip('All Meals'),
                        _buildCategoryChip('Premium Thali'),
                        _buildCategoryChip('Royal Rice'),
                        _buildCategoryChip('Artisan Bread'),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // 5. Gourmet Creations Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Gourmet Creations',
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFF1CC8A),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'View All',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD9A24F),
                            fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // 6. Food Cards Row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        Expanded(child: _buildFoodCard(_mockMeals[0])),
                        SizedBox(width: 3.w),
                        Expanded(child: _buildFoodCard(_mockMeals[1])),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Category Chip Builder
  Widget _buildCategoryChip(String title) {
    final isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
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
          title,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.black : const Color(0xFFD9D7D4),
            fontSize: 14.sp, // Strictly between 14.sp to 18.sp
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Thali Card Item Builder
  Widget _buildFoodCard(FoodItem food) {
    return GestureDetector(
      onTap: () => context.push('/food-detail', extra: food),
      child: Container(
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
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    food.imageUrl,
                    height: 15.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xDD161614),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: food.isVeg ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: food.isVeg ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Text Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.5.sp, // Strictly between 14.sp to 18.sp
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
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
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFD9A24F),
                            size: 14.sp,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${food.rating}',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD9A24F),
                              fontSize: 14.sp, // Strictly between 14.sp to 18.sp
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  
                  // Hygiene verified badge
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x1F4CAF50),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0x3B4CAF50),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.security,
                          color: const Color(0xFF4CAF50),
                          size: 11.sp,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Hygiene Verified',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF4CAF50),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  
                  // Add to Box button
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
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2721),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Add to Box',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp, // Strictly between 14.sp to 18.sp
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
      ),
    );
  }
}
