import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';

class SavedAddressItem {
  final String type;
  final String details;
  final bool isDefault;

  SavedAddressItem({
    required this.type,
    required this.details,
    this.isDefault = false,
  });
}

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<SavedAddressItem> _addresses = [
    SavedAddressItem(
      type: 'Home',
      details: "Villa 14, Amrita Shergil Marg, Lutyens' Delhi, New Delhi, Delhi - 110003",
      isDefault: true,
    ),
    SavedAddressItem(
      type: 'Work',
      details: 'Bespoke Chambers, Floor 4, Barakhamba Road, Connaught Place, New Delhi - 110001',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              } else {
                context.go('/profile');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF191714),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1E1C18), width: 1.5),
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.primaryText, size: 18),
            ),
          ),
        ),
        title: Text(
          'Saved Addresses',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: _addresses.isEmpty
          ? Center(
              child: Text(
                'No saved addresses.',
                style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                final bool isHome = address.type.toLowerCase() == 'home';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isHome ? Icons.home_outlined : Icons.business_center_outlined,
                            color: AppColors.primaryGold,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            address.type,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.primaryGold, width: 1.0),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          // Edit icon
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Edit address feature coming soon!')),
                              );
                            },
                            child: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.secondaryText,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Delete icon
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _addresses.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Address deleted successfully.'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        address.details,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
