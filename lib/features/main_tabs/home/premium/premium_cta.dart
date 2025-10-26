import 'dart:io';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/premium_upgrade_overlay.dart';
import 'package:fitpill/features/main_tabs/home/badge/badge_data.dart';
import 'package:fitpill/features/main_tabs/home/badge/badge_provider.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/home/profile/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PremiumCrownButton extends ConsumerWidget {
  const PremiumCrownButton({super.key});

  static const _premiumCrown = Color(0xFFFFC107); // sarı
  static const _freeCrown    = Color(0xFF1E88E5); // mavi

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumStatus = ref.watch(premiumStatusProvider);
    final isPremium =
    premiumStatus.maybeWhen(data: (v) => v, orElse: () => false);
    final isLoading = premiumStatus.isLoading;

    final semanticsLabel = isPremium
        ? S.of(context)!.premiumMemberCardTitle
        : S.of(context)!.goPremium;

    // Arka plan tamamen şeffaf, yalnızca taç rengi değişiyor.
    return Semantics(
      button: true,
      label: semanticsLabel,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed:
              isLoading ? null : () => _onTap(context, ref, isPremium: isPremium),
              tooltip: semanticsLabel,
              splashRadius: 26,
              icon: FaIcon(
                FontAwesomeIcons.crown,
                size: 22,
                color: isPremium ? _premiumCrown : _freeCrown,
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    (isPremium ? _premiumCrown : _freeCrown).withValues(alpha: 0.9),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref, {required bool isPremium}) {
    if (!isPremium) {
      _showPromotionDialog(context, ref);
    } else {
      _showMemberDialog(context, ref);
    }
  }

  void _showPromotionDialog(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    showGeneralDialog<void>(
      context: context,
      barrierLabel: l10n!.goPremium,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _PremiumDialogShell(
          gradient: const [Color(0xFF4FC3F7), Color(0xFF1976D2)],
          child: _PremiumPromoContent(
            l10n: l10n,
            onUpgrade: () {
              Navigator.of(dialogContext).pop();
              showPremiumUpgradeOverlay(context);
            },
          ),
        );
      },
      transitionBuilder: _dialogTransition,
    );
  }

  void _showMemberDialog(BuildContext context, WidgetRef ref) {
    final profileState = ref.read(profileProvider);
    final l10n = S.of(context);
    showGeneralDialog<void>(
      context: context,
      barrierLabel: l10n!.premiumMemberCardTitle,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _PremiumDialogShell(
          gradient: const [Color(0xFFFFF59D), Color(0xFFFFB300)],
          child: profileState.when(
            data: (profile) {
              final joinDate = profile.premiumJoinedAt;
              final localeTag =
                  Localizations.localeOf(context).toLanguageTag();
              final formattedJoinDate = joinDate != null
                  ? DateFormat.yMMMMd(localeTag).format(joinDate)
                  : l10n.premiumMemberSinceUnknown;
              final displayName =
                  profile.name.isNotEmpty ? profile.name : l10n.profile;
              return _PremiumMemberContent(
                profile: profile,
                joinDate: formattedJoinDate,
                l10n: l10n,
              );
            },
            loading: () => const SizedBox(
              height: 240,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            error: (error, stackTrace) => _PremiumErrorContent(
              message: l10n.premiumMemberCardError,
              retryLabel: l10n.premiumMemberCardTryAgain,
              onRetry: () {
                Navigator.of(dialogContext).pop();
                ref.read(profileProvider.notifier).fetchProfile();
              },
            ),
          ),
        );
      },
      transitionBuilder: _dialogTransition,
    );
  }
}

Widget _dialogTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curved = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    ),
  );
}

class _PremiumDialogShell extends StatelessWidget {
  const _PremiumDialogShell({
    required this.child,
    required this.gradient,
  });

  final Widget child;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 420),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24, 32, 24, 28),
                        child: child,
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumPromoContent extends StatelessWidget {
  const _PremiumPromoContent({
    required this.l10n,
    required this.onUpgrade,
  });

  final S l10n;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(bodyColor: Colors.white, displayColor: Colors.white);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha:0.15),
                border: Border.all(color: Colors.white.withValues(alpha:0.4)),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.crown,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.premiumUnlockTitle,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.premiumUnlockDescription,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha:0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _PremiumPromoHighlight(
          icon: Icons.auto_awesome,
          text: l10n.upgradeToCreateRoutine,
        ),
        _PremiumPromoHighlight(
          icon: Icons.timeline,
          text: l10n.upgradeToSaveProgress,
        ),
        _PremiumPromoHighlight(
          icon: Icons.lock_open,
          text: l10n.premiumSectionLocked,
        ),
        _PremiumPromoHighlight(
          icon: Icons.history,
          text: l10n.workoutHistoryNotSaved,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: onUpgrade,
            icon: const Icon(Icons.workspace_premium),
            label: Text(l10n.goPremium),
          ),
        ),
      ],
    );
  }
}

