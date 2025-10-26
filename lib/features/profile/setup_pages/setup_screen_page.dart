// lib/features/setup/pages/setup_page.dart

import 'package:fitpill/core/ui//widgets/app_schimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/app/shell/bottom_nav_shell.dart';
import 'setup_model.dart';
import 'setup_provider.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isSaving = false;

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String? _heightError;
  String? _weightError;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final setup = ref.read(setupProvider);

    if (_currentPage == 0 && setup.birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.selectBirthDate)),
      );
      return;
    }

    if (_currentPage == 1 && setup.gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.selectGender)),
      );
      return;
    }

    if (_currentPage == 2) {
      final height = int.tryParse(_heightController.text);
      if (height == null || height < 100 || height > 250) {
        setState(() => _heightError = S.of(context)!.heightRangeError);
        return;
      }
      _heightError = null;
    }

    if (_currentPage == 3) {
      final weight = double.tryParse(_weightController.text);
      if (weight == null || weight < 30 || weight > 300) {
        setState(() => _weightError = S.of(context)!.weightRangeError);
        return;
      }
      _weightError = null;
    }

    if (_currentPage < 3) {
      setState(() => _currentPage++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _save();
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(setupProvider.notifier).saveSetupData();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainMenu()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.of(context)!.errorOccurred}: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(setupProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context)!.setupProfile,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: colors.primary,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.primary.withValues(alpha: 0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              children: [
                _buildProgressIndicator(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _birthDatePage(setup),
                      _genderPage(setup),
                      _heightPage(),
                      _weightPage(),
                    ],
                  ),
                ),
                _buildNavigationButton(theme),
              ],
            ),
          ),
        ),
        if (_isSaving)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: AppShimmer(
                height: 80,
                width: 80,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
      ],
    ); // ✅ Scaffold burada doğru şekilde kapatıldı
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentPage == index ? 28 : 12,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? Theme.of(context).colorScheme.primary
                  : Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _isSaving
                    ? null
                    : () {
                        setState(() {
                          _currentPage--;
                        });
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(S.of(context)!.back),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: AppShimmer(
                        height: 24,
                        width: 24,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    )
                  : Text(
                      _currentPage < 3
                          ? S.of(context)!.next
                          : S.of(context)!.save,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _birthDatePage(SetupData setup) {
    return _SetupCard(
      icon: Icons.calendar_month_rounded,
      title: S.of(context)!.birthDate,
      child: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_calendar_rounded, size: 22),
              label: Text(
                setup.birthDate == null
                    ? S.of(context)!.selectDate
                    : DateFormat('dd MMMM yyyy', 'tr_TR')
                        .format(setup.birthDate!),
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade100, width: 2),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.now().subtract(const Duration(days: 365 * 13)),
                  firstDate: DateTime(1900),
                  lastDate:
                      DateTime.now().subtract(const Duration(days: 365 * 13)),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: Theme.of(context).colorScheme.primary,
                          surface: Colors.white,
                        ),
                        dialogTheme: const DialogThemeData(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  ref.read(setupProvider.notifier).updateBirthDate(picked);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'En az 13 yaşında olmalısınız',
            style: TextStyle(
              color: Colors.blueGrey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderPage(SetupData setup) {
    return _SetupCard(
      icon: Icons.person_outline_rounded,
      title: S.of(context)!.gender,
      child: Column(
        children: [
          _GenderChoice(
            value: 'male',
            groupValue: setup.gender,
            icon: Icons.male_rounded,
            label: S.of(context)!.male,
            onChanged: (val) =>
                ref.read(setupProvider.notifier).updateGender(val!),
          ),
          const SizedBox(height: 12),
          _GenderChoice(
            value: 'female',
            groupValue: setup.gender,
            icon: Icons.female_rounded,
            label: S.of(context)!.female,
            onChanged: (val) =>
                ref.read(setupProvider.notifier).updateGender(val!),
          ),
        ],
      ),
    );
  }

  Widget _heightPage() {
    return _SetupCard(
      icon: Icons.height_rounded,
      title: '${S.of(context)!.height} (cm)',
      child: TextField(
        controller: _heightController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3)
        ],
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.height_rounded, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorText: _heightError,
          hintText: '175',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        onChanged: (val) =>
            ref.read(setupProvider.notifier).updateHeight(val.trim()),
      ),
    );
  }

  Widget _weightPage() {
    return _SetupCard(
      icon: Icons.monitor_weight_outlined,
      title: S.of(context)!.weight,
      child: TextField(
        controller: _weightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*[.]?[0-9]{0,2}')),
          LengthLimitingTextInputFormatter(5),
        ],
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.scale_rounded, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorText: _weightError,
          hintText: '70.5',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        onChanged: (val) =>
            ref.read(setupProvider.notifier).updateWeight(val.trim()),
      ),
    );
  }
}

class _SetupCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SetupCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        shadowColor: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    size: 32, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 20),
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey.shade800)),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderChoice extends StatelessWidget {
  final String value;
  final String? groupValue;
  final IconData icon;
  final String label;
  final Function(String?) onChanged;

  const _GenderChoice({
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? colors.primary : Colors.blue.shade100,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade50,
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 34,
                color: isSelected ? colors.primary : Colors.blueGrey.shade600),
            const SizedBox(width: 16),
            Text(label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colors.primary : Colors.blueGrey.shade800,
                )),
          ],
        ),
      ),
    );
  }
}
