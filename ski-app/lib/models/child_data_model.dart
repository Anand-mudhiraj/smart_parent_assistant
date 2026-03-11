class ChildData {
  final int sleepQuality;
  final int feedingGap;
  final int cryingIntensity;
  final int discomfort;
  final int temperature;

  ChildData({
    required this.sleepQuality,
    required this.feedingGap,
    required this.cryingIntensity,
    required this.discomfort,
    required this.temperature,
  });

  Map<String, dynamic> toJson() {
    return {
      "feature_1": sleepQuality,
      "feature_2": feedingGap,
      "feature_3": cryingIntensity,
      "feature_4": discomfort,
      "feature_5": temperature,
    };
  }
}
