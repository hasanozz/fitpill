import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/premium_upgrade_overlay.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'backpack_bag.dart';
import 'backpack_detail_page.dart';
import 'backpack_provider.dart';

class BackpackPage extends ConsumerWidget {
  const BackpackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bagsAsync = ref.watch(backpackBagProvider);
    final bagNotifier = ref.read(backpackBagProvider.notifier);
    final premiumStatus = ref.watch(premiumStatusProvider);
    final isPremium =
        premiumStatus.maybeWhen(data: (value) => value, orElse: () => false);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.myBags),
        centerTitle: true,
        backgroundColor: ThemeHelper.getBackgroundColor(context),
      ),
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: bagsAsync.when(
        data: (bags) {
          if (bags.isEmpty) {
            return Center(child: Text(S.of(context)!.haventCreatedBag));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bags.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final bag = bags[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BackpackDetailPage(bag: bag)),
                ),
                onLongPress: () {
                  // düzenleme veya silme menüsü
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: ThemeHelper.getCardColor(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.backpack, size: 48),
                      const SizedBox(height: 8),
                      Text(_resolveBagName(context, bag),
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const AppPageShimmer(padding: EdgeInsets.symmetric(horizontal: 16)),
        error: (error, _) => Center(
          child: Text(S.of(context)!.error),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isPremium) {
            showPremiumUpgradeOverlay(context);
            return;
          }
          _showCreateDialog(context, bagNotifier);
        },
        backgroundColor: ThemeHelper.getTextColor(context),
        child: Icon(Icons.add, color: ThemeHelper.getCardColor(context)),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, BackpackBagNotifier notifier) {
    showCustomTextFieldDialog(
      context: context,
      title: S.of(context)!.addBag,
      labels: [S.of(context)!.bagName],
      icon: FontAwesomeIcons.bagShopping,
      confirmText: S.of(context)!.add,
      cancelText: S.of(context)!.cancel,
      onConfirm: (values) {
        final name = values.first.trim();
        if (name.isNotEmpty) {
          notifier.addBag(name);
        }
      },
    );
  }
}

String _resolveBagName(BuildContext context, BackpackBag bag) {
  final l10n = S.of(context);
  switch (bag.name) {
    case 'default_backpack_name':
      return l10n!.defaultBackpackName;
    default:
      return bag.name;
  }
}
