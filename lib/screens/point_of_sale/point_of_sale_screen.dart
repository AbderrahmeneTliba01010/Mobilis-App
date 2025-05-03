import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/point_of_sale/bloc/point_of_sale_cubit.dart';
import 'package:mobilis/screens/point_of_sale/bloc/point_of_sale_state.dart';
import 'package:mobilis/widgets/point_of_sale/point_of_sale_card.dart';
import '../../models/point_of_sale_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class PointsOfSaleScreen extends StatefulWidget {
  const PointsOfSaleScreen({super.key});

  @override
  State<PointsOfSaleScreen> createState() => _PointsOfSaleScreenState();
}

class _PointsOfSaleScreenState extends State<PointsOfSaleScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PointsOfSaleCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Points of Sale'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 16,
              child: Text(
                'JD',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchBar(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildCategoryFilter(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildPointsList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.filter_list),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return BlocConsumer<PointsOfSaleCubit, PointsOfSaleState>(
      listenWhen: (previous, current) {
        // Only listen when state changes to a different search query
        final prevQuery = previous is PointsOfSaleSearched ? previous.searchQuery : '';
        final currQuery = current is PointsOfSaleSearched ? current.searchQuery : '';
        return prevQuery != currQuery;
      },
      listener: (context, state) {
        // Update search controller text if state changed due to other factors
        if (state is PointsOfSaleSearched) {
          if (_searchController.text != state.searchQuery) {
            _searchController.text = state.searchQuery;
          }
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name, zone, address, contact...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<PointsOfSaleCubit>().searchPointsOfSale('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              context.read<PointsOfSaleCubit>().searchPointsOfSale(value);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      {'name': 'All', 'icon': Icons.grid_view_rounded},
      {'name': 'Mobile', 'icon': Icons.smartphone},
      {'name': 'Electronics', 'icon': Icons.computer},
      {'name': 'Telecom', 'icon': Icons.cell_tower},
    ];

    return BlocBuilder<PointsOfSaleCubit, PointsOfSaleState>(
      builder: (context, state) {
        String activeFilter = 'All';
        if (state is PointsOfSaleFiltered) {
          activeFilter = state.activeFilter;
        }

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isActive = activeFilter == category['name'];

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  selected: isActive,
                  showCheckmark: false,
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primary,
                  label: Row(
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 16,
                        color: isActive ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  onSelected: (selected) {
                    context
                        .read<PointsOfSaleCubit>()
                        .filterByCategory(category['name'] as String);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPointsList() {
    return BlocBuilder<PointsOfSaleCubit, PointsOfSaleState>(
      builder: (context, state) {
        if (state is PointsOfSaleLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PointsOfSaleError) {
          return Center(child: Text(state.message));
        }

        List<PointOfSale> pointsToShow = [];
        
        if (state is PointsOfSaleFiltered) {
          pointsToShow = state.filteredPoints;
        } else if (state is PointsOfSaleLoaded) {
          pointsToShow = state.allPoints;
        }

        if (pointsToShow.isEmpty) {
          return const Center(
            child: Text(
              'No points of sale found',
              style: AppTextStyles.subheading,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: pointsToShow.length,
          itemBuilder: (context, index) {
            final point = pointsToShow[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PointOfSaleCard(pointOfSale: point),
            );
          },
        );
      },
    );
  }
}