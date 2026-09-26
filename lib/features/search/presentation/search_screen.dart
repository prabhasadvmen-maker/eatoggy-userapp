import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/dummy_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _results = [];

  void _onSearch(String val) {
    if (val.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }
    setState(() {
      _results = DummyData.foodItems
          .where((food) => food.name.toLowerCase().contains(val.toLowerCase()) || food.description.toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          autofocus: true,
          style: theme.textTheme.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'Search food items...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppColors.muted),
          ),
        ),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: _results.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 60, color: AppColors.muted),
                  SizedBox(height: 12),
                  Text('No results found.', style: TextStyle(color: AppColors.secondaryText)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.p16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final food = _results[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: food.imageUrl.startsWith('assets/')
                        ? Image.asset(food.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                        : Image.network(food.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('₹${food.price}', style: const TextStyle(color: AppColors.primaryGold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/food-detail', extra: food),
                );
              },
            ),
    );
  }
}
