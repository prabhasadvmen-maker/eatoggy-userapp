import 'models.dart';

class DummyData {
  DummyData._();

  static const List<Category> categories = [
    Category(id: '1', name: 'North Indian', icon: '🍲'),
    Category(id: '2', name: 'South Indian', icon: '🫓'),
    Category(id: '3', name: 'Tiffin', icon: '🍱'),
    Category(id: '4', name: 'Healthy', icon: '🥗'),
    Category(id: '5', name: 'Breakfast', icon: '🥞'),
    Category(id: '6', name: 'Lunch', icon: '🍛'),
    Category(id: '7', name: 'Dinner', icon: '🍲'),
  ];

  static const List<FoodItem> foodItems = [
    FoodItem(
      id: 'f1',
      name: 'Premium Shahi Paneer Thali',
      description: 'Rich cottage cheese cubes cooked in light spiced cashew cream gravy, accompanied by 2 Butter Roti, Jeera Rice, and Dal Makhani.',
      price: 189.0,
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?q=80&w=400&auto=format&fit=crop',
      category: 'North Indian',
      rating: 4.8,
      isVeg: true,
      nutrition: 'Calories: 680 kcal | Protein: 22g | Carbs: 85g | Fat: 28g',
      ingredients: ['Cottage Cheese', 'Cashew Paste', 'Wheat Flour', 'Basmati Rice', 'Black Lentils'],
    ),
    FoodItem(
      id: 'f2',
      name: 'Ghar Ki Homely Dal Khichdi',
      description: 'Comforting yellow lentils and rice tempered with pure cow ghee, cumin, and hing. Served with roasted papad and home pickle.',
      price: 129.0,
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?q=80&w=400&auto=format&fit=crop',
      category: 'Tiffin',
      rating: 4.9,
      isVeg: true,
      nutrition: 'Calories: 420 kcal | Protein: 14g | Carbs: 65g | Fat: 10g',
      ingredients: ['Moong Dal', 'Basmati Rice', 'Ghee', 'Cumin Seeds', 'Asafoetida'],
    ),
    FoodItem(
      id: 'f3',
      name: 'High Protein Quinoa Bowl',
      description: 'Fluffy organic quinoa topped with roasted exotic veggies, grilled paneer cubes, tossed seeds, and a zesty herb lemon dressing.',
      price: 220.0,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=400&auto=format&fit=crop',
      category: 'Healthy',
      rating: 4.6,
      isVeg: true,
      nutrition: 'Calories: 380 kcal | Protein: 18g | Carbs: 45g | Fat: 14g',
      ingredients: ['Quinoa', 'Bell Peppers', 'Broccoli', 'Paneer', 'Pumpkin Seeds'],
    ),
    FoodItem(
      id: 'f4',
      name: 'Traditional Masala Dosa',
      description: 'Crispy fermented crepe with potato masala filling. Served with home-style coconut chutney, tomato garlic chutney, and steaming piping hot sambar.',
      price: 110.0,
      imageUrl: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?q=80&w=400&auto=format&fit=crop',
      category: 'South Indian',
      rating: 4.7,
      isVeg: true,
      nutrition: 'Calories: 350 kcal | Protein: 7g | Carbs: 58g | Fat: 9g',
      ingredients: ['Rice Batter', 'Potatoes', 'Mustard Seeds', 'Curry Leaves', 'Coconut'],
    ),
    FoodItem(
      id: 'f5',
      name: 'Butter Chicken Homestyle Thali',
      description: 'Succulent chicken pieces cooked in tomato gravy, with homestyle spices. Served with 2 Phulka, Rice, and cucumber salad.',
      price: 249.0,
      imageUrl: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?q=80&w=400&auto=format&fit=crop',
      category: 'North Indian',
      rating: 4.8,
      isVeg: false,
      nutrition: 'Calories: 740 kcal | Protein: 34g | Carbs: 72g | Fat: 30g',
      ingredients: ['Chicken', 'Tomatoes', 'Butter', 'Cream', 'Whole Wheat'],
    ),
  ];

  static const List<Coupon> coupons = [
    Coupon(
      code: 'EATNEW',
      discountPercent: 50,
      maxDiscount: 100,
      minOrderValue: 150,
      description: 'Get 50% OFF up to ₹100 on your first food order.',
      expiryDate: '31 Aug 2026',
    ),
    Coupon(
      code: 'FREEGOLD',
      discountPercent: 20,
      maxDiscount: 150,
      minOrderValue: 299,
      description: 'Flat 20% discount on premium home thalis.',
      expiryDate: '05 Sep 2026',
    ),
  ];

  static const List<SubscriptionPlan> subscriptionPlans = [
    SubscriptionPlan(
      id: 'sub_weekly',
      name: 'Imperial Weekly',
      pricePerMeal: 328.0,
      totalMeals: 7,
      durationDays: 7,
      deliveryDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      benefits: [
        'Choice of Royal Veg or Nawabi Non-Veg Thali',
        'Complementary Artisanal Dessert on Sunday',
      ],
    ),
    SubscriptionPlan(
      id: 'sub_monthly',
      name: 'Maharaja Monthly',
      pricePerMeal: 283.0,
      totalMeals: 30,
      durationDays: 30,
      deliveryDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      benefits: [
        'Choice of Royal Veg or Nawabi Non-Veg Thali',
        'Complementary Artisanal Dessert on Sunday',
      ],
      isRecommended: true,
    ),
  ];

  static const Address sampleAddress = Address(
    id: 'addr1',
    name: 'Aman Kumar',
    flatHouse: 'Apartment 4B, Skyview Towers',
    street: 'Outer Ring Road, Marathahalli',
    landmark: 'Opposite Shell Petrol Station',
    city: 'Bengaluru',
    pincode: '560037',
    type: 'Home',
  );
}
