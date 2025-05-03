import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobilis/screens/point_of_sale/bloc/point_of_sale_cubit.dart';
import '../../models/point_of_sale_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class PointOfSaleCard extends StatelessWidget {
  final PointOfSale pointOfSale;

  const PointOfSaleCard({
    super.key,
    required this.pointOfSale,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pointOfSale.name,
                  style: AppTextStyles.subheading,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    pointOfSale.category,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Address',
              pointOfSale.address,
              'Zone',
              pointOfSale.zone,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Contact',
              pointOfSale.contact,
              'Opens',
              pointOfSale.openingHours,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(context),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    Widget statusWidget;
    
    if (pointOfSale.scheduledVisit != null && pointOfSale.scheduledVisit!.isNotEmpty) {
      statusWidget = Row(
        children: [
          Text(
            'Scheduled: ${pointOfSale.scheduledVisit}',
            style: AppTextStyles.body,
          ),
          const SizedBox(width: 8),
          _buildStatusBadge(),
        ],
      );
    } else {
      statusWidget = Row(
        children: [
          Text(
            'Last visit: ${pointOfSale.lastVisit}',
            style: AppTextStyles.body,
          ),
          const SizedBox(width: 8),
          _buildStatusBadge(),
        ],
      );
    }
    
    return statusWidget;
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: pointOfSale.isActive 
            ? Colors.greenAccent.withOpacity(0.2) 
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        pointOfSale.isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 12.0,
          color: pointOfSale.isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('View on Map'),
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today_outlined,color: Colors.white,size: 20),
            label: const Text('Schedule Visit',style: TextStyle(color: Colors.white),),
            onPressed: () => _showScheduleDialog(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showScheduleDialog(BuildContext context) async {
    // Get current time
    final now = TimeOfDay.now();
    
    // Show time picker
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (selectedTime != null) {
      // Format date for today
      final today = DateTime.now();
      final dateFormat = DateFormat('MMM d');
      final formattedDate = dateFormat.format(today);
      
      // Format time 
      final hour = selectedTime.hour.toString().padLeft(2, '0');
      final minute = selectedTime.minute.toString().padLeft(2, '0');
      
      // Create formatted schedule string
      final scheduleString = 'Today, $hour:$minute';
      
      if (context.mounted) {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Schedule'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Store: ${pointOfSale.name}'),
                const SizedBox(height: 8),
                Text('Date: $formattedDate'),
                const SizedBox(height: 8),
                Text('Time: ${selectedTime.format(context)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<PointsOfSaleCubit>().scheduleVisit(
                        pointOfSale.name,
                        scheduleString,
                      );
                  Navigator.pop(context);
                  Navigator.pop(context);
                  
                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Visit scheduled for ${pointOfSale.name} at ${selectedTime.format(context)}'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Confirm',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      }
    }
  }
}