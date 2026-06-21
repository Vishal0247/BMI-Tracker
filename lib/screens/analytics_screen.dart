import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/app_state.dart';
import '../models/bmi_record.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedChartIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Analytics',
          style: AppTextStyles.title1,
        ),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, _) {
          final allRecords = appState.getAllRecords();

          if (allRecords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Data Available',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Calculate your BMI to see analytics',
                    style: AppTextStyles.body3,
                  ),
                ],
              ),
            );
          }

          final weeklyRecords = appState.getWeeklyRecords();
          final monthlyRecords = appState.getMonthlyRecords();
          final averageBMI = appState.getAverageBMI();
          final latestRecord = appState.getLatestRecord();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Current BMI',
                        latestRecord?.bmi.toStringAsFixed(1) ?? '0',
                        latestRecord?.category ?? 'N/A',
                        AppColors.getColorByCategory(latestRecord?.category ?? 'Normal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Average BMI',
                        averageBMI?.toStringAsFixed(1) ?? '0',
                        'All Time',
                        AppColors.primaryStart,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Goal Progress
                if (appState.targetWeight != null && latestRecord != null) ...[
                  _buildGoalProgress(appState.targetWeight!, latestRecord.weight, appState.unitSystem),
                  const SizedBox(height: 20),
                ],

                // Chart Selection
                Row(
                  children: [
                    _buildChartButton('Weekly', 0),
                    const SizedBox(width: 12),
                    _buildChartButton('Monthly', 1),
                  ],
                ),
                const SizedBox(height: 20),

                // Charts
                if (_selectedChartIndex == 0)
                  _buildWeeklyChart(weeklyRecords)
                else
                  _buildMonthlyChart(monthlyRecords),

                const SizedBox(height: 32),

                // Records Count by Category
                _buildCategoryStats(allRecords),

                const SizedBox(height: 32),

                // Latest Records
                _buildLatestRecords(allRecords),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(double targetWeight, double currentWeight, String unitSystem) {
    final diff = currentWeight - targetWeight;
    final absDiff = diff.abs();
    final unitLabel = unitSystem == 'metric' ? 'kg' : 'lbs';
    final actionText = diff > 0 ? 'to lose' : (diff < 0 ? 'to gain' : 'Goal reached!');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryStart.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Goal Progress', style: AppTextStyles.title3),
              const Icon(Icons.flag, color: AppColors.primaryStart),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Target Weight', style: AppTextStyles.caption1),
                  const SizedBox(height: 4),
                  Text('${targetWeight.toStringAsFixed(1)} $unitLabel', style: AppTextStyles.body1),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Remaining', style: AppTextStyles.caption1),
                  const SizedBox(height: 4),
                  Text(
                    '${absDiff.toStringAsFixed(1)} $unitLabel $actionText', 
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryStart,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartButton(String label, int index) {
    final isSelected = _selectedChartIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedChartIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(List<BMIRecord> records) {
    if (records.isEmpty) {
      return Center(
        child: Text(
          'No weekly data',
          style: AppTextStyles.body3,
        ),
      );
    }

    final sortedRecords = records.reversed.toList();
    final spots = sortedRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.bmi);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly BMI Trend',
            style: AppTextStyles.title3,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < sortedRecords.length) {
                          return Text(
                            '${sortedRecords[value.toInt()].dateTime.day}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryStart,
                        AppColors.primaryEnd,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primaryStart,
                          strokeWidth: 2,
                          strokeColor: AppColors.cardBackground,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryStart.withValues(alpha: 0.3),
                          AppColors.primaryStart.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart(List<BMIRecord> records) {
    if (records.isEmpty) {
      return Center(
        child: Text(
          'No monthly data',
          style: AppTextStyles.body3,
        ),
      );
    }

    final sortedRecords = records.reversed.toList();
    final spots = sortedRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.bmi);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly BMI Trend',
            style: AppTextStyles.title3,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < sortedRecords.length &&
                            value.toInt() % 3 == 0) {
                          return Text(
                            '${sortedRecords[value.toInt()].dateTime.day}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryStart,
                        AppColors.primaryEnd,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.primaryStart,
                          strokeWidth: 2,
                          strokeColor: AppColors.cardBackground,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryStart.withValues(alpha: 0.3),
                          AppColors.primaryStart.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStats(List<BMIRecord> records) {
    final categories = {'Normal': 0, 'Overweight': 0, 'Obese': 0, 'Underweight': 0};
    for (var record in records) {
      categories[record.category] = (categories[record.category] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Records by Category',
            style: AppTextStyles.title3,
          ),
          const SizedBox(height: 16),
          ...categories.entries.map((entry) {
            final percentage = (entry.value / records.length * 100).toStringAsFixed(1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.key} (${entry.value})',
                        style: AppTextStyles.body3,
                      ),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryStart,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: entry.value / records.length,
                      minHeight: 6,
                      backgroundColor: AppColors.textSecondary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.getColorByCategory(entry.key),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLatestRecords(List<BMIRecord> records) {
    final latest = records.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Records',
            style: AppTextStyles.title3,
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: latest.length,
            separatorBuilder: (_, __) => Divider(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              height: 16,
            ),
            itemBuilder: (context, index) {
              final record = latest[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.formattedDate,
                        style: AppTextStyles.caption1,
                      ),
                      Text(
                        record.category,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getColorByCategory(record.category),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    record.bmi.toStringAsFixed(1),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryStart,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
