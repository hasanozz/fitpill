import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/exercise_image.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/user_exercise_provider.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/volume_score_line_chart.dart';
import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/weightLineChart.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/core/utils/formatter.dart';
import 'package:fitpill/core/ui/dialogs/show_dialogs.dart';
import 'exercise_set_model.dart';
import 'persona_best_card.dart';

/// Exercise Overview sayfası. egzersizin görseli, kaç puan aldığı. Set ekleme, set geçmişini görme, grafikleri görme.
/// Details butonuna basınca egzersizin videosunun olduğu sayfa açılır

class ExerciseOverviewPage extends ConsumerStatefulWidget {
  final String exerciseName;

  const ExerciseOverviewPage({super.key, required this.exerciseName});

  @override
  ConsumerState<ExerciseOverviewPage> createState() =>
      _ExerciseOverviewPageState();
}

class _ExerciseOverviewPageState extends ConsumerState<ExerciseOverviewPage> {
  /// Görsel ve grafiklerin olduğu kısım için page controller
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double headerHeight = (size.height * 0.37).clamp(160.0, 360.0);
    final isDark = ThemeHelper.isDarkTheme(context);
    final fitpillColor = ThemeHelper.getFitPillColor(context);
    final cloudflareBaseUrl =  dotenv.env['CLOUDFLARE_R2_BASE_URL']!;

    /// görsel ve grafiklerin olduğu liste pageview'de direkt kullanılacak
    final List<Widget> headerPages = [
      ExerciseImage(
        imageUrl:
            "${cloudflareBaseUrl}images/incline_smith_machine.png",
        title: widget.exerciseName,
        cropFocusY: 0.1,
        onDetails: () {},
      ),
      WeightLineChart(exerciseName: widget.exerciseName),
      VolumeScoreLineChart(exerciseName: widget.exerciseName),
    ];

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Egzersizin görselinin, isminin kaç puan aldığını gösteren yıldızın ve details butonunu gösteren sayfayı çağırıyoruz. En üst kısım
              SizedBox(
                // Sizedbox ile height vermezsen pageview 0px algılıyıp görünmüyor.
                height: headerHeight,
                width: double.infinity,

                /// Egzersiz görseli ve grafik bölümü pageview ile yana kaydırmalı
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPageIndex = i),
                  children: headerPages,
                ),
              ),

              /// DOTS. HANGİ PAGE'DEYİZ? SORUSUNA CEVAP
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(headerPages.length, (index) {
                  final bool active = _currentPageIndex == index;

                  /// Animasyonlu geçiş
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: active
                          ? fitpillColor // LIGHT MODE LACIVERT RENGI
                          : (isDark ? Colors.white24 : Colors.black26),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Kişisel en iyi skorları gösteren kart "persona_best_card.dart" sayfasından çekiyoruz. Heaviest Set, Highest Volume. İkisini de gösteriyor row halinde
                    PersonalBestCard(exerciseName: widget.exerciseName),
                  ],
                ),
              ),

              /// eklenen setlerin olduğu kısım. set geçmişi
              Expanded(
                child: Builder(
                  builder: (context) {
                    /// egzersizleri provider'dan çekiyor
                    final setsAsync =
                        ref.watch(userExerciseProvider(widget.exerciseName));

                    /// eğer çekememişse hata circularprogressindicator gösteriyor sonra hata mesajı veriyor.
                    return setsAsync.when(
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: fitpillColor,
                              ),
                            ),
                        error: (e, _) => Center(
                              child: Text('${S.of(context)!.error} $e'),
                            ),
                        data: (sets) {
                          if (sets.isEmpty) {
                            return Center(
                              child: Text(S.of(context)!.noSetsYet),
                            );
                          }

                          /// çekmişse listeliyor.
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            // ufak bi padding veriyor en alttaki listTile yapışık olmasın alta diye.
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: sets.length,
                                itemBuilder: (context, index) {
                                  // TODO: BURDAKİ TARİH DALGALARI TAŞINABİLİR Mİ BAŞKA YERE? KALABALIK VE CAN SIKICI DURUYOR
                                  final set = sets[index];
                                  final now = DateTime.now();
                                  final difference =
                                      now.difference(set.exerciseDate).inDays;
                                  final String timeAgoText = difference == 0
                                      ? S.of(context)!.today
                                      : difference == 1
                                          ? S.of(context)!.yesterday
                                          : '$difference ${S.of(context)!.dayAgo}';

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                    clipBehavior: Clip.hardEdge,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    color: ThemeHelper.getCardColor2(context),
                                    child: Slidable(
                                      key: ValueKey(set.id),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),

                                        extentRatio: 0.25,
                                        // slidablelar %25 kadar açılıyor
                                        children: [
                                          CustomSlidableAction(
                                            onPressed: (_) async {
                                              await ref
                                                  .read(userExerciseProvider(
                                                          widget.exerciseName)
                                                      .notifier)
                                                  .deleteSet(setId: set.id, exerciseId: widget.exerciseName);
                                            },
                                            backgroundColor: Colors.red,
                                            flex: 1,
                                            autoClose: true,
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          '${formatDoubleFromString(set.weight.toString())} x ${set.reps} @${formatDoubleFromString(set.rir.toString())} RIR  ',
                                          style: TextStyle(
                                            color: ThemeHelper.getTextColor(
                                                context),
                                          ),
                                        ),
                                        trailing: Text(
                                          timeAgoText,
                                          style: TextStyle(
                                              color: ThemeHelper.getTextColor(
                                                      context)
                                                  .withAlpha(111),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        });
                  },
                ),
              ),
            ],
          ),

          /// SET EKLEME BUTONU
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    /// OPEN BOTTOM SHEETI ACIYOR SET EKLEME İÇİN OLANI.
                    // TODO: BUNUN YERİNE ÜSTTE SET EKLEME? BEST CARDLARIN ALTINDA?
                    openBottomSheetAddSet(
                        context: context,
                        ref: ref,
                        exerciseName: widget.exerciseName,
                        onSubmit: (ExerciseSet set) async {
                          try {
                            await ref
                                .read(userExerciseProvider(widget.exerciseName)
                                    .notifier)
                                .addSet(
                                  set:set,
                              exerciseId: widget.exerciseName
                                );
                          } catch (e) {
                            /// BURDAKİ SNACKBARMESSAGE'I DEĞİŞ. ÜSTTE OLABİLİR.
                            ScaffoldMessenger.of(context).showSnackBar(
                              //BİZİM SNKACBARI KULAN
                              SnackBar(
                                content: Text('${S.of(context)!.error}: $e'),
                              ),
                            );
                          }
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fitpillColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    S.of(context)!.addSet,
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeHelper.getBackgroundColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: ThemeHelper.getFitPillColor(context),
                    size: 24,
                    weight: 900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
