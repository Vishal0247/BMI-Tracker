class BMICalculator {
  static double calculateBMI(double weight, double height) {
    // height should be in cm, convert to meters
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  static String getMotivationalMessage(String category) {
    switch (category.toLowerCase()) {
      case 'normal':
        return 'Great job! Maintain your healthy lifestyle.';
      case 'overweight':
        return 'Small consistent steps can make a big difference.';
      case 'underweight':
        return 'Focus on a balanced and nutritious diet.';
      case 'obese':
        return 'Take control of your health today. You can do it!';
      default:
        return 'Keep working towards your fitness goals.';
    }
  }

  static String getHealthyWeightRange(double height) {
    // Healthy BMI range: 18.5 to 24.9
    double heightInMeters = height / 100;
    double minWeight = 18.5 * (heightInMeters * heightInMeters);
    double maxWeight = 24.9 * (heightInMeters * heightInMeters);
    return '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)} kg';
  }

  static String getIdealWeight(double height) {
    // BMI 22 is considered ideal
    double heightInMeters = height / 100;
    double idealWeight = 22 * (heightInMeters * heightInMeters);
    return '${idealWeight.toStringAsFixed(1)} kg';
  }

  static double getCalorieRecommendation(
    double weight,
    double height,
    int age,
    String gender,
    String activityLevel,
  ) {
    // Harris-Benedict equation
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    // Activity multiplier
    double multiplier;
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        multiplier = 1.2;
        break;
      case 'light':
        multiplier = 1.375;
        break;
      case 'moderate':
        multiplier = 1.55;
        break;
      case 'very active':
        multiplier = 1.725;
        break;
      default:
        multiplier = 1.55;
    }

    return bmr * multiplier;
  }

  static double getWaterIntakeRecommendation(double weight) {
    // 30-35 ml per kg of body weight
    return weight * 0.035;
  }

  static int getHealthScore(
    double bmi,
    int age,
    int exerciseHours,
    int sleepHours,
  ) {
    int score = 100;

    // BMI score
    if (bmi < 18.5 || bmi > 30) {
      score -= 25;
    } else if (bmi < 25) {
      score -= 0;
    } else {
      score -= 10;
    }

    // Age consideration (this is simplified)
    if (age < 30) {
      score += 10;
    }

    // Exercise score
    if (exerciseHours >= 7) {
      score += 15;
    } else if (exerciseHours >= 5) {
      score += 10;
    } else if (exerciseHours >= 3) {
      score += 5;
    }

    // Sleep score
    if (sleepHours >= 8) {
      score += 15;
    } else if (sleepHours >= 7) {
      score += 10;
    } else if (sleepHours >= 5) {
      score += 5;
    }

    return score.clamp(0, 100);
  }
}
