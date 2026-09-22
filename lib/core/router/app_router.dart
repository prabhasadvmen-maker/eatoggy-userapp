import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '9999999999';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: '/location-permission',
        builder: (context, state) => const LocationPermissionScreen(),
      ),
      GoRoute(
        path: '/select-location',
        builder: (context, state) => const SelectLocationScreen(),
      ),
      GoRoute(
        path: '/add-address',
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: '/saved-addresses',
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
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/menu',
            builder: (context, state) => const MenuScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/subscription',
            builder: (context, state) => const SubscriptionPlansScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/food-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final food = state.extra as FoodItem;
          return FoodDetailScreen(food: food);
        },
      ),
      GoRoute(
        path: '/cart',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/offers',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OffersScreen(),
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/payment',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final amount = state.extra as double? ?? 0.0;
          return PaymentScreen(amount: amount);
        },
      ),
      GoRoute(
        path: '/order-success',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return OrderSuccessScreen(order: order);
        },
      ),
      GoRoute(
        path: '/order-details',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return OrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        path: '/write-review',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return WriteReviewScreen(order: order);
        },
      ),
      GoRoute(
        path: '/tracking',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final order = state.extra as Order;
          return TrackingScreen(order: order);
        },
      ),
      GoRoute(
        path: '/plan-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final plan = state.extra as SubscriptionPlan;
          return PlanDetailScreen(plan: plan);
        },
      ),
      GoRoute(
        path: '/customize-subscription',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final plan = state.extra as SubscriptionPlan;
          return CustomizeSubscriptionScreen(plan: plan);
        },
      ),
      GoRoute(
        path: '/my-subscription',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MySubscriptionScreen(),
      ),
      GoRoute(
        path: '/subscription-calendar',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final subscription = state.extra as Subscription;
          return SubscriptionCalendarScreen(subscription: subscription);
        },
      ),
      GoRoute(
        path: '/support',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/ticket-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final ticket = state.extra as SupportTicket;
          return TicketDetailScreen(ticket: ticket);
        },
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
