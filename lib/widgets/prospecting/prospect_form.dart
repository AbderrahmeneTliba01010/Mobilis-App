import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/prospecting/bloc/prospecting_cubit.dart';
import '../../models/prospect_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';

class ProspectForm extends StatefulWidget {
  const ProspectForm({super.key});

  @override
  State<ProspectForm> createState() => _ProspectFormState();
}

class _ProspectFormState extends State<ProspectForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCommune;
  String? _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _currentLocation = "36.7235°N, 3.0804°E";

  final List<String> _communes = [
    'Bab Ezzouar',
    'Kouba',
    'Hydra',
    'Algiers',
    'Oran'
  ];
  final List<String> _categories = [
    'Electronics',
    'Mobile',
    'Telecom',
    'Mixed',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateLocation() {
    // In a real app, this would get the actual GPS coordinates
    setState(() {
      _currentLocation = "36.7235°N, 3.0804°E";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location updated')),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final prospect = Prospect(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        contactPerson: _contactPersonController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        commune: _selectedCommune ?? '',
        category: _selectedCategory ?? '',
        notes: _notesController.text,
        status: 'New',
        createdAt: DateTime.now(),
        location: _currentLocation,
      );

      context.read<ProspectingCubit>().addProspect(prospect);

      // Reset form
      _formKey.currentState!.reset();
      _nameController.clear();
      _contactPersonController.clear();
      _phoneController.clear();
      _addressController.clear();
      _notesController.clear();
      setState(() {
        _selectedCommune = null;
        _selectedCategory = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prospect added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              children: [
                _buildTab('Basic Info', isSelected: true),
                _buildTab('Business Details'),
                _buildTab('Location'),
              ],
            ),
            const SizedBox(height: 16),

            // Form fields
            _buildFormField(
              label: 'Point of Sale Name',
              controller: _nameController,
              isRequired: true,
              hintText: 'Enter POS name',
            ),

            _buildFormField(
              label: 'Contact Person',
              controller: _contactPersonController,
              hintText: 'Full name',
            ),

            _buildFormField(
              label: 'Phone Number',
              controller: _phoneController,
              isRequired: true,
              hintText: '+213 XXX XXX XXX',
            ),

            _buildFormField(
              label: 'Address',
              controller: _addressController,
              isRequired: true,
              hintText: 'Street address',
            ),

            _buildDropdownField(
              label: 'Commune',
              value: _selectedCommune,
              items: _communes,
              hintText: 'Select Commune',
              isRequired: true,
              onChanged: (value) {
                setState(() {
                  _selectedCommune = value;
                });
              },
            ),

            // Current location
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Current Location',
                        style: AppTextStyles.bodySmall
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(_currentLocation, style: AppTextStyles.bodySmall),
                      const SizedBox(width: 3),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Update'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)), 
                      ),
                    ),
                    onPressed: _updateLocation,
                  ),
                ],
              ),
            ),

            // Take photo button
            OutlinedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take photo of the POS'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                  minimumSize: const Size(double.infinity, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )),
              onPressed: () {
                // In a real app, this would open the camera
              },
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: 'POS Category',
              value: _selectedCategory,
              items: _categories,
              hintText: 'Select Category',
              isRequired: true,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),

            _buildFormField(
              label: 'Notes',
              controller: _notesController,
              hintText: 'Additional information about this prospect...',
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Prospect'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        )),
                    onPressed: _submitForm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, {bool isSelected = false}) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              child: Text(
                title,
                style: isSelected
                    ? AppTextStyles.body.copyWith(color: AppColors.primary)
                    : AppTextStyles.body,
              ),
            ),
          ),
          Container(
            height: 2,
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: label, style: AppTextStyles.body),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            maxLines: maxLines,
            validator: isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hintText,
    required Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: label, style: AppTextStyles.body),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonFormField<String>(
              value: value,
              isExpanded: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: InputBorder.none,
              ),
              hint: Text(hintText),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              validator: isRequired
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
