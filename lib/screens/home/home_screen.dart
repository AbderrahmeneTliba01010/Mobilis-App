// home_screen.dart (add this to your screens directory)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/visit_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/territory/territory_stats_card.dart';
import 'bloc/home_cubit.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _VisitStatus {
    completed,
    pending,
    missed,
  }

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _visitTabController;

  
  
  @override
  void initState() {
    super.initState();
    _visitTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _visitTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadDashboardData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sales Representatives app'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 16,
                child: Text(
                  'JD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return _buildContent(context, state);
            } else if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(state),
            const SizedBox(height: 16),
            _buildPerformanceStatsCard(state.weeklyPerformance),
            const SizedBox(height: 16),
            _buildFieldOperationsMap(),
            const SizedBox(height: 16),
            _buildVisitManagement(state.visits),
          ],
        ),
      ),
    );
  }

 Widget _buildSummaryCard(HomeLoaded state) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Summary section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Summary", style: AppTextStyles.subheading),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMMM d, yyyy').format(DateTime.now()),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Today's stats - top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TerritoryStatsCard(
                value: "${state.visitsCompleted}/${state.totalVisits}",
                label: "Visits Completed",
                valueColor: AppColors.primary,
              ),
              TerritoryStatsCard(
                value: "${state.newProspects}",
                label: "New Prospects",
                valueColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Today's stats - bottom row with distance and field time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TerritoryStatsCard(
                value: "${state.distanceTraveled}km",
                label: "Distance\nTraveled",
                valueColor: AppColors.textPrimary,
              ),
              TerritoryStatsCard(
                value: "${state.fieldTime.split(':')[0]}:${state.fieldTime.split(':')[1]}h",
                label: "Total Field\nTime",
                valueColor: AppColors.textPrimary,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Territory Coverage section - separate
          const Text("Territory Coverage", style: AppTextStyles.subheading),
          const SizedBox(height: 16),
          
          // Chart and legend in a row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Coverage chart
              SizedBox(
                width: 120,
                height: 120,
                child: _buildCoverageChart(state),
              ),
              const SizedBox(width: 20),
              
              // Legend
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendItem(Colors.green, "Visited"),
                  const SizedBox(height: 8),
                  _buildLegendItem(Colors.amber, "Pending"),
                  const SizedBox(height: 8),
                  _buildLegendItem(Colors.grey, "Missed"),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Helper method to build a legend item
Widget _buildLegendItem(Color color, String label) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: AppTextStyles.bodySmall,
      ),
    ],
  );
}

  Widget _buildCoverageChart(HomeLoaded state) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 30,
            sections: [
              PieChartSectionData(
                color: Colors.green,
                value: state.coverageStats.visited,
                title: '',
                radius: 15,
              ),
              PieChartSectionData(
                color: Colors.amber,
                value: state.coverageStats.pending,
                title: '',
                radius: 15,
              ),
              PieChartSectionData(
                color: Colors.grey,
                value: state.coverageStats.missed,
                title: '',
                radius: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceStatsCard(List<int> weeklyStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Performance Stats", style: AppTextStyles.subheading),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barGroups: _getBarGroups(weeklyStats),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 5,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: AppColors.divider,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                          return Text(
                            days[value.toInt()],
                            style: AppTextStyles.bodySmall,
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const Text('');
                          return Text(
                            '${value.toInt()}',
                            style: AppTextStyles.bodySmall,
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<int> data) {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].toDouble(),
            color: AppColors.primary,
            width: 15,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFieldOperationsMap() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Field Operations Map", style: AppTextStyles.subheading),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.layers, size: 16, color: AppColors.secondary),
                          SizedBox(width: 4),
                          Text("Layers", style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.my_location, size: 16, color: AppColors.secondary),
                          SizedBox(width: 4),
                          Text("My Location", style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 240,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(36.7525, 3.0420), // Algiers coordinates
                zoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                const MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(36.7525, 3.0420),
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitManagement(List<Visit> visits) {
    // Categorize visits
    final todayVisits = visits.where((v) => _isVisitToday(v.startTime)).toList();
    final tomorrowVisits = visits.where((v) => _isVisitTomorrow(v.startTime)).toList();
    final weekVisits = visits.where((v) => !_isVisitToday(v.startTime) && !_isVisitTomorrow(v.startTime)).toList();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Visit Management", style: AppTextStyles.subheading),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16,color: Colors.white,),
                  label: const Text("Add Visit",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _visitTabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: "Today"),
              Tab(text: "Tomorrow"),
              Tab(text: "Week"),
            ],
          ),
          SizedBox(
            height: 300, // Fixed height for visit list
            child: TabBarView(
              controller: _visitTabController,
              children: [
                _buildVisitList(todayVisits),
                _buildVisitList(tomorrowVisits),
                _buildVisitList(weekVisits),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitList(List<Visit> visits) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: visits.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final visit = visits[index];
        final visitStatus = _getVisitStatus(visit.startTime, visit.endTime);
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getStatusColor(visitStatus),
            radius: 6,
          ),
          title: Text(visit.name, style: AppTextStyles.subheading),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${visit.startTime} - ${visit.endTime}',
                style: AppTextStyles.bodySmall,
              ),
              Text(
                _getStatusText(visitStatus),
                style: AppTextStyles.bodySmall.copyWith(
                  color: _getStatusColor(visitStatus),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (visitStatus == _VisitStatus.pending)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Check In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.more_vert, color: AppColors.textSecondary),
            ],
          ),
        );
      },
    );
  }

  // Helper enum for visit status
  

  _VisitStatus _getVisitStatus(String startTimeStr, String endTimeStr) {
    // Parse the time strings assuming they're in format like "09:30"
    final now = DateTime.now();
    final startTime = _parseTimeString(startTimeStr);
    final endTime = _parseTimeString(endTimeStr);
    
    final startDateTime = DateTime(
      now.year, 
      now.month, 
      now.day, 
      startTime.hour, 
      startTime.minute
    );
    
    final endDateTime = DateTime(
      now.year, 
      now.month, 
      now.day, 
      endTime.hour, 
      endTime.minute
    );
    
    if (now.isAfter(endDateTime)) {
      return _VisitStatus.completed;
    } else if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
      return _VisitStatus.pending;
    } else {
      return _VisitStatus.pending; // Upcoming visits are also pending
    }
  }

  TimeOfDay _parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  bool _isVisitToday(String startTimeStr) {
    // For demonstration purposes - in a real app, you'd check the actual date
    return true; // Just for demo
  }

  bool _isVisitTomorrow(String startTimeStr) {
    // For demonstration purposes
    return false; // Just for demo, assign visits to today
  }

  Color _getStatusColor(_VisitStatus status) {
    switch (status) {
      case _VisitStatus.completed:
        return Colors.green;
      case _VisitStatus.pending:
        return Colors.amber;
      case _VisitStatus.missed:
        return Colors.grey;
    }
  }

  String _getStatusText(_VisitStatus status) {
    switch (status) {
      case _VisitStatus.completed:
        return 'Completed';
      case _VisitStatus.pending:
        return 'Pending';
      case _VisitStatus.missed:
        return 'Missed';
    }
  }
}