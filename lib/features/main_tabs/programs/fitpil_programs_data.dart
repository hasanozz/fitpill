class FitpilProgram {
  const FitpilProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.focus,
    required this.duration,
    this.level,
    this.highlights = const <String>[],
  });

  final String id;
  final String title;
  final String description;
  final String focus;
  final String duration;
  final String? level;
  final List<String> highlights;
}

const fitpilPrograms = <FitpilProgram>[
  FitpilProgram(
    id: 'fitpil-upper-body-blast',
    title: 'Upper Body Blast',
    description:
        'Strength-focused push and pull session designed to light up chest, back and arms.',
    focus: 'Push/Pull Supersets',
    duration: '45 dk',
    level: 'Orta',
    highlights: [
      'Isınma band devresi',
      '6 hareketlik süperset akışı',
      'Finisher: Burnout push-up ladder',
    ],
  ),
  FitpilProgram(
    id: 'fitpil-leg-day-reset',
    title: 'Leg Day Reset',
    description:
        'Denge, güç ve mobiliteyi aynı seansta geliştiren fonksiyonel alt vücut programı.',
    focus: 'Bacak & Core Stabilizasyonu',
    duration: '50 dk',
    level: 'Orta',
    highlights: [
      'Tempo squat piramidi',
      'Tek bacak denge kombinasyonları',
      'Kettlebell finisher devresi',
    ],
  ),
  FitpilProgram(
    id: 'fitpil-engine-builder',
    title: 'Engine Builder',
    description:
        'Kalp ritmini yükselten ve kondisyonu sürdürülebilir şekilde geliştiren hibrit kardiyo güç antrenmanı.',
    focus: 'Metabolik Kondisyon',
    duration: '35 dk',
    level: 'Tüm seviyeler',
    highlights: [
      'EMOM kombinasyonları',
      'Air bike / rower seçenekleri',
      'Kapalı devre core güçlendirme',
    ],
  ),
  FitpilProgram(
    id: 'fitpil-mobility-flow',
    title: 'Mobility Flow',
    description:
        'Esnekliği artırıp kas gerginliğini azaltan, nefes odaklı akış hareketlerinden oluşan rahatlatıcı seans.',
    focus: 'Mobilite & Esneme',
    duration: '30 dk',
    level: 'Başlangıç',
    highlights: [
      'Dinamik kalça açıcılar',
      'Omurga mobilizasyon sekansı',
      'Kapanış: Guided breathwork',
    ],
  ),
  FitpilProgram(
    id: 'fitpil-core-sculpt',
    title: 'Core Sculpt',
    description:
        'Vücudun merkez bölgesine odaklanan kuvvet ve dayanıklılık seansı; plank varyasyonları ve rotasyonel hareketler içerir.',
    focus: 'Core Güçlendirme',
    duration: '25 dk',
    level: 'Tüm seviyeler',
    highlights: [
      'Zaman altında plank serileri',
      'Anti-rotasyon hareketleri',
      'Dumbbell finisher kombinasyonu',
    ],
  ),
];

