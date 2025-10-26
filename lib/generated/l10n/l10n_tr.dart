// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class STr extends S {
  STr([String locale = 'tr']) : super(locale);

  @override
  String get settings => 'Ayarlar';

  @override
  String get languageSelect => 'Dil Seçimi';

  @override
  String get themeSelect => 'Tema Seçimi';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'İngilizce';

  @override
  String get themeD => 'Koyu Tema';

  @override
  String get themeL => 'Açık Tema';

  @override
  String get blog => 'Blog';

  @override
  String get forum => 'Forum';

  @override
  String get chatbot => 'Chat Bot';

  @override
  String get search => 'Ara';

  @override
  String get profile => 'Profil';

  @override
  String get name => 'İsim';

  @override
  String get surname => 'Soyisim';

  @override
  String get age => 'Yaş';

  @override
  String get birthDate => 'Doğum Tarihi';

  @override
  String get height => 'Boy';

  @override
  String get weight => 'Kilo';

  @override
  String get arm => 'Kol';

  @override
  String get shoulder => 'Omuz';

  @override
  String get chest => 'Göğüs';

  @override
  String get waist => 'Bel';

  @override
  String get hip => 'Kalça';

  @override
  String get neck => 'Boyun';

  @override
  String get leg => 'Bacak';

  @override
  String get calf => 'Kalf';

  @override
  String get fatPercentage => 'Yağ Oranı';

  @override
  String get dailyCalories => 'Günlük Kalori';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String get selectImageSource => 'Resim Kaynağı Seç';

  @override
  String get captureFromCamera => 'Kameradan Çek';

  @override
  String get chooseFromGallery => 'Galeriden Seç';

  @override
  String get deleteImage => 'Resmi Sil';

  @override
  String get save => 'Kaydet';

  @override
  String get progress => 'Analiz';

  @override
  String get exercises => 'Egzersizler';

  @override
  String get workout => 'Antrenman';

  @override
  String get calculators => 'Hesaplayıcılar';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get myGymBag => 'Spor Çantam';

  @override
  String get bagEmpty => 'Çanta Boş';

  @override
  String get recommendedItems => 'Önerilen Eşyalar';

  @override
  String get towel => 'Havlu';

  @override
  String get waterBottle => 'Su Şişesi';

  @override
  String get sportsShoes => 'Spor Ayakkabı';

  @override
  String get slippers => 'Terlik';

  @override
  String get socks => 'Çorap';

  @override
  String get proteinBar => 'Protein Bar';

  @override
  String get gloves => 'Eldiven';

  @override
  String get headphones => 'Kulaklık';

  @override
  String get addItems => 'Eşya Ekle';

  @override
  String get letsPrepare => 'Spora Gidiyorum';

  @override
  String get itemName => 'Eşya Adı';

  @override
  String get cancel => 'İptal';

  @override
  String get add => 'Ekle';

  @override
  String get confirm => 'Onayla';

  @override
  String get airQulity => 'Hava Kalitesi';

  @override
  String get activity => 'Aktivite';

  @override
  String get rm => '1 RM';

  @override
  String get workSet => 'Çalışma Seti';

  @override
  String get bodyFatPercentage => 'Yağ Oranı';

  @override
  String bodyFatLastUpdated(Object date) {
    return 'Son güncelleme $date';
  }

  @override
  String get bodyFatMissingProfileInfo =>
      'Yağ oranını hesaplamak için profilinize cinsiyet ve boy bilgisi ekleyin.';

  @override
  String bodyFatMissingMeasurements(Object metrics) {
    return 'Yağ oranını hesaplamak için şu ölçümleri ekleyin: $metrics';
  }

  @override
  String get bodyFatInvalidMeasurements =>
      'Ölçüm değerleri hatalı görünüyor. Bel ölçüsü boyun ölçüsünden büyük olmalıdır.';

  @override
  String get bodyFatFatFreeMass => 'Yağsız kütle';

  @override
  String get calories => 'Kalori';

  @override
  String get bmi => 'BMI';

  @override
  String get ffmi => 'FFMI';

  @override
  String get routines => 'Rutinler';

  @override
  String get nutrition => 'Beslenme';

  @override
  String get myRoutines => 'Rutinlerim';

  @override
  String get history => 'Geçmiş';

  @override
  String get createFolder => 'Klasör Oluştur';

  @override
  String get addYourRecipe => 'Yemek Tarifi Ekle';

  @override
  String get noHistoryFound => 'Henüz Geçmiş Bulunmuyor';

  @override
  String get newestToOldest => 'En Yeniden En Eskiye';

  @override
  String get oldestToNewest => 'En Eskiden En Yeniye';

  @override
  String get createWorkoutRoutine => 'Rutin Oluşturun';

  @override
  String get createNutritionRoutine => 'Beslenme Rutini Oluşturun';

  @override
  String get routineName => 'Rutin İsmi';

  @override
  String get chooseIcon => 'İkon Seçin';

  @override
  String get icon => 'İkon';

  @override
  String get iconColor => 'İkon Rengi';

  @override
  String get value => 'Değeri';

  @override
  String get start => 'Başla';

  @override
  String get createExercise => 'Egzersiz Oluşturun';

  @override
  String get numberOfSets => 'Set Sayısı';

  @override
  String get numberOfReps => 'Tekrar Sayısı';

  @override
  String get saveExercise => 'Egzersizi Kaydet';

  @override
  String get reps => 'Tekrar';

  @override
  String get duration => 'Süre';

  @override
  String get finishAndSave => 'Bitir ve Kaydet';

  @override
  String get exitWithoutSaving => 'Kaydetmeden Çık';

  @override
  String get itemsInBag => 'Çantadaki Eşyalar';

  @override
  String get someItemsNotSelected => 'Bazı Eşyaları Seçmediniz';

  @override
  String get missingSelection => 'Eksik Seçim';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get doYouConfirm => 'Onaylıyor musunuz';

  @override
  String get deleted => 'Silindi';

  @override
  String get addWorkout => 'Antrenman Ekle';

  @override
  String get createRoutinePromptTitle => 'Hemen rutin oluştur';

  @override
  String get createRoutinePromptSubtitle =>
      'Antrenmana başla, gelişimi hisset!';

  @override
  String get noWorkoutsAddedYet => 'Henüz antrenman eklenmemiş';

  @override
  String get deleteRoutine => 'Rutini Sil';

  @override
  String get createWorkout => 'Antrenman Oluştur';

  @override
  String get routineAndWorkoutsWillBeDeleted =>
      'isimli rutininiz ve içindeki antrenmanlar silinecektir.\nOnaylıyor musunuz?';

  @override
  String get understood => 'Tamam';

  @override
  String get information => 'Bilgilendirme';

  @override
  String get backpackDescription =>
      'Bu uygulama spor çantanızda bulunması gereken öğeleri yönetmenizi sağlar. Eşyaları ekleyebilir, silebilir ve sıralayabilirsiniz.';

  @override
  String get cameraAccessRequired => 'Kameraya erişim izni gerekli';

  @override
  String get photosAccessRequired => 'Fotoğraflara erişim izni gerekli';

  @override
  String get confirmDeleteImage => 'Resmi silmek istediğinizden emin misiniz';

  @override
  String get cannotBeEmpty => 'Boş olamaz';

  @override
  String get enterValidNumber => 'Geçerli bir sayı girin';

  @override
  String get heightRangeError => 'Boy 50 ile 250 cm arasında olmalı';

  @override
  String get weightRangeError => 'Kilo 10 ile 635 arasında olmalı';

  @override
  String get ageRangeError => 'Yaş 10 ile 100 arasında olmalı';

  @override
  String get fatPercentageRangeError => 'Yağ oranı 0 ile 100 arasında olmalı';

  @override
  String get noData => 'Bilgi Yok';

  @override
  String get routineAddedHomepage => 'Rutin Ana Sayfa\'ya Eklendi.';

  @override
  String get refreshPage => 'Sayfayı Yenile';

  @override
  String get workoutWillBeDeleted => 'silinecektir.\nOnaylıyor musunuz?';

  @override
  String get deleteWorkout => 'Antrenmanı Sil';

  @override
  String deleteRoutineConfirmation(Object routineName) {
    return '$routineName silinecektir. Onaylıyor musun?\n';
  }

  @override
  String get sortingOptions => 'Sıralama Seçenekleri';

  @override
  String get anErrorOccurred => 'Bir hata oluştu';

  @override
  String get deleteConfirmation => 'Silme Onayı';

  @override
  String get unknownTitle => 'Bilinmeyen Başlık';

  @override
  String get noDataForPage => 'Bu sayfa için veri bulunamadı';

  @override
  String get noExerciseName => 'Hareket İsmi Yok';

  @override
  String get fillAllFields => 'Tüm alanları doldurun';

  @override
  String get setsRangeError => 'Set sayısını 1-20 aralığında giriniz';

  @override
  String get update => 'Güncelle';

  @override
  String get delete => 'Sil';

  @override
  String get createRoutine => 'Rutin Oluşturun';

  @override
  String get editRoutine => 'Rutini Düzenle';

  @override
  String get edit => 'Düzenle';

  @override
  String deleteWorkoutConfirmation(Object workoutName) {
    return '$workoutName silinecektir. Onaylıyor musun?\n';
  }

  @override
  String get shortMon => 'Pzt';

  @override
  String get shortTue => 'Sal';

  @override
  String get shortWed => 'Çrş';

  @override
  String get shortThu => 'Prş';

  @override
  String get shortFri => 'Cum';

  @override
  String get shortSat => 'Cmt';

  @override
  String get shortSun => 'Paz';

  @override
  String get monday => 'Pazartesi';

  @override
  String get tuesday => 'Salı';

  @override
  String get wednesday => 'Çarşamba';

  @override
  String get thursday => 'Perşembe';

  @override
  String get friday => 'Cuma';

  @override
  String get saturday => 'Cumartesi';

  @override
  String get sunday => 'Pazar';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get pushDay => 'İtiş Günü';

  @override
  String get confirmDelete => 'Silinsin mi?';

  @override
  String get locationPermissionsPermanentlyDenied =>
      'Konum izinleri kalıcı olarak reddedildi, uygulama ayarlarından izin verin';

  @override
  String get permissionRequired => 'İzin Gerekli';

  @override
  String get error => 'Hata';

  @override
  String errorWithMessage(Object message) {
    return 'Hata: $message';
  }

  @override
  String get dataCouldNotBeLoaded => 'Veri yüklenemedi';

  @override
  String get airQualityCalculator => 'Hava Kalitesi Hesaplayıcı';

  @override
  String get airQualityGood =>
      'Hava kalitesi tatmin edici seviyede ve hava kirliliği riski çok az ya da hiç yok.';

  @override
  String get airQualityModerate =>
      'Hava kalitesi kabul edilebilir seviyede, ancak bazı kirleticiler için hassas bireylerde hafif sağlık sorunları yaşanabilir.';

  @override
  String get airQualitySensitive =>
      'Hassas gruplarda sağlık etkileri görülebilir. Genel halkın etkilenme olasılığı düşüktür.';

  @override
  String get airQualityUnhealthy =>
      'Herkes sağlık sorunları yaşamaya başlayabilir; hassas gruplar daha ciddi etkiler yaşayabilir.';

  @override
  String get airQualityVeryUnhealthy =>
      'Acil durum koşullarında sağlık uyarıları. Genel nüfusun etkilenme olasılığı daha yüksektir.';

  @override
  String get airQualityHazardous =>
      'Sağlık alarmı: Herkes ciddi sağlık sorunları yaşayabilir.';

  @override
  String get airQualityUnknown => 'Hava kalitesi verisi bulunamadı.';

  @override
  String get walk => 'Yürüyüş';

  @override
  String get inclinedWalk => 'Eğimli Yürüyüş';

  @override
  String get run => 'Koşu';

  @override
  String get bicycle => 'Bisiklet';

  @override
  String get swimming => 'Yüzme';

  @override
  String get weightlifting => 'Ağırlık';

  @override
  String get rowing => 'Kürek Çekme';

  @override
  String get weeklyRoutineTitle => 'Haftalık rutin';

  @override
  String get weeklyRoutineDescription =>
      'Haftanı planla, antrenman veya dinlenme günlerini ekle ve geldiğinde tamamlandı olarak işaretle.';

  @override
  String get weeklyRoutineError =>
      'Rutinin şu anda yüklenemedi. Lütfen kısa süre sonra tekrar dene.';

  @override
  String get weeklyRoutineOffDay => 'Dinlenme günü';

  @override
  String get weeklyRoutineNotPlanned => 'Planlanmış antrenman yok';

  @override
  String get weeklyRoutineMarkDone => 'Tamamlandı olarak işaretle';

  @override
  String get weeklyRoutineMarkNotDone => 'İşareti geri al';

  @override
  String get weeklyRoutineAddWorkout => 'Antrenman ekle';

  @override
  String get weeklyRoutineSetOffDay => 'Dinlenme günü';

  @override
  String get weeklyRoutineClearDay => 'Temizle';

  @override
  String get weeklyRoutineSelectSource =>
      'Kendi antrenmanların veya FitPill programları arasından seç';

  @override
  String get weeklyRoutineTabMyWorkouts => 'Antrenmanlarım';

  @override
  String get weeklyRoutineTabFitpill => 'Fitpill';

  @override
  String get weeklyRoutineNotificationTitle => 'FitPill antrenmanın hazır!';

  @override
  String weeklyRoutineNotificationBody(Object workout) {
    return 'Bugünkü plan: $workout';
  }

  @override
  String get weeklyRoutineNoPersonalWorkouts =>
      'Buraya eklemek için önce bir antrenman rutini oluştur.';

  @override
  String get weeklyRoutineNoWorkoutsInRoutine =>
      'Bu rutinde henüz kayıtlı antrenman yok';

  @override
  String get weeklyRoutineFailedToLoadWorkouts => 'Antrenmanlar yüklenemedi';

  @override
  String get weeklyRoutineCardTitle => 'Haftalık rutin';

  @override
  String get weeklyRoutineShortcutTooltip => 'Haftalık plan';

  @override
  String get weeklyRoutineCompletionOnlyToday =>
      'Sadece bugünkü antrenmanı onaylayabilirsin.';

  @override
  String get weeklyRoutineAnalyticsCardTitle => 'Antrenman analizleri';

  @override
  String weeklyRoutineAnalyticsThisMonth(Object month, int count) {
    return 'Bu ay ($month): $count antrenman günü';
  }

  @override
  String weeklyRoutineAnalyticsLastMonth(Object month, int count) {
    return 'Geçen ay ($month): $count gün spora gittin';
  }

  @override
  String get weeklyRoutineAnalyticsEmpty =>
      'İstatistikler için antrenmanlarını işaretlemeye başla.';

  @override
  String get fitpillProgramLevel => 'Seviye';

  @override
  String get fitpillProgramAddedToWeeklyRoutine => 'Haftalık rutine eklendi';

  @override
  String get fitpillProgramAddToRoutine => 'Haftalık plana ekle';

  @override
  String get fitpillProgramSelectDay => 'Hangi güne ekleyelim?';

  @override
  String get workoutTabHeader => 'Antrenmanını planla';

  @override
  String get workoutTabMyWorkouts => 'Antrenmanlarım';

  @override
  String get workoutTabFitpillPrograms => 'FitPill Programları';

  @override
  String get jumpRope => 'İp atlama';

  @override
  String get stairs => 'Merdiven';

  @override
  String get hiit => 'HIIT';

  @override
  String get football => 'Futbol';

  @override
  String get basketball => 'Basketbol';

  @override
  String get volleyball => 'Voleybol';

  @override
  String get boxing => 'Boks';

  @override
  String get dance => 'Dans';

  @override
  String get housework => 'Ev İşleri';

  @override
  String get sex => 'Seks';

  @override
  String get sleep => 'Uyku';

  @override
  String get activityCalorieCalculator => 'Aktivite Kalori Hesaplayıcı';

  @override
  String get metInfoText =>
      'Egzersizlerin MET değerleri baz alınarak hangi aktivitede kaç kalori yaktığınız hesaplanır. Değerler yaklaşık olup kişisel farklılıklara göre değişiklik gösterebilir.';

  @override
  String get ok => 'Tamam';

  @override
  String get bodyWeightKg => 'Vücut Ağırlığı (kg)';

  @override
  String get exercise => 'Egzersiz';

  @override
  String get tempo => 'Tempo';

  @override
  String get slow => 'Sakin';

  @override
  String get moderate => 'Dengeli';

  @override
  String get fast => 'Yoğun';

  @override
  String get burnedCalories => 'Yakılan Kalori';

  @override
  String get invalidWeight =>
      'Geçersiz kilo girişi, 30 ile 250 arasında olmalı';

  @override
  String get baklava => 'Baklava';

  @override
  String get pizza => 'Pizza';

  @override
  String get hamburger => 'Hamburger';

  @override
  String get bread => 'Ekmek';

  @override
  String get soda => 'Gazlı İçecek';

  @override
  String get creamyCoffee => 'Kremalı Kahve';

  @override
  String get minutes => 'Dakika';

  @override
  String get slice => 'dilim';

  @override
  String get piece => 'tane';

  @override
  String get glass => 'bardak';

  @override
  String get grande => 'grande';

  @override
  String get foods => 'Yiyecekler';

  @override
  String get repMaxCalculator => 'Rep Max Hesaplayıcı';

  @override
  String get info => 'Bilgilendirme';

  @override
  String get brzyckiFormulaInfo =>
      'Brzycki Formülü ile 1-10 tekrar arasında kaldırabileceğiniz maksimum ağırlık tahmin edilir.';

  @override
  String get invalidWeightRm => 'Geçersiz Ağırlık, 500\'den fazla olmamalı';

  @override
  String get resultsWillAppearHere => 'Sonuçlar burada görünecek.';

  @override
  String get workSetCalculator => 'Çalışma Seti Hesaplayıcı';

  @override
  String get workSetInfo =>
      '1 Tekrar maksimum ağırlığınıza göre çalışma seti kombinasyonları sunar. 1 Tekrar maksimum ağırlığınızı 1 RM hesaplayıcısında hesaplayabilirsiniz.';

  @override
  String get oneRepMax => '1 Tekrar Maksimum';

  @override
  String get set => 'Set';

  @override
  String get easy => 'Kolay';

  @override
  String get medium => 'Orta';

  @override
  String get low => 'Düşük';

  @override
  String get high => 'Yoğun';

  @override
  String get hard => 'Zor';

  @override
  String get fixedWeight => 'Sabit Ağırlık';

  @override
  String get rampSystem => 'Rampa Sistem';

  @override
  String get workSets => 'Çalışma Setleri';

  @override
  String get allSets => 'Tüm Setler';

  @override
  String get fatRateCalculator => 'Yağ Oranı Hesaplayıcı';

  @override
  String get fatRateInfo =>
      'Boyun: adem elması etrafından, Bel: göbek deliği etrafından, Kalça: en geniş yerinden ölçülmelidir. Hesaplamada Navy BF Calculator algoritması kullanılmaktadır.';

  @override
  String get male => 'Erkek';

  @override
  String get female => 'Kadın';

  @override
  String get yourFatPercentage => 'Yağ Oranınız';

  @override
  String get saveFatPercentageQuestion => 'Yağ Oranı Kaydedilsin mi?';

  @override
  String get fatPercentageSaved => 'Yağ oranı profilinize kaydedildi';

  @override
  String get successfullySaved => 'Başarıyla kaydedildi';

  @override
  String get upgradeToSaveProgress =>
      'İlerlemeni kaydetmek için premiuma yükselt';

  @override
  String get upgradeToCreateRoutine => 'Rutin oluşturmak için premiuma yükselt';

  @override
  String get premiumMembershipExpired =>
      'Premium süren doldu. Yenileyerek sınırsız kullanmaya devam edebilirsin.';

  @override
  String get premiumSectionLocked =>
      'Bu bölümü kullanmak için aktif bir premium plana ihtiyacın var. Devam etmek için yükselt ya da yenile.';

  @override
  String get workoutHistoryNotSaved =>
      'Ücretsiz planda antrenman geçmişi kaydedilmez. Seanslarını saklamak için premiuma yükselt.';

  @override
  String get premiumUnlockTitle => 'FitPill Premium\'u Keşfet';

  @override
  String get premiumUnlockDescription =>
      'Kişiselleştirilmiş antrenmanlar, derinlemesine analizler ve özel üyelik ayrıcalıkları için premiuma geç.';

  @override
  String get goPremium => 'Premium\'a Geç';

  @override
  String get premiumMemberCardTitle => 'Premium Üye';

  @override
  String premiumMemberSince(String date) {
    return '$date tarihinden beri üye';
  }

  @override
  String get premiumMemberSinceUnknown => '—';

  @override
  String get premiumProfileHighlights => 'Profil öne çıkanları';

  @override
  String get premiumProfileMissing =>
      'Daha fazla kişisel bilgi ekleyerek öne çıkanları zenginleştirebilirsin.';

  @override
  String get premiumAvatarReady => 'Avatar seçildi';

  @override
  String get profilePhotoPremiumOnly =>
      'Profil fotoğrafı yükleme Premium üyeler için kullanılabilir.';

  @override
  String get profilePhotoPermissionDenied =>
      'Devam etmek için kamera veya galeri izni gerekiyor. Lütfen Ayarlar\'dan etkinleştir.';

  @override
  String get profilePhotoUpdated => 'Profil fotoğrafın güncellendi.';

  @override
  String get profilePhotoUpdateFailed =>
      'Profil fotoğrafı güncellenemedi. Lütfen tekrar dene.';

  @override
  String get premiumCardShareTitle => 'Premium kartını paylaş';

  @override
  String get premiumShareWhatsapp => 'WhatsApp';

  @override
  String get premiumShareInstagram => 'Instagram';

  @override
  String get premiumShareCopy => 'Bağlantıyı kopyala';

  @override
  String get premiumShareCopied => 'Paylaşım metni panoya kopyalandı!';

  @override
  String get premiumShareError => 'Bu uygulamayı açamadık. Lütfen tekrar dene.';

  @override
  String get premiumMemberCardError =>
      'Premium bilgilerin şu anda yüklenemedi.';

  @override
  String get premiumMemberCardTryAgain => 'Tekrar dene';

  @override
  String premiumShareMessage(String name) {
    return '$name FitPill Premium\'a katıldı! Hedeflerimize birlikte ulaşalım.';
  }

  @override
  String get saveFatPercentage => 'Bu Yağ Oranını Profile Kaydet';

  @override
  String get calorieCalculator => 'Kalori Hesaplayıcı';

  @override
  String get calorieInfo =>
      'Bazal metabolizma hızınız ve günlük almanız gereken kalori hesaplanmaktadır. Hedefinize göre azaltıp artırabilirsiniz. Hesaplamada Katch-McArdle formülü kullanılmaktadır.';

  @override
  String get weightRangeWarning =>
      'Vücut ağırlığı 25-300 kg arasında olmalıdır.';

  @override
  String get fatPercentageRangeWarning =>
      'Yağ oranı 2-60 aralığında olmalıdır.';

  @override
  String get maintainWeight => 'Kilonuzu Korumak İçin';

  @override
  String get loseWeight => 'Kilo Vermek İçin';

  @override
  String get gainWeight => 'Kilo Almak İçin';

  @override
  String get sedentary => 'Hareketsiz Yaşam - Sedanter';

  @override
  String get lightlyActive => 'Hafif Hareketli - 1-2 gün egzersiz';

  @override
  String get moderatelyActive => 'Orta Aktif - 3-4 gün egzersiz';

  @override
  String get veryActive => 'Hareketli Yaşam - 5-6 gün egzersiz';

  @override
  String get athletic => 'Aşırı Yoğun iş veya spor';

  @override
  String get bmrValue => 'BMR Değeriniz';

  @override
  String get maintainCalorie => 'Kilonuzu korumak için';

  @override
  String get calorieDeficit => 'Kilo vermek için';

  @override
  String get calorieSurplus => 'Kilo almak için';

  @override
  String get bmiCalculator => 'BMI Hesaplayıcı';

  @override
  String get bmiInfo =>
      'Sağlıklı bir yaşam için bulunmamız gereken kilo aralığını belirtir. Boy ve kilo oranıyla hesaplanır. 18.5 ile 24.9 arası sağlıklı aralıktır. Sporcu iseniz FFMI sizin için daha optimal bir ölçüttür.';

  @override
  String get severelyUnderweight => 'Ciddi Derecede Zayıf';

  @override
  String get underweight => 'Zayıf';

  @override
  String get normalWeight => 'İdeal';

  @override
  String get overweight => 'Kilolu';

  @override
  String get obese => 'Obez';

  @override
  String get idealWeight => 'İdeal Kilo';

  @override
  String get lowerLimit => 'Alt Sınır';

  @override
  String get upperLimit => 'Üst Sınır';

  @override
  String get ffmiCalculator => 'FFMI Hesaplayıcı';

  @override
  String get ffmiInfo =>
      'Vücut yağsız kütlesini boy uzunluğuna oranlar. Standart BMI\'dan farklı olarak kas ve yağı ayırt ederek sporcular için daha doğru sonuç verir.';

  @override
  String get bodyWeight => 'Vücut Kütlesi';

  @override
  String get leanMass => 'Yağsız Kütle';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get enterValidName => 'Lütfen geçerli bir ad girin.';

  @override
  String get invalidEmail => 'Lütfen geçerli bir e-posta adresi girin.';

  @override
  String get weakPassword => 'Şifre en az 6 karakter olmalıdır.';

  @override
  String get emailExists => 'Bu e-posta ile zaten bir hesap var.';

  @override
  String get userNotFound => 'Bu e-posta ile kayıtlı bir kullanıcı bulunamadı.';

  @override
  String get wrongPassword => 'Hatalı şifre girdiniz.';

  @override
  String get unknownError => 'Bilinmeyen bir hata oluştu.';

  @override
  String get registrationSuccessful => 'Kayıt başarılı!';

  @override
  String get enterValidHeight => 'Lütfen geçerli bir boy girin.';

  @override
  String get enterValidWeight => 'Lütfen geçerli bir kilo girin.';

  @override
  String get invalidHeight => 'Hatalı Boy';

  @override
  String get firestoreError => 'Firestore Hatası';

  @override
  String get quitConfirm => 'Çıkış yapmak istediğinize emin misiniz?';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get alreadyAdded => 'Bu eşya zaten eklenmiş!';

  @override
  String get rateApp => 'Uygulamayı Puanla';

  @override
  String get contactUs => 'İletişime Geç';

  @override
  String get other => 'Diğer';

  @override
  String get welcome => 'Hoş Geldiniz';

  @override
  String get favoritedExercises => 'Favori Egzersizler';

  @override
  String get fitpillSlogan => 'FitPill ile sağlıklı yaşama adım atın';

  @override
  String get loginFailed => 'Giriş başarısız!';

  @override
  String get emailEmpty => 'E-posta boş bırakılamaz!';

  @override
  String get emailInvalid => 'Geçerli bir e-posta adresi giriniz!';

  @override
  String get passwordEmpty => 'Şifre boş bırakılamaz!';

  @override
  String get passwordMinLength => 'Şifre en az 6 karakter olmalıdır!';

  @override
  String get passwordRequirements =>
      'Şifre büyük harf, küçük harf ve rakam içermelidir!';

  @override
  String get login => 'Giriş Yap';

  @override
  String get workoutWithMe => 'Benimle Yap';

  @override
  String get alreadyHaveAccountQuestion => 'Hesabınız var mı?';

  @override
  String get noAccountQuestion => 'Hesabınız yok mu?';

  @override
  String get createNewAccount => 'Yeni Hesap Oluştur';

  @override
  String get registerSlogan => 'FitPill deneyimine hemen başlayın';

  @override
  String get nameEmpty => 'İsim boş bırakılamaz!';

  @override
  String get nameMinLength => 'İsim en az 3 karakter olmalıdır!';

  @override
  String get privacyPolicy =>
      'KVKK ve Gizlilik Politikasını Okudum ve Kabul Ediyorum';

  @override
  String get acceptPrivacyPolicy => 'KVKK onayını kabul etmelisiniz!';

  @override
  String get startFree => 'Ücretsiz Başla';

  @override
  String get alreadyMember => 'Zaten Üyeyim';

  @override
  String get healthyLifeJourney => 'Sağlıklı Yaşam\nYolculuğunuz Başlıyor';

  @override
  String get personalizedTraining =>
      'Kişiselleştirilmiş antrenman programları ve beslenme rehberiyle hedeflerinize ulaşın';

  @override
  String get registrationTerms =>
      'Kayıt olarak, kullanım koşullarını ve gizlilik politikasını kabul etmiş olursunuz.';

  @override
  String get forgotPassword => 'Şifremi Unuttum';

  @override
  String get resetPassword => 'Şifreyi Sıfırla';

  @override
  String get passwordResetLink =>
      'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi!';

  @override
  String get invalidCredentials => 'Geçersiz e-posta veya şifre!';

  @override
  String get healthStatistics => 'Sağlık İstatistikleri';

  @override
  String get metrics => 'Değerler';

  @override
  String get selectDate => 'Tarih Seç';

  @override
  String get graph => 'Grafik';

  @override
  String get toSeeGraph => 'Grafiğinizi görebilmek için bir ölçüm ekleyin';

  @override
  String get startYourJourney => 'FitPill yolculuğunuza başlayın 😊🤔🤓';

  @override
  String get measurementRange => 'Geçersiz değer aralığı';

  @override
  String get invalidNumberFormat => 'Geçersiz format';

  @override
  String get onlyNumericValuesAllowed => 'Sadece sayısal değerler giriniz!';

  @override
  String get editWorkout => 'Antrenmanı Düzenle';

  @override
  String get workoutSummary => 'Antrenman Tamamlandı!';

  @override
  String get congrats => 'Tebrikler, antrenmanını tamamladın!';

  @override
  String exerciseCount(Object count) {
    return '🏋️ Egzersiz Sayısı: $count';
  }

  @override
  String caloriesBurned(Object calories) {
    return '🔥 Yaklaşık Kalori: $calories kcal';
  }

  @override
  String get totalTime => '⏳ Toplam Süre: ';

  @override
  String get noWorkouts => 'Henüz antrenman eklenmedi!';

  @override
  String get addWorkoutProgram =>
      'Başlamak için bir antrenman programı ekleyin.';

  @override
  String get workoutAdded => 'Antrenman başarıyla kaydedildi!';

  @override
  String get exerciseName => 'Egzersiz İsmi';

  @override
  String get setCount => 'Set Sayısı';

  @override
  String get setDuration => 'Set Süresi (sn)';

  @override
  String get restDuration => 'Mola Süresi (sn)';

  @override
  String workoutWillTake(Object calories, Object minutes) {
    return 'Bu program yaklaşık $minutes dakika sürecek ve $calories kalori yakacaksın.';
  }

  @override
  String get preparationTime => 'Hazırlık Süresi';

  @override
  String get restTime => 'Mola Süresi';

  @override
  String get exerciseTime => 'Egzersiz Süresi';

  @override
  String get deleteExercise => 'Egzersizi Sil';

  @override
  String get addExercise => 'Egzersiz Ekle';

  @override
  String get pleaseAddExercise =>
      'Lütfen en az 1 egzersiz ekleyin ve isimleri doldurun.';

  @override
  String get pause => 'Duraklat';

  @override
  String get resume => 'Devam Et';

  @override
  String get savedWorkouts => 'Kayıtlı Antrenmanlar';

  @override
  String get gender => 'Cinsiyet';

  @override
  String get superSet => 'Süperset';

  @override
  String get workoutCompleted => 'Antrenman Tamamlandı!';

  @override
  String get congratulations => 'Tebrikler!';

  @override
  String get errorOccurred => 'Hata oluştu!';

  @override
  String get noWorkoutsAdded => 'Henüz antrenman eklenmedi';

  @override
  String get addWorkoutPrompt =>
      'Başlamak için yeni bir antrenman programı oluşturun';

  @override
  String get unnamedWorkout => 'İsimsiz Antrenman';

  @override
  String get startActivity => 'Aktiviteyi Başlat';

  @override
  String get selectActivity => 'Aktivite Seçin';

  @override
  String get stop => 'Bitir';

  @override
  String get incline => 'Eğim';

  @override
  String get noActivtyRecords => 'Henüz aktivite kaydı yok.';

  @override
  String get pleaseLogin => 'Geçmişinizi görmek için giriş yapın';

  @override
  String get tempoLevel => 'Tempo Seviyesi';

  @override
  String get targetDuration => 'Hedef Süre (min)';

  @override
  String get activityHistory => 'Aktivite Geçmişi';

  @override
  String get weightTrackedInProgress =>
      'Kilo, Analiz bölümünde takip edilir ve otomatik olarak güncellenir';

  @override
  String get areYouSure => 'Emin misin?';

  @override
  String get exit => 'Çıkış';

  @override
  String get selectAvatar => 'Select Avatar';

  @override
  String get max20 => 'En fazla 20 adet eşya ekleyebilirsiniz';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String get allTime => 'Tüm Zamanlar';

  @override
  String get caloriesSummary => 'Kalori Özeti';

  @override
  String get account => 'Hesap';

  @override
  String get passwordChange => 'Şifre Değiştir';

  @override
  String get generalError => 'Bir hata oluştu';

  @override
  String get currentPassword => 'Mevcut Şifre';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get requiredField => 'Bu alan zorunludur';

  @override
  String get passwordsNotMatch => 'Şifreler uyuşmuyor';

  @override
  String get passwordChanged => 'Şifre başarıyla değiştirildi!';

  @override
  String get passwordChangeCooldown =>
      '24 saat içinde sadece 1 kez değiştirebilirsiniz';

  @override
  String get newPasswordSameAsOld => 'Yeni parola eskisiyle aynı';

  @override
  String get passwordResetEmailSent => 'Şifre sıfırlama maili gönderildi';

  @override
  String get emailSent => 'Mail Gönderildi';

  @override
  String get resetEmailWillBeSentTo =>
      'Şifre sıfırlama bağlantısı şu e-posta adresine gönderilecek:';

  @override
  String get send => 'Gönder';

  @override
  String get setupProfile => 'Profil Kurulumu';

  @override
  String get selectBirthDate => 'Lütfen doğum tarihinizi seçin';

  @override
  String get chooseDate => 'Tarih Seç';

  @override
  String get selectGender => 'Cinsiyet Seçin';

  @override
  String get next => 'İleri';

  @override
  String get back => 'Geri';

  @override
  String get pleaseFillAllFields => 'Lütfen tüm alanları doldurun';

  @override
  String get deleteAccount => 'Hesabı Sil';

  @override
  String get myBags => 'Çantalarım';

  @override
  String get defaultBackpackName => 'Başlangıç Çantası';

  @override
  String get addBag => 'Yeni Çanta Ekle';

  @override
  String get bagName => 'Çanta Adı';

  @override
  String get haventCreatedBag => 'Henüz çanta oluşturmadın.';

  @override
  String get bagSettings => 'Çanta Ayarları';

  @override
  String get askDeleteBag => 'Bu çantayı silmek istediğine emin misin?';

  @override
  String get deleteBag => 'Çantayı Sil';

  @override
  String get emptyBag => 'Bu çanta boş.';

  @override
  String get createRoutineNow => 'Hemen rutin oluştur';

  @override
  String get startTrainingFeelProgress => 'Antrenmana başla, Gelişimi hisset!';

  @override
  String get dayAgo => 'gün önce';

  @override
  String get bestPerformances => 'En İyi Performanslar';

  @override
  String get weightTrackingChart => 'Ağırlık Takip Grafiği';

  @override
  String get volumeTrackingChart => 'Hacim Takip Grafiği';

  @override
  String get noSetsYet => 'Henüz set yok';

  @override
  String get addSet => 'Set ekle';

  @override
  String get heaviestSet => 'En Ağır Set';

  @override
  String get highestVolume => 'En Yüksek Hacim';

  @override
  String get addAtLeast2 => 'Grafik için en az 2 veri girilmeli.';

  @override
  String get oneRepMaxWeight => '1 Rep Max Ağırlığınız';

  @override
  String get yourWishSet => 'Yapmak İstediğiniz Set ve Tekrar';

  @override
  String get setDifficult => 'Set Zorluğu';

  @override
  String get setType => 'Set Türü';

  @override
  String get carbohydrate => 'Karbonhidrat';

  @override
  String get fat => 'Yağ';

  @override
  String get fiber => 'Lif';

  @override
  String get dailyWaterNeed => 'Günlük Su İhtiyacı';

  @override
  String get burnFat => 'Yağ yakmak';

  @override
  String get maintainMass => 'Kütle korumak';

  @override
  String get gainMass => 'Kütle kazanmak';

  @override
  String get yourActivityLevel => 'Aktivite Düzeyiniz';

  @override
  String get yourDestination => 'Hedefiniz';

  @override
  String get bodyType => 'Vücut Tipi';

  @override
  String get nutritionTrackingTitle => 'Beslenme takibi';

  @override
  String get nutritionTrackingDescription =>
      'Öğünlerini ekle, yemeklerini düzenle ve günlük mikro & makro değerlerini takip et.';

  @override
  String get nutritionEmptyMealsTitle => 'Henüz bir öğün eklenmedi';

  @override
  String get nutritionEmptyMealsDescription =>
      'İlk öğününü oluşturmak için aşağıdaki butonu kullanabilirsin.';

  @override
  String get nutritionDailyTotals => 'Günlük toplamlar';

  @override
  String get nutritionNoSummary => 'Değerler, yemek eklediğinde hesaplanacak.';

  @override
  String get nutritionEmptyMealBody =>
      'Bu öğünde henüz yemek yok. Makroları takip etmek için yemek eklemeye başlayabilirsin.';

  @override
  String get nutritionAddMeal => 'Öğün ekle';

  @override
  String get nutritionAddFood => 'Yemek ekle';

  @override
  String get nutritionDeleteMeal => 'Öğünü sil';

  @override
  String get nutritionNewMealTitle => 'Yeni öğün';

  @override
  String get nutritionMealNameLabel => 'Öğün adı';

  @override
  String get nutritionMealNameEmpty => 'Lütfen bir öğün adı gir.';

  @override
  String get nutritionFoodNameLabel => 'Yemek adı';

  @override
  String get nutritionFoodNameEmpty => 'Lütfen bir yemek adı gir.';

  @override
  String get protein => 'Protein';

  @override
  String get sodium => 'Sodyum';

  @override
  String get goals => 'Hedefler';

  @override
  String get goalTabTitle => 'Kendine hedef koy';

  @override
  String get goalTabDescription =>
      'Net hedefler ve tarihler belirleyerek motivasyonunu yüksek tut.';

  @override
  String get goalPremiumRequired =>
      'Hedef takibi yalnızca Premium üyeler için.';

  @override
  String get goalUpgradeButton => 'Premium\'a yükselt';

  @override
  String get goalAddButton => 'Hedef oluştur';

  @override
  String get goalEmptyStateTitle => 'Henüz hedef yok';

  @override
  String get goalEmptyStateDescription =>
      'İlerlemeni takip etmek için yeni bir hedef oluştur.';

  @override
  String get goalActiveSectionTitle => 'Aktif hedefler';

  @override
  String get goalCompletedSectionTitle => 'Tamamlanan hedefler';

  @override
  String goalMetricSummaryTitle(String metric) {
    return '$metric için hedef';
  }

  @override
  String goalMetricRemainingDown(String value, String unit) {
    return 'Hedefe $value $unit kaldı';
  }

  @override
  String goalMetricRemainingUp(String value, String unit) {
    return 'Hedefe $value $unit kaldı';
  }

  @override
  String get goalEditFromMetric => 'Hedefi düzenle';

  @override
  String get goalCreateFromMetric => 'Hedef belirle';

  @override
  String get goalFormTitle => 'Yeni hedef';

  @override
  String get goalFormUpdateTitle => 'Hedefi güncelle';

  @override
  String get goalFormMetricLabel => 'Metrik';

  @override
  String get goalFormCurrentLabel => 'Mevcut değer';

  @override
  String get goalFormTargetLabel => 'Hedef değer';

  @override
  String get goalFormDeadlineLabel => 'Bitiş tarihi';

  @override
  String get goalFormDeadlinePick => 'Değiştir';

  @override
  String get goalFormNumericError => 'Lütfen geçerli sayılar gir.';

  @override
  String get goalFormErrorEqualValues =>
      'Mevcut ve hedef değerler aynı olamaz.';

  @override
  String get goalFormSuccessCreated => 'Hedef başarıyla oluşturuldu.';

  @override
  String get goalFormSuccessUpdated => 'Hedef başarıyla güncellendi.';

  @override
  String get goalFormSubmit => 'Hedefi kaydet';

  @override
  String get goalDeleteDialogTitle => 'Hedefi sil';

  @override
  String get goalDeleteDialogMessage =>
      'Bu hedefi silmek istediğine emin misin?';

  @override
  String get goalDeleteDialogConfirm => 'Sil';

  @override
  String get goalDeletedMessage => 'Hedef silindi.';

  @override
  String get goalMenuEdit => 'Düzenle';

  @override
  String get goalMenuDelete => 'Sil';

  @override
  String get goalCurrentValue => 'Mevcut';

  @override
  String get autoTrackedMetricHint =>
      'Bu metrik en güncel ölçümlerine göre otomatik olarak güncellenir.';

  @override
  String get goalTargetValue => 'Hedef';

  @override
  String get goalDifferenceValue => 'Fark';

  @override
  String get goalStartValue => 'Başlangıç';

  @override
  String get goalCompletedChip => 'Tamamlandı';

  @override
  String get goalMarkComplete => 'Tamamlandı olarak işaretle';

  @override
  String get goalMarkedCompleted => 'Hedef tamamlandı!';

  @override
  String get goalDueToday => 'Son gün bugün';

  @override
  String goalDaysLeft(int days) {
    return '$days gün kaldı';
  }

  @override
  String goalOverdue(int days) {
    return '$days gün gecikti';
  }

  @override
  String goalCompletedOn(String date) {
    return '$date tarihinde tamamlandı';
  }

  @override
  String get goalErrorState => 'Hedeflerin yüklenemedi. Lütfen tekrar dene.';

  @override
  String get badgeCountLabel => 'rozet';

  @override
  String get badgeSheetTitle => 'Premium rozetleri';

  @override
  String badgeCurrentTier(String tier) {
    return 'Geçerli seviye: $tier';
  }

  @override
  String badgeTotalLabel(int count) {
    return 'Toplam $count rozet';
  }

  @override
  String badgeNextThreshold(int count) {
    return 'Bir sonraki seviye için $count rozet kaldı';
  }

  @override
  String get badgeAllTiersCompleted => 'En yüksek seviyeye ulaştın!';

  @override
  String get badgeLevelsTitle => 'Rozet seviyeleri';

  @override
  String get badgeTierRookie => 'Başlangıç';

  @override
  String get badgeTierBronze => 'Bronz';

  @override
  String get badgeTierSilver => 'Gümüş';

  @override
  String get badgeTierGold => 'Altın';

  @override
  String get badgeTierElite => 'Elit';

  @override
  String badgeThresholdLabel(int count) {
    return '≥ $count';
  }
}
