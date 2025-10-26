import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'badge_data.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'badge_provider.dart';

class BadgeDisplay extends ConsumerWidget {
  const BadgeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeAsync = ref.watch(badgeProvider);

    return badgeAsync.when(
      loading: () => const AppShimmer(height: 32, width: 110),
      error: (e, st) => Text('Hata: $e'),
      data: (badgeData) {
        final isDarkTheme = ThemeHelper.isDarkTheme(context);
        final badgeStyle = _BadgeStyle.resolve(
          tier: badgeData.tier,
          isDarkMode: isDarkTheme,
        );
        final badgeIcon = _getBadgeIcon(badgeData.tier);

        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: () => _showBadgeDetails(context, badgeData),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: badgeStyle.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: badgeStyle.shadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: badgeStyle.iconBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          badgeIcon,
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _localizedTierName(context, badgeData.tier),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.tomorrow(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeStyle.badgeChipBackground,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.emoji_events_rounded,
                                      size: 15,
                                      color: badgeStyle.badgeChipForeground,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '${badgeData.totalBadges} ${S.of(context)!.badgeCountLabel}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.tomorrow(
                                          fontSize: 12,
                                          color: badgeStyle.badgeChipForeground,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeData badgeData) {
    final l10n = S.of(context);
    final totalBadges = badgeData.totalBadges;
    final nextThreshold =
        totalBadges >= 20 ? null : badgeData.nextTierThreshold;
    final progress = badgeData.progressToNextTier;
    final remaining = nextThreshold != null
        ? (nextThreshold - totalBadges).clamp(0, nextThreshold)
        : 0;
    final badgeIcon = _getBadgeIcon(badgeData.tier);
    final tierLabel = _localizedTierName(context, badgeData.tier);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                    child: Image.asset(badgeIcon, width: 52, height: 52),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n!.badgeSheetTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.badgeCurrentTier(tierLabel),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.badgeTotalLabel(totalBadges),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (nextThreshold != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: theme.colorScheme.onSurface
                              .withValues(alpha: 0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.badgeNextThreshold(remaining),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.badgeAllTiersCompleted,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildBadgeLevels(context, badgeData.tier),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgeLevels(BuildContext context, String currentTier) {
    final l10n = S.of(context);
    final theme = Theme.of(context);
    final tiers = [
      _BadgeLevel(
        title: l10n!.badgeTierRookie,
        threshold: 0,
        asset: 'assets/images/beginner.png',
        identifier: 'Rookie Challenger',
      ),
      _BadgeLevel(
        title: l10n.badgeTierBronze,
        threshold: 5,
        asset: 'assets/images/active_user.png',
        identifier: 'Bronze Challenger',
      ),
      _BadgeLevel(
        title: l10n.badgeTierSilver,
        threshold: 10,
        asset: 'assets/images/dedicted.png',
        identifier: 'Silver Challenger',
      ),
      _BadgeLevel(
        title: l10n.badgeTierGold,
        threshold: 15,
        asset: 'assets/images/legend.png',
        identifier: 'Gold Challenger',
      ),
      _BadgeLevel(
        title: l10n.badgeTierElite,
        threshold: 20,
        asset: 'assets/images/legend.png',
        identifier: 'Elite Challenger',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 40;
        const columns = 3;
        const spacing = 12.0;
        final rawWidth = (availableWidth - spacing * (columns - 1)) / columns;
        final itemWidth = rawWidth.isFinite && rawWidth > 0 ? rawWidth : 110.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                l10n.badgeLevelsTitle,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: tiers
                  .map(
                    (tier) => SizedBox(
                      width: itemWidth,
                      child: _badgeLevelItem(
                        context,
                        tier,
                        isActive: tier.identifier == currentTier,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _badgeLevelItem(BuildContext context, _BadgeLevel tier,
      {required bool isActive}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.08),
          width: isActive ? 1.6 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(tier.asset, width: 40, height: 40),
          const SizedBox(height: 8),
          Text(
            tier.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            S.of(context)!.badgeThresholdLabel(tier.threshold),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _getBadgeIcon(String tier) {
    switch (tier) {
      case 'Bronze Challenger':
        return 'assets/images/active_user.png';
      case 'Silver Challenger':
        return 'assets/images/dedicted.png';
      case 'Gold Challenger':
      case 'Elite Challenger':
        return 'assets/images/legend.png';
      default:
        return 'assets/images/beginner.png';
    }
  }

  String _localizedTierName(BuildContext context, String tier) {
    final l10n = S.of(context);
    switch (tier) {
      case 'Bronze Challenger':
        return l10n!.badgeTierBronze;
      case 'Silver Challenger':
        return l10n!.badgeTierSilver;
      case 'Gold Challenger':
        return l10n!.badgeTierGold;
      case 'Elite Challenger':
        return l10n!.badgeTierElite;
      default:
        return l10n!.badgeTierRookie;
    }
  }
}

class _BadgeStyle {
  const _BadgeStyle({
    required this.gradientColors,
    required this.shadowColor,
    required this.iconBackground,
    required this.badgeChipBackground,
    required this.badgeChipForeground,
  });

  final List<Color> gradientColors;
  final Color shadowColor;
  final Color iconBackground;
  final Color badgeChipBackground;
  final Color badgeChipForeground;

  static _BadgeStyle resolve({
    required String tier,
    required bool isDarkMode,
  }) {
    const fallbackColor = Color(0xFFFFB155);
    const tierBaseColors = <String, Color>{
      'Rookie Challenger': Color(0xFF4F6DD6),
      'Bronze Challenger': Color(0xFFB47A46),
      'Silver Challenger': Color(0xFFC5CAD6),
      'Gold Challenger': Color(0xFFE4C269),
      'Elite Challenger': Color(0xFF8C7CFF),
    };

    final baseColor = tierBaseColors[tier] ?? fallbackColor;
    final gradientStart =
        _adjustLightness(baseColor, isDarkMode ? -0.05 : -0.02);
    final gradientEnd = _adjustLightness(baseColor, isDarkMode ? 0.08 : 0.16);
    final shadowColor =
        _blendWith(baseColor, Colors.black, isDarkMode ? 0.65 : 0.4)
            .withValues(alpha: 0.45);
    final iconBackground =
        _blendWith(baseColor, Colors.white, isDarkMode ? 0.18 : 0.5)
            .withValues(alpha: isDarkMode ? 0.35 : 0.4);
    final badgeBackground = _blendWith(
      baseColor,
      isDarkMode ? Colors.black : Colors.white,
      isDarkMode ? 0.75 : 0.82,
    ).withValues(alpha: isDarkMode ? 0.32 : 0.18);
    final badgeForeground = isDarkMode
        ? _blendWith(baseColor, Colors.white, 0.7)
        : _blendWith(baseColor, Colors.black, 0.35);

    return _BadgeStyle(
      gradientColors: [gradientStart, gradientEnd],
      shadowColor: shadowColor,
      iconBackground: iconBackground,
      badgeChipBackground: badgeBackground,
      badgeChipForeground: badgeForeground,
    );
  }
}

Color _adjustLightness(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

Color _blendWith(Color base, Color target, double t) {
  return Color.lerp(base, target, t) ?? base;
}

class _BadgeLevel {
  const _BadgeLevel({
    required this.title,
    required this.threshold,
    required this.asset,
    required this.identifier,
  });

  final String title;
  final int threshold;
  final String asset;
  final String identifier;
}
