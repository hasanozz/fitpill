import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyTypeCalculator extends StatefulWidget {
  const BodyTypeCalculator({super.key});

  @override
  State<BodyTypeCalculator> createState() => _BodyTypeCalculatorState();
}

class _BodyTypeCalculatorState extends State<BodyTypeCalculator> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<int?> selectedAnswers = List.generate(5, (index) => null);

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          '1. Bir elin baş ve orta parmağıyla diğer el bileğinizi kavradığınızda hangisi gerçekleşiyor?',
      'options': [
        'Parmaklar üst üste geliyor',
        'Parmaklar uç uca denk geliyor',
        'Parmaklar birbirine ulaşamıyor',
      ],
    },
    {
      'question':
          '2. Aynaya baktığınızda vücudunuzda ilk hangisi dikkat çekiyor?',
      'options': [
        'Kemiklerim belirgin',
        'Kaslarım belirgin',
        'Yağlarım belirgin',
      ],
    },
    {
      'question': '3. Kilo alıp-verme konusunda hangisi seni daha iyi tanımlar',
      'options': [
        'Yiyorum yiyorum, kilo alamıyorum',
        'Kilo alıp-verme konusunda pek zorlanmam',
        'Su içsem yarıyor',
      ],
    },
    {
      'question': '4. Vücut yapınızı nasıl tanımlarsınız?',
      'options': [
        'İnce ve uzun (kalem gibi)',
        'Dengeli (kum saati)',
        'Alt bölgede daha geniş (armut gibi)',
      ],
    },
    {
      'question': '5. Egzersize ara verdiğinizde hangisi gerçekleşir?',
      'options': [
        'Kilo kaybediyorum',
        'Pek değişmiyor',
        'Kilo alıyorum',
      ],
    },
  ];

  Widget buildQuestionPage(int index) {
    final questionData = questions[index];
    final String questiongText = questionData['question'];
    final List<String> options = List<String>.from(questionData['options']);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questiongText,
            // style: TextStyle(
            //   fontSize: 18,
            //   fontWeight: FontWeight.bold,
            //   color: ThemeHelper.getTextColor(context),
            // ),
            style: GoogleFonts.russoOne(
              fontSize: 16,
              color: ThemeHelper.getTextColor(context),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ...List.generate(options.length, (optionIndex) {
            final isSelected = selectedAnswers[index] == optionIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAnswers[index] = optionIndex;
                });
                if (_currentPage < questions.length - 1) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                }
              },
              child: Card(
                color: ThemeHelper.getCardColor(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? ThemeHelper.isDarkTheme(context)
                            ? Colors.amber
                            : Colors.blue
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    options[optionIndex],
                    // style: TextStyle(
                    //   fontSize: 16,
                    //   color: ThemeHelper.getTextColor(context),
                    // ),
                    style: GoogleFonts.russoOne(
                      fontSize: 14,
                      color: ThemeHelper.getTextColor(context)
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  void calculateBodyType() {
    int ekto = 0;
    int mezo = 0;
    int endo = 0;

    for (var answer in selectedAnswers) {
      switch (answer) {
        case 0:
          ekto += 20;
          break;
        case 1:
          mezo += 20;
          break;
        case 2:
          endo += 20;
          break;
      }
    }

    final result = {
      'Ektomorf': ekto,
      'Mezomorf': mezo,
      'Endomorf': endo,
    };

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(result: result),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        title: Text(
          "Vücut Tipi Hesaplayıcı",
          style: GoogleFonts.tomorrow(
            fontSize: 20,
            color: ThemeHelper.getTextColor(context),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Divider(
              height: 0.1,
              color: ThemeHelper.getTextColor(context),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return buildQuestionPage(index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: _currentPage != 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Önceki'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side:
                          BorderSide(color: ThemeHelper.getTextColor(context)),
                      foregroundColor: ThemeHelper.getTextColor(context),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                Text(
                  'Soru ${_currentPage + 1} / 5',
                  style: TextStyle(
                    fontSize: 18,
                    color: ThemeHelper.getTextColor(context),
                  ),
                ),
                Visibility(
                  visible: _currentPage == questions.length - 1 &&
                      selectedAnswers[questions.length - 1] != null,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      calculateBodyType();
                    },
                    label: const Text('Sonuçları Gör'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side:
                          BorderSide(color: ThemeHelper.getTextColor(context)),
                      foregroundColor: ThemeHelper.getTextColor(context),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final Map<String, int> result;

  const ResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final total = result.values.reduce((a, b) => a + b);
    final ekto = result['Ektomorf'] ?? 0;
    final mezo = result['Mezomorf'] ?? 0;
    final endo = result['Endomorf'] ?? 0;

    final yorum = generateBodyTypeComment(ekto, mezo, endo);

    final textColor = ThemeHelper.getTextColor(context);
    final backgroundColor = ThemeHelper.getCardColor(context);
    final accentColor =
        ThemeHelper.isDarkTheme(context) ? Colors.amber : Colors.blue.shade600;

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        title: Text(
          'Vücut Tipi Sonucu',
          // style: TextStyle(color: textColor),
          style: GoogleFonts.russoOne(
            // fontSize: 18,
            color: textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Divider(
              height: 0.1,
              color: ThemeHelper.getTextColor(context),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ...result.entries.map((entry) {
                    final percent = (entry.value / total * 100).round();

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: textColor.withAlpha((255 * 0.3).toInt())),
                      ),
                      elevation: 2,
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                entry.key,
                                // style: TextStyle(
                                //   fontSize: 18,
                                //   fontWeight: FontWeight.bold,
                                //   color: textColor,
                                // ),
                                // style: GoogleFonts.russoOne(
                                //   fontSize: 18,
                                //   color: textColor,
                                // ),
                                style: GoogleFonts.tomorrow(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: LinearProgressIndicator(
                                  value: percent / 100,
                                  minHeight: 10,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      accentColor),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '%$percent',
                                textAlign: TextAlign.end,
                                // style: TextStyle(
                                //   fontSize: 16,
                                //   color: textColor,
                                // ),
                                // style: GoogleFonts.russoOne(
                                //   fontSize: 16,
                                //   color: textColor,
                                // ),
                                style: GoogleFonts.tomorrow(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  Text(
                    yorum,
                    style: GoogleFonts.tomorrow(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String generateBodyTypeComment(int ekto, int mezo, int endo) {
  final Map<String, int> sorted = {
    'Ektomorf': ekto,
    'Mezomorf': mezo,
    'Endomorf': endo,
  };

  final sortedList = sorted.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final top = sortedList[0];
  final second = sortedList[1];
  final third = sortedList[2];

  final topName = top.key;
  final topValue = top.value;
  final secondName = second.key;
  final secondValue = second.value;

  // TEK BASKIN
  if (topValue >= 80) {
    if (topName == 'Ektomorf') {
      return 'Düşük yağ oranı, dar omuzlar ve ince kemik yapısıyla kilo almakta ve kas kazanmakta genetik olarak dezavantajlı olabilirsiniz. '
          'Aşırı kardiyo, gelişiminizi baltalayabilir; bu nedenle enerji fazlasını koruyarak özellikle karbonhidratı yüksek tutmanız faydalı olur. '
          'Bulk dönemlerinde %50–60 karbonhidrat oranı idealdir; definasyonda bile karbonhidratı aşırı kısmaya gerek yoktur. '
          'Kalori ihtiyacınızı karşılamakta zorlanıyorsanız, süt bazlı shake’ler, smoothie’ler ve enerji yoğun öğünler (fıstık ezmesi, bal, zeytinyağı, kuru yemiş) pratik ve etkili çözümler sunar.';
    } else if (topName == 'Mezomorf') {
      return 'Atletik ve dengeli bir vücut yapısına sahipsiniz. Kas kazanımı sizin için genetik olarak daha kolay, '
          'kilo kontrolü ise genellikle rahattır. Bu yapı sayesinde hem bulk hem definasyon '
          'dönemlerini daha esnek yönetebilirsiniz.'
          'Bulk döneminde %45–55 karbonhidrat oranı kas gelişimi için yeterlidir. '
          'Yağlanma riski oluşursa önce yağ alımına odaklanmak genellikle daha doğru bir stratejidir. Definasyonda ise karbonhidratı aşırı kısmadan (%35–45 aralığında), formunuzu koruyabilir ve kas kaybı yaşamadan ilerleyebilirsiniz.'
          'Beslenme düzeninizde kompleks karbonhidratlara, yeterli protein alımına ve dengeli yağ kaynaklarına yer vermek, '
          'performansınızı ve görünümünüzü sürdürülebilir hâle getirir.';
    } else {
      return 'Geniş omuzlara, dolgun kaslara ve daha yüksek yağ oranına sahip bir vücut tipiniz var. '
          'Kas kazanımı genetik olarak kolay olsa da, yağlanma eğiliminiz oldukça yüksektir. '
          'Bu nedenle kalori kontrolü ve karbonhidrat yönetimi antrenman kadar önemlidir. '
          'Definasyon döneminde düşük karbonhidratlı (%20–25) beslenme, insülin direncinizin etkisini dengelemeye '
          'yardımcı olur. Yağ ve protein oranını yüksek tutmak (özellikle %40–45 yağ, %30–35 protein) '
          'yağ yakımını desteklerken kas kaybını önler. '
          'Antrenman rutininize kardiyoyu mutlaka dâhil etmeniz önerilir. '
          'Böylece kalori açığını sadece beslenmeyle değil, hareketle de destekleyerek sürdürülebilir '
          'bir denge yakalayabilirsiniz. Fonksiyonel ve çok eklemli hareketlere öncelik vermek, daha '
          'fazla kası aktive ederek yağ yakım sürecini hızlandırır.';
    }
  }

  // 60-40 TİPİK KOMBİNLER
  if (topValue == 60 && secondValue == 40) {
    if (topName == 'Ektomorf' && secondName == 'Mezomorf') {
      return 'Zayıf kemik yapınız ve düşük yağ oranınız, sizi ektomorf yapıya yakınlaştırsa da kas '
          'gelişimine yatkınlığınız mezomorf etkisini hissettiriyor. Bu ikili yapı sayesinde hacim kazanmakta '
          'zorlanabilirsiniz ama doğru antrenman ve yeterli kaloriyle oldukça estetik bir form yakalayabilirsiniz.'
          'Antrenmanlarda toparlanmaya dikkat ederek yüksek yoğunluklu ama sürdürülebilir bir program benimsemek '
          'faydalı olur. Bulk döneminde %50 civarında karbonhidrat içeren bir beslenme planı kas gelişiminizi desteklerken, definasyonda da bu oranı aşırı kısmadan devam edebilirsiniz.'
          'Kalori açığını kapatmak için sıvı kaloriler (smoothie, süt bazlı karışımlar) ve enerji yoğun atıştırmalıklar '
          '(fıstık ezmesi, bal, muz) özellikle sizin gibi iştahsız veya az yiyen bireylerde süreci kolaylaştırabilir.';
    }
    if (topName == 'Mezomorf' && secondName == 'Ektomorf') {
      return 'Kas kazanımına genetik olarak yatkınsınız, ancak yapınız hacimden çok tanımlı ve sıkı bir '
          'görünüm oluşturmaya meyilli. Bu, ektomorf etkisinin kas hacmini sınırlayıp, formu estetik tutmasıyla ilgilidir.'
          'Antrenmanlara hızlı adapte olursunuz fakat toparlanma kapasiteniz her zaman yüksek olmayabilir; '
          'bu yüzden yüksek hacimli çalışmalarda toparlanma sürelerini iyi planlamanız gerekir. Estetik odaklı '
          'çalışanlar için bu yapı ciddi bir avantaj sunar.'
          'Beslenmede karbonhidrat toleransınız iyidir, fakat fazla miktarda kalori eklemek kas yerine yağ '
          'olarak dönebilir. Bu yüzden kalori fazlasını agresif değil, kademeli şekilde artırmak daha doğrudur. '
          '%45 civarında karbonhidrat oranı ile kas gelişimini destekleyebilir, formunuzu da koruyabilirsiniz.'
          'Bu yapı, hacim odaklı değil “detaylı & çizgili” gelişim isteyen bireyler için idealdir.';
    }
    if (topName == 'Mezomorf' && secondName == 'Endomorf') {
      return 'Kas gelişimine doğal olarak yatkınsınız ve antrenmanlara hızlı uyum sağlayabiliyorsunuz. '
          'Ancak bu yapı, fazla kalori alındığında kasla birlikte yağ depolama eğilimini de beraberinde getirir. '
          'Bu nedenle hem hacim kazanmak hem de formu korumak için antrenman ve beslenme planınızda kontrolü elden bırakmamalısınız.'
          'Bulk döneminde karbonhidrat oranınızı %45 seviyesinde tutmak gelişiminiz için yeterlidir; fazlası yağlanmayı '
          'hızlandırabilir. Definasyonda ise karbonhidratı %35’lere indirerek, yağ oranınızı kontrol altında tutabilir ve kas kaybı yaşamadan formunuzu geri kazanabilirsiniz.'
          'Bu yapı, “hacim kazanmak kolay ama çizgiyi korumak zor” profilidir. Bu yüzden özellikle definasyon dönemlerinde '
          'disiplinli olmak, farkı yaratan en önemli faktördür.';
    }
    if (topName == 'Endomorf' && secondName == 'Mezomorf') {
      return 'Kas kütlesi kazanmakta zorluk yaşamazsınız; hacim artışı sizin için doğaldır. Ancak bu yapı aynı zamanda yağ '
          'depolamaya da çok eğilimlidir. Bu nedenle “kaslı ama yumuşak” bir görünüm oluşabilir.'
          'Antrenman tarafında ağırlık çalışmalarınızla birlikte düzenli kardiyo uygulamak, yağ oranınızı kontrol altında tutmak '
          'için kritik rol oynar. Bulk dönemlerinde karbonhidratı %40 seviyesinin üzerine çıkarmak, yağlanma riskini artırabilir. '
          'Definasyonda ise düşük karbonhidrat (%25 civarı) ve yüksek yağ–protein içeriğiyle estetik görünüm daha rahat korunabilir.'
          'Bu yapı güç ve kas açısından avantajlıdır ama kontrolsüz beslenme durumunda form çok hızlı kaybedilir. Bu yüzden fiziksel '
          'potansiyelinizi korumak için istikrarlı bir kalori dengesi ve periyodik definasyon şarttır.';
    }
    if (topName == 'Endomorf' && secondName == 'Ektomorf') {
      return 'Vücudunuz yağ depolamaya oldukça yatkın olmasına rağmen, kemik yapınızın dar ve kas kazanımınızın düşük olması '
          'nedeniyle gelişiminiz dış görünüşe güçlü şekilde yansımayabilir. Bu yapı genellikle “zayıf ama yağlı” ya da '
          '“hacimsiz ama yumuşak” bir vücut formuna yol açabilir.'
          'Bu durumda kas inşa etmek ve aynı anda yağ oranını düşürmek temel hedefiniz olmalıdır. Ağırlık antrenmanlarıyla '
          'kas kütlesi artırılırken, beslenme tarafında düşük karbonhidrat (%25–30), yüksek protein ve yağ oranları tercih edilmelidir.'
          'Sadece kalori kısıtlaması değil, kaliteli makro dağılımı ve kas kazanımına uygun bir antrenman planı bu vücut tipi için fark '
          'yaratır. Kardiyo mutlaka haftalık rutine entegre edilmelidir; aksi hâlde yağ oranı kolayca kontrolsüz hâle gelebilir.';
    }
    if (topName == 'Ektomorf' && secondName == 'Endomorf') {
      return 'Vücut yapınız genel olarak zayıf ve ince kemikli olsa da, bölgesel yağlanma eğiliminiz yüksek olabilir. '
          'Bu durum genellikle karın çevresi, kalça ve bel bölgesinde toplanan yağlarla kendini gösterir. '
          'Görünüm olarak “ince ama fit olmayan” bir duruş yaratabilir.'
          'Kas kazanımı sizin için zaten zorlayıcıyken, bu tipte ek olarak yağ dağılımı da estetik formu olumsuz etkileyebilir. '
          'Bu nedenle önceliğiniz, kalori fazlası oluşturarak kas inşa etmek olmalı; ancak bu '
          'süreçte karbonhidrat ve yağ kaynaklarının kalitesine dikkat etmeniz gerekir.'
          'Sıvı kaloriler ve enerji yoğun öğünlerle kalori hedeflerinizi tamamlamanız faydalı olurken, abur cubur tarzı düzensiz '
          'kaloriler yağ dağılımınızı daha da kötüleştirebilir. Definasyon dönemlerinde ise '
          'karbonhidratı aşırı kısmadan (%30–40 aralığında) ilerlemek, kas kaybı yaşamadan form kazanmanızı sağlar.';
    }
  }

  // 60-20-20 tipi üçlüler
  if (topValue == 60 && secondValue == 20 && third.value == 20) {
    if (topName == "Ektomorf" && secondName == 'Mezomorf') {
      return 'Düşük yağ oranına, ince kemik yapısına ve dar omuzlara sahip bir vücut tipiniz var. '
          'Kilo almakta ve kas inşa etmekte genetik olarak dezavantajlı olabilirsiniz. '
          'Mezomorf katkısı kas gelişimine az da olsa destek sunsa da, bu yapı hâlâ yüksek kalorili beslenme '
          've direnç odaklı antrenmana bağımlı bir yapıdır.'
          'Aşırı kardiyo, hedefinize ters çalışabilir; zaten hızlı olan metabolizmanız '
          'nedeniyle fazladan kalori yakımı, gelişimi daha da zorlaştırabilir. '
          'Bulk dönemlerinde %50–60 karbonhidrat oranı tercih edilebilir. '
          'Definasyon dönemlerinde bile karbonhidratı minimuma çekmenize gerek yoktur.'
          'Sıvı kaloriler, basit karbonhidratlar ve enerji yoğun öğünler bu '
          'konuda faydalı olabilir. Sürekli yemek zorlayıcıysa, süt '
          'bazlı shake’ler veya ev yapımı smoothie’lerle kaloriyi tamamlamak hem sindirimi kolaylaştırır hem de pratiklik sağlar.';
    }
    if (topName == "Mezomorf" && secondName == 'Ektomorf') {
      return 'Antrenmanlara hızlı yanıt veriyor, kas gelişimini kolayca sağlayabiliyorsunuz. Vücut geliştirme '
          'açısından genetik olarak avantajlısınız; hacim almak sizin için zor değil. Ancak bu yapı '
          'her ne kadar güçlü olsa da, potansiyelini verimli kullanmak için dikkatli olunması gereken noktalar var.'
          'Ektomorf etkisi formunuzu biraz daha “fit” ve estetik kılabilirken, endomorf tarafı '
          'disiplinsizlik hâlinde yağlanmayı hızlandırabilir. Dolayısıyla bu yapı “çok iyiye de çok bozulmaya da gidebilir” çizgisindedir.'
          'Bulk döneminde karbonhidrat oranınızı %45–50 civarında tutmak gelişiminiz için yeterlidir. '
          'Kalori fazlasını agresif kullanmak yerine makro dengesine sadık kalırsanız '
          'hem kas kazanımı hem görünüm kontrollü ilerler. Kardiyo ihtiyaca göre dozlanabilir ama tamamen ihmal edilmemelidir';
    }
    if (topName == "Endomorf" && secondName == 'Ektomorf') {
      return 'Kas hacmi kazanmak sizin için zor değildir, ancak yağ depolama eğiliminiz yüksek olduğu için elde '
          'ettiğiniz hacim görsel olarak net görünmeyebilir. Ektomorf etkisi hafifçe metabolizmayı desteklese de, '
          'formunuzu korumak tamamen sizin disiplininize bağlıdır.'
          'Bu yapı, “yapı var ama çizgi yok” görünümüne çok yatkındır. O yüzden bulk sürecinde '
          'kalori fazlasını fazla agresif kullanmak yerine, makro dengesine özellikle '
          'dikkat edilmelidir. %35–40 karbonhidrat, %30–35 protein ve %25–30 yağ aralığı hem kası korur hem yağlanmayı sınırlar.'
          'Kardiyo bu yapıda lüks değil zorunluluktur. Özellikle yüksek '
          'tempolu yürüyüşler ve haftalık planlı yağ yakım protokolleri '
          'hem performansı düşürmeden hem de formu destekleyerek sizi "hacimli ama şişkin" değil, "hacimli ve güçlü" bir forma yaklaştırır.';
    }
  }

  // 40–40–20 tipi üçlü denge
  if (topValue == 40 && secondValue == 40 && third.value == 20) {
    if (topName == 'Ektomorf' && secondName == 'Mezomorf') {
      return 'Gövde yapınız ince, yağsız ve çizgili formu korumaya yatkın. Hacim kazanmanız biraz zaman alabilir ama '
          'antrenmanlara çabuk yanıt verirsiniz. Kas hatları kolay belirginleşir, bu da sizi "kuru ama '
          'atletik" forma en yakın yapılardan biri yapar.'
          'Bu yapı, “ne yapsam etki ediyor ama aşırısı da ters tepebilir” tipi için idealdir. Yani antrenman ve '
          'beslenmeyi disiplinli götürdüğünüz sürece gelişim nettir, ancak fazla kalori veya hacim hedeflemeden '
          'yapılan yüklenmeler sizi şişkin, formdan uzak bir görünüme sokabilir.'
          'Yağlanma eğiliminiz düşük olsa da, düzensiz kalori alımı veya dengesiz karbonhidrat tüketimi '
          'formu hızlıca etkileyebilir. %45’e kadar karbonhidrat içeren dengeli bir makro yapısı, '
          'hem performansınızı hem de kas görünümünüzü destekler. Bu yapıda dikkat edilmesi gereken en kritik şey, “gereğinden fazlası zarar” ilkesine sadık kalmaktır.';
    }
    if (topName == 'Mezomorf' && secondName == 'Endomorf') {
      return 'Kas gelişimine yatkın ve hacimli bir yapıya sahipsiniz. Antrenmanlara iyi tepki verirsiniz ve kuvvet '
          'artışı sizde hızlı gerçekleşir. Ancak bu yapının dezavantajı; hatların çabuk bulanıklaşması '
          've yağlanmaya meyilli olmasıdır.'
          'Estetik bir formu koruyabilmek için kalori dengesini iyi kurmalı, karbonhidratı performansı '
          'destekleyecek düzeyde (%40–45) tutmalı ve yağ alımını sıkı takip etmelisiniz. Dışarıdan güçlü '
          've dolgun görünseniz de, çizgili bir form için kardiyo, porsiyon kontrolü ve dönemsel definasyon kaçınılmazdır.'
          'Bu yapı “hacim var ama detay kaçıyor” tipi için klasik bir örnektir. '
          'Gelişiminizi sürdürülebilir kılmak için bulk fazlarında gereksiz kalori '
          'fazlasından kaçınmalı; hedefiniz sadece büyümek değil, büyürken formu da korumak olmalıdır.';
    }
    if (topName == 'Ektomorf' && secondName == 'Endomorf') {
      return 'Vücudunuz hem zayıf hem yağlı olabilir. Genetik olarak çelişkili yapılar taşıyorsunuz. '
          'Hedef odaklı beslenme ve uzun vadeli planlama şart. Kas inşasını merkeze koymalı, gereksiz kalori '
          'kısıtlamaları yerine kaliteli ve dengeli öğünlere yönelmelisiniz. Basit şekerleri sınırlayıp, '
          'kompleks karbonhidratlardan destek alarak kas kazanımını destekleyebilirsiniz. '
          'Kardiyoyu tamamen kesmek değil, tempolu yürüyüş veya kısa süreli interval çalışmalarla '
          'metabolizmayı aktif tutmak daha sürdürülebilir olacaktır. Hızlı sonuç beklemeyin; '
          'ancak düzenli ağırlık çalışmalarıyla beraber stratejik beslenme yürütülürse bu '
          'yapıdan çıkabilecek form hem sağlam hem estetik olabilir. Sizi geliştirecek şey '
          'agresif değişim değil, sabırlı ve akıllı ilerleyiştir.';
    }
  }

  // Default fallback
  return '';
}
