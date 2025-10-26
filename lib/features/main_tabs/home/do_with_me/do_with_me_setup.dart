import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';

import 'do_with_me_activity_card.dart';
import 'do_with_me_tracker.dart';
import 'package:fitpill/l10n/l10n_extensions.dart';

// AKTİVİTE SETUP'I SÜRE, EĞİM FALAN AYARLAMA

class ActivitySetupScreen extends StatefulWidget {
  final Activity activity;

  const ActivitySetupScreen(this.activity, {super.key});

  @override
  _ActivitySetupScreenState createState() => _ActivitySetupScreenState();
}

class _ActivitySetupScreenState extends State<ActivitySetupScreen> {
  String _selectedTempo = 'medium'; // Varsayılan değer
  double _incline = 0.0;
  int _targetMinutes = 30;

  final Map<String, Color> _tempoColors = {
    'low': Colors.green, // 🔑 Anahtar kelime
    'medium': Colors.orange,
    'high': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.getActivityName(widget.activity.name)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (widget.activity.name.contains('walk') ||
                widget.activity.name.contains('run'))
              _buildParameterCard(
                title: S.of(context)!.incline,
                child: Slider(
                  value: _incline,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  label: _incline.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _incline = value),
                ),
              ),
            _buildParameterCard(
              title: S.of(context)!.tempoLevel,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _tempoColors.entries.map((entry) {
                  return ChoiceChip(
                    label: Text(S.of(context)!.getTempoName(entry.key)),
                    selected: _selectedTempo == entry.key,
                    selectedColor: entry.value.withAlpha((255 * 0.2).toInt()),
                    labelStyle: TextStyle(
                      color: _selectedTempo == entry.key
                          ? entry.value
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      setState(() => _selectedTempo = entry.key);
                    },
                  );
                }).toList(),
              ),
            ),
            _buildParameterCard(
              title: S.of(context)!.targetDuration,
              child: Slider(
                value: _targetMinutes.toDouble(),
                min: 5,
                max: 120,
                divisions: 23,
                label: _targetMinutes.toString(),
                onChanged: (value) =>
                    setState(() => _targetMinutes = value.toInt()),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, size: 28),
              label: Text(S.of(context)!.start,
                  style: const TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityTrackerScreen(
                    activity: widget.activity,
                    tempoKey: _selectedTempo,
                    incline: _incline,
                    targetMinutes: _targetMinutes,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
