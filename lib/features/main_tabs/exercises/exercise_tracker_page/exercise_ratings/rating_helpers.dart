String exerciseIdFromName(String name) {
  // Türkçe karakterleri sadeleştir
  const map = {
    'ç': 'c',
    'ğ': 'g',
    'ı': 'i',
    'ö': 'o',
    'ş': 's',
    'ü': 'u',
    'Ç': 'c',
    'Ğ': 'g',
    'İ': 'i',
    'I': 'i',
    'Ö': 'o',
    'Ş': 's',
    'Ü': 'u',
  };
  final buf = StringBuffer();
  for (final ch in name.trim().runes) {
    final s = String.fromCharCode(ch);
    buf.write(map[s] ?? s);
  }
  // lower → harf/rakam dışını _ yap → birden çok _’yı tekine indir → baş/son _ kırp
  var slug = buf.toString().toLowerCase();
  slug = slug.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  slug = slug.replaceAll(RegExp(r'_+'), '_');
  slug = slug.replaceAll(RegExp(r'^_|_$'), '');
  return slug; // örn: "Bench Press" -> "bench_press"
}
