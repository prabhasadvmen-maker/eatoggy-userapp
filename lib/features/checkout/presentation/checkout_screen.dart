import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/cubit/cart_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedSlotIndex = 0;
  int _selectedPaymentIndex = 0;

  final List<Map<String, String>> _timeSlots = const [
    {'time': '12:30 - 1:15', 'label': 'Gourmet Slot'},
    {'time': '1:30 - 2:15', 'label': 'Gourmet Slot'},
  ];

  final List<Map<String, dynamic>> _paymentMethods = const [
    {
      'title': 'UPI',
      'subtitle': 'GPay, PhonePe, Paytm & more',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Credit / Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card_outlined,
    },
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay when your order arrives',
      'icon': Icons.money_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Scrollable content ─────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Title
                        Center(
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryGold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── DELIVERING TO ──────────────────────────────────
                        Text(
                          'DELIVERING TO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGold,
                            letterSpacing: 1.4,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.secondaryText,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Home (Shergil Marg)',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Amrita Shergil Marg, Lutyens\' Delhi',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── SELECT PREMIUM LUNCH SLOT ──────────────────────
                        Text(
                          'SELECT PREMIUM LUNCH SLOT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGold,
                            letterSpacing: 1.4,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: List.generate(_timeSlots.length, (index) {
                            final bool isSelected = _selectedSlotIndex == index;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _selectedSlotIndex = index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: EdgeInsets.only(
                                    right: index == 0 ? 8 : 0,
                                    left: index == 1 ? 8 : 0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? AppColors.goldGradient
                                        : null,
                                    color: isSelected
                                        ? null
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _timeSlots[index]['time']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? const Color(0xFF2A1A00)
                                              : AppColors.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _timeSlots[index]['label']!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isSelected
                                              ? const Color(0xFF4A3010)
                                              : AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 32),

                        // ── PREFERRED PAYMENT METHOD ───────────────────────
                        Text(
                          'PREFERRED PAYMENT METHOD',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGold,
                            letterSpacing: 1.4,
                          ),
                        ),

                        const SizedBox(height: 12),
                        ...List.generate(_paymentMethods.length, (index) {
                          final method = _paymentMethods[index];
                          final isSelected = _selectedPaymentIndex == index;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryGold : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: RadioListTile(
                              value: index,
                              groupValue: _selectedPaymentIndex,
                              onChanged: (val) => setState(() => _selectedPaymentIndex = val!),
                              activeColor: AppColors.primaryGold,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              title: Row(
                                children: [
                                  Icon(method['icon'] as IconData, color: AppColors.secondaryText),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(method['title'] as String,
                                            style: TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w600)),
                                        Text(method['subtitle'] as String,
                                            style: TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ── Bottom: Place Order button ─────────────────────────────
                Container(
                  color: AppColors.background,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => context.push(
                              '/payment',
                              extra: state.total),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD9A24F),
                                  Color(0xFFF1CC8A),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                'Place Order • ₹${state.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A0E00),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 120,
                          height: 4,
                          margin: const EdgeInsets.only(top: 4, bottom: 8),
                          decoration: BoxDecoration(
                            color: AppColors.muted,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
