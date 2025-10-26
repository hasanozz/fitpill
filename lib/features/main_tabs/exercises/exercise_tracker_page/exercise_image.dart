import 'package:fitpill/features/main_tabs/exercises/exercise_tracker_page/exercise_ratings/ratingpanel.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'exercise_details/dumb_player.dart';

/// Exercise Overview Sayfasında üst kısımdaki egzersizin görselinin olduğu kısım.
/// Bu sayfa Görsel, egzersizin ismi, yıldız(egzersizin kullanıcılar tarafından aldığı puan) ve Details butonunu(egzersizin videsonu açar) barındırıyor

class ExerciseImage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double cropFocusY;
  final VoidCallback? onDetails;


  const ExerciseImage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.cropFocusY,
    required this.onDetails,

  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double alignY = (cropFocusY.clamp(0.0, 1.0) * 2) - 1;
    final cloudflareBaseUrl =  dotenv.env['CLOUDFLARE_R2_BASE_URL']!;
    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// Cloudflare r2'den gelen url ile görseli gösteriyoruz
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment(0, alignY),
          ),

          /// üst tarafta karartmalı geçiş yapmak için
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0, 0.54),
                colors: [Colors.black26, Colors.transparent],
              ),
            ),
          ),

          /// alt tarafta karartmalı geçiş yapmak için
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.22,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -0.2),
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xAA000000),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Align(
                alignment: Alignment.topRight,
                child: RatingPanel(
                  exerciseName: title,
                ),
              ),
            ),
          ),

          /// Görsel üstündeki Overlay ---> egzersiz ismi, yıldız, details butonu...
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Sol alt: egzersiz ismi
                    Expanded(
                      child: FittedBox(
                        /// egzersiz ismi sığmazsa text boyutunu küçültüyor. ya çok küçültürse?
                        /// auto_size_text kütüphanesi ile hem 2 satıra indirilip hem de text boyutu küçültülebilir hangisi uygunsa
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    /// appbar olmadığı için yıldız vs telefonun üst bilgi kısmında (şarj, saat vs.) olmasın diye safearea kullandım
                    /// sağ üstte yıldız ve puan, altta details butonu
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          // const ExerciseDetailPage(),
                                          // ExerciseVideoPlayer(
                                          //   title: title,
                                          //   videoUrl:
                                          //       'https://media.fitpillapp.com/smith_machine_incline_press/master.m3u8',
                                          // )),
                                          ExerciseDetailPage(
                                            // Her seferinde CDN'i tazelemeye zorlayacak bir sorgu parametresi ekleyin
                                            videoUrl:
                                                '${cloudflareBaseUrl}smith_machine_incline_press/master.m3u8',
                                            title: title,
                                          )));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  ThemeHelper.getCardColor2(context)
                                      .withValues(alpha: 0.45),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Details'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
