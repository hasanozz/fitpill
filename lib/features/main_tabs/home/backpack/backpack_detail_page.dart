import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/premium_upgrade_overlay.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'backpack_bag.dart';
import 'backpack_item.dart';
import 'backpack_provider.dart';

class BackpackDetailPage extends ConsumerStatefulWidget {
  final BackpackBag bag;

  const BackpackDetailPage({super.key, required this.bag});

  @override
  ConsumerState<BackpackDetailPage> createState() => _BackpackDetailPageState();
}

class _BackpackDetailPageState extends ConsumerState<BackpackDetailPage> {

  @override
  Widget build(BuildContext context) {
    final bagsAsync = ref.watch(backpackBagProvider);
    final resolvedBag = bagsAsync.maybeWhen(
      data: (bags) => bags.firstWhere(
        (bag) => bag.id == widget.bag.id,
        orElse: () => widget.bag,
      ),
      orElse: () => widget.bag,
    );

    final itemsAsync = ref.watch(backpackItemsProvider(resolvedBag.id));

    // -------------------------------------------------------------------
    // 🔥 HATA ÇÖZÜMÜ 1: FutureProvider'ın notifier'ı yoktur.
    // final itemsNotifier = ref.read(backpackItemsProvider(resolvedBag.id).notifier);
    // Komutlar için NotifierProvider'ı okuyun:
    final itemCommands = ref.read(backpackItemsCommandsProvider.notifier);
    // -------------------------------------------------------------------


    //
    // final itemsNotifier =
    // ref.read(backpackItemsProvider(resolvedBag.id).notifier);
    final premiumStatus = ref.watch(premiumStatusProvider);
    final isPremium =
        premiumStatus.maybeWhen(data: (value) => value, orElse: () => false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_resolveBagName(context, resolvedBag)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              if (!isPremium) {
                showPremiumUpgradeOverlay(context);
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BackpackSettingsPage(bag: resolvedBag),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: itemsAsync.when(
        loading: () => const AppPageShimmer(padding: EdgeInsets.all(16)),
        error: (e, _) => Center(child: Text("${S.of(context)!.error}: $e")),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(S.of(context)!.bagEmpty));
          }

          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async{
                        if (!isPremium) {
                          showPremiumUpgradeOverlay(context);
                          return;
                        }
                        await itemCommands.deleteItem(resolvedBag.id, item.name);
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      label: S.of(context)!.delete,
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: Text(_getEmoji(item),
                        style: const TextStyle(fontSize: 24)),
                    title: Text(_resolveItemName(context, item.name)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isPremium) {
            showPremiumUpgradeOverlay(context);
            return;
          }
          _showAddItemDialog(context, resolvedBag.id);
        },
        backgroundColor: ThemeHelper.getTextColor(context),
        child: Icon(Icons.add, color: ThemeHelper.getCardColor(context)),
      ),
    );
  }

  // -------------------------------------------------------------------
  // 🔥 HATA ÇÖZÜMÜ 2: BackpackItemsNotifier yerine bagId parametresini al
  // void _showAddItemDialog(BuildContext context, BackpackItemsNotifier notifier) {
  void _showAddItemDialog(
      BuildContext context, String bagId) {
    final itemCommands = ref.read(backpackItemsCommandsProvider.notifier);
  // -------------------------------------------------------------------

    // -------------------------------------------------------------------
    // ⚠️ Don't use 'BuildContext's across async gaps uyarısı için:
    // ModalSheet açmadan önce l10n'u almanız doğru.
    // -----


    final l10n = S.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeHelper.getCardColor2(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _BackpackAddItemSheet(
          title: l10n!.addItems,
          nameLabel: l10n.itemName,
          chooseIconLabel: l10n.chooseIcon,
          cancelLabel: l10n.cancel,
          addLabel: l10n.add,
          onSubmit: (name, iconKey)async {
            await itemCommands.addItem(
              bagId,
              BackpackItem(name: name, iconKey: iconKey),
            );
          },
        );
      },
    );
  }
}

class _BackpackAddItemSheet extends StatefulWidget {
  const _BackpackAddItemSheet({
    required this.title,
    required this.nameLabel,
    required this.chooseIconLabel,
    required this.cancelLabel,
    required this.addLabel,
    required this.onSubmit,
  });

  final String title;
  final String nameLabel;
  final String chooseIconLabel;
  final String cancelLabel;
  final String addLabel;
  final void Function(String name, String iconKey) onSubmit;

  @override
  State<_BackpackAddItemSheet> createState() => _BackpackAddItemSheetState();
}

