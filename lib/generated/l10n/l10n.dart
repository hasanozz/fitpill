import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @languageSelect.
  ///
  /// In en, this message translates to:
  /// **'Language Selection'**
  String get languageSelect;

  /// No description provided for @themeSelect.
  ///
  /// In en, this message translates to:
  /// **'Theme Selection'**
  String get themeSelect;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @themeD.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get themeD;

  /// No description provided for @themeL.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get themeL;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// No description provided for @forum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Chat Bot'**
  String get chatbot;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @arm.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get arm;

  /// No description provided for @shoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get shoulder;

  /// No description provided for @chest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get chest;

  /// No description provided for @waist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get waist;

  /// No description provided for @hip.
  ///
  /// In en, this message translates to:
  /// **'Hip'**
  String get hip;

  /// No description provided for @neck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get neck;

  /// No description provided for @leg.
  ///
  /// In en, this message translates to:
  /// **'Leg'**
  String get leg;

  /// No description provided for @calf.
  ///
  /// In en, this message translates to:
  /// **'Calf'**
  String get calf;

  /// No description provided for @fatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Fat Rate'**
  String get fatPercentage;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @captureFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Capture from Camera'**
  String get captureFromCamera;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @calculators.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get calculators;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myGymBag.
  ///
  /// In en, this message translates to:
  /// **'My Gym Bag'**
  String get myGymBag;

  /// No description provided for @bagEmpty.
  ///
  /// In en, this message translates to:
  /// **'Bag is Empty'**
  String get bagEmpty;

  /// No description provided for @recommendedItems.
  ///
  /// In en, this message translates to:
  /// **'Recommended Items'**
  String get recommendedItems;

  /// No description provided for @towel.
  ///
  /// In en, this message translates to:
  /// **'Towel'**
  String get towel;

  /// No description provided for @waterBottle.
  ///
  /// In en, this message translates to:
  /// **'Water Bottle'**
  String get waterBottle;

  /// No description provided for @sportsShoes.
  ///
  /// In en, this message translates to:
  /// **'Sports Shoes'**
  String get sportsShoes;

  /// No description provided for @slippers.
  ///
  /// In en, this message translates to:
  /// **'Slippers'**
  String get slippers;

  /// No description provided for @socks.
  ///
  /// In en, this message translates to:
  /// **'Socks'**
  String get socks;

  /// No description provided for @proteinBar.
  ///
  /// In en, this message translates to:
  /// **'Protein Bar'**
  String get proteinBar;

  /// No description provided for @gloves.
  ///
  /// In en, this message translates to:
  /// **'Gloves'**
  String get gloves;

  /// No description provided for @headphones.
  ///
  /// In en, this message translates to:
  /// **'Headphones'**
  String get headphones;

  /// No description provided for @addItems.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get addItems;

  /// No description provided for @letsPrepare.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Ready'**
  String get letsPrepare;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @airQulity.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQulity;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @rm.
  ///
  /// In en, this message translates to:
  /// **'1 RM'**
  String get rm;

  /// No description provided for @workSet.
  ///
  /// In en, this message translates to:
  /// **'Work Set'**
  String get workSet;

  /// No description provided for @bodyFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Percentage'**
  String get bodyFatPercentage;

  /// No description provided for @bodyFatLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String bodyFatLastUpdated(Object date);

  /// No description provided for @bodyFatMissingProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Add your gender and height to calculate body fat.'**
  String get bodyFatMissingProfileInfo;

  /// No description provided for @bodyFatMissingMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Add the following measurements to calculate body fat: {metrics}'**
  String bodyFatMissingMeasurements(Object metrics);

  /// No description provided for @bodyFatInvalidMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurement values look incorrect. Waist must be greater than neck.'**
  String get bodyFatInvalidMeasurements;

  /// No description provided for @bodyFatFatFreeMass.
  ///
  /// In en, this message translates to:
  /// **'Lean mass'**
  String get bodyFatFatFreeMass;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// No description provided for @ffmi.
  ///
  /// In en, this message translates to:
  /// **'FFMI'**
  String get ffmi;

  /// No description provided for @routines.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get routines;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @myRoutines.
  ///
  /// In en, this message translates to:
  /// **'My Routines'**
  String get myRoutines;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @createFolder.
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolder;

  /// No description provided for @addYourRecipe.
  ///
  /// In en, this message translates to:
  /// **'Add Your Recipe'**
  String get addYourRecipe;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No History Found'**
  String get noHistoryFound;

  /// No description provided for @newestToOldest.
  ///
  /// In en, this message translates to:
  /// **'Newest to Oldest'**
  String get newestToOldest;

  /// No description provided for @oldestToNewest.
  ///
  /// In en, this message translates to:
  /// **'Oldest to Newest'**
  String get oldestToNewest;

  /// No description provided for @createWorkoutRoutine.
  ///
  /// In en, this message translates to:
  /// **'Create Routine'**
  String get createWorkoutRoutine;

  /// No description provided for @createNutritionRoutine.
  ///
  /// In en, this message translates to:
  /// **'Create Nutrition Routine'**
  String get createNutritionRoutine;

  /// No description provided for @routineName.
  ///
  /// In en, this message translates to:
  /// **'Routine Name'**
  String get routineName;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose Icon'**
  String get chooseIcon;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @iconColor.
  ///
  /// In en, this message translates to:
  /// **'Icon Color'**
  String get iconColor;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @createExercise.
  ///
  /// In en, this message translates to:
  /// **'Create Exercise'**
  String get createExercise;

  /// No description provided for @numberOfSets.
  ///
  /// In en, this message translates to:
  /// **'Number of Sets'**
  String get numberOfSets;

  /// No description provided for @numberOfReps.
  ///
  /// In en, this message translates to:
  /// **'Number of Reps'**
  String get numberOfReps;

  /// No description provided for @saveExercise.
  ///
  /// In en, this message translates to:
  /// **'Save Exercise'**
  String get saveExercise;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @finishAndSave.
  ///
  /// In en, this message translates to:
  /// **'Finish and Save'**
  String get finishAndSave;

  /// No description provided for @exitWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Exit Without Saving'**
  String get exitWithoutSaving;

  /// No description provided for @itemsInBag.
  ///
  /// In en, this message translates to:
  /// **'Items in Bag'**
  String get itemsInBag;

  /// No description provided for @someItemsNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Some Items Not Selected'**
  String get someItemsNotSelected;

  /// No description provided for @missingSelection.
  ///
  /// In en, this message translates to:
  /// **'Missing Selection'**
  String get missingSelection;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @doYouConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm'**
  String get doYouConfirm;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @addWorkout.
  ///
  /// In en, this message translates to:
  /// **'Add Workout'**
  String get addWorkout;

  /// No description provided for @createRoutinePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a routine now'**
  String get createRoutinePromptTitle;

  /// No description provided for @createRoutinePromptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start working out, feel the progress!'**
  String get createRoutinePromptSubtitle;

  /// No description provided for @noWorkoutsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No Workouts added yet'**
  String get noWorkoutsAddedYet;

  /// No description provided for @deleteRoutine.
  ///
  /// In en, this message translates to:
  /// **'Delete Routine'**
  String get deleteRoutine;

  /// No description provided for @createWorkout.
  ///
  /// In en, this message translates to:
  /// **'Create Workout'**
  String get createWorkout;

  /// No description provided for @routineAndWorkoutsWillBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'and all its workouts will be deleted.\nDo you confirm?'**
  String get routineAndWorkoutsWillBeDeleted;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Understood'**
  String get understood;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @backpackDescription.
  ///
  /// In en, this message translates to:
  /// **'This app allows you to manage the items that should be in your gym bag. You can add, delete, and organize items.'**
  String get backpackDescription;

  /// No description provided for @cameraAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera access is required'**
  String get cameraAccessRequired;

  /// No description provided for @photosAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Photos access is required'**
  String get photosAccessRequired;

  /// No description provided for @confirmDeleteImage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the image'**
  String get confirmDeleteImage;

  /// No description provided for @cannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cannot be empty'**
  String get cannotBeEmpty;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @heightRangeError.
  ///
  /// In en, this message translates to:
  /// **'Height must be between 50 and 250 cm'**
  String get heightRangeError;

  /// No description provided for @weightRangeError.
  ///
  /// In en, this message translates to:
  /// **'Weight must be between 10 and 635'**
  String get weightRangeError;

  /// No description provided for @ageRangeError.
  ///
  /// In en, this message translates to:
  /// **'Age must be between 10 and 100'**
  String get ageRangeError;

  /// No description provided for @fatPercentageRangeError.
  ///
  /// In en, this message translates to:
  /// **'Fat percentage must be between 0 and 100'**
  String get fatPercentageRangeError;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @routineAddedHomepage.
  ///
  /// In en, this message translates to:
  /// **'Routine Added to Home Page.'**
  String get routineAddedHomepage;

  /// No description provided for @refreshPage.
  ///
  /// In en, this message translates to:
  /// **'Refresh Page'**
  String get refreshPage;

  /// No description provided for @workoutWillBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'will be deleted.\nDo you confirm?'**
  String get workoutWillBeDeleted;

  /// No description provided for @deleteWorkout.
  ///
  /// In en, this message translates to:
  /// **'Delete Workout'**
  String get deleteWorkout;

  /// No description provided for @deleteRoutineConfirmation.
  ///
  /// In en, this message translates to:
  /// **'{routineName} will be deleted. Do you confirm?\n'**
  String deleteRoutineConfirmation(Object routineName);

  /// No description provided for @sortingOptions.
  ///
  /// In en, this message translates to:
  /// **'Sorting Options'**
  String get sortingOptions;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// No description provided for @unknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown Title'**
  String get unknownTitle;

  /// No description provided for @noDataForPage.
  ///
  /// In en, this message translates to:
  /// **'No data found for this page'**
  String get noDataForPage;

  /// No description provided for @noExerciseName.
  ///
  /// In en, this message translates to:
  /// **'No Exercise Name'**
  String get noExerciseName;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Fill all fields'**
  String get fillAllFields;

  /// No description provided for @setsRangeError.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of sets in the range of 1-20'**
  String get setsRangeError;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @createRoutine.
  ///
  /// In en, this message translates to:
  /// **'Create Routine'**
  String get createRoutine;

  /// No description provided for @editRoutine.
  ///
  /// In en, this message translates to:
  /// **'Edit Routine'**
  String get editRoutine;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deleteWorkoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'{workoutName} will be deleted. Do you confirm?\n'**
  String deleteWorkoutConfirmation(Object workoutName);

  /// No description provided for @shortMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get shortMon;

  /// No description provided for @shortTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get shortTue;

  /// No description provided for @shortWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get shortWed;

  /// No description provided for @shortThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get shortThu;

  /// No description provided for @shortFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get shortFri;

  /// No description provided for @shortSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get shortSat;

  /// No description provided for @shortSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get shortSun;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @pushDay.
  ///
  /// In en, this message translates to:
  /// **'Push Day'**
  String get pushDay;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete it?'**
  String get confirmDelete;

  /// No description provided for @locationPermissionsPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions have been permanently denied, please allow them from app settings'**
  String get locationPermissionsPermanentlyDenied;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @dataCouldNotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Data could not be loaded'**
  String get dataCouldNotBeLoaded;

  /// No description provided for @airQualityCalculator.
  ///
  /// In en, this message translates to:
  /// **'Air Quality Calculator'**
  String get airQualityCalculator;

  /// No description provided for @airQualityGood.
  ///
  /// In en, this message translates to:
  /// **'Air quality is satisfactory, and air pollution poses little or no risk.'**
  String get airQualityGood;

  /// No description provided for @airQualityModerate.
  ///
  /// In en, this message translates to:
  /// **'Air quality is acceptable; however, some pollutants may be a concern for sensitive groups.'**
  String get airQualityModerate;

  /// No description provided for @airQualitySensitive.
  ///
  /// In en, this message translates to:
  /// **'Sensitive groups may experience health effects. The general public is not likely to be affected.'**
  String get airQualitySensitive;

  /// No description provided for @airQualityUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Everyone may begin to experience health effects; sensitive groups may experience more serious effects.'**
  String get airQualityUnhealthy;

  /// No description provided for @airQualityVeryUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Health alert: Everyone may experience more serious health effects.'**
  String get airQualityVeryUnhealthy;

  /// No description provided for @airQualityHazardous.
  ///
  /// In en, this message translates to:
  /// **'Health warning of emergency conditions: everyone is more likely to be affected.'**
  String get airQualityHazardous;

  /// No description provided for @airQualityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Air quality data is unavailable.'**
  String get airQualityUnknown;

  /// No description provided for @walk.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walk;

  /// No description provided for @inclinedWalk.
  ///
  /// In en, this message translates to:
  /// **'Inclined Walking'**
  String get inclinedWalk;

  /// No description provided for @run.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get run;

  /// No description provided for @bicycle.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get bicycle;

  /// No description provided for @swimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get swimming;

  /// No description provided for @weightlifting.
  ///
  /// In en, this message translates to:
  /// **'Weightlifting'**
  String get weightlifting;

  /// No description provided for @rowing.
  ///
  /// In en, this message translates to:
  /// **'Rowing'**
  String get rowing;

  /// No description provided for @weeklyRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly routine'**
  String get weeklyRoutineTitle;

  /// No description provided for @weeklyRoutineDescription.
  ///
  /// In en, this message translates to:
  /// **'Plan your week, add workouts or rest days and mark them as complete when you show up.'**
  String get weeklyRoutineDescription;

  /// No description provided for @weeklyRoutineError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your routine right now. Please try again shortly.'**
  String get weeklyRoutineError;

  /// No description provided for @weeklyRoutineOffDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get weeklyRoutineOffDay;

  /// No description provided for @weeklyRoutineNotPlanned.
  ///
  /// In en, this message translates to:
  /// **'No workout planned'**
  String get weeklyRoutineNotPlanned;

  /// No description provided for @weeklyRoutineMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as complete'**
  String get weeklyRoutineMarkDone;

  /// No description provided for @weeklyRoutineMarkNotDone.
  ///
  /// In en, this message translates to:
  /// **'Undo completion'**
  String get weeklyRoutineMarkNotDone;

  /// No description provided for @weeklyRoutineAddWorkout.
  ///
  /// In en, this message translates to:
  /// **'Add workout'**
  String get weeklyRoutineAddWorkout;

  /// No description provided for @weeklyRoutineSetOffDay.
  ///
  /// In en, this message translates to:
  /// **'Set as rest'**
  String get weeklyRoutineSetOffDay;

  /// No description provided for @weeklyRoutineClearDay.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weeklyRoutineClearDay;

  /// No description provided for @weeklyRoutineSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Choose from your workouts or FitPill programs'**
  String get weeklyRoutineSelectSource;

  /// No description provided for @weeklyRoutineTabMyWorkouts.
  ///
  /// In en, this message translates to:
  /// **'My workouts'**
  String get weeklyRoutineTabMyWorkouts;

  /// No description provided for @weeklyRoutineTabFitpill.
  ///
  /// In en, this message translates to:
  /// **'FitPill'**
  String get weeklyRoutineTabFitpill;

  /// No description provided for @weeklyRoutineNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your FitPill workout is ready!'**
  String get weeklyRoutineNotificationTitle;

  /// No description provided for @weeklyRoutineNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s plan: {workout}'**
  String weeklyRoutineNotificationBody(Object workout);

  /// No description provided for @weeklyRoutineNoPersonalWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Create a workout routine first to add it here.'**
  String get weeklyRoutineNoPersonalWorkouts;

  /// No description provided for @weeklyRoutineNoWorkoutsInRoutine.
  ///
  /// In en, this message translates to:
  /// **'No workouts saved in this routine yet'**
  String get weeklyRoutineNoWorkoutsInRoutine;

  /// No description provided for @weeklyRoutineFailedToLoadWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts could not be loaded'**
  String get weeklyRoutineFailedToLoadWorkouts;

  /// No description provided for @weeklyRoutineCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly routine'**
  String get weeklyRoutineCardTitle;

  /// No description provided for @weeklyRoutineShortcutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get weeklyRoutineShortcutTooltip;

  /// No description provided for @weeklyRoutineCompletionOnlyToday.
  ///
  /// In en, this message translates to:
  /// **'Check-ins are only available for today\'s workout.'**
  String get weeklyRoutineCompletionOnlyToday;

  /// No description provided for @weeklyRoutineAnalyticsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Training analytics'**
  String get weeklyRoutineAnalyticsCardTitle;

  /// No description provided for @weeklyRoutineAnalyticsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month ({month}): {count} workout days'**
  String weeklyRoutineAnalyticsThisMonth(Object month, int count);

  /// No description provided for @weeklyRoutineAnalyticsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month ({month}): {count} workout days'**
  String weeklyRoutineAnalyticsLastMonth(Object month, int count);

  /// No description provided for @weeklyRoutineAnalyticsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mark workouts to build your stats.'**
  String get weeklyRoutineAnalyticsEmpty;

  /// No description provided for @fitpillProgramLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get fitpillProgramLevel;

  /// No description provided for @fitpillProgramAddedToWeeklyRoutine.
  ///
  /// In en, this message translates to:
  /// **'Added to your weekly routine'**
  String get fitpillProgramAddedToWeeklyRoutine;

  /// No description provided for @fitpillProgramAddToRoutine.
  ///
  /// In en, this message translates to:
  /// **'Add to weekly plan'**
  String get fitpillProgramAddToRoutine;

  /// No description provided for @fitpillProgramSelectDay.
  ///
  /// In en, this message translates to:
  /// **'Which day should we add it to?'**
  String get fitpillProgramSelectDay;

  /// No description provided for @workoutTabHeader.
  ///
  /// In en, this message translates to:
  /// **'Plan your training'**
  String get workoutTabHeader;

  /// No description provided for @workoutTabMyWorkouts.
  ///
  /// In en, this message translates to:
  /// **'My workouts'**
  String get workoutTabMyWorkouts;

  /// No description provided for @workoutTabFitpillPrograms.
  ///
  /// In en, this message translates to:
  /// **'FitPill Programs'**
  String get workoutTabFitpillPrograms;

  /// No description provided for @jumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump Rope'**
  String get jumpRope;

  /// No description provided for @stairs.
  ///
  /// In en, this message translates to:
  /// **'Stairs'**
  String get stairs;

  /// No description provided for @hiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get hiit;

  /// No description provided for @football.
  ///
  /// In en, this message translates to:
  /// **'Football'**
  String get football;

  /// No description provided for @basketball.
  ///
  /// In en, this message translates to:
  /// **'Basketball'**
  String get basketball;

  /// No description provided for @volleyball.
  ///
  /// In en, this message translates to:
  /// **'Volleyball'**
  String get volleyball;

  /// No description provided for @boxing.
  ///
  /// In en, this message translates to:
  /// **'Boxing'**
  String get boxing;

  /// No description provided for @dance.
  ///
  /// In en, this message translates to:
  /// **'Dancing'**
  String get dance;

  /// No description provided for @housework.
  ///
  /// In en, this message translates to:
  /// **'Housework'**
  String get housework;

  /// No description provided for @sex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sex;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @activityCalorieCalculator.
  ///
  /// In en, this message translates to:
  /// **'Activity Calorie Calculator'**
  String get activityCalorieCalculator;

  /// No description provided for @metInfoText.
  ///
  /// In en, this message translates to:
  /// **'Calories burned for each activity are calculated based on MET values. These values are approximate and may vary due to individual differences.'**
  String get metInfoText;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @bodyWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Body Weight (kg)'**
  String get bodyWeightKg;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @tempo.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get tempo;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Intense'**
  String get fast;

  /// No description provided for @burnedCalories.
  ///
  /// In en, this message translates to:
  /// **'Burned Calories'**
  String get burnedCalories;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Invalid weight input, must be between 30 and 250'**
  String get invalidWeight;

  /// No description provided for @baklava.
  ///
  /// In en, this message translates to:
  /// **'Baklava'**
  String get baklava;

  /// No description provided for @pizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get pizza;

  /// No description provided for @hamburger.
  ///
  /// In en, this message translates to:
  /// **'Hamburger'**
  String get hamburger;

  /// No description provided for @bread.
  ///
  /// In en, this message translates to:
  /// **'Bread'**
  String get bread;

  /// No description provided for @soda.
  ///
  /// In en, this message translates to:
  /// **'Soda'**
  String get soda;

  /// No description provided for @creamyCoffee.
  ///
  /// In en, this message translates to:
  /// **'Creamy Coffee'**
  String get creamyCoffee;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @slice.
  ///
  /// In en, this message translates to:
  /// **'slice'**
  String get slice;

  /// No description provided for @piece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get piece;

  /// No description provided for @glass.
  ///
  /// In en, this message translates to:
  /// **'glass'**
  String get glass;

  /// No description provided for @grande.
  ///
  /// In en, this message translates to:
  /// **'grande'**
  String get grande;

  /// No description provided for @foods.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get foods;

  /// No description provided for @repMaxCalculator.
  ///
  /// In en, this message translates to:
  /// **'Rep Max Calculator'**
  String get repMaxCalculator;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @brzyckiFormulaInfo.
  ///
  /// In en, this message translates to:
  /// **'The Brzycki Formula estimates the maximum weight you can lift for 1-10 repetitions.'**
  String get brzyckiFormulaInfo;

  /// No description provided for @invalidWeightRm.
  ///
  /// In en, this message translates to:
  /// **'Invalid weight, must not exceed 500'**
  String get invalidWeightRm;

  /// No description provided for @resultsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Results will appear here.'**
  String get resultsWillAppearHere;

  /// No description provided for @workSetCalculator.
  ///
  /// In en, this message translates to:
  /// **'Work Set Calculator'**
  String get workSetCalculator;

  /// No description provided for @workSetInfo.
  ///
  /// In en, this message translates to:
  /// **'Provides work set combinations based on your 1 Rep Max. You can calculate your 1 Rep Max using the 1 RM calculator.'**
  String get workSetInfo;

  /// No description provided for @oneRepMax.
  ///
  /// In en, this message translates to:
  /// **'1 Rep Max'**
  String get oneRepMax;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @fixedWeight.
  ///
  /// In en, this message translates to:
  /// **'Fixed Weight'**
  String get fixedWeight;

  /// No description provided for @rampSystem.
  ///
  /// In en, this message translates to:
  /// **'Ramp System'**
  String get rampSystem;

  /// No description provided for @workSets.
  ///
  /// In en, this message translates to:
  /// **'Work Sets'**
  String get workSets;

  /// No description provided for @allSets.
  ///
  /// In en, this message translates to:
  /// **'All Sets'**
  String get allSets;

  /// No description provided for @fatRateCalculator.
  ///
  /// In en, this message translates to:
  /// **'Body Fat Calculator'**
  String get fatRateCalculator;

  /// No description provided for @fatRateInfo.
  ///
  /// In en, this message translates to:
  /// **'Neck: around Adam\'s apple, Waist: around the navel, Hips: at the widest point. The calculation is based on the Navy BF Calculator algorithm.'**
  String get fatRateInfo;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @yourFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Your Fat Percentage'**
  String get yourFatPercentage;

  /// No description provided for @saveFatPercentageQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save your fat percentage?'**
  String get saveFatPercentageQuestion;

  /// No description provided for @fatPercentageSaved.
  ///
  /// In en, this message translates to:
  /// **'Fat percentage has been saved to your profile'**
  String get fatPercentageSaved;

  /// No description provided for @successfullySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get successfullySaved;

  /// No description provided for @upgradeToSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to premium to save progress'**
  String get upgradeToSaveProgress;

  /// No description provided for @upgradeToCreateRoutine.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to premium to create routines'**
  String get upgradeToCreateRoutine;

  /// No description provided for @premiumMembershipExpired.
  ///
  /// In en, this message translates to:
  /// **'Your premium membership has expired. Renew to keep training without restrictions.'**
  String get premiumMembershipExpired;

  /// No description provided for @premiumSectionLocked.
  ///
  /// In en, this message translates to:
  /// **'This section requires an active premium plan. Upgrade or renew to continue.'**
  String get premiumSectionLocked;

  /// No description provided for @workoutHistoryNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout history isn\'t saved on the free plan. Upgrade to keep your sessions.'**
  String get workoutHistoryNotSaved;

  /// No description provided for @premiumUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock FitPill Premium'**
  String get premiumUnlockTitle;

  /// No description provided for @premiumUnlockDescription.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to discover personalised workouts, deeper insights, and exclusive member perks.'**
  String get premiumUnlockDescription;

  /// No description provided for @goPremium.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get goPremium;

  /// No description provided for @premiumMemberCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMemberCardTitle;

  /// Displays when the user joined premium with a formatted date.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String premiumMemberSince(String date);

  /// No description provided for @premiumMemberSinceUnknown.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get premiumMemberSinceUnknown;

  /// No description provided for @premiumProfileHighlights.
  ///
  /// In en, this message translates to:
  /// **'Profile highlights'**
  String get premiumProfileHighlights;

  /// No description provided for @premiumProfileMissing.
  ///
  /// In en, this message translates to:
  /// **'Add more profile details to unlock personalised highlights.'**
  String get premiumProfileMissing;

  /// No description provided for @premiumAvatarReady.
  ///
  /// In en, this message translates to:
  /// **'Avatar selected'**
  String get premiumAvatarReady;

  /// No description provided for @profilePhotoPremiumOnly.
  ///
  /// In en, this message translates to:
  /// **'Profile photo uploads are available for Premium members.'**
  String get profilePhotoPremiumOnly;

  /// No description provided for @profilePhotoPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'We need camera or photo library permission to continue. Please enable it in Settings.'**
  String get profilePhotoPermissionDenied;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully.'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t update your profile photo. Please try again.'**
  String get profilePhotoUpdateFailed;

  /// No description provided for @premiumCardShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your premium card'**
  String get premiumCardShareTitle;

  /// No description provided for @premiumShareWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get premiumShareWhatsapp;

  /// No description provided for @premiumShareInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get premiumShareInstagram;

  /// No description provided for @premiumShareCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get premiumShareCopy;

  /// No description provided for @premiumShareCopied.
  ///
  /// In en, this message translates to:
  /// **'Share message copied to clipboard!'**
  String get premiumShareCopied;

  /// No description provided for @premiumShareError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open that app. Please try again.'**
  String get premiumShareError;

  /// No description provided for @premiumMemberCardError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your premium details right now.'**
  String get premiumMemberCardError;

  /// No description provided for @premiumMemberCardTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get premiumMemberCardTryAgain;

  /// No description provided for @premiumShareMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} just joined FitPill Premium! Let\'s reach our goals together.'**
  String premiumShareMessage(String name);

  /// No description provided for @saveFatPercentage.
  ///
  /// In en, this message translates to:
  /// **'Save This Fat Percentage to Profile'**
  String get saveFatPercentage;

  /// No description provided for @calorieCalculator.
  ///
  /// In en, this message translates to:
  /// **'Calorie Calculator'**
  String get calorieCalculator;

  /// No description provided for @calorieInfo.
  ///
  /// In en, this message translates to:
  /// **'Your basal metabolic rate and daily calorie intake are calculated. You can increase or decrease according to your goal. The Katch-McArdle formula is used for the calculation.'**
  String get calorieInfo;

  /// No description provided for @weightRangeWarning.
  ///
  /// In en, this message translates to:
  /// **'Body weight must be between 25-300 kg.'**
  String get weightRangeWarning;

  /// No description provided for @fatPercentageRangeWarning.
  ///
  /// In en, this message translates to:
  /// **'Body fat percentage must be between 2-60.'**
  String get fatPercentageRangeWarning;

  /// No description provided for @maintainWeight.
  ///
  /// In en, this message translates to:
  /// **'Maintain Your Weight'**
  String get maintainWeight;

  /// No description provided for @loseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// No description provided for @gainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get gainWeight;

  /// No description provided for @sedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary Lifestyle'**
  String get sedentary;

  /// No description provided for @lightlyActive.
  ///
  /// In en, this message translates to:
  /// **'Light Exercise - 1-2 days of exercise'**
  String get lightlyActive;

  /// No description provided for @moderatelyActive.
  ///
  /// In en, this message translates to:
  /// **'Moderately Active - 3-4 days of exercise'**
  String get moderatelyActive;

  /// No description provided for @veryActive.
  ///
  /// In en, this message translates to:
  /// **'Active Life - 5-6 days of exercise'**
  String get veryActive;

  /// No description provided for @athletic.
  ///
  /// In en, this message translates to:
  /// **'Extremely intense work or sports'**
  String get athletic;

  /// No description provided for @bmrValue.
  ///
  /// In en, this message translates to:
  /// **'BMR'**
  String get bmrValue;

  /// No description provided for @maintainCalorie.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintainCalorie;

  /// No description provided for @calorieDeficit.
  ///
  /// In en, this message translates to:
  /// **'Weight Loss'**
  String get calorieDeficit;

  /// No description provided for @calorieSurplus.
  ///
  /// In en, this message translates to:
  /// **'Weight Gain'**
  String get calorieSurplus;

  /// No description provided for @bmiCalculator.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiCalculator;

  /// No description provided for @bmiInfo.
  ///
  /// In en, this message translates to:
  /// **'It indicates the weight range we should be in for a healthy life. It is calculated based on height and weight ratio. The range of 18.5 to 24.9 is considered healthy. If you are an athlete, FFMI is a more optimal measure for you.'**
  String get bmiInfo;

  /// No description provided for @severelyUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Severely Underweight'**
  String get severelyUnderweight;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @normalWeight.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalWeight;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @obese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get obese;

  /// No description provided for @idealWeight.
  ///
  /// In en, this message translates to:
  /// **'Ideal Weight'**
  String get idealWeight;

  /// No description provided for @lowerLimit.
  ///
  /// In en, this message translates to:
  /// **'Low Lim'**
  String get lowerLimit;

  /// No description provided for @upperLimit.
  ///
  /// In en, this message translates to:
  /// **'Upp Lim'**
  String get upperLimit;

  /// No description provided for @ffmiCalculator.
  ///
  /// In en, this message translates to:
  /// **'FFMI Calculator'**
  String get ffmiCalculator;

  /// No description provided for @ffmiInfo.
  ///
  /// In en, this message translates to:
  /// **'It measures the fat-free mass of the body in proportion to height. Unlike standard BMI, it differentiates between muscle and fat, providing more accurate results for athletes.'**
  String get ffmiInfo;

  /// No description provided for @bodyWeight.
  ///
  /// In en, this message translates to:
  /// **'Body Weight'**
  String get bodyWeight;

  /// No description provided for @leanMass.
  ///
  /// In en, this message translates to:
  /// **'Lean Mass'**
  String get leanMass;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name.'**
  String get enterValidName;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get invalidEmail;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 6 characters.'**
  String get weakPassword;

  /// No description provided for @emailExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get emailExists;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get wrongPassword;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownError;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// No description provided for @enterValidHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid height.'**
  String get enterValidHeight;

  /// No description provided for @enterValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight.'**
  String get enterValidWeight;

  /// No description provided for @invalidHeight.
  ///
  /// In en, this message translates to:
  /// **'Invalid Height'**
  String get invalidHeight;

  /// No description provided for @firestoreError.
  ///
  /// In en, this message translates to:
  /// **'Firestore Error'**
  String get firestoreError;

  /// No description provided for @quitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to logout?'**
  String get quitConfirm;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @alreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'This item has already been added!'**
  String get alreadyAdded;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateApp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @favoritedExercises.
  ///
  /// In en, this message translates to:
  /// **'Favorite Exercises'**
  String get favoritedExercises;

  /// No description provided for @fitpillSlogan.
  ///
  /// In en, this message translates to:
  /// **'Take a step to a healthy life with Fitpill'**
  String get fitpillSlogan;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed!'**
  String get loginFailed;

  /// No description provided for @emailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty!'**
  String get emailEmpty;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address!'**
  String get emailInvalid;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty!'**
  String get passwordEmpty;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long!'**
  String get passwordMinLength;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password must contain an uppercase letter, a lowercase letter, and a number!'**
  String get passwordRequirements;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @workoutWithMe.
  ///
  /// In en, this message translates to:
  /// **'Workout with Me'**
  String get workoutWithMe;

  /// No description provided for @alreadyHaveAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountQuestion;

  /// No description provided for @noAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountQuestion;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a New Account'**
  String get createNewAccount;

  /// No description provided for @registerSlogan.
  ///
  /// In en, this message translates to:
  /// **'Start your FitPill experience now'**
  String get registerSlogan;

  /// No description provided for @nameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty!'**
  String get nameEmpty;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters long!'**
  String get nameMinLength;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the KVKK and Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @acceptPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'You must accept the KVKK approval!'**
  String get acceptPrivacyPolicy;

  /// No description provided for @startFree.
  ///
  /// In en, this message translates to:
  /// **'Start Free'**
  String get startFree;

  /// No description provided for @alreadyMember.
  ///
  /// In en, this message translates to:
  /// **'Already a Member'**
  String get alreadyMember;

  /// No description provided for @healthyLifeJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Healthy Life\nJourney Begins'**
  String get healthyLifeJourney;

  /// No description provided for @personalizedTraining.
  ///
  /// In en, this message translates to:
  /// **'Achieve your goals with personalized training programs and nutrition guide'**
  String get personalizedTraining;

  /// No description provided for @registrationTerms.
  ///
  /// In en, this message translates to:
  /// **'By registering, you agree to the terms of use and privacy policy.'**
  String get registrationTerms;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordResetLink.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your email address!'**
  String get passwordResetLink;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password!'**
  String get invalidCredentials;

  /// No description provided for @healthStatistics.
  ///
  /// In en, this message translates to:
  /// **'Health Stats'**
  String get healthStatistics;

  /// No description provided for @metrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get metrics;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @graph.
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get graph;

  /// No description provided for @toSeeGraph.
  ///
  /// In en, this message translates to:
  /// **'Add metrics to see your graph'**
  String get toSeeGraph;

  /// No description provided for @startYourJourney.
  ///
  /// In en, this message translates to:
  /// **'start your FitPill journey 😊🤔🤓'**
  String get startYourJourney;

  /// No description provided for @measurementRange.
  ///
  /// In en, this message translates to:
  /// **'Invalid measurment range'**
  String get measurementRange;

  /// No description provided for @invalidNumberFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid number format'**
  String get invalidNumberFormat;

  /// No description provided for @onlyNumericValuesAllowed.
  ///
  /// In en, this message translates to:
  /// **'Only numeric values!'**
  String get onlyNumericValuesAllowed;

  /// No description provided for @editWorkout.
  ///
  /// In en, this message translates to:
  /// **'Edit Workout'**
  String get editWorkout;

  /// No description provided for @workoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Workout Completed!'**
  String get workoutSummary;

  /// No description provided for @congrats.
  ///
  /// In en, this message translates to:
  /// **'Congratulations, you\'ve finished your workout!'**
  String get congrats;

  /// No description provided for @exerciseCount.
  ///
  /// In en, this message translates to:
  /// **'🏋️ Exercise Count: {count}'**
  String exerciseCount(Object count);

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'🔥 Estimated Calories Burned: {calories} kcal'**
  String caloriesBurned(Object calories);

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'⏳ Total Duration: '**
  String get totalTime;

  /// No description provided for @noWorkouts.
  ///
  /// In en, this message translates to:
  /// **'No workouts added yet!'**
  String get noWorkouts;

  /// No description provided for @addWorkoutProgram.
  ///
  /// In en, this message translates to:
  /// **'Add a workout program to get started.'**
  String get addWorkoutProgram;

  /// No description provided for @workoutAdded.
  ///
  /// In en, this message translates to:
  /// **'Workout successfully saved!'**
  String get workoutAdded;

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise Name'**
  String get exerciseName;

  /// No description provided for @setCount.
  ///
  /// In en, this message translates to:
  /// **'Set Count'**
  String get setCount;

  /// No description provided for @setDuration.
  ///
  /// In en, this message translates to:
  /// **'Set Duration (s)'**
  String get setDuration;

  /// No description provided for @restDuration.
  ///
  /// In en, this message translates to:
  /// **'Rest Duration (s)'**
  String get restDuration;

  /// No description provided for @workoutWillTake.
  ///
  /// In en, this message translates to:
  /// **'This program will take around {minutes} minutes and burn {calories} calories.'**
  String workoutWillTake(Object calories, Object minutes);

  /// No description provided for @preparationTime.
  ///
  /// In en, this message translates to:
  /// **'Preparation Time'**
  String get preparationTime;

  /// No description provided for @restTime.
  ///
  /// In en, this message translates to:
  /// **'Rest Time'**
  String get restTime;

  /// No description provided for @exerciseTime.
  ///
  /// In en, this message translates to:
  /// **'Exercise Time'**
  String get exerciseTime;

  /// No description provided for @deleteExercise.
  ///
  /// In en, this message translates to:
  /// **'Delete Exercise'**
  String get deleteExercise;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @pleaseAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one exercise and fill in the names.'**
  String get pleaseAddExercise;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @savedWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Saved Workouts'**
  String get savedWorkouts;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @superSet.
  ///
  /// In en, this message translates to:
  /// **'Superset'**
  String get superSet;

  /// No description provided for @workoutCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout Completed!'**
  String get workoutCompleted;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred!'**
  String get errorOccurred;

  /// No description provided for @noWorkoutsAdded.
  ///
  /// In en, this message translates to:
  /// **'No workouts added yet'**
  String get noWorkoutsAdded;

  /// No description provided for @addWorkoutPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create a new workout program to get started'**
  String get addWorkoutPrompt;

  /// No description provided for @unnamedWorkout.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Workout'**
  String get unnamedWorkout;

  /// No description provided for @startActivity.
  ///
  /// In en, this message translates to:
  /// **'Start Activity'**
  String get startActivity;

  /// No description provided for @selectActivity.
  ///
  /// In en, this message translates to:
  /// **'Select Activity'**
  String get selectActivity;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get stop;

  /// No description provided for @incline.
  ///
  /// In en, this message translates to:
  /// **'Incline'**
  String get incline;

  /// No description provided for @noActivtyRecords.
  ///
  /// In en, this message translates to:
  /// **'No activity records yet.'**
  String get noActivtyRecords;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login to see your history'**
  String get pleaseLogin;

  /// No description provided for @tempoLevel.
  ///
  /// In en, this message translates to:
  /// **'Tempo Level'**
  String get tempoLevel;

  /// No description provided for @targetDuration.
  ///
  /// In en, this message translates to:
  /// **'Target Duration (min)'**
  String get targetDuration;

  /// No description provided for @activityHistory.
  ///
  /// In en, this message translates to:
  /// **'Activity History'**
  String get activityHistory;

  /// No description provided for @weightTrackedInProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight is tracked in Progress section and updated automatically'**
  String get weightTrackedInProgress;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @selectAvatar.
  ///
  /// In en, this message translates to:
  /// **'Select Avatar'**
  String get selectAvatar;

  /// No description provided for @max20.
  ///
  /// In en, this message translates to:
  /// **'You can add up to 20 items'**
  String get max20;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @caloriesSummary.
  ///
  /// In en, this message translates to:
  /// **'Calories Summary'**
  String get caloriesSummary;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @passwordChange.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get passwordChange;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get generalError;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This Field is Required'**
  String get requiredField;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords Not Match'**
  String get passwordsNotMatch;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Changed'**
  String get passwordChanged;

  /// No description provided for @passwordChangeCooldown.
  ///
  /// In en, this message translates to:
  /// **'You can change your password 1 time in 24 hours'**
  String get passwordChangeCooldown;

  /// No description provided for @newPasswordSameAsOld.
  ///
  /// In en, this message translates to:
  /// **'New Password is same as old'**
  String get newPasswordSameAsOld;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset mail sent'**
  String get passwordResetEmailSent;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'E-mail Sent'**
  String get emailSent;

  /// No description provided for @resetEmailWillBeSentTo.
  ///
  /// In en, this message translates to:
  /// **'A password reset link will be sent to the following email address:'**
  String get resetEmailWillBeSentTo;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @setupProfile.
  ///
  /// In en, this message translates to:
  /// **'Setup Profile'**
  String get setupProfile;

  /// No description provided for @selectBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Please select your birthdate'**
  String get selectBirthDate;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get chooseDate;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @myBags.
  ///
  /// In en, this message translates to:
  /// **'My Bags'**
  String get myBags;

  /// No description provided for @defaultBackpackName.
  ///
  /// In en, this message translates to:
  /// **'Starter Bag'**
  String get defaultBackpackName;

  /// No description provided for @addBag.
  ///
  /// In en, this message translates to:
  /// **'Add New Bag'**
  String get addBag;

  /// No description provided for @bagName.
  ///
  /// In en, this message translates to:
  /// **'Bag Name'**
  String get bagName;

  /// No description provided for @haventCreatedBag.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created a bag yet.'**
  String get haventCreatedBag;

  /// No description provided for @bagSettings.
  ///
  /// In en, this message translates to:
  /// **'Bag Settings'**
  String get bagSettings;

  /// No description provided for @askDeleteBag.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete this bag'**
  String get askDeleteBag;

  /// No description provided for @deleteBag.
  ///
  /// In en, this message translates to:
  /// **'Delete Bag'**
  String get deleteBag;

  /// No description provided for @emptyBag.
  ///
  /// In en, this message translates to:
  /// **'Bag is empty.'**
  String get emptyBag;

  /// No description provided for @createRoutineNow.
  ///
  /// In en, this message translates to:
  /// **'Create a routine now'**
  String get createRoutineNow;

  /// No description provided for @startTrainingFeelProgress.
  ///
  /// In en, this message translates to:
  /// **'Start training, feel the progress!'**
  String get startTrainingFeelProgress;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get dayAgo;

  /// No description provided for @bestPerformances.
  ///
  /// In en, this message translates to:
  /// **'Best Performances'**
  String get bestPerformances;

  /// No description provided for @weightTrackingChart.
  ///
  /// In en, this message translates to:
  /// **'Weight Tracking Chart'**
  String get weightTrackingChart;

  /// No description provided for @volumeTrackingChart.
  ///
  /// In en, this message translates to:
  /// **'Volume Tracking Chart'**
  String get volumeTrackingChart;

  /// No description provided for @noSetsYet.
  ///
  /// In en, this message translates to:
  /// **'No sets yet'**
  String get noSetsYet;

  /// No description provided for @addSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get addSet;

  /// No description provided for @heaviestSet.
  ///
  /// In en, this message translates to:
  /// **'Heaviest Set'**
  String get heaviestSet;

  /// No description provided for @highestVolume.
  ///
  /// In en, this message translates to:
  /// **'Highest Volume'**
  String get highestVolume;

  /// No description provided for @addAtLeast2.
  ///
  /// In en, this message translates to:
  /// **'At least 2 data points must be entered for the chart.'**
  String get addAtLeast2;

  /// No description provided for @oneRepMaxWeight.
  ///
  /// In en, this message translates to:
  /// **'Your 1 Rep Max Weight'**
  String get oneRepMaxWeight;

  /// No description provided for @yourWishSet.
  ///
  /// In en, this message translates to:
  /// **'Sets and Reps You Want to Do'**
  String get yourWishSet;

  /// No description provided for @setDifficult.
  ///
  /// In en, this message translates to:
  /// **'Set Difficulty'**
  String get setDifficult;

  /// No description provided for @setType.
  ///
  /// In en, this message translates to:
  /// **'Set Type'**
  String get setType;

  /// No description provided for @carbohydrate.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate'**
  String get carbohydrate;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @fiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fiber;

  /// No description provided for @dailyWaterNeed.
  ///
  /// In en, this message translates to:
  /// **'Daily Water Need'**
  String get dailyWaterNeed;

  /// No description provided for @burnFat.
  ///
  /// In en, this message translates to:
  /// **'Burn fat'**
  String get burnFat;

  /// No description provided for @maintainMass.
  ///
  /// In en, this message translates to:
  /// **'Maintain mass'**
  String get maintainMass;

  /// No description provided for @gainMass.
  ///
  /// In en, this message translates to:
  /// **'gain mass'**
  String get gainMass;

  /// No description provided for @yourActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Your Activity Level'**
  String get yourActivityLevel;

  /// No description provided for @yourDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get yourDestination;

  /// No description provided for @bodyType.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyType;

  /// No description provided for @nutritionTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition tracking'**
  String get nutritionTrackingTitle;

  /// No description provided for @nutritionTrackingDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your meals, manage foods, and monitor daily micro & macro values.'**
  String get nutritionTrackingDescription;

  /// No description provided for @nutritionEmptyMealsTitle.
  ///
  /// In en, this message translates to:
  /// **'No meals yet'**
  String get nutritionEmptyMealsTitle;

  /// No description provided for @nutritionEmptyMealsDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the button below to create your first meal.'**
  String get nutritionEmptyMealsDescription;

  /// No description provided for @nutritionDailyTotals.
  ///
  /// In en, this message translates to:
  /// **'Daily totals'**
  String get nutritionDailyTotals;

  /// No description provided for @nutritionNoSummary.
  ///
  /// In en, this message translates to:
  /// **'Totals will be calculated once you add foods.'**
  String get nutritionNoSummary;

  /// No description provided for @nutritionEmptyMealBody.
  ///
  /// In en, this message translates to:
  /// **'This meal has no foods yet. Start adding foods to keep track of your macros.'**
  String get nutritionEmptyMealBody;

  /// No description provided for @nutritionAddMeal.
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get nutritionAddMeal;

  /// No description provided for @nutritionAddFood.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get nutritionAddFood;

  /// No description provided for @nutritionDeleteMeal.
  ///
  /// In en, this message translates to:
  /// **'Delete meal'**
  String get nutritionDeleteMeal;

  /// No description provided for @nutritionNewMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a meal'**
  String get nutritionNewMealTitle;

  /// No description provided for @nutritionMealNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal name'**
  String get nutritionMealNameLabel;

  /// No description provided for @nutritionMealNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a meal name.'**
  String get nutritionMealNameEmpty;

  /// No description provided for @nutritionFoodNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Food name'**
  String get nutritionFoodNameLabel;

  /// No description provided for @nutritionFoodNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a food name.'**
  String get nutritionFoodNameEmpty;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @sodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodium;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @goalTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Set ambitious goals'**
  String get goalTabTitle;

  /// No description provided for @goalTabDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay motivated by defining clear targets and deadlines.'**
  String get goalTabDescription;

  /// No description provided for @goalPremiumRequired.
  ///
  /// In en, this message translates to:
  /// **'Goal tracking is a Premium feature.'**
  String get goalPremiumRequired;

  /// No description provided for @goalUpgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Premium'**
  String get goalUpgradeButton;

  /// No description provided for @goalAddButton.
  ///
  /// In en, this message translates to:
  /// **'Create goal'**
  String get goalAddButton;

  /// No description provided for @goalEmptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No goals yet'**
  String get goalEmptyStateTitle;

  /// No description provided for @goalEmptyStateDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a goal to start tracking your progress.'**
  String get goalEmptyStateDescription;

  /// No description provided for @goalActiveSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Active goals'**
  String get goalActiveSectionTitle;

  /// No description provided for @goalCompletedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed goals'**
  String get goalCompletedSectionTitle;

  /// No description provided for @goalMetricSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal for {metric}'**
  String goalMetricSummaryTitle(String metric);

  /// No description provided for @goalMetricRemainingDown.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit} to go'**
  String goalMetricRemainingDown(String value, String unit);

  /// No description provided for @goalMetricRemainingUp.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit} to go'**
  String goalMetricRemainingUp(String value, String unit);

  /// No description provided for @goalEditFromMetric.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get goalEditFromMetric;

  /// No description provided for @goalCreateFromMetric.
  ///
  /// In en, this message translates to:
  /// **'Set a goal'**
  String get goalCreateFromMetric;

  /// No description provided for @goalFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get goalFormTitle;

  /// No description provided for @goalFormUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update goal'**
  String get goalFormUpdateTitle;

  /// No description provided for @goalFormMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get goalFormMetricLabel;

  /// No description provided for @goalFormCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get goalFormCurrentLabel;

  /// No description provided for @goalFormTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target value'**
  String get goalFormTargetLabel;

  /// No description provided for @goalFormDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get goalFormDeadlineLabel;

  /// No description provided for @goalFormDeadlinePick.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get goalFormDeadlinePick;

  /// No description provided for @goalFormNumericError.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers.'**
  String get goalFormNumericError;

  /// No description provided for @goalFormErrorEqualValues.
  ///
  /// In en, this message translates to:
  /// **'Current and target values cannot be the same.'**
  String get goalFormErrorEqualValues;

  /// No description provided for @goalFormSuccessCreated.
  ///
  /// In en, this message translates to:
  /// **'Goal created successfully.'**
  String get goalFormSuccessCreated;

  /// No description provided for @goalFormSuccessUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal updated successfully.'**
  String get goalFormSuccessUpdated;

  /// No description provided for @goalFormSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save goal'**
  String get goalFormSubmit;

  /// No description provided for @goalDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete goal'**
  String get goalDeleteDialogTitle;

  /// No description provided for @goalDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this goal?'**
  String get goalDeleteDialogMessage;

  /// No description provided for @goalDeleteDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get goalDeleteDialogConfirm;

  /// No description provided for @goalDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Goal deleted.'**
  String get goalDeletedMessage;

  /// No description provided for @goalMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get goalMenuEdit;

  /// No description provided for @goalMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get goalMenuDelete;

  /// No description provided for @goalCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get goalCurrentValue;

  /// Helper text shown on metrics that are automatically tracked
  ///
  /// In en, this message translates to:
  /// **'This metric updates automatically from your latest measurements.'**
  String get autoTrackedMetricHint;

  /// No description provided for @goalTargetValue.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get goalTargetValue;

  /// No description provided for @goalDifferenceValue.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get goalDifferenceValue;

  /// No description provided for @goalStartValue.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get goalStartValue;

  /// No description provided for @goalCompletedChip.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get goalCompletedChip;

  /// No description provided for @goalMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as complete'**
  String get goalMarkComplete;

  /// No description provided for @goalMarkedCompleted.
  ///
  /// In en, this message translates to:
  /// **'Goal marked as completed!'**
  String get goalMarkedCompleted;

  /// No description provided for @goalDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get goalDueToday;

  /// No description provided for @goalDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String goalDaysLeft(int days);

  /// No description provided for @goalOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days} days overdue'**
  String goalOverdue(int days);

  /// No description provided for @goalCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String goalCompletedOn(String date);

  /// No description provided for @goalErrorState.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your goals. Please try again.'**
  String get goalErrorState;

  /// No description provided for @badgeCountLabel.
  ///
  /// In en, this message translates to:
  /// **'badges'**
  String get badgeCountLabel;

  /// No description provided for @badgeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium badges'**
  String get badgeSheetTitle;

  /// No description provided for @badgeCurrentTier.
  ///
  /// In en, this message translates to:
  /// **'Current tier: {tier}'**
  String badgeCurrentTier(String tier);

  /// No description provided for @badgeTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} badges collected'**
  String badgeTotalLabel(int count);

  /// No description provided for @badgeNextThreshold.
  ///
  /// In en, this message translates to:
  /// **'{count} more badges for the next tier'**
  String badgeNextThreshold(int count);

  /// No description provided for @badgeAllTiersCompleted.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the highest tier!'**
  String get badgeAllTiersCompleted;

  /// No description provided for @badgeLevelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Badge tiers'**
  String get badgeLevelsTitle;

  /// No description provided for @badgeTierRookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie Challenger'**
  String get badgeTierRookie;

  /// No description provided for @badgeTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze Challenger'**
  String get badgeTierBronze;

  /// No description provided for @badgeTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver Challenger'**
  String get badgeTierSilver;

  /// No description provided for @badgeTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Challenger'**
  String get badgeTierGold;

  /// No description provided for @badgeTierElite.
  ///
  /// In en, this message translates to:
  /// **'Elite Challenger'**
  String get badgeTierElite;

  /// No description provided for @badgeThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'≥ {count}'**
  String badgeThresholdLabel(int count);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'tr':
      return STr();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
