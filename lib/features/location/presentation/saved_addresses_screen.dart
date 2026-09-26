import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/logger.dart';
import '../../../widgets/custom_widgets.dart';
import '../bloc/saved_addresses_bloc.dart';
import '../bloc/saved_addresses_event.dart';
import '../bloc/saved_addresses_state.dart';
import '../data/models/add_address_response.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavedAddressesBloc()..add(const FetchSavedAddressesEvent()),
      child: const _SavedAddressesView(),
    );
  }
}

class _SavedAddressesView extends StatelessWidget {
  const _SavedAddressesView();

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.business_center_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _confirmDeleteAddress(BuildContext context, CustomerAddressData address) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF191714),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2C2721), width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFE57373),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'Delete Address',
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this "${address.label}" address? This action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: AppColors.secondaryText,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SavedAddressesBloc>().add(
                    DeleteSavedAddressEvent(address.id),
                  );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.profile);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF191714),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2C2721), width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.primaryText,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Saved Addresses',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF1CC8A),
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: PrimaryGoldButton(
            text: '+ Add New Address',
            onPressed: () async {
              try {
                appLog("📍 Navigating to: ${AppRoutes.addAddress}");
                final result = await context.push(AppRoutes.addAddress);
                if (result == true && context.mounted) {
                  context
                      .read<SavedAddressesBloc>()
                      .add(const FetchSavedAddressesEvent());
                }
              } catch (e, stack) {
                appLog("❌ Error navigating to add address: $e\n$stack");
              }
            },
          ),
        ),
      ),
  
      body: BlocConsumer<SavedAddressesBloc, SavedAddressesState>(
        listener: (context, state) {
          if (state is SavedAddressesFailure) {
            Helpers.showErrorSnackbar('Addresses', state.error);
          } else if (state is AddressDeleteSuccess) {
            Helpers.showSuccessSnackbar('Address Deleted', state.message);
          }
        },
        buildWhen: (previous, current) => current is! AddressDeleteSuccess,
        builder: (context, state) {
          if (state is SavedAddressesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            );
          }

          if (state is SavedAddressesFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 16.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      state.error,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 3.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF191714),
                        side: const BorderSide(color: Color(0xFFD9A24F)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<SavedAddressesBloc>()
                            .add(const FetchSavedAddressesEvent());
                      },
                      child: Text(
                        'Retry',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFD9A24F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SavedAddressesEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: 20.w,
                      color: const Color(0xFF4A453E),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No saved addresses found',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF1CC8A),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Add your delivery address to start placing gourmet orders.',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SavedAddressesLoaded) {
            return RefreshIndicator(
              color: AppColors.primaryGold,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context
                    .read<SavedAddressesBloc>()
                    .add(const FetchSavedAddressesEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                itemCount: state.addresses.length,
                itemBuilder: (context, index) {
                  final CustomerAddressData address = state.addresses[index];
                  final bool isSelected = address.id == state.activeAddressId;

                  final fullAddress = [
                    address.addressLine1,
                    address.addressLine2,
                    address.city,
                    address.state,
                    if (address.pincode.isNotEmpty) address.pincode,
                  ].where((s) => s.isNotEmpty).join(', ');

                  return GestureDetector(
                    onTap: () {
                      context
                          .read<SavedAddressesBloc>()
                          .add(SelectActiveAddressEvent(address));
                      Helpers.showSuccessSnackbar(
                        'Delivery Address Selected',
                        'Delivering to ${address.label} (${address.city})',
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFD9A24F)
                              : const Color(0xFF2C2721),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getIconForLabel(address.label),
                                color: const Color(0xFFD9A24F),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                address.label,
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              if (address.isDefault) ...[
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFFD9A24F),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    'DEFAULT',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD9A24F),
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                              const Spacer(),
                              InkWell(
                                onTap: () =>
                                    _confirmDeleteAddress(context, address),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF231E18),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF382F26),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color(0xFFE57373),
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFFD9A24F),
                                  size: 20,
                                )
                              else
                                const Icon(
                                  Icons.radio_button_unchecked,
                                  color: AppColors.secondaryText,
                                  size: 20,
                                ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '${address.name} • ${address.mobile}',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD9A24F),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            fullAddress,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.secondaryText,
                              height: 1.35,
                            ),
                          ),
                          if (address.landmark != null &&
                              address.landmark!.isNotEmpty) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              'Landmark: ${address.landmark}',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: const Color(0xFF8E8A82),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
