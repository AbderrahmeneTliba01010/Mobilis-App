import 'package:bloc/bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(const SettingsState(
          notificationsEnabled: true,
          locationEnabled: true,
          autoSyncEnabled: true,
          selectedLanguage: 'English',
          defaultMapView: 'Street',
          routeCalculation: 'Distance',
          syncFrequency: 'Every 15 mins',
        ));

  void toggleNotifications(bool isEnabled) {
    emit(state.copyWith(notificationsEnabled: isEnabled));
  }

  void toggleLocation(bool isEnabled) {
    emit(state.copyWith(locationEnabled: isEnabled));
  }

  void toggleAutoSync(bool isEnabled) {
    emit(state.copyWith(autoSyncEnabled: isEnabled));
  }

  void changeLanguage(String language) {
    emit(state.copyWith(selectedLanguage: language));
  }

  void changeMapView(String mapView) {
    emit(state.copyWith(defaultMapView: mapView));
  }

  void changeRouteCalculation(String method) {
    emit(state.copyWith(routeCalculation: method));
  }

  void changeSyncFrequency(String frequency) {
    emit(state.copyWith(syncFrequency: frequency));
  }
}
