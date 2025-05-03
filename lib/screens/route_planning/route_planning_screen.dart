// route_planning_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_styles.dart';
import '../../../widgets/route_planning/visit_tile.dart';
import 'bloc/route_planning_cubit.dart';
import 'bloc/route_planning_state.dart';
import 'route_details_screen.dart';

class RoutePlanningScreen extends StatelessWidget {
  const RoutePlanningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoutePlanningCubit(),
      child: BlocConsumer<RoutePlanningCubit, RoutePlanningState>(
        listener: (context, state) {
          if (state.status == RouteStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state.isRouteGenerated && state.status == RouteStatus.success) {
            // Navigate to the route details screen when route is generated successfully
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RouteDetailsScreen(visits: state.plannedVisits),
              ),
            );
          } else if (state.isRouteSaved && state.status == RouteStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Route saved successfully'),
                backgroundColor: AppColors.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Route Planning'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text('JD', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, RoutePlanningState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Route Settings',
                      style: AppTextStyles.subheading,
                    ),
                    const SizedBox(height: 16),
                    // Date Selector
                    const Text('Select Date'),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MM/dd/yyyy').format(state.settings.date),
                              style: AppTextStyles.body,
                            ),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Starting Point
                    const Text('Starting Point'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(
                            state.settings.startingPoint,
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Optimization Preference
                    const Text('Optimization Preference'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(
                            state.settings.optimizationPreference,
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Additional Options
                    const Text('Additional Options'),
                    const SizedBox(height: 8),
                    // Avoid Traffic
                    Row(
                      children: [
                        Checkbox(
                          value: state.settings.avoidTraffic,
                          onChanged: (value) => context
                              .read<RoutePlanningCubit>()
                              .toggleAvoidTraffic(value ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const Text('Avoid Traffic'),
                      ],
                    ),
                    // Consider Opening Hours
                    Row(
                      children: [
                        Checkbox(
                          value: state.settings.considerOpeningHours,
                          onChanged: (value) => context
                              .read<RoutePlanningCubit>()
                              .toggleConsiderOpeningHours(value ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const Text('Consider Opening Hours'),
                      ],
                    ),
                    // Include Breaks
                    Row(
                      children: [
                        Checkbox(
                          value: state.settings.includeBreaks,
                          onChanged: (value) => context
                              .read<RoutePlanningCubit>()
                              .toggleIncludeBreaks(value ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const Text('Include Breaks'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Generate Route Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: state.status == RouteStatus.loading
                            ? null
                            : () => context.read<RoutePlanningCubit>().generateRoute(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        icon: const Icon(Icons.shuffle, color: Colors.white),
                        label: state.status == RouteStatus.loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Generate Optimized Route',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Planned Visits Section
            if (state.plannedVisits.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Planned Visits',
                    style: AppTextStyles.subheading,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Filter'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Visit List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.plannedVisits.length,
                itemBuilder: (context, index) {
                  final visit = state.plannedVisits[index];
                  return VisitTile(
                    visit: visit,
                    onAddPressed: () {
                      // Handle add action
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.status == RouteStatus.loading
                          ? null
                          : () => context.read<RoutePlanningCubit>().saveRoute(),
                      icon: const Icon(Icons.save),
                      label: const Text('Save Route'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text(
                        'Export',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final cubit = context.read<RoutePlanningCubit>();
    final currentDate = DateTime.now();
    final initialDate = cubit.state.settings.date;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: currentDate,
      lastDate: currentDate.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      cubit.setDate(selectedDate);
    }
  }
}