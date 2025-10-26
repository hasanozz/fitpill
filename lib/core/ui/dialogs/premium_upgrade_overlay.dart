import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';

Future<void> showPremiumUpgradeOverlay(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierLabel: 'premiumUpgrade',
    barrierColor: Colors.black.withAlpha(170),
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _PremiumUpgradeOverlay();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: child,
        ),
      );
    },
  );
}

class _PremiumUpgradeOverlay extends StatelessWidget {
  const _PremiumUpgradeOverlay();

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeHelper.isDarkTheme(context);
    final Color cardColor = ThemeHelper.getCardColor(context);
    final Color accentColor = isDark ? Colors.orange : const Color(0xFF0D47A1);
    final Color textColor = ThemeHelper.getTextColor(context);
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';

    final List<_PremiumFeature> features = [
      _PremiumFeature(
        icon: Icons.auto_graph,
        title: isTurkish ? 'İlerlemeni sınırsız kaydet' : 'Save unlimited progress',
        description: S.of(context)!.upgradeToSaveProgress,
      ),
      _PremiumFeature(
        icon: Icons.fitness_center,
        title: isTurkish
            ? 'Sınırsız rutin ve antrenman oluştur'
            : 'Create unlimited routines & workouts',
        description: S.of(context)!.upgradeToCreateRoutine,
      ),
      _PremiumFeature(
        icon: Icons.workspace_premium,
        title: isTurkish
            ? 'Premium içeriklere özel erişim'
            : 'Access exclusive premium content',
        description: S.of(context)!.premiumSectionLocked,
      ),
    ];

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: isDark ? 0.25 : 0.18),
                              accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTurkish
                                  ? 'Fitpill Premium ile gücünü artır'
                                  : 'Unlock your strength with Fitpill Premium',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isTurkish
                                  ? 'Tüm antrenman planları ve gelişim araçları tek pakette.'
                                  : 'All training plans and progress tools in one package.',
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor.withValues(alpha: 0.75),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...features.map(
                            (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _PremiumFeatureTile(
                            feature: feature,
                            accentColor: accentColor,
                            textColor: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // TODO: integrate actual purchase flow when available.
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: ThemeHelper.getBackgroundColor(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            isTurkish ? 'Premium\'a yükselt' : 'Upgrade to Premium',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: textColor.withValues(alpha: 0.7),
                          ),
                          child: Text(
                            isTurkish ? 'Daha sonra' : 'Maybe later',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 24,
              left: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.close, color: textColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumFeature {
  const _PremiumFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _PremiumFeatureTile extends StatelessWidget {
  const _PremiumFeatureTile({
    required this.feature,
    required this.accentColor,
    required this.textColor,
  });

  final _PremiumFeature feature;
  final Color accentColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.35),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              color: accentColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  feature.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}