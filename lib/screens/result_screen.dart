import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/bmi_record.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/bmi_calculator.dart';

import '../widgets/bmi_gauge.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatefulWidget {
  final BMIRecord bmiRecord;

  const ResultScreen({
    Key? key,
    required this.bmiRecord,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();

    // Show confetti if normal BMI
    if (widget.bmiRecord.category == 'Normal') {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _confettiController.play();
        }
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final healthyRange =
        BMICalculator.getHealthyWeightRange(widget.bmiRecord.height);
    final idealWeight =
        BMICalculator.getIdealWeight(widget.bmiRecord.height);
    final motivationalMessage =
        BMICalculator.getMotivationalMessage(widget.bmiRecord.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your BMI Result',
          style: AppTextStyles.title1,
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Confetti
                  if (widget.bmiRecord.category == 'Normal')
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        particleDrag: 0.05,
                        emissionFrequency: 0.05,
                        numberOfParticles: 20,
                        gravity: 0.1,
                        shouldLoop: false,
                        colors: const [
                          AppColors.normalBMI,
                          Colors.white,
                          Color(0xFF22C55E),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  // BMI Gauge
                  Center(
                    child: BMIGauge(
                      bmi: widget.bmiRecord.bmi,
                      category: widget.bmiRecord.category,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Motivational Message
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.getGradientByCategory(
                          widget.bmiRecord.category),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.getColorByCategory(
                                  widget.bmiRecord.category)
                              .withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      motivationalMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Details Section
                  _buildDetailsCard('Healthy Weight Range', healthyRange),
                  const SizedBox(height: 16),
                  _buildDetailsCard('Your Ideal Weight', idealWeight),
                  const SizedBox(height: 32),

                  // Body Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Weight',
                          '${widget.bmiRecord.weight.toStringAsFixed(1)} kg',
                          Icons.monitor_weight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          'Height',
                          '${widget.bmiRecord.height.toStringAsFixed(1)} cm',
                          Icons.height,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          'Age',
                          '${widget.bmiRecord.age} yrs',
                          Icons.cake,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final bmiValue = widget.bmiRecord.bmi.toStringAsFixed(1);
                            final category = widget.bmiRecord.category;
                            final message = 'I just calculated my BMI using BMI Calculator Pro! My BMI is $bmiValue ($category). Track your health with me!';
                            Share.share(message);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryStart.withValues(alpha: 0.2),
                            foregroundColor: AppColors.primaryStart,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cardBackground,
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryStart.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.body2,
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryStart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.primaryStart,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption1,
          ),
        ],
      ),
    );
  }
}