class _PremiumPromoHighlight extends StatelessWidget {
  const _PremiumPromoHighlight({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha:0.9)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha:0.9),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumMemberContent extends StatelessWidget {
  const _PremiumMemberContent({
    required this.profile,
    required this.joinDate,
    required this.l10n,
  });

  final UserProfileModel profile;
  final String joinDate;
  final S l10n;

  @override
  Widget build(BuildContext context) {
    final highlights = _buildHighlights(context, profile);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PremiumAvatar(profile: profile),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name.isNotEmpty ? profile.name : l10n.profile,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.premiumMemberSince(joinDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha:0.85),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Consumer(
          builder: (context, ref, _) {
            final badgeState = ref.watch(badgeProvider);
            return badgeState.when(
              data: (badgeData) => _PremiumBadgeSummary(badgeData: badgeData),
              loading: () => const SizedBox(height: 72),
              error: (error, stackTrace) => const SizedBox.shrink(),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          l10n.premiumProfileHighlights,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        if (highlights.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: highlights,
          )
        else
          Text(
            l10n.premiumProfileMissing,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha:0.85),
                ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<Widget> _buildHighlights(BuildContext context, UserProfileModel profile) {
    final l10n = S.of(context);
    final List<_PremiumTagChip> tags = [];

    if (profile.height.isNotEmpty) {
      tags.add(_PremiumTagChip(
        icon: Icons.height,
        label: '${l10n!.height}: ${profile.height}',
      ));
    }
    if (profile.gender.isNotEmpty) {
      tags.add(_PremiumTagChip(
        icon: Icons.person,
        label: '${l10n!.gender}: ${profile.gender}',
      ));
    }
    if (profile.birthDate.isNotEmpty) {
      tags.add(_PremiumTagChip(
        icon: Icons.cake_outlined,
        label: '${l10n!.birthDate}: ${profile.birthDate}',
      ));
    }
    if (profile.avatar != null && profile.avatar!.isNotEmpty) {
      tags.add(_PremiumTagChip(
        icon: Icons.emoji_emotions,
        label: l10n!.premiumAvatarReady,
      ));
    }

    return tags;
  }
}

class _PremiumBadgeSummary extends StatelessWidget {
  const _PremiumBadgeSummary({required this.badgeData});

  final BadgeData badgeData;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final accent = Colors.amber.shade400;
    final nextThreshold =
        badgeData.totalBadges >= 20 ? null : badgeData.nextTierThreshold;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [accent.withValues(alpha: 0.25), accent.withValues(alpha: 0.15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              Text(
                l10n!.badgeSheetTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.badgeCurrentTier(_localizedTierName(context, badgeData.tier)),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.badgeTotalLabel(badgeData.totalBadges),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: badgeData.progressToNextTier,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            nextThreshold == null
                ? l10n.badgeAllTiersCompleted
                : l10n.badgeNextThreshold(
                    nextThreshold - badgeData.totalBadges,
                  ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
          ),
        ],
      ),
    );
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

class _PremiumTagChip extends StatelessWidget {
  const _PremiumTagChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha:0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _PremiumAvatar extends StatelessWidget {
  const _PremiumAvatar({required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (profile.profileImage != null && profile.profileImage!.isNotEmpty) {
      final imagePath = profile.profileImage!;
      if (imagePath.startsWith('http')) {
        imageProvider = NetworkImage(imagePath);
      } else {
        final file = File(imagePath);
        if (file.existsSync()) {
          imageProvider = FileImage(file);
        }
      }
    } else if (profile.avatar != null && profile.avatar!.isNotEmpty) {
      imageProvider = AssetImage('assets/avatars/${profile.avatar}.png');
    }

    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white.withValues(alpha:0.2),
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 40,
            )
          : null,
    );
  }
}

class _PremiumErrorContent extends StatelessWidget {
  const _PremiumErrorContent({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha:0.9),
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: onRetry,
            child: Text(
              retryLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
