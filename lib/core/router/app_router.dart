import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
import '../../features/location/presentation/location_permission_screen.dart';
import '../../features/location/presentation/select_location_screen.dart';
import '../../features/location/presentation/add_address_screen.dart';
import '../../features/location/presentation/saved_addresses_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/menu/presentation/menu_screen.dart';
import '../../features/food_detail/presentation/food_detail_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/payment/presentation/payment_screen.dart';
import '../../features/orders/presentation/order_success_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/orders/presentation/order_details_screen.dart';
import '../../features/orders/presentation/write_review_screen.dart';
import '../../features/tracking/presentation/tracking_screen.dart';
import '../../features/subscription/presentation/subscription_plans_screen.dart';
import '../../features/subscription/presentation/plan_detail_screen.dart';
import '../../features/subscription/presentation/customize_subscription_screen.dart';
import '../../features/subscription/presentation/my_subscription_screen.dart';
import '../../features/subscription/presentation/subscription_calendar_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/support/presentation/support_screen.dart';
import '../../features/support/presentation/ticket_detail_screen.dart';
import '../../shared/widgets/navigation_shell.dart';
import '../../shared/models/models.dart';
import '../../features/offers/presentation/offers_screen.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  static GlobalKey<NavigatorState> get navigatorKey => _rootNavigatorKey;

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    navigatorKey: _rootNavigatorKey,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri}'),
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final phone = state.extra as String? ?? '9999999999';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.locationPermission,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LocationPermissionScreen(),
      ),
      GoRoute(
        path: AppRoutes.selectLocation,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SelectLocationScreen(),
      ),
      GoRoute(
        path: AppRoutes.addAddress,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: AppRoutes.savedAddresses,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return NavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.menu,
            builder: (context, state) => const MenuScreen(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: AppRoutes.subscription,
            builder: (context, state) => const SubscriptionPlansScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.foodDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final food = state.extra as FoodItem;
          return FoodDetailScreen(food: food);
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.offers,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OffersScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.payment,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final amount = state.extra as double? ?? 0.0;
          return PaymentScreen(amount: amount);
        },
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return OrderSuccessScreen(order: order);
        },
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return OrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        path: AppRoutes.writeReview,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return WriteReviewScreen(order: order);
        },
      ),
      GoRoute(
        path: AppRoutes.tracking,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return TrackingScreen(order: order);
        },
      ),
      GoRoute(
        path: AppRoutes.planDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final plan = state.extra as SubscriptionPlan;
          return PlanDetailScreen(plan: plan);
        },
      ),
      GoRoute(
        path: AppRoutes.customizeSubscription,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final plan = state.extra as SubscriptionPlan;
          return CustomizeSubscriptionScreen(plan: plan);
        },
      ),
      GoRoute(
        path: AppRoutes.mySubscription,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MySubscriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscriptionCalendar,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final subscription = state.extra as Subscription;
          return SubscriptionCalendarScreen(subscription: subscription);
        },
      ),
      GoRoute(
        path: AppRoutes.support,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.ticketDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final ticket = state.extra as SupportTicket;
          return TicketDetailScreen(ticket: ticket);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
