import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_widgets.dart';
import '../../../shared/models/models.dart';
import '../../home/cubit/home_cubit.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _nameController = TextEditingController(text: 'Aman Kumar');
  final _flatController = TextEditingController(text: 'Apartment 4B, Skyview Towers');
  final _streetController = TextEditingController(text: 'Outer Ring Road, Marathahalli');
  final _landmarkController = TextEditingController(text: 'Opposite Shell Petrol Station');
  final _cityController = TextEditingController(text: 'Bengaluru');
  final _pincodeController = TextEditingController(text: '560037');
  String _addressType = 'Home';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Complete Address', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(labelText: 'Receiver Name', hintText: 'Enter name', controller: _nameController),
              const SizedBox(height: 16),
              AppTextField(labelText: 'Flat / House No / Floor', hintText: 'Flat 4B', controller: _flatController),
              const SizedBox(height: 16),
              AppTextField(labelText: 'Street / Area', hintText: 'Enter street', controller: _streetController),
              const SizedBox(height: 16),
              AppTextField(labelText: 'Landmark', hintText: 'Enter landmark', controller: _landmarkController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: AppTextField(labelText: 'City', hintText: 'Bengaluru', controller: _cityController)),
                  const SizedBox(width: 16),
                  Expanded(child: AppTextField(labelText: 'Pincode', hintText: '560037', controller: _pincodeController)),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Address Type',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: ['Home', 'Work', 'Other'].map((type) {
                  final isSelected = _addressType == type;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _addressType = type;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryGold.withOpacity(0.15) : AppColors.surface,
                        border: Border.all(color: isSelected ? AppColors.primaryGold : Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? AppColors.primaryGold : AppColors.secondaryText,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),
              PrimaryGoldButton(
                text: 'Save Address & Proceed',
                onPressed: () {
                  final address = Address(
                    id: 'addr_new',
                    name: _nameController.text,
                    flatHouse: _flatController.text,
                    street: _streetController.text,
                    landmark: _landmarkController.text,
                    city: _cityController.text,
                    pincode: _pincodeController.text,
                    type: _addressType,
                  );
                  context.read<HomeCubit>().updateAddress(address);
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
