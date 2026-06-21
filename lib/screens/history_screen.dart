import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/bmi_record.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late TextEditingController _searchController;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Normal', 'Overweight', 'Obese', 'Underweight'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BMIRecord> _getFilteredRecords(List<BMIRecord> records) {
    List<BMIRecord> filtered = records;

    // Filter by category
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((record) => record.category == _selectedFilter)
          .toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((record) =>
              record.weight
                  .toString()
                  .contains(_searchController.text) ||
              record.height.toString().contains(_searchController.text) ||
              record.bmi.toString().contains(_searchController.text))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'BMI History',
          style: AppTextStyles.title1,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.cardBackground,
                  title: Text(
                    'Clear History?',
                    style: AppTextStyles.title2,
                  ),
                  content: Text(
                    'Are you sure you want to delete all records?',
                    style: AppTextStyles.body2,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<AppStateProvider>()
                            .clearAllRecords();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, _) {
          final records = appState.getAllRecords();

          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Records Yet',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Calculate your BMI to see history',
                    style: AppTextStyles.body3,
                  ),
                ],
              ),
            );
          }

          final filteredRecords = _getFilteredRecords(records);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: AppTextStyles.body1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search by weight, height, BMI...',
                      hintStyle: AppTextStyles.body3,
                      prefixIcon: const Icon(Icons.search,
                          color: AppColors.textSecondary),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions
                        .map((filter) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: _selectedFilter == filter
                                        ? AppColors.primaryGradient
                                        : null,
                                    color: _selectedFilter == filter
                                        ? null
                                        : AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedFilter == filter
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Records
                if (filteredRecords.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No records found',
                        style: AppTextStyles.body3,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                      return Dismissible(
                        key: Key(record.key.toString()),
                        background: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          context
                              .read<AppStateProvider>()
                              .deleteRecord(records.indexOf(record));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Record deleted')),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: AppColors.getGradientByCategory(
                                      record.category),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    record.bmi.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.category,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.getColorByCategory(
                                            record.category),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${record.formattedDate} at ${record.formattedTime}',
                                      style: AppTextStyles.caption1,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${record.weight}kg • ${record.height}cm',
                                      style: AppTextStyles.body3,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton(
                                color: AppColors.cardBackground,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Delete'),
                                    onTap: () {
                                      context
                                          .read<AppStateProvider>()
                                          .deleteRecord(records.indexOf(record));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
