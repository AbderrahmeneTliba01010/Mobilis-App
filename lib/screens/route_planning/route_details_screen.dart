// route_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../models/visit_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/text_styles.dart';
import 'bloc/route_details_cubit.dart';
import 'bloc/route_details_state.dart';

class RouteDetailsScreen extends StatefulWidget {
  final List<Visit> visits;

  const RouteDetailsScreen({
    Key? key,
    required this.visits,
  }) : super(key: key);

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  // State variable for panel collapsed status
  bool _isDirectionsPanelCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RouteDetailsCubit()..loadRouteDetails(widget.visits),
      child: Scaffold(
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
        body: BlocBuilder<RouteDetailsCubit, RouteDetailsState>(
          builder: (context, state) {
            if (state.status == RouteDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == RouteDetailsStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Failed to load route details',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<RouteDetailsCubit>()
                            .loadRouteDetails(widget.visits);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                if (state.routeDirections.isNotEmpty)
                  _buildCollapsibleDirectionsPanel(context, state),
                Expanded(
                  child: _buildMap(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollapsibleDirectionsPanel(BuildContext context, RouteDetailsState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with toggle button
          InkWell(
            onTap: () {
              setState(() {
                _isDirectionsPanelCollapsed = !_isDirectionsPanelCollapsed;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.routeSummary,
                          style: AppTextStyles.subheading,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.totalDistance} km, ${state.totalDuration} min',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isDirectionsPanelCollapsed 
                        ? Icons.keyboard_arrow_down 
                        : Icons.keyboard_arrow_up,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          // Directions content
          if (!_isDirectionsPanelCollapsed) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDirectionsList(state),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDirectionsList(RouteDetailsState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.routeDirections.length > 5
          ? 5
          : state.routeDirections.length,
      itemBuilder: (context, index) {
        final direction = state.routeDirections[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getDirectionIcon(direction.type),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(direction.instruction, style: AppTextStyles.body),
                    if (direction.distance != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${direction.distance} m',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getDirectionIcon(DirectionType type) {
    IconData iconData;
    switch (type) {
      case DirectionType.start:
        iconData = Icons.trip_origin;
        break;
      case DirectionType.straight:
        iconData = Icons.arrow_upward;
        break;
      case DirectionType.turnRight:
        iconData = Icons.turn_right;
        break;
      case DirectionType.turnLeft:
        iconData = Icons.turn_left;
        break;
      case DirectionType.slightRight:
        iconData = Icons.turn_slight_right;
        break;
      case DirectionType.slightLeft:
        iconData = Icons.turn_slight_left;
        break;
      case DirectionType.destination:
        iconData = Icons.location_on;
        break;
    }
    
    return Icon(iconData, size: 18, color: AppColors.textSecondary);
  }

  Widget _buildMap(BuildContext context, RouteDetailsState state) {
    if (state.route.isEmpty) {
      return const Center(child: Text('Route not available'));
    }

    final cubit = context.read<RouteDetailsCubit>();

    return FlutterMap(
      mapController: cubit.mapController,
      options: MapOptions(
        initialCenter: state.route[state.route.length ~/ 2],
        initialZoom: 13,
      ),
      nonRotatedChildren: [
        Positioned(
          right: 10,
          top: 10,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: "zoomIn",
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
                onPressed: () => cubit.zoomIn(),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: "zoomOut",
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.remove),
                onPressed: () => cubit.zoomOut(),
              ),
            ],
          ),
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Updated URL without subdomains
          // The warnings in logs suggest avoiding subdomains with OSM's tile server
          // subdomains: const ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: state.route,
              strokeWidth: 4.0,
              color: AppColors.primary,
            ),
          ],
        ),
        MarkerLayer(
          markers: _buildMarkers(state),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers(RouteDetailsState state) {
    final markers = <Marker>[];
    
    // Add visit markers
    for (int i = 0; i < state.visitPoints.length; i++) {
      markers.add(
        Marker(
          point: state.visitPoints[i],
          width: 40,
          height: 40,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Center(
              child: Text(
                (i + 1).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return markers;
  }
}