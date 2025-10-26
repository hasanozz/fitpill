// ====================================================================
// YARDIMCI WIDGET: Title ve Value gösterimi
// ====================================================================

import 'package:fitpill/core/system/config//theme/theme_helper.dart';
import 'package:flutter/material.dart';

Widget _buildInfoRow({
  required BuildContext context,
  required String title,
  required Widget valueWidget,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BAŞLIK (Gri veya Açık Renk)
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white60, // Koyu arka planda daha yumuşak görünür
          ),
        ),
        const SizedBox(height: 4),
        // DEĞER (Daha Büyük ve Vurgulu)
        valueWidget,
      ],
    ),
  );
}

// ====================================================================
// YARDIMCI WIDGET: Stimulus/Fatigue Puan Görseli
// ====================================================================

Widget _buildRatingBar(int score, int maxScore, Color color, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label ($score/$maxScore)',
        style: TextStyle(
          fontSize: 14,
          color: color.withOpacity(0.8),
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Row(
        children: List.generate(maxScore, (index) {
          // Score'a göre rengi belirle
          return Icon(
            Icons.circle, // Yuvarlak daire
            size: 16,
            color: index < score ? color : color.withOpacity(0.2),
          );
        }),
      ),
    ],
  );
}

// ====================================================================
// 9. INFO SEKMESİ ANA İÇERİĞİ
// ====================================================================

Widget buildInfoContent(BuildContext context) {
  // Örnek Veriler (Bu verileri egzersizinize göre dinamik olarak almalısınız)
  const int stimulus = 4; // 5 üzerinden
  const int fatigue = 2; // 5 üzerinden
  const String riskLevel = 'Orta (Dizler)';
  const String biomechanicFocus = 'Uzun Kas Pozisyonu (Stretched)';
  const String exerciseType = 'Compound (Bileşik)';
  const String stabilization = 'Yüksek Core Katılımı';

  // Basit bir tema helper tanımı (eğer kodunuzda yoksa)
  final Color fitPillColor = ThemeHelper.getFitPillColor(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ----------------------------------------------------
      // 1. Stimulus / Fatigue Oranı (ÖZEL BÖLÜM)
      // ----------------------------------------------------
      _buildInfoRow(
        context: context,
        title: 'STIMULUS / FATIGUE (Uyarı / Yorgunluk)',
        valueWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRatingBar(
                  stimulus,
                  5,
                  Colors.red, // Stimulus için Kırmızı
                  'Stimulus (Uyarı)',
                ),
                const SizedBox(width: 10),
                _buildRatingBar(
                  fatigue,
                  5,
                  Colors.grey.shade600, // Fatigue için Gri
                  'Fatigue (Yorgunluk)',
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              '[Yüksek Stimulus, Düşük Fatigue]. Hızlı toparlanma sağlarken yüksek kas gelişimi uyarısı sunar. Sık programlamaya (yüksek frekansa) uygundur.',
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.getTextColor(context),
              ),
            ),
          ],
        ),
      ),
      const Divider(color: Colors.white12),

      // ----------------------------------------------------
      // 2. Zorluk Seviyesi
      // ----------------------------------------------------
      _buildInfoRow(
        context: context,
        title: 'ZORLUK SEVİYESİ',
        valueWidget: Text(
          'Orta / İleri',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: fitPillColor,
          ),
        ),
      ),
      const Divider(color: Colors.white12),

      // ----------------------------------------------------
      // 3. Risk ve Form İpuçları
      // ----------------------------------------------------
      _buildInfoRow(
        context: context,
        title: 'RİSK SEVİYESİ VE ODAK',
        valueWidget: Text(
          '$riskLevel - Dikkatli Form',
          style: TextStyle(
            fontSize: 16,
            color: riskLevel.contains('Orta') ? Colors.orange : Colors.green,
          ),
        ),
      ),
      const Divider(color: Colors.white12),

      // ----------------------------------------------------
      // 4. Biyomekanik Odak
      // ----------------------------------------------------
      _buildInfoRow(
        context: context,
        title: 'BİYOMEKANİK ODAK',
        valueWidget: Text(
          biomechanicFocus,
          style: TextStyle(
            fontSize: 16,
            color: ThemeHelper.getTextColor(context),
          ),
        ),
      ),
      const Divider(color: Colors.white12),

      // ----------------------------------------------------
      // 5. Egzersiz Tipi
      // ----------------------------------------------------
      _buildInfoRow(
        context: context,
        title: 'EGZERSİZ TİPİ',
        valueWidget: Text(
          exerciseType,
          style: TextStyle(
            fontSize: 16,
            color: ThemeHelper.getTextColor(context),
          ),
        ),
      ),
      const Divider(color: Colors.white12),

      // ----------------------------------------------------
      // 6. Gerekli Stabilizasyon
      // ----------------------------------------------------
      _buildInfoRow(
        context: context,
        title: 'GEREKLİ STABİLİZASYON',
        valueWidget: Text(
          stabilization,
          style: TextStyle(
            fontSize: 16,
            color: ThemeHelper.getTextColor(context),
          ),
        ),
      ),
    ],
  );
}

// ====================================================================
// KULLANIMI (ExerciseDetailPage içinde)
// ====================================================================
/*
// ... TabBarView içinde ...

              // INFO sekmesi
              buildSliverTabContent(
                _buildInfoContent(context),
              ),
*/
