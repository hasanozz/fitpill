import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:fitpill/core/system/config/theme/theme_providers.dart';
import 'package:fitpill/core/system/config/locale/locale_notifier.dart';
import 'package:fitpill/features//auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitpill/features/auth/auth_notifier.dart';
import 'package:fitpill/features/auth/pages/onboarding_page.dart';
import 'pages/change_password_page.dart';

class SettingsPage extends ConsumerWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode?> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'destek@fitpill.com',
      query: 'subject=Fitpill Destek Talebi&body=Merhaba,',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchStore() async {
    final Uri storeUri =
    Uri.parse("https://play.google.com/store/apps/details?id=com.fitpill");
    if (await canLaunchUrl(storeUri)) {
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    }
  }

//Hesap silme fonksiyonu
  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(context)!.confirmDelete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context)!.password),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                labelText: S.of(context)!.password,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(S.of(context)!.cancel),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(S.of(context)!.delete),
              onPressed: () async {
                Navigator.pop(dialogContext); // dialogu kapat

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => const Center(
                    child: AppShimmer(
                      height: 72,
                      width: 72,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ),
                );

                final result = await ref
                    .read(authProvider.notifier)
                    .deleteAccountWithPassword(passwordController.text.trim());

                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true)
                    .pop(); // spinner'ı kapat

                if (result == null) {
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingPage()),
                          (route) => false,
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        result == 'wrong_password'
                            ? S.of(context)!.wrongPassword
                            : S.of(context)!.unknownError,
                      ),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localizationProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        title: Text(
          S.of(context)!.settings,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _buildSectionHeader(context, S.of(context)!.languageSelect),
            Card(
              color: ThemeHelper.getCardColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  locale.languageCode == 'tr'
                      ? S.of(context)!.turkish
                      : S.of(context)!.english,
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () => _showLanguageBottomSheet(context, ref),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(context, S.of(context)!.themeSelect),
            Card(
              color: ThemeHelper.getCardColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: SwitchListTile(
                title: Text(
                  isDarkMode ? S.of(context)!.themeD : S.of(context)!.themeL,
                  style: const TextStyle(fontSize: 16),
                ),
                activeTrackColor: ThemeHelper.getFitPillColor(context)
                    .withValues(alpha: 0.54),
                activeThumbColor: Colors.orange,
                secondary: const Icon(Icons.brightness_6),
                value: isDarkMode,
                onChanged: (value) {
                  ref
                      .read(themeNotifierProvider.notifier)
                      .setTheme(value ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(context, S.of(context)!.other),
            Card(
              color: ThemeHelper.getCardColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.mail, color: Colors.blue),
                title: Text(S.of(context)!.contactUs,
                    style: const TextStyle(fontSize: 16)),
                onTap: _launchEmail,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: ThemeHelper.getCardColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.star_rate, color: Colors.orange),
                title: Text(S.of(context)!.rateApp,
                    style: const TextStyle(fontSize: 16)),
                onTap: _launchStore,
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(context, S.of(context)!.account),
            Card(
              color: ThemeHelper.getCardColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.password_outlined,
                    color: ThemeHelper.getTextColor(context)),
                title: Text(
                  S.of(context)!.passwordChange,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: ThemeHelper.getCardColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.logout_rounded,
                    color: ThemeHelper.getTextColor(context)),
                title: Text(
                  S.of(context)!.logout,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
                onTap: () {
                  showCustomTextFieldDialog(
                    context: context,
                    title: S.of(context)!.quitConfirm,
                    labels: [],
                    // boş
                    icon: Icons.info,
                    content: Text(
                      S.of(context)!.backpackDescription,
                      style: const TextStyle(fontSize: 16),
                    ),
                    cancelText: S.of(context)!.cancel,
                    confirmText: S.of(context)!.confirm,
                    onConfirm: (_) async {
                      await ref.read(authProvider.notifier).signOut();

                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnboardingPage()),
                            (Route<dynamic> route) => false,
                      );
                    }, // Gerekirse boş bir fonksiyon ver
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              color: Colors.red.shade400,
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.white),
                title: Text(
                  S.of(context)!.deleteAccount,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                onTap: () => _showDeleteDialog(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600]),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeHelper.getCardColor2(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context)!.languageSelect,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      "TR",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    S.of(context)!.turkish,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    ref.read(localizationProvider.notifier).setTurkish();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      "EN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    S.of(context)!.english,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    ref.read(localizationProvider.notifier).setEnglish();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
