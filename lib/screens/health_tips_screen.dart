import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({Key? key}) : super(key: key);

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final Map<String, List<Map<String, dynamic>>> _tipsByCategory = {
    'Normal': [
      {
        'title': 'Maintain Healthy Habits',
        'description': 'Continue with regular exercise and balanced diet to maintain your ideal BMI.',
        'icon': Icons.favorite,
        'color': AppColors.normalBMI,
      },
      {
        'title': 'Exercise Regularly',
        'description': 'Aim for at least 150 minutes of moderate aerobic activity per week.',
        'icon': Icons.directions_run,
        'color': AppColors.normalBMI,
      },
      {
        'title': 'Drink Enough Water',
        'description': 'Stay hydrated by drinking 8-10 glasses of water daily.',
        'icon': Icons.local_drink,
        'color': AppColors.normalBMI,
      },
      {
        'title': 'Get Enough Sleep',
        'description': 'Aim for 7-9 hours of quality sleep every night.',
        'icon': Icons.nights_stay,
        'color': AppColors.normalBMI,
      },
      {
        'title': 'Eat Balanced Meals',
        'description': 'Include fruits, vegetables, whole grains, and lean proteins in your diet.',
        'icon': Icons.restaurant_menu,
        'color': AppColors.normalBMI,
      },
    ],
    'Overweight': [
      {
        'title': 'Reduce Sugar Intake',
        'description': 'Limit sugary drinks and desserts. Replace with water and natural alternatives.',
        'icon': Icons.no_drinks,
        'color': AppColors.overweightBMI,
      },
      {
        'title': 'Increase Daily Activity',
        'description': 'Take stairs instead of elevators, walk more, and avoid prolonged sitting.',
        'icon': Icons.directions_walk,
        'color': AppColors.overweightBMI,
      },
      {
        'title': 'Sleep Properly',
        'description': 'Poor sleep disrupts metabolism. Aim for consistent 7-8 hours daily.',
        'icon': Icons.nights_stay,
        'color': AppColors.overweightBMI,
      },
      {
        'title': 'Portion Control',
        'description': 'Use smaller plates and bowls to help with portion control naturally.',
        'icon': Icons.restaurant,
        'color': AppColors.overweightBMI,
      },
      {
        'title': 'Avoid Fast Food',
        'description': 'Minimize processed and fast foods. Cook meals at home for better control.',
        'icon': Icons.fastfood,
        'color': AppColors.overweightBMI,
      },
    ],
    'Underweight': [
      {
        'title': 'Increase Protein Intake',
        'description': 'Eat more chicken, fish, eggs, beans, and nuts for healthy weight gain.',
        'icon': Icons.egg,
        'color': AppColors.underweightBMI,
      },
      {
        'title': 'Eat Calorie-Rich Foods',
        'description': 'Include healthy fats like avocados, nuts, and olive oil in your diet.',
        'icon': Icons.restaurant,
        'color': AppColors.underweightBMI,
      },
      {
        'title': 'Have Frequent Meals',
        'description': 'Eat 5-6 smaller meals throughout the day instead of 3 large ones.',
        'icon': Icons.restaurant_menu,
        'color': AppColors.underweightBMI,
      },
      {
        'title': 'Strength Training',
        'description': 'Include resistance exercises to build muscle mass, not just fat.',
        'icon': Icons.fitness_center,
        'color': AppColors.underweightBMI,
      },
      {
        'title': 'Use Supplements',
        'description': 'Consider weight gainer supplements, but consult a nutritionist first.',
        'icon': Icons.local_pharmacy,
        'color': AppColors.underweightBMI,
      },
    ],
    'Obese': [
      {
        'title': 'Start with Small Steps',
        'description': 'Begin with 10-15 minute walks daily and gradually increase duration.',
        'icon': Icons.directions_walk,
        'color': AppColors.obeseBMI,
      },
      {
        'title': 'Cut Calorie Intake',
        'description': 'Aim for a 500 calorie deficit per day for safe weight loss of 1kg/week.',
        'icon': Icons.remove,
        'color': AppColors.obeseBMI,
      },
      {
        'title': 'Drink More Water',
        'description': 'Drink water before meals to feel fuller and support metabolism.',
        'icon': Icons.water_drop,
        'color': AppColors.obeseBMI,
      },
      {
        'title': 'Consult a Professional',
        'description': 'Talk to a doctor or nutritionist for personalized guidance.',
        'icon': Icons.local_hospital,
        'color': AppColors.obeseBMI,
      },
      {
        'title': 'Track Your Progress',
        'description': 'Monitor weight, BMI, and measurements to celebrate small victories.',
        'icon': Icons.trending_down,
        'color': AppColors.obeseBMI,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Health Tips',
          style: AppTextStyles.title1,
        ),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, _) {
          final latestRecord = appState.getLatestRecord();
          final category = latestRecord?.category ?? 'Normal';
          final recommendedTips = _tipsByCategory[category] ?? _tipsByCategory['Normal']!;
          final otherCategories = _tipsByCategory.keys.where((k) => k != category).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.getGradientByCategory(category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        category == 'Normal'
                            ? Icons.check_circle
                            : category == 'Overweight'
                                ? Icons.warning
                                : category == 'Underweight'
                                    ? Icons.info
                                    : Icons.error,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your BMI Category',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            category,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Tips
                Text('Recommended For You', style: AppTextStyles.title2),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recommendedTips.length,
                  itemBuilder: (context, index) {
                    final tip = recommendedTips[index];
                    return _buildTipCard(
                      tip['title'] as String,
                      tip['description'] as String,
                      tip['icon'] as IconData,
                      tip['color'] as Color,
                      index,
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                Text('Other Health Tips', style: AppTextStyles.title2),
                const SizedBox(height: 12),
                ...otherCategories.map((otherCategory) {
                   return Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('$otherCategory BMI Tips', style: AppTextStyles.title3),
                       const SizedBox(height: 12),
                       ..._tipsByCategory[otherCategory]!.map((tip) => _buildTipCard(
                         tip['title'] as String,
                         tip['description'] as String,
                         tip['icon'] as IconData,
                         tip['color'] as Color,
                         0,
                       )).toList(),
                       const SizedBox(height: 16),
                     ],
                   );
                }).toList(),
                const SizedBox(height: 20),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'These tips are general guidelines. For personalized advice, consult a healthcare professional.',
                          style: AppTextStyles.caption1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipCard(
    String title,
    String description,
    IconData icon,
    Color color,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AnimatedBuilder(
        animation: AlwaysStoppedAnimation(0.0),
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.title3,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: AppTextStyles.body3,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
