// app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_navigation_screen.dart';
import 'screens/route_planning/bloc/route_planning_cubit.dart';
import 'screens/route_planning/route_details_screen.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoutePlanningCubit>(
          create: (context) => RoutePlanningCubit(),
        ),
        // Add other cubits as needed
      ],
      child: MaterialApp(
        title: 'Field Sales App',
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
        routes: {
          '/route-details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
            return RouteDetailsScreen(visits: args.cast());
          },
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/route-details') {
            final args = settings.arguments as List<dynamic>;
            return MaterialPageRoute(
              builder: (context) {
                return RouteDetailsScreen(visits: args.cast());
              },
            );
          }
          return null;
        },
      ),
    );
  }
}