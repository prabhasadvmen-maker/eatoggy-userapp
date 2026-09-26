import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/custom_widgets.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Map mockup visual
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: AppColors.muted),
                  SizedBox(height: 12),
                  Text('Premium Map Integration Mockup', style: TextStyle(color: AppColors.secondaryText)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.muted.withOpacity(0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: AppColors.primaryGold),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search location or flat...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.p24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusSheet)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.my_location, color: AppColors.primaryGold),
                      const SizedBox(width: 12),
                      Text(
                        'Marathahalli, Outer Ring Road',
                        style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Skyview Towers Apartment, Bengaluru, Karnataka, 560037',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  PrimaryGoldButton(
                    text: 'Confirm Location',
                    isLoading: _isLoading,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Future.delayed(const Duration(milliseconds: 600), () {
                        if (mounted) {
                          context.go('/add-address');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
