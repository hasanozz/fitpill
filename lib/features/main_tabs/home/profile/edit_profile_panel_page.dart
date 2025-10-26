import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/utils/formatter.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/progress/progress_provider.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePanelPage extends ConsumerStatefulWidget {
  const EditProfilePanelPage({super.key});

  @override
  ConsumerState<EditProfilePanelPage> createState() =>
      _EditProfilePanelPageState();
}

class _EditProfilePanelPageState extends ConsumerState<EditProfilePanelPage> {
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  late String _selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).maybeWhen(
          data: (profile) => profile,
          orElse: () => null,
        );

    final latestWeight = ref.read(progressHistoryProvider('weight')).maybeWhen(
          data: (history) =>
              history.isNotEmpty ? history.first.value.toString() : '',
          orElse: () => '',
        );

    _nameController = TextEditingController(text: profile?.name ?? '');
    _birthDateController =
        TextEditingController(text: profile?.birthDate ?? '');
    _heightController =
        TextEditingController(text: profile?.height.toString() ?? '');
    _selectedGender = profile?.gender ?? '';
    _weightController =
        TextEditingController(text: formatDoubleFromString(latestWeight));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // void _openDatePicker() async {
  //   final selected = await showCustomDatePicker(context: context, initialDate: "2025-08-01", firstDate: 1900, lastDate: DateTime.now().year - 12);
  //   if (selected != null) {
  //     setState(() {
  //       _selectedDate = selected;
  //     });
  //   }
  // }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _saveProfile() async {
    final updatedProfile = ref.read(profileProvider).maybeWhen(
          data: (profile) => profile.copyWith(
            name: _nameController.text.trim(),
            birthDate: _birthDateController.text.trim(),
            height: _heightController.text.trim().isEmpty
                ? null
                : _heightController.text.trim(),
            gender: _selectedGender,
          ),
          orElse: () => null,
        );

    if (updatedProfile != null) {
      await ref.read(profileProvider.notifier).updateProfile(updatedProfile);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        title: Text(S.of(context)!.editProfile,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            const Divider(height: 0.5),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
            TextFormField(
              cursorColor: ThemeHelper.getTextColor(context),
              controller: _nameController,
              maxLength: 30,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              decoration: InputDecoration(
                labelText: S.of(context)!.name,
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                prefixIcon: const Icon(Icons.person),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: ThemeHelper.getTextColor(context),
              controller: _birthDateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: S.of(context)!.birthDate,
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.calendar_today),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              dropdownColor: ThemeHelper.getCardColor2(context),
              value: _selectedGender.isNotEmpty ? _selectedGender : null,
              items: [
                DropdownMenuItem(
                    value: 'male', child: Text(S.of(context)!.male)),
                DropdownMenuItem(
                    value: 'female', child: Text(S.of(context)!.female)),
              ],
              onChanged: (value) =>
                  setState(() => _selectedGender = value ?? ''),
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                labelText: S.of(context)!.gender,
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              cursorColor: ThemeHelper.getTextColor(context),
              controller: _heightController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: "${S.of(context)!.height} (cm)",
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.height),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _weightController,
              readOnly: true, // Kullanıcı değiştiremeyecek
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "${S.of(context)!.weight} (kg)",
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.monitor_weight),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor:
                    ThemeHelper.getCardColor2(context), // Hafif gri arka plan
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    S.of(context)!.weightTrackedInProgress,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
