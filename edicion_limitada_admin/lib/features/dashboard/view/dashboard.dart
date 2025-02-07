// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _selectedTimeFrame = 'daily';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  

  List<Map<String, dynamic>>? _cachedOrders;

 bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

 

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return  Scaffold(
        body: Center(child:Lottie.asset('image/dashboardLottie.json')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Dashboard'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDateFilter(),
              _buildTimeFrameSelector(),
              if (_cachedOrders != null) ...[
                _buildSummaryCards(_cachedOrders!),
                Container(
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  child: _buildSalesChart(_cachedOrders!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

   Future<void> _fetchData() async {
   setState(() => _isLoading = true);
    
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: _startDate)
          .where('createdAt', isLessThanOrEqualTo: _endDate)
          .orderBy('createdAt')
          .get(); // Using get() instead of stream

      _cachedOrders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'totalAmount': (data['totalAmount'] ?? 0.0) as double,
          'createdAt': (data['createdAt'] as Timestamp).toDate(),
          'orderCount': 1,
        };
      }).toList();

      if (mounted) {
      setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
       setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(DateFormat('MMM dd, yyyy').format(_startDate)),
              onPressed: () => _selectDate(true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('to'),
          ),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(DateFormat('MMM dd, yyyy').format(_endDate)),
              onPressed: () => _selectDate(false),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'daily', label: Text('Daily')),
          ButtonSegment(value: 'weekly', label: Text('Weekly')),
          ButtonSegment(value: 'monthly', label: Text('Monthly')),
        ],
        selected: {_selectedTimeFrame},
        onSelectionChanged: (Set<String> selection) {
          setState(() {
            _selectedTimeFrame = selection.first;
          });
        },
      ),
    );
  }

  Widget _buildSummaryCards(List<Map<String, dynamic>> orders) {
    double totalSales = 0;
    int totalOrders = orders.length;

    for (var order in orders) {
      totalSales += order['totalAmount'] as double;
    }

    double averageOrder = totalOrders > 0 ? totalSales / totalOrders : 0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildSummaryCard(
            'Total Sales',
            '\$${NumberFormat('#,##0.00').format(totalSales)}',
            Icons.attach_money,
            Colors.green,
          ),
          _buildSummaryCard(
            'Total Orders',
            totalOrders.toString(),
            Icons.shopping_cart,
            Colors.blue,
          ),
          _buildSummaryCard(
            'Average Order',
            '\$${NumberFormat('#,##0.00').format(averageOrder)}',
            Icons.analytics,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart(List<Map<String, dynamic>> orders) {
    final groupedData = _groupSalesData(orders);
    final spots = groupedData.entries.map((entry) {
      return FlSpot(
        entry.key.millisecondsSinceEpoch.toDouble(),
        entry.value,
      );
    }).toList();

    if (spots.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _getValueInterval(spots),
          verticalInterval: _getDateInterval(),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: _getDateInterval(),
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _getFormattedDate(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: _getValueInterval(spots),
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${NumberFormat('#,##0').format(value)}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            dotData: FlDotData(show: spots.length < 30),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
         //   tooltipBgColor: Theme.of(context).cardColor,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                return LineTooltipItem(
                  '${_getFormattedDate(date)}\n\$${NumberFormat('#,##0.00').format(spot.y)}',
                  TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  // Rest of the utility methods remain the same
  Map<DateTime, double> _groupSalesData(List<Map<String, dynamic>> orders) {
    final groupedData = <DateTime, double>{};
    
    for (final order in orders) {
      final date = _normalizeDate(order['createdAt'] as DateTime);
      groupedData[date] = (groupedData[date] ?? 0) + (order['totalAmount'] as double);
    }
    
    return Map.fromEntries(
      groupedData.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
  }

  DateTime _normalizeDate(DateTime date) {
    switch (_selectedTimeFrame) {
      case 'daily':
        return DateTime(date.year, date.month, date.day);
      case 'weekly':
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        return DateTime(weekStart.year, weekStart.month, weekStart.day);
      case 'monthly':
        return DateTime(date.year, date.month);
      default:
        return date;
    }
  }

  String _getFormattedDate(DateTime date) {
    switch (_selectedTimeFrame) {
      case 'daily':
        return DateFormat('MMM d').format(date);
      case 'weekly':
        return DateFormat('MMM d').format(date);
      case 'monthly':
        return DateFormat('MMM yyyy').format(date);
      default:
        return DateFormat('MMM d').format(date);
    }
  }

  double _getDateInterval() {
    switch (_selectedTimeFrame) {
      case 'daily':
        return const Duration(days: 1).inMilliseconds.toDouble();
      case 'weekly':
        return const Duration(days: 7).inMilliseconds.toDouble();
      case 'monthly':
        return const Duration(days: 30).inMilliseconds.toDouble();
      default:
        return const Duration(days: 1).inMilliseconds.toDouble();
    }
  }

  double _getValueInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1000;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return (maxY / 5).roundToDouble();
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _fetchData(); // Refresh data when date changes
    }
  }
}