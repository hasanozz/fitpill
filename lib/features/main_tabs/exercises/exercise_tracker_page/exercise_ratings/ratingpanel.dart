import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_rating_provider.dart';

class RatingPanel extends ConsumerStatefulWidget {
  final String exerciseName; // <-- gerekli
  const RatingPanel({super.key, required this.exerciseName});

  @override
  ConsumerState<RatingPanel> createState() => _RatingPanelState();
}

class _RatingPanelState extends ConsumerState<RatingPanel> {
  bool _open = false;
  int _selected = 0; // 0 => seçilmemiş
  bool _busy = false;

  int? _currentRating;

  void _toggle() {
    setState(() {
      _open = !_open;
      // Panel açılırken: _selected değerini kayıtlı rating'e eşitle
      if (_open) {
        _selected = _currentRating ?? 0;
      }
      // Panel kapanırken: _selected değeri zaten _currentRating olarak kalacak
      // veya _select'ten sonra güncellenmiş olacak.
    });
  }

  Future<void> _select(int stars) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _selected = stars;
    });

    // ARTIK SADECE kendi rating'ini yazıyoruz
    final setRating = ref.read(setMyExerciseRatingProvider);
    await setRating(exerciseName: widget.exerciseName, rating: stars);

    _currentRating = stars;

    // Cloud Function otomatik aggregate güncelleyecek
    // await Future.delayed(const Duration(milliseconds: 150));
    //
    // await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    setState(() {
      _busy = false;
      _open = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aggAsync = ref.watch(exerciseAggregateProvider(widget.exerciseName));
    final myRatingAsync =
        ref.watch(myExerciseRatingProvider(widget.exerciseName));

    myRatingAsync.whenData((rating) {
      if (rating != _currentRating) {
        _currentRating = rating;
        // Eğer panel kapalıysa, Riverpod'dan gelen yeni değeri _selected'a yansıt
        // ki panel açıldığında doğru değerle başlasın.
        if (!_open) {
          _selected = _currentRating ?? 0;
        }
        // setState gerekli DEĞİL çünkü StreamProvider'dan gelen veri zaten
        // build metodunu yeniden çağıracak.
      }
    });

    final avgText = aggAsync.when(
      data: (agg) => agg.average.toStringAsFixed(1),
      loading: () => "…",
      error: (_, __) => "—",
    );

    final countText = aggAsync.when(
      data: (agg) {
        final c = agg.ratingCount;
        if (c >= 1000000) return "${(c / 1000000).toStringAsFixed(1)}M kişi";
        if (c >= 1000) return "${(c / 1000).toStringAsFixed(1)}K kişi";
        return "$c kişi";
      },
      loading: () => "…",
      error: (_, __) => "—",
    );

    if (!_open) {
      return GestureDetector(
        onTap: _busy ? null : _toggle,
        child: Card(
          color: ThemeHelper.getCardColor2(context).withValues(alpha: 0.45),
          child: SizedBox(
            height: 50,
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      avgText,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, size: 24, color: Colors.amber),
                  ],
                ),
                Text(
                  countText,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: Card(
        color: ThemeHelper.getCardColor2(context).withValues(alpha: 0.45),
        child: Container(
          key: const ValueKey('panel'),
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final idx = i + 1;
                  final filled = _selected >= idx;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _busy ? null : () => _select(idx),
                      child: _busy && _selected == idx
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ThemeHelper.getFitPillColor(context),
                              ),
                            )
                          : Icon(filled ? Icons.star : Icons.star_border,
                              size: 30, color: Colors.amber),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _busy ? null : _toggle,
                child: const Icon(Icons.close,
                    size: 26, color: Colors.white, weight: 900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
