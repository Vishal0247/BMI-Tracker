import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';


class BMIGauge extends StatefulWidget {
  final double bmi;
  final String category;
  final Duration animationDuration;

  const BMIGauge({
    Key? key,
    required this.bmi,
    required this.category,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<BMIGauge> createState() => _BMIGaugeState();
}

class _BMIGaugeState extends State<BMIGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0, end: 1).animate(widget.animationDuration > Duration.zero
            ? CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
            : AlwaysStoppedAnimation(1));
    _controller.forward();
  }

  @override
  void didUpdateWidget(BMIGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bmi != widget.bmi) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getBMIPercentage() {
    // BMI range from 10 to 40
    double percentage = ((widget.bmi - 10) / 30).clamp(0.0, 1.0);
    return percentage;
  }

  Color _getCategoryColor() {
    return AppColors.getColorByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double percentage = _getBMIPercentage() * _animation.value;

        return Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cardBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  // Gauge background
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: GaugePainter(
                      percentage: percentage,
                      color: _getCategoryColor(),
                      backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
                    ),
                  ),
                  // Center content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.category,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Underweight', AppColors.underweightBMI, 'Below 18.5'),
                _buildLegendItem('Normal', AppColors.normalBMI, '18.5-24.9'),
                _buildLegendItem('Overweight', AppColors.overweightBMI, '25-29.9'),
                _buildLegendItem('Obese', AppColors.obeseBMI, 'Above 30'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          range,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color backgroundColor;

  GaugePainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Draw background arc
    paint.color = backgroundColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 2,
      false,
      paint,
    );

    // Draw progress arc
    paint.color = color;
    paint.shader = SweepGradient(
      colors: [color, color.withValues(alpha: 0.5)],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      (math.pi * 2) * percentage,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.color != color;
  }
}
