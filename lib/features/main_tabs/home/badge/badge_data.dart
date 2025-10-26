class BadgeData {
  final int totalBadges;
  final String tier;
  final DateTime? lastAwardedAt;

  const BadgeData({
    required this.totalBadges,
    required this.tier,
    this.lastAwardedAt,
  });

  int get nextTierThreshold {
    if (totalBadges < 5) return 5;
    if (totalBadges < 10) return 10;
    if (totalBadges < 15) return 15;
    if (totalBadges < 20) return 20;
    return 25;
  }

  double get progressToNextTier {
    if (totalBadges >= 20) {
      return 1;
    }
    final previousThreshold = _previousTierThreshold(nextTierThreshold);
    final span = (nextTierThreshold - previousThreshold).toDouble();
    if (span <= 0) {
      return 0;
    }
    return ((totalBadges - previousThreshold) / span).clamp(0.0, 1.0);
  }

  int _previousTierThreshold(int threshold) {
    switch (threshold) {
      case 5:
        return 0;
      case 10:
        return 5;
      case 15:
        return 10;
      case 20:
        return 15;
      default:
        return 20;
    }
  }
}
