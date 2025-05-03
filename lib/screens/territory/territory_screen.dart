import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilis/widgets/territory/map_layer_item.dart';
import 'package:mobilis/widgets/territory/territory_stats_card.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import 'bloc/territory_cubit.dart';
import 'bloc/territory_state.dart';


class TerritoryScreen extends StatefulWidget {
  const TerritoryScreen({Key? key}) : super(key: key);

  @override
  State<TerritoryScreen> createState() => _TerritoryScreenState();
}

class _TerritoryScreenState extends State<TerritoryScreen> {
  final MapController _mapController = MapController();
  bool _isLayersMenuOpen = false;
  String _currentMapType = 'Default';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TerritoryCubit()..loadTerritoryData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Territory Map'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Handle notifications
              },
            ),
          ],
        ),
        body: BlocBuilder<TerritoryCubit, TerritoryState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Map
                      FlutterMap(
                        mapController: _mapController,
                        options: const MapOptions(
                          initialCenter: LatLng(36.7539, 3.0589), // Algiers coordinates
                          initialZoom: 13.0,
                          maxZoom: 18.0,
                          minZoom: 3.0,
                        ),
                        children: [
                          // Base tile layer
                          TileLayer(
                            urlTemplate: _currentMapType == 'Default' 
                              ? 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
                              : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          
                          // Zone Boundaries layer
                          if (state.showZoneBoundaries)
                            PolygonLayer(
                              polygons: state.zones.map((zone) {
                                return Polygon(
                                  points: zone.boundaries,
                                  color: zone.color.withOpacity(0.3),
                                  borderColor: zone.color,
                                  borderStrokeWidth: 2.0,
                                );
                              }).toList(),
                            ),
                          
                          // Points of Sale layer
                          if (state.showPointsOfSale)
                            MarkerLayer(
                              markers: state.pointsOfSale.map((pos) {
                                return Marker(
                                  width: 30.0,
                                  height: 30.0,
                                  point: pos.location,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                      
                                    ),
                                    child: const Icon(
                                      Icons.store,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          
                          // My Location marker
                          if (state.showMyLocation && state.currentLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 30.0,
                                  height: 30.0,
                                  point: state.currentLocation!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      
                      // Map controls
                      Positioned(
                        top: 16.0,
                        left: 16.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Map type selector
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  ChoiceChip(
                                    label: const Text('Default'),
                                    selected: _currentMapType == 'Default',
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _currentMapType = 'Default';
                                        });
                                      }
                                    },
                                    selectedColor: AppColors.primary.withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: _currentMapType == 'Default'
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  const SizedBox(width: 8.0),
                                  ChoiceChip(
                                    label: const Text('Satellite'),
                                    selected: _currentMapType == 'Heatmap',
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _currentMapType = 'Heatmap';
                                        });
                                      }
                                    },
                                    selectedColor: AppColors.primary.withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: _currentMapType == 'Heatmap'
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16.0),
                            
                            // Zoom controls
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      _mapController.move(
                                        _mapController.center,
                                        _mapController.zoom + 1,
                                      );
                                    },
                                  ),
                                  const Divider(height: 1.0, thickness: 1.0),
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      _mapController.move(
                                        _mapController.center,
                                        _mapController.zoom - 1,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Layers menu
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: _isLayersMenuOpen ? 200.0 : 50.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _isLayersMenuOpen
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.layers, color: AppColors.primary),
                                          const SizedBox(width: 8.0),
                                          const Text(
                                            'Layers',
                                            style: AppTextStyles.subheading,
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isLayersMenuOpen = false;
                                              });
                                            },
                                            child: const Icon(Icons.close, size: 20.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1.0, thickness: 1.0),
                                    MapLayerItem(
                                      title: 'My Location',
                                      icon: Icons.my_location,
                                      isActive: state.showMyLocation,
                                      onToggle: (value) {
                                        context.read<TerritoryCubit>().toggleMyLocation(value);
                                      },
                                    ),
                                    MapLayerItem(
                                      title: 'Boundaries',
                                      icon: Icons.grid_on,
                                      isActive: state.showZoneBoundaries,
                                      onToggle: (value) {
                                        context.read<TerritoryCubit>().toggleZoneBoundaries(value);
                                      },
                                    ),
                                    MapLayerItem(
                                      title: 'PDVs',
                                      icon: Icons.store,
                                      isActive: state.showPointsOfSale,
                                      onToggle: (value) {
                                        context.read<TerritoryCubit>().togglePointsOfSale(value);
                                      },
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isLayersMenuOpen = true;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(Icons.layers, color: AppColors.primary),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Stats Cards
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TerritoryStatsCard(
                        value: state.assignedZones.toString(),
                        label: 'Assigned Zones',
                        valueColor: AppColors.primary,
                      ),
                      TerritoryStatsCard(
                        value: state.totalPointsOfSale.toString(),
                        label: 'Total POS',
                        valueColor: AppColors.primary,
                      ),
                      TerritoryStatsCard(
                        value: '${state.coverageRate}%',
                        label: 'Coverage Rate',
                        valueColor: AppColors.primary,
                      ),
                      TerritoryStatsCard(
                        value: state.dailyAvgVisits.toString(),
                        label: 'Daily Avg Visits',
                        valueColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}