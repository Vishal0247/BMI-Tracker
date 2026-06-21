import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../models/bmi_record.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/bmi_calculator.dart';
import '../widgets/animated_button.dart';
import '../widgets/custom_slider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gender_selector.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late AnimationController _fadeController;

  double _weight = 70;
  double _height = 170;
  String _gender = 'Male';
  int _age = 25;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: '70');
    _heightController = TextEditingController(text: '170');
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    try {
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text);

      if (weight <= 0 || height <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid weight and height'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      double bmi = BMICalculator.calculateBMI(weight, height);
      String category = BMICalculator.getBMICategory(bmi);

      // Create record
      final record = BMIRecord(
        dateTime: DateTime.now(),
        weight: weight,
        height: height,
        bmi: bmi,
        category: category,
        gender: _gender,
        age: _age,
      );

      // Add to history
      context.read<AppStateProvider>().addBMIRecord(record);

      // Navigate to result screen
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ResultScreen(bmiRecord: record),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0)
                      .animate(animation),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid numbers',
              style: AppTextStyles.body2),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                _buildWelcomeCard(),
                const SizedBox(height: 32),

                // Weight Input
                CustomSlider(
                  label: 'Weight',
                  value: _weight,
                  min: 20,
                  max: 200,
                  unit: 'kg',
                  divisions: 180,
                  onChanged: (value) {
                    setState(() {
                      _weight = value;
                      _weightController.text = value.toStringAsFixed(1);
                    });
                  },
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  label: 'Enter Weight',
                  hint: 'e.g., 70',
                  controller: _weightController,
                  unit: 'kg',
                  icon: Icons.monitor_weight,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _weight = double.tryParse(value) ?? _weight;
                      });
                    }
                  },
                ),
                const SizedBox(height: 28),

                // Height Input
                CustomSlider(
                  label: 'Height',
                  value: _height,
                  min: 100,
                  max: 250,
                  unit: 'cm',
                  divisions: 150,
                  onChanged: (value) {
                    setState(() {
                      _height = value;
                      _heightController.text = value.toStringAsFixed(1);
                    });
                  },
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  label: 'Enter Height',
                  hint: 'e.g., 170',
                  controller: _heightController,
                  unit: 'cm',
                  icon: Icons.height,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _height = double.tryParse(value) ?? _height;
                      });
                    }
                  },
                ),
                const SizedBox(height: 28),

                // Gender Selector
                GenderSelector(
                  selectedGender: _gender,
                  onChanged: (gender) {
                    setState(() {
                      _gender = gender;
                    });
                  },
                ),
                const SizedBox(height: 28),

                // Age Selector
                _buildAgeSelector(),
                const SizedBox(height: 36),

                // Calculate Button
                AnimatedGradientButton(
                  label: 'Calculate BMI',
                  onPressed: _calculateBMI,
                  height: 56,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good Morning!';
    } else if (hour < 17) {
      greeting = 'Good Afternoon!';
    } else {
      greeting = 'Good Evening!';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A11CB).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Calculate your BMI and start your fitness journey',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age',
          style: AppTextStyles.title3,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$_age years',
                  style: AppTextStyles.body1,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _age > 1
                        ? () {
                            setState(() => _age--);
                          }
                        : null,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryStart.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: AppColors.primaryStart,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _age < 120
                        ? () {
                            setState(() => _age++);
                          }
                        : null,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryStart.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.primaryStart,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
