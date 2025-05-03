import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/prospecting/bloc/prospecting_cubit.dart';
import 'package:mobilis/screens/prospecting/bloc/prospecting_state.dart';

import '../../models/prospect_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/prospecting/prospect_form.dart';
import '../../widgets/prospecting/prospect_list_item.dart';
import '../../widgets/prospecting/stats_card.dart';

class ProspectingScreen extends StatefulWidget {
  const ProspectingScreen({super.key});

  @override
  State<ProspectingScreen> createState() => _ProspectingScreenState();
}

class _ProspectingScreenState extends State<ProspectingScreen> {
  bool _isFormExpanded = true;

  @override
  void initState() {
    super.initState();
    context.read<ProspectingCubit>().loadProspects();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProspectingCubit, ProspectingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Prospecting'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text('JD', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: state.status == ProspectingStatus.loading && state.prospects.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsSection(state),
                        const SizedBox(height: 16),
                        _buildProspectForm(),
                        const SizedBox(height: 16),
                        _buildRecentProspects(context, state),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _isFormExpanded = true;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(ProspectingState state) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: 'Prospects This Month',
            value: '${state.prospectsThisMonth}',
            secondValue: '${state.targetProspects}',
            label: 'Target:',
            progress: state.prospectsThisMonth / state.targetProspects,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatsCard(
            title: 'Prospects Accepted',
            value: '${state.acceptedProspects}',
            secondValue: 'Success Rate: ${state.successRate.toStringAsFixed(0)}%',
            progress: state.successRate / 100,
          ),
        ),
      ],
    );
  }

  Widget _buildProspectForm() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('New Prospect', style: AppTextStyles.subheading),
                TextButton.icon(
                  icon: Icon(
                    _isFormExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    _isFormExpanded ? 'Collapse' : 'Expand',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  onPressed: () {
                    setState(() {
                      _isFormExpanded = !_isFormExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isFormExpanded) const ProspectForm(),
        ],
      ),
    );
  }

  Widget _buildRecentProspects(BuildContext context, ProspectingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Prospects', style: AppTextStyles.subheading),
        const SizedBox(height: 8),
        _buildFilterChips(context, state),
        const SizedBox(height: 8),
        ...context.read<ProspectingCubit>().filteredProspects.map((prospect) {
          return ProspectListItem(prospect: prospect);
        }),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context, ProspectingState state) {
    final filters = ['All', 'New', 'Pending', 'Accepted', 'Rejected'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = state.selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
              ),
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              onSelected: (selected) {
                context.read<ProspectingCubit>().filterProspects(filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}