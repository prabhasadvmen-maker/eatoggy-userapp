import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/app_repository.dart';
import '../../../shared/models/dummy_data.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../orders/presentation/cubit/order_cubit.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;

  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  void _processPayment() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
      // Instantiate repository call to create active order
      final repo = MockAppRepository();
      final cartCubit = context.read<CartCubit>();
      final order = await repo.placeOrder(
        cartCubit.state.items,
        cartCubit.state.discountAmount,
        DummyData.sampleAddress,
      );
      if (mounted) {
        context.read<OrderCubit>().addOrder(order);
        cartCubit.clearCart();
        context.go('/order-success', extra: order);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isProcessing) ...[
                const CircularProgressIndicator(color: AppColors.primaryGold),
                const SizedBox(height: 24),
                Text(
                  'Processing Secure Payment...',
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please do not close the application or press back.',
                  style: theme.textTheme.bodySmall,
                ),
              ] else ...[
                const Icon(Icons.check_circle, size: 80, color: AppColors.success),
                const SizedBox(height: 24),
                Text(
                  'Payment Complete!',
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
