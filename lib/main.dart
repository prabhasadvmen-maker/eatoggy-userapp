import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/network/app_repository.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'features/subscription/cubit/subscription_cubit.dart';
import 'features/orders/presentation/cubit/order_cubit.dart';
import 'features/splash/cubit/splash_cubit.dart';
import 'features/onboarding/cubit/onboarding_cubit.dart';
import 'features/menu/cubit/menu_cubit.dart';

void main() {
  final repository = MockAppRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashCubit()..initSplash()),
        BlocProvider(create: (_) => OnboardingCubit()),
        BlocProvider(create: (_) => HomeCubit(repository)),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => SubscriptionCubit(repository)),
        BlocProvider(create: (_) => OrderCubit()),
        BlocProvider(create: (_) => MenuCubit()),
      ],
      child: const EatoggyApp(),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
GlobalKey<NavigatorState> get navigatorKey => AppRouter.navigatorKey;

class EatoggyApp extends StatelessWidget {
  const EatoggyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: 'EATOGGY',
          theme: AppTheme.darkTheme,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
