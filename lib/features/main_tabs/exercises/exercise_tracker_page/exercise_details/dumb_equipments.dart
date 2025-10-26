// ====================================================================
// 7. EKİPMAN LİSTESİ İTEM WİDGET'I
// ====================================================================
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';

Widget _buildEquipmentListItem({
  required String imagePath,
  required String name,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        // 1. İKON (Büyük ve Vurgulu)
        SizedBox(
          width: 36,
          height: 44,
          child: Image.asset(
            imagePath,
            color: ThemeHelper.getTextColor(context),
            // Tema renginizi kullanın
            // size: 32, // İkonu biraz büyük yaptık
          ),
        ),
        const SizedBox(width: 20),
        // 2. EKİPMAN ADI (Büyük ve Kalın)
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600, // Hafif kalın
              color: ThemeHelper.getTextColor(context),
            ),
          ),
        ),
      ],
    ),
  );
}

// ====================================================================
// 8. EKİPMAN LİSTESİ ANA İÇERİĞİ
// ====================================================================

Widget buildEquipmentContent(BuildContext context) {
  // Tema rengini varsayılan olarak mavi tonlarında alalım (eğer ThemeHelper yoksa)
  // FitPillColor yerine Colors.blue veya Colors.orange kullanabilirsiniz.

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Örnek Ekipmanlar (Dumb İçerik)
      _buildEquipmentListItem(
        imagePath: 'assets/images/dumbbell2.png', // Geçici İkon
        name: 'Smith Machine',
        context: context,
      ),
      const Divider(color: Colors.white12),
      _buildEquipmentListItem(
        imagePath: 'assets/images/dumbbell2.png', // Geçici İkon
        name: 'Ayarlanabilir Bench Sehpası',
        context: context,
      ),
      const Divider(color: Colors.white12),
      _buildEquipmentListItem(
        imagePath: 'assets/images/dumbbell2.png', // Geçici İkon
        name: 'Ağırlık Plakaları (20kg, 10kg)',
        context: context,
      ),
      const Divider(color: Colors.white12),
      _buildEquipmentListItem(
        imagePath: 'assets/images/dumbbell2.png', // Geçici İkon
        name: 'Opsiyonel: Antrenman Eldiveni',
        context: context,
      ),
      // Eğer içerik çok kısa ise, buraya biraz daha fazla içerik ekleyebilirsiniz.
    ],
  );
}

// ====================================================================
// KULLANIMI (ExerciseDetailPage içinde)
// ====================================================================
// Eski kodunuzdaki buildSliverTabContent fonksiyonu yerine bunu kullanın:
/*
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // TARGET sekmesi
              buildSliverTabContent(
                Text('Hedef kaslar, birincil ve ikincil kas grupları...'),
              ),

              // EQUIPMENTS sekmesi (GÜNCELLENDİ)
              buildSliverTabContent(
                _buildEquipmentContent(context), // <-- Yeni içerik burada!
              ),

              // INFO sekmesi
              buildSliverTabContent(
                Text('Egzersiz tarihçesi, zorluk seviyesi ve uyarılar...'),
              ),
            ],
          ),
*/
