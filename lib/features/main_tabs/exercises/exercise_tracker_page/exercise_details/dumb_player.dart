// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../settings/theme/theme_helper.dart';
//
// // 1. KENDİ R2 URL'NİZİ BURAYA YAPIŞTIRIN!
// const String r2MasterPlaylistUrl =
//     'https://media.fitpillapp.com/smith_machine_incline_press/master.m3u8';
//
// // ====================================================================
// // 2. VIDEO OYNATICI WIDGET'I
// // ====================================================================
//
// const List<Tab> _tabs = [
//   Tab(text: 'Target'),
//   Tab(text: 'Equipments'),
//   Tab(text: 'Info'),
// ];
//
// class ExerciseVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String title;
//
//   const ExerciseVideoPlayer({
//     super.key,
//     required this.videoUrl,
//     required this.title,
//   });
//
//   @override
//   State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
// }
//
// class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
//   late VideoPlayerController _controller;
//   double _currentSpeed = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         // Video yüklendiğinde otomatik oynat
//         _controller.setLooping(true);
//         _controller.play();
//         setState(() {});
//       }).catchError((error) {
//         // <-- KONSOLA YAZDIRMA
//         // Hata durumunda bile setState çağırın ki build metodu tetiklensin
//         setState(() {});
//       });
//   }
//
//   // Video durum dinleyicisi: Loop mantığı
//   void _videoListener() {
//     // Sadece controller initialize edilmişse ve döngüye girmesi gerekiyorsa
//     if (!_controller.value.isInitialized) return;
//
//     // Video bittiğinde (konum sürenin tamamına eşit veya yakınsa)
//     if (_controller.value.position >= _controller.value.duration) {}
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // Oynatma hızını 1.0x ve 0.5x arasında değiştirir
//   void _toggleSpeed() {
//     if (!_controller.value.isInitialized) return;
//
//     final newSpeed = _currentSpeed == 1.0 ? 0.5 : 1.0;
//     _controller.setPlaybackSpeed(newSpeed);
//     setState(() {
//       _currentSpeed = newSpeed;
//     });
//   }
//
//   void _togglePlayPause() {
//     if (!_controller.value.isInitialized) return;
//
//     setState(() {
//       _controller.value.isPlaying ? _controller.pause() : _controller.play();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final videoHeight = screenHeight * 0.65;
//
//     if (!_controller.value.isInitialized) {
//       return Container(
//         height: videoHeight,
//         color: Colors.black,
//         child: const Center(
//           child: CircularProgressIndicator(
//               color: Colors.white), // TODO: BURAYA SCIMMER SKELETON EKLENECEK
//         ),
//       );
//     }
//
//     return DefaultTabController(
//       length: _tabs.length,
//       child: Scaffold(
//         body: Container(
//           color: ThemeHelper.getBackgroundColor(context),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 3. VİDEO VE KONTROLLERİN YER ALACAĞI STACK (YENİ YAPI)
//               SizedBox(
//                 height: videoHeight, // Stack'e zorunlu yüksekliği veriyoruz
//                 width: double.infinity,
//                 child: Stack(
//                   children: [
//                     // 1. KATMAN: VİDEO GÖRÜNTÜLEYİCİ (Tüm alanı kaplar)
//                     Container(
//                       color: Colors.black,
//                       // Layout mantığınız aynı kalır
//                       child: ClipRect(
//                         child: SizedBox(
//                           height: videoHeight,
//                           width: double.infinity,
//                           child: FittedBox(
//                             fit: BoxFit.cover,
//                             child: SizedBox(
//                               width: _controller.value.size.width,
//                               height: _controller.value.size.height,
//                               child: VideoPlayer(_controller),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 5.0),
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: TextButton(
//                           onPressed: _togglePlayPause,
//                           child: Icon(
//                             _controller.value.isPlaying
//                                 ? Icons.pause
//                                 : Icons.play_arrow,
//                             color: ThemeHelper.getFitPillColor(context),
//                             size: 30,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
//                       child: Align(
//                         alignment: Alignment.bottomRight,
//                         child: TextButton(
//                           onPressed: _toggleSpeed,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 Colors.grey.shade800.withValues(alpha: 0.75),
//                             // Arkaplan saydamlaştırıldı
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           child: Text(
//                             '${_currentSpeed.toStringAsFixed(1)}x',
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SafeArea(
//                       child: Align(
//                         alignment: Alignment.topLeft,
//                         child: IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Stack Sonu
//
//               // Video Kontrolleri ve Başlık (SADECE BAŞLIK KALDI)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // 4. Başlık
//                     Center(
//                       child: Text(
//                         widget.title,
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: ThemeHelper.getTextColor(context),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//
//               // 5. TabBar için yer
//               // ...
//
//               const TabBar(
//                 tabs: _tabs,
//                 indicatorColor: Colors.white,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.grey,
//                 // indicatorSize: TabBarIndicatorSize.label, // Opsiyonel
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     // ANLATIM Sekmesi İçeriği
//                     _buildTabContent(
//                         'Bu sekme, egzersizin adım adım anlatımını içerir.'),
//
//                     // KASLAR Sekmesi İçeriği
//                     _buildTabContent(
//                         'Bu sekme, çalıştırılan birincil ve ikincil kas gruplarını listeler.'),
//
//                     // NOTLAR Sekmesi İçeriği
//                     _buildTabContent(
//                         'Bu sekme, kullanıcıların egzersiz hakkındaki kişisel notlarını içerir.'),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget _buildTabContent(String content) {
//   // TabBarView içindeki her sekme içeriğini kaydırılabilir yapmak için
//   // SingleChildScrollView kullanmaya devam edebiliriz.
//   return SingleChildScrollView(
//     padding: const EdgeInsets.all(16.0),
//     child: Text(
//       content * 20, // İçeriği kaydırmayı göstermek için çoğalttık
//       style: const TextStyle(color: Colors.white70, fontSize: 16),
//     ),
//   );
// }
//
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   // ... (Gerekli kod aynı kalır)
//   _SliverAppBarDelegate(this._tabBar, this._backgroundColor);
//
//   final TabBar _tabBar;
//   final Color _backgroundColor;
//
//   @override
//   double get minExtent => _tabBar.preferredSize.height;
//
//   @override
//   double get maxExtent => _tabBar.preferredSize.height;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: _backgroundColor,
//       child: _tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }

import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:video_player/video_player.dart';

import 'package:fitpill/features/main_tabs/home/anatomy/anatomy_repository.dart';
import 'dumb_activation_level.dart';
import 'dumb_anatomy_view.dart';
import 'dumb_equipments.dart';
import 'dumb_info.dart';

// Varsayımsal ThemeHelper ve Extension (Sizin tema kodunuzdan alınmıştır)

extension ColorExtension on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return this.withOpacity(alpha);
    }
    return this;
  }
}