class _BackpackAddItemSheetState extends State<_BackpackAddItemSheet> {
  late TextEditingController _textController;
  String _selectedIcon = _iconOptions.first.key;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _textController.text.trim();
    if (name.isEmpty) {
      return;
    }
    widget.onSubmit(name, _selectedIcon);
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmit(),
            decoration: InputDecoration(
              labelText: widget.nameLabel,
              prefixIcon: const Icon(FontAwesomeIcons.tag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.chooseIconLabel,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final option in _iconOptions)
                ChoiceChip(
                  label: Text(
                    option.value,
                    style: const TextStyle(fontSize: 20),
                  ),
                  selected: _selectedIcon == option.key,
                  onSelected: (value) {
                    if (!value) {
                      return;
                    }
                    setState(() {
                      _selectedIcon = option.key;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).maybePop();
                },
                child: Text(widget.cancelLabel),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(widget.addLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackpackSettingsPage extends ConsumerStatefulWidget {
  final BackpackBag bag;

  const BackpackSettingsPage({super.key, required this.bag});

  @override
  ConsumerState<BackpackSettingsPage> createState() =>
      _BackpackSettingsPageState();
}

class _BackpackSettingsPageState extends ConsumerState<BackpackSettingsPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bag.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isPremium = ref
        .read(premiumStatusProvider)
        .maybeWhen(data: (value) => value, orElse: () => false);
    if (!isPremium) {
      showPremiumUpgradeOverlay(context);
      return;
    }
    final newName = _nameController.text.trim();
    if (newName.isEmpty || newName == widget.bag.name) {
      Navigator.pop(context);
      return;
    }

    await ref
        .read(backpackBagProvider.notifier)
        .renameBag(widget.bag.id, newName);
    Navigator.pop(context); // Geri dön
  }

  Future<void> _delete() async {
    final isPremium = ref
        .read(premiumStatusProvider)
        .maybeWhen(data: (value) => value, orElse: () => false);
    if (!isPremium) {
      showPremiumUpgradeOverlay(context);
      return;
    }
    await showCustomTextFieldDialog(
      context: context,
      title: S.of(context)!.deleteBag,
      labels: [],
      // TextField yok
      icon: Icons.warning_amber,
      confirmText: S.of(context)!.delete,
      cancelText: S.of(context)!.cancel,
      content: Text(
        S.of(context)!.askDeleteBag,
        style: const TextStyle(fontSize: 16),
      ),
      onConfirm: (_) async {
        await ref.read(backpackBagProvider.notifier).deleteBag(widget.bag.id);
        Navigator.pop(context); // ayar sayfası
        Navigator.pop(context); // detail sayfası
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.bagSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: S.of(context)!.bagName,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: Text(S.of(context)!.deleteBag,
                    style: TextStyle(color: Colors.red)),
                onPressed: _delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getEmoji(BackpackItem item) {
  switch ((item.iconKey ?? item.name).toLowerCase()) {
    case 'towel':
      return '🧺';
    case 'water_bottle':
      return '🚰';
    case 'headphones':
      return '🎧';
    case 'gloves':
      return '🧤';
    case 'sports_shoes':
      return '👟';
    case 'slippers':
      return '🩴';
    case 'socks':
      return '🧦';
    case 'watch':
      return '⏱️';
    case 'rope':
      return '🪢';
    case 'supplement':
      return '💊';
    case 'yoga':
      return '🧘';
    case 'tshirt':
      return '👕';
    case 'shaker':
      return '🥤';
    case 'notebook':
      return '📓';
    case 'backpack':
      return '🎒';
    default:
      return '🎒';
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

String _resolveItemName(BuildContext context, String name) {
  final l10n = S.of(context);
  switch (name) {
    case 'towel':
      return l10n!.towel;
    case 'water_bottle':
      return l10n!.waterBottle;
    case 'sports_shoes':
      return l10n!.sportsShoes;
    case 'slippers':
      return l10n!.slippers;
    case 'socks':
      return l10n!.socks;
    default:
      return name;
  }
}

const _iconOptions = <MapEntry<String, String>>[
  MapEntry('backpack', '🎒'),
  MapEntry('towel', '🧺'),
  MapEntry('water_bottle', '🚰'),
  MapEntry('sports_shoes', '👟'),
  MapEntry('watch', '⏱️'),
  MapEntry('rope', '🪢'),
  MapEntry('supplement', '💊'),
  MapEntry('yoga', '🧘'),
  MapEntry('tshirt', '👕'),
  MapEntry('shaker', '🥤'),
  MapEntry('notebook', '📓'),
];
