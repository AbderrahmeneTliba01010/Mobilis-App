import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/settings/bloc/settings_cubit.dart';
import 'package:mobilis/screens/settings/bloc/settings_state.dart';
import 'package:mobilis/widgets/settings/dropdown_settings_tile.dart';
import 'package:mobilis/widgets/settings/profile_card.dart';
import 'package:mobilis/widgets/settings/settings_section.dart';
import 'package:mobilis/widgets/settings/settings_tile.dart';
import 'package:mobilis/widgets/settings/toggle_settings_tile.dart';
import '../../models/user_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.sampleUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 16,
            child: Text(
              user.avatarInitials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocProvider(
        create: (_) => SettingsCubit(),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProfileCard(user: user),
                const SizedBox(height: 16),

                // Account Settings
                SettingsSection(
                  title: 'Account Settings',
                  icon: Icons.person_outline,
                  children: [
                    SettingsTile(
                      icon: Icons.phone_outlined,
                      title: 'Phone Number',
                      subtitle: user.phone,
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.email_outlined,
                      title: 'Email Address',
                      subtitle: user.email,
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Application Settings
                SettingsSection(
                  title: 'Application Settings',
                  icon: Icons.settings_outlined,
                  children: [
                    DropdownSettingsTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      value: state.selectedLanguage,
                      onChanged: (value) {
                        if (value != null) {
                          cubit.changeLanguage(value);
                        }
                      },
                      items: const ['English', 'Français', 'العربية'],
                    ),
                    const Divider(height: 1),
                    ToggleSettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Receive alerts about visits and messages',
                      value: state.notificationsEnabled,
                      onChanged: cubit.toggleNotifications,
                    ),
                    const Divider(height: 1),
                    ToggleSettingsTile(
                      icon: Icons.location_on_outlined,
                      title: 'Location Services',
                      subtitle: 'Allow app to access your location',
                      value: state.locationEnabled,
                      onChanged: cubit.toggleLocation,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Map Settings
                SettingsSection(
                  title: 'Map Settings',
                  icon: Icons.map_outlined,
                  children: [
                    DropdownSettingsTile(
                      icon: Icons.map_outlined,
                      title: 'Default Map View',
                      value: state.defaultMapView,
                      onChanged: (value) {
                        if (value != null) {
                          cubit.changeMapView(value);
                        }
                      },
                      items: const ['Street', 'Satellite', 'Terrain'],
                    ),
                    const Divider(height: 1),
                    DropdownSettingsTile(
                      icon: Icons.route_outlined,
                      title: 'Route Calculation',
                      subtitle: 'Default optimization method',
                      value: state.routeCalculation,
                      onChanged: (value) {
                        if (value != null) {
                          cubit.changeRouteCalculation(value);
                        }
                      },
                      items: const ['Distance', 'Time', 'Fuel Efficiency'],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Synchronization
                SettingsSection(
                  title: 'Synchronization',
                  icon: Icons.sync_outlined,
                  children: [
                    ToggleSettingsTile(
                      icon: Icons.sync_outlined,
                      title: 'Auto-sync Data',
                      subtitle: 'Keep data updated automatically',
                      value: state.autoSyncEnabled,
                      onChanged: cubit.toggleAutoSync,
                    ),
                    const Divider(height: 1),
                    DropdownSettingsTile(
                      icon: Icons.timer_outlined,
                      title: 'Sync Frequency',
                      subtitle: 'How often data is synchronized',
                      value: state.syncFrequency,
                      onChanged: (value) {
                        if (value != null) {
                          cubit.changeSyncFrequency(value);
                        }
                      },
                      items: const [
                        'Every 15 mins',
                        'Every 30 mins',
                        'Every hour',
                        'Manual only'
                      ],
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.sync_outlined,
                      title: 'Sync Now',
                      subtitle: 'Last sync: Today, 10:45 AM',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SettingsSection(
                  title: 'Account Actions',
                  icon: Icons.warning_amber_outlined,
                  children: [
                    SettingsTile(
                      icon: Icons.logout_outlined,
                      title: 'Sign Out',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.delete_outline,
                      title: 'Reset Account Data',
                      subtitle: 'Clear all personal data',
                      titleColor: Colors.red,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
