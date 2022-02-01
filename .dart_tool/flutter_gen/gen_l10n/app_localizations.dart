
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_ru.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hy'),
    Locale('ru')
  ];

  /// No description provided for @dashbroadText.
  ///
  /// In en, this message translates to:
  /// **'Dashbroad'**
  String get dashbroadText;

  /// No description provided for @shedulText.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get shedulText;

  /// No description provided for @qrCodeText.
  ///
  /// In en, this message translates to:
  /// **'My QR code'**
  String get qrCodeText;

  /// No description provided for @orderBags.
  ///
  /// In en, this message translates to:
  /// **'Order bags'**
  String get orderBags;

  /// No description provided for @contatcIfno.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contatcIfno;

  /// No description provided for @settingsText.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsText;

  /// No description provided for @logOutText.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOutText;

  /// No description provided for @homePicupsText.
  ///
  /// In en, this message translates to:
  /// **'Pickups'**
  String get homePicupsText;

  /// No description provided for @ongoingText.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoingText;

  /// No description provided for @passedText.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passedText;

  /// No description provided for @homeButtonText.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULE A PICKUP'**
  String get homeButtonText;

  /// No description provided for @editButtonText.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButtonText;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @shchedulMenuText.
  ///
  /// In en, this message translates to:
  /// **'Schedule a pickup'**
  String get shchedulMenuText;

  /// No description provided for @pickupDateText.
  ///
  /// In en, this message translates to:
  /// **'Pickup Date'**
  String get pickupDateText;

  /// No description provided for @pickupTimeText.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get pickupTimeText;

  /// No description provided for @intervalText.
  ///
  /// In en, this message translates to:
  /// **'Interval:(min 1 hours)'**
  String get intervalText;

  /// No description provided for @noteText.
  ///
  /// In en, this message translates to:
  /// **'Note for driver'**
  String get noteText;

  /// No description provided for @noteCommentText.
  ///
  /// In en, this message translates to:
  /// **'Writing any specific details theat will help the driver compleate the pickup. Ex: Bags will be at the door, or Jiggle the handle. It is not locked.'**
  String get noteCommentText;

  /// No description provided for @cancelText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelText;

  /// No description provided for @confirmText.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmText;

  /// No description provided for @contactIfnoText.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contactIfnoText;

  /// No description provided for @phoneNumText.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumText;

  /// No description provided for @addressText.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addressText;

  /// No description provided for @addressConfirmationText.
  ///
  /// In en, this message translates to:
  /// **'Address confirmation'**
  String get addressConfirmationText;

  /// No description provided for @streetLabelText.
  ///
  /// In en, this message translates to:
  /// **'Street name*'**
  String get streetLabelText;

  /// No description provided for @bdgText.
  ///
  /// In en, this message translates to:
  /// **'Bdg*'**
  String get bdgText;

  /// No description provided for @aptText.
  ///
  /// In en, this message translates to:
  /// **'Apt'**
  String get aptText;

  /// No description provided for @floorText.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floorText;

  /// No description provided for @entryText.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entryText;

  /// No description provided for @addressComment.
  ///
  /// In en, this message translates to:
  /// **'Address comment'**
  String get addressComment;

  /// No description provided for @invalidText.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalidText;

  /// No description provided for @welcomeLoginText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SmartApaga'**
  String get welcomeLoginText;

  /// No description provided for @forgotPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Forgot password ?'**
  String get forgotPasswordText;

  /// No description provided for @loginText.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginText;

  /// No description provided for @signUpText.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpText;

  /// No description provided for @emailText.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailText;

  /// No description provided for @passwordErrorText.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get passwordErrorText;

  /// No description provided for @passwordText.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordText;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orText;

  /// No description provided for @termsOfuseText.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfuseText;

  /// No description provided for @privacyPolicyText.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyText;

  /// No description provided for @scanQrCodeText.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQrCodeText;

  /// No description provided for @bagIdText.
  ///
  /// In en, this message translates to:
  /// **'Bag ID'**
  String get bagIdText;

  /// No description provided for @confirmId.
  ///
  /// In en, this message translates to:
  /// **'Confirm ID'**
  String get confirmId;

  /// No description provided for @dontHaveBagsText.
  ///
  /// In en, this message translates to:
  /// **'I Don\'t have bags'**
  String get dontHaveBagsText;

  /// No description provided for @cameraFacingText.
  ///
  /// In en, this message translates to:
  /// **'Camera facing'**
  String get cameraFacingText;

  /// No description provided for @wastTypeText.
  ///
  /// In en, this message translates to:
  /// **'Waste Type'**
  String get wastTypeText;

  /// No description provided for @belowText.
  ///
  /// In en, this message translates to:
  /// **'Below, please approximate how many 100L bags of waste you have for each type of waste'**
  String get belowText;

  /// No description provided for @plasticText.
  ///
  /// In en, this message translates to:
  /// **'Plastic'**
  String get plasticText;

  /// No description provided for @paperText.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get paperText;

  /// No description provided for @glassText.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get glassText;

  /// No description provided for @orederBagsButtonText.
  ///
  /// In en, this message translates to:
  /// **'Order bags'**
  String get orederBagsButtonText;

  /// No description provided for @addAnotherBagText.
  ///
  /// In en, this message translates to:
  /// **'Add another bag'**
  String get addAnotherBagText;

  /// No description provided for @nextButtonText.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButtonText;

  /// No description provided for @congratulationsText.
  ///
  /// In en, this message translates to:
  /// **'Congratulations on taking the first step towards a more sustainable Armenia! With this app you will be able to order recyclable waste pickups from our home or office.'**
  String get congratulationsText;

  /// No description provided for @fullNameText.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameText;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @taxCodeText.
  ///
  /// In en, this message translates to:
  /// **'Tax Code'**
  String get taxCodeText;

  /// No description provided for @singingDirectorsText.
  ///
  /// In en, this message translates to:
  /// **'Contact Person`s Name'**
  String get singingDirectorsText;

  /// No description provided for @companyEmailText.
  ///
  /// In en, this message translates to:
  /// **'Company e-mail'**
  String get companyEmailText;

  /// No description provided for @authorizedText.
  ///
  /// In en, this message translates to:
  /// **'I am authorized to complete this from and I have read and agreed to SmartApaga’s terms of use and privacy policy'**
  String get authorizedText;

  /// No description provided for @registerText.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerText;

  /// No description provided for @reusableText.
  ///
  /// In en, this message translates to:
  /// **'Reusable'**
  String get reusableText;

  /// No description provided for @disposableText.
  ///
  /// In en, this message translates to:
  /// **'Diposable'**
  String get disposableText;

  /// No description provided for @homeAdressText.
  ///
  /// In en, this message translates to:
  /// **'Home addresses'**
  String get homeAdressText;

  /// No description provided for @quantityText.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityText;

  /// No description provided for @totalText.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalText;

  /// No description provided for @youHaveNoPickup.
  ///
  /// In en, this message translates to:
  /// **'You have no pickups'**
  String get youHaveNoPickup;

  /// No description provided for @signUpAsanIndividualText.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get signUpAsanIndividualText;

  /// No description provided for @signUpAsAnOrganizationText.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get signUpAsAnOrganizationText;

  /// No description provided for @countinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get countinue;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @newText.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newText;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @periodTimeText.
  ///
  /// In en, this message translates to:
  /// **'Please, mention a period not less than 1 hour'**
  String get periodTimeText;

  /// No description provided for @pickupSuccessfullyAddedText.
  ///
  /// In en, this message translates to:
  /// **'Pickup successfully added'**
  String get pickupSuccessfullyAddedText;

  /// No description provided for @fieldErrorText.
  ///
  /// In en, this message translates to:
  /// **'Error! One of the fields is blank'**
  String get fieldErrorText;

  /// No description provided for @pickupEditText.
  ///
  /// In en, this message translates to:
  /// **'Pickup is Edit!'**
  String get pickupEditText;

  /// No description provided for @theFieldsdoNotMatchText.
  ///
  /// In en, this message translates to:
  /// **'The fields do not match !'**
  String get theFieldsdoNotMatchText;

  /// No description provided for @periodTextBox.
  ///
  /// In en, this message translates to:
  /// **'Put the time not earlier than 10 AM'**
  String get periodTextBox;

  /// No description provided for @periodTextBox2.
  ///
  /// In en, this message translates to:
  /// **'Put the time not later than 10 PM'**
  String get periodTextBox2;

  /// No description provided for @cancelText2.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get cancelText2;

  /// No description provided for @confirmCacel.
  ///
  /// In en, this message translates to:
  /// **'Do you want to cancel this pickup ?'**
  String get confirmCacel;

  /// No description provided for @replaceText.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replaceText;

  /// No description provided for @editText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to Edit this pickup ?'**
  String get editText;

  /// No description provided for @chooseAddressText.
  ///
  /// In en, this message translates to:
  /// **'Choose address'**
  String get chooseAddressText;

  /// No description provided for @pickupCancelText.
  ///
  /// In en, this message translates to:
  /// **'Pickup is Cansel'**
  String get pickupCancelText;

  /// No description provided for @okText.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okText;

  /// No description provided for @noText.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noText;

  /// No description provided for @bacCodeCheckText.
  ///
  /// In en, this message translates to:
  /// **'There is already a bag with this code'**
  String get bacCodeCheckText;

  /// No description provided for @cannotDeletAddressText.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete address as there is a Pickup at that address'**
  String get cannotDeletAddressText;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hy', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hy': return AppLocalizationsHy();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