final cloudflareBaseUrl = dotenv.env['CLOUDFLARE_R2_BASE_URL']!;
final String r2MasterPlaylistUrl =
    '${cloudflareBaseUrl}smith_machine_incline_press/master.m3u8';

// ====================================================================
// 2. SABİT TANIMLAR
// ====================================================================

const List<Tab> _tabs = [
  Tab(text: 'TARGET'),
  Tab(text: 'EQUIPMENTS'),
  Tab(text: 'INFO'),
];

// ====================================================================
// 3. TABBARVIEW İÇERİK WIDGET'I
// ====================================================================

Widget _buildTabContent(String content) {
  // TabBarView içindeki içerikler NestedScrollView body'de olduğu için kayar
  return Padding(
    // Kaydırma efektini kaldırmak için buraya NoGlowScrollBehavior ekleyebilirsiniz.
    padding: const EdgeInsets.all(16.0),
    child: Text(
      content, // İçeriği kısa tuttum, test etmek için çoğaltabilirsiniz.
      style: const TextStyle(color: Colors.white70, fontSize: 16),
    ),
  );
}

// ====================================================================
// 4. VİDEO OYNATICI (SADECE GÖRÜNTÜ VE MANTIK)
// ====================================================================

// Artık sadece video oynatıcı ve kontrolleri döndürür.
class _VideoAndControls extends StatefulWidget {
  final String videoUrl;
  final double videoHeight;

  const _VideoAndControls({
    required this.videoUrl,
    required this.videoHeight,
  });

  @override
  State<_VideoAndControls> createState() => _VideoAndControlsState();
}

