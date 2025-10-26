import 'package:flutter/material.dart';

// Sizin renk fonksiyonunuzu kullanıyoruz
Color _colorForActivation(int level) {
  switch (level.clamp(0, 5)) {
    case 1:
      return const Color(0x66ADFF2F); // Açık Yeşil (Minimal)
    case 2:
      return const Color(0x66FFFF00); // Sarı (Düşük)
    case 3:
      return const Color(0x66FFA500); // Turuncu (Orta)
    case 4:
      return const Color(0x66FF0000); // Kırmızı (Yüksek)
    case 5:
      return const Color(0x66800000); // Koyu Bordo (Maksimum)
    default:
      return const Color(0x00000000); // Şeffaf (Yok)
  }
}

// Aktivasyon seviyesi için açıklama metinlerini döndüren yardımcı fonksiyon
String _textForActivationLevel(int level) {
  switch (level) {
    case 5:
      return 'Maksimum (Hedef Kas Grubu)';
    case 4:
      return 'Yüksek (Birincil)';
    case 3:
      return 'Orta (Destekleyici, İkincil)';
    case 2:
      return 'Düşük (Stabilizatör)';
    case 1:
      return 'Minimal';
    default:
      return 'Yok';
  }
}

// Tek bir aktivasyon seviyesinin gösterimi için widget
Widget _buildLegendItem(BuildContext context, int level) {
  // Seviye 0 (Yok) gösterilmez
  if (level == 0) return const SizedBox.shrink();

  final color = _colorForActivation(level);
  final text = _textForActivationLevel(level);

  // Tema rengini kullanarak text rengini ayarlayalım
  final textColor = Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black87;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisSize: MainAxisSize.min, // Sadece içeriği kadar yer kaplar
      children: [
        // Renkli Yuvarlak Daire
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            // Şeffaf olduğu için kenarlık ekleyerek daha belirgin hale getirebiliriz
            border: Border.all(
              color: color.withOpacity(1.0).withAlpha(0xFF).withOpacity(0.5),
              // Opak versiyonunun yarım opaklığı
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Açıklama Metni
        Text(
          text,
          style: TextStyle(fontSize: 14, color: textColor),
        ),
      ],
    ),
  );
}

// Ana Gösterge (Lejant) Widget'ı
class ActivationLevelLegend extends StatelessWidget {
  const ActivationLevelLegend({super.key});

  @override
  Widget build(BuildContext context) {
    // 5'ten 1'e doğru sıralama (en yoğun olanı en üste koymak için)
    const List<int> levels = [5, 4, 3, 2, 1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        ...levels.map((level) => _buildLegendItem(context, level)).toList(),
      ],
    );
  }
}

// Kullanım Örneği:
/*
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(10)
          ),
          child: const ActivationLevelLegend(),
        ),
      ),
    );
  }
}
*/