class _VideoAndControlsState extends State<_VideoAndControls> {
  late VideoPlayerController _controller;
  double _currentSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      }).catchError((error) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSpeed() {
    if (!_controller.value.isInitialized) return;
    final newSpeed = _currentSpeed == 1.0 ? 0.5 : 1.0;
    _controller.setPlaybackSpeed(newSpeed);
    setState(() {
      _currentSpeed = newSpeed;
    });
  }

  void _togglePlayPause() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(
        height: widget.videoHeight,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Container(
      color: ThemeHelper.getBackgroundColor(context),
      child: SizedBox(
        height: widget.videoHeight,
        width: double.infinity,
        child: Stack(
          children: [
            // 1. KATMAN: VİDEO GÖRÜNTÜLEYİCİ
            Container(
              color: Colors.black,
              child: ClipRect(
                child: SizedBox(
                  height: widget.videoHeight,
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            ),

            // KONTROLLER VE GERİ DÖN BUTONU (Hepsi Stack içinde ve videonun üzerinde)

            // PAUSE BUTONU
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextButton(
                  onPressed: _togglePlayPause,
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: ThemeHelper.getFitPillColor(context),
                    size: 30,
                  ),
                ),
              ),
            ),

            // HIZ BUTONU
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: TextButton(
                  onPressed: _toggleSpeed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800.withOpacity(0.75),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    '${_currentSpeed.toStringAsFixed(1)}x',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),

            // GERİ DÖN BUTONU (EN ÜSTTE)
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 5. SLIVERPERSISTENTHEADER İÇİN DELEGATE SINIFI
// ====================================================================

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._backgroundColor);

  final TabBar _tabBar;
  final Color _backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// ====================================================================
// 6. ANA SAYFA (ExerciseDetailPage) - Tüm Kaydırmayı Yönetir
// ====================================================================

class ExerciseDetailPage extends StatelessWidget {
  final String title;
  final String videoUrl;

  ExerciseDetailPage({
    super.key,

    // Varsayılan değerler artık null veya const string olabilir
    String? title,
    String? videoUrl,


    // this.title = 'Örnek Egzersiz: Derin Squat Hareketi',
    // this.videoUrl =  r2MasterPlaylistUrl,


  }): title = title ?? 'Örnek Egzersiz: Derin Squat Hareketi', // const string varsayılana atandı
  // Eğer videoUrl null ise (dışarıdan verilmediyse), runtime değerini ata
        videoUrl = videoUrl ?? r2MasterPlaylistUrl;
  // Üye (final fields) initialization listesi kullanıldı.;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final videoHeight = screenHeight * 0.65; // Video yüksekliğini belirle

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                // VİDEO VE BAŞLIK BU LISTENIN İÇİNDE KAYAR
                delegate: SliverChildListDelegate([
                  // 1. VİDEO OYNATICI VE KONTROLLER
                  _VideoAndControls(
                    videoUrl: videoUrl,
                    videoHeight: videoHeight,
                  ),

                  // 2. BAŞLIK (Video ile birlikte kayar)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ThemeHelper.getTextColor(context),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),

              // 3. TABBAR (KAYDIRMADA ÜSTE YAPIŞIR)
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: _tabs,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                  ),
                  ThemeHelper.getBackgroundColor(context),
                ),
                pinned: true,
              ),
            ];
          },

          // 4. TABBARVIEW İÇERİĞİ
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              buildSliverTabContent(
                Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MiniAnatomyHeatmap(
                            side: AnatomySide.front,
                            width: 240,
                            height: 360,
                            // Şimdilik sabit (JSON id'leriyle birebir):
                            activations: {
                              'chest': 5,
                              'anterior-deltoid': 4,
                              'lateral-triceps': 3,
                              'abs': 2,
                              'quadriceps': 1,
                              'obliques': 1,
                              'adductor': 5,
                              'biceps': 5,
                              'lateral-deltoid': 5,
                              'hip-flexors': 3,
                              'calves': 3,
                              'forearm': 2,
                              'upper-traps': 2,
                              'neck': 4
                            },
                          ),
                        ),
                        Expanded(
                          child: MiniAnatomyHeatmap(
                            side: AnatomySide.back,
                            width: 240,
                            height: 360,
                            // Şimdilik sabit (JSON id'leriyle birebir):
                            activations: {
                              'lats': 5,
                              'hamstings': 4,
                              'rotator-cuff': 3,
                              'upper-traps': 2,
                              'lateral-triceps': 3,
                              'glutes-maximus': 2,
                              'triceps-lateral-head': 3,
                              'lower-traps': 1,
                              'triceps-long-head': 5,
                              'obliques': 1,
                              'adductors': 5,
                              'lateral-deltoid': 5,
                              'posterior-deltoid': 4,
                              'glutes-medius': 4,
                              'spinal-erectors': 3,
                              'quadriceps': 1,
                              'calves': 3,
                              'forearm': 2,
                            },
                          ),
                        ),
                      ],
                    ),
                    const ActivationLevelLegend(),
                  ],
                ),
                // Örn: ExerciseDetailsHeader içinde
              ),
              buildSliverTabContent(
                buildEquipmentContent(context),
              ),
              buildSliverTabContent(
                buildInfoContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// TabBarView sayfası için: içerik kısa olsa bile boşluk bırakmadan
/// alanı doldurur, uzun olursa kaydırılır.
Widget buildSliverTabContent(Widget child) {
  return CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverToBoxAdapter(child: child),
      ),
      // İçerik kısa ise kalan alanı doldur, scroll ihtiyacı yoksa boş kayma olmaz.
      // const SliverFillRemaining(hasScrollBody: false),
    ],
  );
}
