import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Inspector'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @biometricAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthentication;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @officialDesignation.
  ///
  /// In en, this message translates to:
  /// **'Official Designation'**
  String get officialDesignation;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @nameOfSender.
  ///
  /// In en, this message translates to:
  /// **'Name of Sender'**
  String get nameOfSender;

  /// No description provided for @senderOfficialDesignation.
  ///
  /// In en, this message translates to:
  /// **'Sender Official Designation'**
  String get senderOfficialDesignation;

  /// No description provided for @doNumber.
  ///
  /// In en, this message translates to:
  /// **'DO Number'**
  String get doNumber;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get division;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @sendingSampleLocation.
  ///
  /// In en, this message translates to:
  /// **'Sending Sample Location'**
  String get sendingSampleLocation;

  /// No description provided for @lab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get lab;

  /// No description provided for @selectDistrictFirst.
  ///
  /// In en, this message translates to:
  /// **'Select district first'**
  String get selectDistrictFirst;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @selectDivisionFirst.
  ///
  /// In en, this message translates to:
  /// **'Select division first'**
  String get selectDivisionFirst;

  /// No description provided for @requestForSlipNumber.
  ///
  /// In en, this message translates to:
  /// **'Request for slip number'**
  String get requestForSlipNumber;

  /// No description provided for @enterCount.
  ///
  /// In en, this message translates to:
  /// **'Enter count'**
  String get enterCount;

  /// No description provided for @slipNumberCount.
  ///
  /// In en, this message translates to:
  /// **'Enter slip number count'**
  String get slipNumberCount;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @resubmitSample.
  ///
  /// In en, this message translates to:
  /// **'Resubmit Sample'**
  String get resubmitSample;

  /// No description provided for @submittingRequest.
  ///
  /// In en, this message translates to:
  /// **'Submitting resubmit request... Please wait'**
  String get submittingRequest;

  /// No description provided for @noSamplesToResubmit.
  ///
  /// In en, this message translates to:
  /// **'Currently no samples present to resubmit'**
  String get noSamplesToResubmit;

  /// No description provided for @confirmResubmit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Resubmit'**
  String get confirmResubmit;

  /// No description provided for @validation.
  ///
  /// In en, this message translates to:
  /// **'Validation'**
  String get validation;

  /// No description provided for @rememberPass.
  ///
  /// In en, this message translates to:
  /// **'Remember your password'**
  String get rememberPass;

  /// No description provided for @missingFields.
  ///
  /// In en, this message translates to:
  /// **'Missing serial number or user id'**
  String get missingFields;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @menuFormVI.
  ///
  /// In en, this message translates to:
  /// **'Form VI'**
  String get menuFormVI;

  /// No description provided for @menuSampleListRecords.
  ///
  /// In en, this message translates to:
  /// **'Sample List Records'**
  String get menuSampleListRecords;

  /// No description provided for @menuRequestSlipNumber.
  ///
  /// In en, this message translates to:
  /// **'Request for slip number'**
  String get menuRequestSlipNumber;

  /// No description provided for @menuSlipNumberInfo.
  ///
  /// In en, this message translates to:
  /// **'Slip number info'**
  String get menuSlipNumberInfo;

  /// No description provided for @menuRequestNewSample.
  ///
  /// In en, this message translates to:
  /// **'Request For New Sample'**
  String get menuRequestNewSample;

  /// No description provided for @menuOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get menuOthers;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get menuHelpSupport;

  /// No description provided for @menuAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get menuAboutUs;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to Logout?'**
  String get logoutMessage;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirm;

  /// No description provided for @userFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallback;

  /// No description provided for @designationFoodSafetyOfficer.
  ///
  /// In en, this message translates to:
  /// **'Food Safety Officer'**
  String get designationFoodSafetyOfficer;

  /// No description provided for @userIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'User ID:'**
  String get userIdPrefix;

  /// No description provided for @usernamePrefix.
  ///
  /// In en, this message translates to:
  /// **'Username:'**
  String get usernamePrefix;

  /// No description provided for @sampleFormViDetails.
  ///
  /// In en, this message translates to:
  /// **'Sample Form VI Details'**
  String get sampleFormViDetails;

  /// No description provided for @loadingSampleDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading sample details...'**
  String get loadingSampleDetails;

  /// No description provided for @noDetailsFound.
  ///
  /// In en, this message translates to:
  /// **'No details found'**
  String get noDetailsFound;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @serialNo.
  ///
  /// In en, this message translates to:
  /// **'Serial No'**
  String get serialNo;

  /// No description provided for @senderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Sender Name'**
  String get senderNameLabel;

  /// No description provided for @senderDesignationLabel.
  ///
  /// In en, this message translates to:
  /// **'Sender Designation'**
  String get senderDesignationLabel;

  /// No description provided for @doNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'DO Number'**
  String get doNumberLabel;

  /// No description provided for @locationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get locationDetails;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @sampleInformation.
  ///
  /// In en, this message translates to:
  /// **'Sample Information'**
  String get sampleInformation;

  /// No description provided for @sampleCode.
  ///
  /// In en, this message translates to:
  /// **'Sample Code'**
  String get sampleCode;

  /// No description provided for @slipNumber.
  ///
  /// In en, this message translates to:
  /// **'Slip Number'**
  String get slipNumber;

  /// No description provided for @collectionDate.
  ///
  /// In en, this message translates to:
  /// **'Collection Date'**
  String get collectionDate;

  /// No description provided for @collectionPlace.
  ///
  /// In en, this message translates to:
  /// **'Place Of Collection'**
  String get collectionPlace;

  /// No description provided for @sampleName.
  ///
  /// In en, this message translates to:
  /// **'Sample Name'**
  String get sampleName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity Of Sample'**
  String get quantity;

  /// No description provided for @preservativeDetails.
  ///
  /// In en, this message translates to:
  /// **'Preservative Details'**
  String get preservativeDetails;

  /// No description provided for @preservativeAdded.
  ///
  /// In en, this message translates to:
  /// **'Preservative Added ?'**
  String get preservativeAdded;

  /// No description provided for @preservativeName.
  ///
  /// In en, this message translates to:
  /// **'Preservative Name'**
  String get preservativeName;

  /// No description provided for @preservativeQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get preservativeQuantity;

  /// No description provided for @verificationSecurity.
  ///
  /// In en, this message translates to:
  /// **'Verification & Security'**
  String get verificationSecurity;

  /// No description provided for @witnessSignature.
  ///
  /// In en, this message translates to:
  /// **'Signature & Thumb impression of the person/witness from whom the sample has been taken :'**
  String get witnessSignature;

  /// No description provided for @doSignature.
  ///
  /// In en, this message translates to:
  /// **'Code Number of Sample on Wrapper :'**
  String get doSignature;

  /// No description provided for @sealImpression.
  ///
  /// In en, this message translates to:
  /// **'Impression of seal of the sender :'**
  String get sealImpression;

  /// No description provided for @sealNumber.
  ///
  /// In en, this message translates to:
  /// **'Number of Seal:'**
  String get sealNumber;

  /// No description provided for @formViDetails.
  ///
  /// In en, this message translates to:
  /// **'Form VI Details'**
  String get formViDetails;

  /// No description provided for @memoFormVi.
  ///
  /// In en, this message translates to:
  /// **'Memorandum in Form VI (Sealed packed & Specimen of the seal):'**
  String get memoFormVi;

  /// No description provided for @insideWrapper.
  ///
  /// In en, this message translates to:
  /// **'Form VI is inside the sample wrapper?'**
  String get insideWrapper;

  /// No description provided for @wrapperCode.
  ///
  /// In en, this message translates to:
  /// **'Code Number of Sample on Wrapper :'**
  String get wrapperCode;

  /// No description provided for @uploadedDocument.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Document'**
  String get uploadedDocument;

  /// No description provided for @statusTransactions.
  ///
  /// In en, this message translates to:
  /// **'Status Transactions'**
  String get statusTransactions;

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

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @noDocumentsUploaded.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded'**
  String get noDocumentsUploaded;

  /// No description provided for @noFilePathAvailableFor.
  ///
  /// In en, this message translates to:
  /// **'No file path available for'**
  String get noFilePathAvailableFor;

  /// No description provided for @cannotOpen.
  ///
  /// In en, this message translates to:
  /// **'Cannot open'**
  String get cannotOpen;

  /// No description provided for @sampleListTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample List'**
  String get sampleListTitle;

  /// No description provided for @sampleListFilterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get sampleListFilterBy;

  /// No description provided for @sampleListFilterBySerialNo.
  ///
  /// In en, this message translates to:
  /// **'Serial No'**
  String get sampleListFilterBySerialNo;

  /// No description provided for @sampleListFilterBySlipNumber.
  ///
  /// In en, this message translates to:
  /// **'Slip Number'**
  String get sampleListFilterBySlipNumber;

  /// No description provided for @sampleListFilterBySampleName.
  ///
  /// In en, this message translates to:
  /// **'Sample Name'**
  String get sampleListFilterBySampleName;

  /// No description provided for @sampleListFilterByCollectionDate.
  ///
  /// In en, this message translates to:
  /// **'Collection Date'**
  String get sampleListFilterByCollectionDate;

  /// No description provided for @sampleListFilterBySenderName.
  ///
  /// In en, this message translates to:
  /// **'Sender Name'**
  String get sampleListFilterBySenderName;

  /// No description provided for @sampleListFilterBySenderDesignation.
  ///
  /// In en, this message translates to:
  /// **'Sender Designation'**
  String get sampleListFilterBySenderDesignation;

  /// No description provided for @sampleListFilterByDO.
  ///
  /// In en, this message translates to:
  /// **'DO Number'**
  String get sampleListFilterByDO;

  /// No description provided for @sampleListFilterByLab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get sampleListFilterByLab;

  /// No description provided for @sampleListFilterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sampleListFilterByStatus;

  /// No description provided for @sampleListFilterByAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get sampleListFilterByAll;

  /// No description provided for @sampleListFilterByPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get sampleListFilterByPending;

  /// No description provided for @sampleListFilterByApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get sampleListFilterByApproved;

  /// No description provided for @sampleListFilterByRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get sampleListFilterByRejected;

  /// No description provided for @sampleListFilterByResubmit.
  ///
  /// In en, this message translates to:
  /// **'Resubmit'**
  String get sampleListFilterByResubmit;

  /// No description provided for @sampleListFilterBySampleList.
  ///
  /// In en, this message translates to:
  /// **'Sample List'**
  String get sampleListFilterBySampleList;

  /// No description provided for @sampleListFilterBySampleListRecords.
  ///
  /// In en, this message translates to:
  /// **'Sample List Records'**
  String get sampleListFilterBySampleListRecords;

  /// No description provided for @sampleListFilterBySampleListRecordsTooltip.
  ///
  /// In en, this message translates to:
  /// **'View sample list records'**
  String get sampleListFilterBySampleListRecordsTooltip;

  /// No description provided for @sampleListFilterBySampleListRecordsDialog.
  ///
  /// In en, this message translates to:
  /// **'Sample List Records'**
  String get sampleListFilterBySampleListRecordsDialog;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample List Records'**
  String get sampleListFilterBySampleListRecordsDialogTitle;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select the sample list records you want to view'**
  String get sampleListFilterBySampleListRecordsDialogMessage;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'View Records'**
  String get sampleListFilterBySampleListRecordsDialogConfirm;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sampleListFilterBySampleListRecordsDialogCancel;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogNoRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get sampleListFilterBySampleListRecordsDialogNoRecordsFound;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogNoRecordsFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No records found for the selected sample list records'**
  String get sampleListFilterBySampleListRecordsDialogNoRecordsFoundMessage;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogNoRecordsFoundConfirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get sampleListFilterBySampleListRecordsDialogNoRecordsFoundConfirm;

  /// No description provided for @sampleListFilterBySampleListRecordsDialogNoRecordsFoundCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sampleListFilterBySampleListRecordsDialogNoRecordsFoundCancel;

  /// No description provided for @sampleAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample Analysis'**
  String get sampleAnalysisTitle;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitAppTitle;

  /// No description provided for @exitAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to exit?'**
  String get exitAppMessage;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitAppConfirm;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @invalidRange.
  ///
  /// In en, this message translates to:
  /// **'Invalid range: To date must be on/after From date'**
  String get invalidRange;

  /// No description provided for @fetchingFilteredRecords.
  ///
  /// In en, this message translates to:
  /// **'Fetching filtered records...'**
  String get fetchingFilteredRecords;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @loadingStatus.
  ///
  /// In en, this message translates to:
  /// **'Loading status...'**
  String get loadingStatus;

  /// No description provided for @noStatusFound.
  ///
  /// In en, this message translates to:
  /// **'No status found'**
  String get noStatusFound;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile;

  /// No description provided for @updatePass.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePass;

  /// No description provided for @labMaster.
  ///
  /// In en, this message translates to:
  /// **'Lab Master'**
  String get labMaster;

  /// No description provided for @loadingLabs.
  ///
  /// In en, this message translates to:
  /// **'Loading labs...'**
  String get loadingLabs;

  /// No description provided for @labLabel.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get labLabel;

  /// No description provided for @selectLab.
  ///
  /// In en, this message translates to:
  /// **'Select Lab'**
  String get selectLab;

  /// No description provided for @filterTooltipClearHide.
  ///
  /// In en, this message translates to:
  /// **'Clear & Hide Filters'**
  String get filterTooltipClearHide;

  /// No description provided for @filterTooltipShow.
  ///
  /// In en, this message translates to:
  /// **'Show Filters'**
  String get filterTooltipShow;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @switchToTable.
  ///
  /// In en, this message translates to:
  /// **'Switch to Table View'**
  String get switchToTable;

  /// No description provided for @switchToCard.
  ///
  /// In en, this message translates to:
  /// **'Switch to Card View'**
  String get switchToCard;

  /// No description provided for @unexpectedState.
  ///
  /// In en, this message translates to:
  /// **'Unexpected state'**
  String get unexpectedState;

  /// No description provided for @showingRange.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}-{end} of {total} records'**
  String showingRange(Object start, Object end, Object total);

  /// No description provided for @thSerialNo.
  ///
  /// In en, this message translates to:
  /// **'Serial No.'**
  String get thSerialNo;

  /// No description provided for @thSentDate.
  ///
  /// In en, this message translates to:
  /// **'Sent Date'**
  String get thSentDate;

  /// No description provided for @thLabLocation.
  ///
  /// In en, this message translates to:
  /// **'Lab Location'**
  String get thLabLocation;

  /// No description provided for @thRequestedDate.
  ///
  /// In en, this message translates to:
  /// **'Requested Date'**
  String get thRequestedDate;

  /// No description provided for @thResentDate.
  ///
  /// In en, this message translates to:
  /// **'Resent Date'**
  String get thResentDate;

  /// No description provided for @thStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get thStatus;

  /// No description provided for @thActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get thActions;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @form6_landing_title.
  ///
  /// In en, this message translates to:
  /// **'Form VI'**
  String get form6_landing_title;

  /// No description provided for @form6_landing_sections_title.
  ///
  /// In en, this message translates to:
  /// **'Form VI Sections'**
  String get form6_landing_sections_title;

  /// No description provided for @form6_landing_fso_info_title.
  ///
  /// In en, this message translates to:
  /// **'FSO Info'**
  String get form6_landing_fso_info_title;

  /// No description provided for @form6_landing_fso_info_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Food Safety Officer details'**
  String get form6_landing_fso_info_subtitle;

  /// No description provided for @form6_landing_sample_info_title.
  ///
  /// In en, this message translates to:
  /// **'Sample Info'**
  String get form6_landing_sample_info_title;

  /// No description provided for @form6_landing_sample_info_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Basic sample details'**
  String get form6_landing_sample_info_subtitle;

  /// No description provided for @form6_landing_preservative_info_title.
  ///
  /// In en, this message translates to:
  /// **'Preservative Info'**
  String get form6_landing_preservative_info_title;

  /// No description provided for @form6_landing_preservative_info_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Preservative information'**
  String get form6_landing_preservative_info_subtitle;

  /// No description provided for @form6_landing_seal_details_title.
  ///
  /// In en, this message translates to:
  /// **'Seal Details'**
  String get form6_landing_seal_details_title;

  /// No description provided for @form6_landing_seal_details_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Seal and security details'**
  String get form6_landing_seal_details_subtitle;

  /// No description provided for @form6_landing_review_submit_title.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get form6_landing_review_submit_title;

  /// No description provided for @form6_landing_review_submit_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Final review and submission'**
  String get form6_landing_review_submit_subtitle;

  /// No description provided for @form6_landing_submit_button.
  ///
  /// In en, this message translates to:
  /// **'Submit Form'**
  String get form6_landing_submit_button;

  /// No description provided for @form6_landing_form_not_filled.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Form not filled. Please fill the form.'**
  String get form6_landing_form_not_filled;

  /// No description provided for @form6_landing_form_submitted.
  ///
  /// In en, this message translates to:
  /// **'✅ Form VI submitted successfully.'**
  String get form6_landing_form_submitted;

  /// No description provided for @form6_landing_submission_failed.
  ///
  /// In en, this message translates to:
  /// **'Form submission failed.'**
  String get form6_landing_submission_failed;

  /// No description provided for @form6_landing_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get form6_landing_loading;

  /// No description provided for @form6_landing_exit_app.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get form6_landing_exit_app;

  /// No description provided for @form6_landing_exit_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to exit?'**
  String get form6_landing_exit_confirmation;

  /// No description provided for @form6_landing_exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get form6_landing_exit;

  /// No description provided for @form6_step_form_vi_title.
  ///
  /// In en, this message translates to:
  /// **'Form VI'**
  String get form6_step_form_vi_title;

  /// No description provided for @form6_step_previous_button.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get form6_step_previous_button;

  /// No description provided for @form6_step_save_next_button.
  ///
  /// In en, this message translates to:
  /// **'SAVE & NEXT'**
  String get form6_step_save_next_button;

  /// No description provided for @form6_step_submit_button.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get form6_step_submit_button;

  /// No description provided for @form6_step_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please correct the highlighted fields'**
  String get form6_step_validation_error;

  /// No description provided for @form6_step_other_section_incomplete.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please complete all required fields.'**
  String get form6_step_other_section_incomplete;

  /// No description provided for @form6_step_sample_section_incomplete.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please complete all sample fields.'**
  String get form6_step_sample_section_incomplete;

  /// No description provided for @doSlipNumbers.
  ///
  /// In en, this message translates to:
  /// **'DO Slip Numbers'**
  String get doSlipNumbers;

  /// No description provided for @sampleCodeNumber.
  ///
  /// In en, this message translates to:
  /// **'Sample Code Number'**
  String get sampleCodeNumber;

  /// No description provided for @natureOfSample.
  ///
  /// In en, this message translates to:
  /// **'Nature of Sample'**
  String get natureOfSample;

  /// No description provided for @pleaseSelectYesOrNo.
  ///
  /// In en, this message translates to:
  /// **'Please select Yes or No'**
  String get pleaseSelectYesOrNo;

  /// No description provided for @anyOtherDocuments.
  ///
  /// In en, this message translates to:
  /// **'Any other documents'**
  String get anyOtherDocuments;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document Name'**
  String get documentName;

  /// No description provided for @enterDocumentName.
  ///
  /// In en, this message translates to:
  /// **'Enter document name'**
  String get enterDocumentName;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @replaceFile.
  ///
  /// In en, this message translates to:
  /// **'Replace file'**
  String get replaceFile;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// No description provided for @biometricQuickSecureTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick & Secure Sign-in'**
  String get biometricQuickSecureTitle;

  /// No description provided for @biometricFaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable Face ID for faster and secure login. You can still use your password anytime.'**
  String get biometricFaceDesc;

  /// No description provided for @biometricFingerprintDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable fingerprint authentication for faster and secure login. You can still use your password anytime.'**
  String get biometricFingerprintDesc;

  /// No description provided for @biometricNotAvailableWarning.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device. You can enable it later if supported.'**
  String get biometricNotAvailableWarning;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @authenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get authenticating;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'VERIFY OTP'**
  String get verifyOTP;

  /// No description provided for @errorSavingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Error saving preferences'**
  String get errorSavingPreferences;

  /// No description provided for @biometricNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication not supported on this device.'**
  String get biometricNotSupported;

  /// No description provided for @authRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authRequiredTitle;

  /// No description provided for @biometricNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'Biometric not recognized. Try again.'**
  String get biometricNotRecognized;

  /// No description provided for @biometricRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric required'**
  String get biometricRequiredTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @authCanceledOrFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication canceled or failed.'**
  String get authCanceledOrFailed;

  /// No description provided for @authErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Authentication error occurred.'**
  String get authErrorOccurred;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available.'**
  String get biometricNotAvailable;

  /// No description provided for @noFaceEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No face biometric enrolled. Please set up Face ID in device settings.'**
  String get noFaceEnrolled;

  /// No description provided for @noFingerprintEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No fingerprint enrolled. Please set up fingerprint in device settings.'**
  String get noFingerprintEnrolled;

  /// No description provided for @biometricLockedTemporary.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is temporarily locked. Try again later or use passcode.'**
  String get biometricLockedTemporary;

  /// No description provided for @biometricLockedPermanent.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is permanently locked. Please set up new biometrics.'**
  String get biometricLockedPermanent;

  /// No description provided for @passcodeNotSet.
  ///
  /// In en, this message translates to:
  /// **'Device passcode is not set. Please set a device passcode to use biometric authentication.'**
  String get passcodeNotSet;

  /// No description provided for @authFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get authFailedTryAgain;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred.'**
  String get unknownErrorOccurred;

  /// No description provided for @unableToStartBiometric.
  ///
  /// In en, this message translates to:
  /// **'Unable to start biometric authentication.'**
  String get unableToStartBiometric;

  /// No description provided for @debugTestBiometric.
  ///
  /// In en, this message translates to:
  /// **'Debug: Test Biometric'**
  String get debugTestBiometric;

  /// No description provided for @formViSuccess.
  ///
  /// In en, this message translates to:
  /// **'Form VI data submitted succesfully'**
  String get formViSuccess;

  /// No description provided for @otpSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccessfully;

  /// No description provided for @login_bio_face_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Face authentication is not available on this device or not enrolled.'**
  String get login_bio_face_unavailable;

  /// No description provided for @login_bio_fingerprint_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint authentication is not available on this device or not enrolled.'**
  String get login_bio_fingerprint_unavailable;

  /// No description provided for @login_bio_generic_face_or_fingerprint.
  ///
  /// In en, this message translates to:
  /// **'This device reports generic biometrics. The system may show Face or Fingerprint based on what is enrolled.'**
  String get login_bio_generic_face_or_fingerprint;

  /// No description provided for @login_bio_generic_fingerprint_or_face.
  ///
  /// In en, this message translates to:
  /// **'This device reports generic biometrics. The system may show Fingerprint or Face based on what is enrolled.'**
  String get login_bio_generic_fingerprint_or_face;

  /// No description provided for @auth_failed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get auth_failed;

  /// No description provided for @biometricAuthError.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication error: {error}'**
  String biometricAuthError(Object error);

  /// No description provided for @otpVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully'**
  String get otpVerifiedSuccessfully;

  /// No description provided for @otpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Wrong OTP, please enter a valid OTP'**
  String get otpInvalid;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have logged in successfully'**
  String get loginSuccess;

  /// No description provided for @serverNoResponse.
  ///
  /// In en, this message translates to:
  /// **'No response from server'**
  String get serverNoResponse;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String somethingWentWrong(Object error);

  /// No description provided for @oldPass.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPass;

  /// No description provided for @newPass.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPass;

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

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @failedToDecryptServerResponse.
  ///
  /// In en, this message translates to:
  /// **'Failed to decrypt server response.'**
  String get failedToDecryptServerResponse;

  /// No description provided for @otpRequiredSixDigits.
  ///
  /// In en, this message translates to:
  /// **'OTP is required and must be 6 digits.'**
  String get otpRequiredSixDigits;

  /// No description provided for @userIdNotFoundInSecureStorage.
  ///
  /// In en, this message translates to:
  /// **'User ID not found in secure storage.'**
  String get userIdNotFoundInSecureStorage;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'New Password & Confirm Password do not match'**
  String get passwordMismatch;

  /// No description provided for @footer.
  ///
  /// In en, this message translates to:
  /// **'Designed & Developed by'**
  String get footer;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login Here'**
  String get loginHere;

  /// No description provided for @loginWithBio.
  ///
  /// In en, this message translates to:
  /// **'You can login using biometrics or password.'**
  String get loginWithBio;

  /// No description provided for @authorisedPerson.
  ///
  /// In en, this message translates to:
  /// **'Authorized Personnel Only'**
  String get authorisedPerson;

  /// No description provided for @forgotPass.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPass;

  /// No description provided for @faceOrFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Face or Fingerprint'**
  String get faceOrFingerprint;

  /// No description provided for @supported.
  ///
  /// In en, this message translates to:
  /// **'Supported'**
  String get supported;

  /// No description provided for @fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get marathi;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @oldPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Old password is required'**
  String get oldPasswordRequired;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @otpRequired.
  ///
  /// In en, this message translates to:
  /// **'OTP is required'**
  String get otpRequired;

  /// No description provided for @otpMustBeDigits.
  ///
  /// In en, this message translates to:
  /// **'OTP must be {length} digits'**
  String otpMustBeDigits(int length);

  /// No description provided for @otpOnlyDigits.
  ///
  /// In en, this message translates to:
  /// **'OTP must contain only digits'**
  String get otpOnlyDigits;

  /// No description provided for @captchaRequired.
  ///
  /// In en, this message translates to:
  /// **'Captcha is required'**
  String get captchaRequired;

  /// No description provided for @countryRequired.
  ///
  /// In en, this message translates to:
  /// **'Country is required'**
  String get countryRequired;

  /// No description provided for @stateRequired.
  ///
  /// In en, this message translates to:
  /// **'State is required'**
  String get stateRequired;

  /// No description provided for @districtRequired.
  ///
  /// In en, this message translates to:
  /// **'District is required'**
  String get districtRequired;

  /// No description provided for @divisionRequired.
  ///
  /// In en, this message translates to:
  /// **'Division is required'**
  String get divisionRequired;

  /// No description provided for @regionRequired.
  ///
  /// In en, this message translates to:
  /// **'Region is required'**
  String get regionRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @mobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get mobileRequired;

  /// No description provided for @mobileExactDigits.
  ///
  /// In en, this message translates to:
  /// **'Mobile number must be exactly 10 digits'**
  String get mobileExactDigits;

  /// No description provided for @mobileOnlyDigits.
  ///
  /// In en, this message translates to:
  /// **'Mobile number must contain only digits'**
  String get mobileOnlyDigits;

  /// No description provided for @otpMaxDigits.
  ///
  /// In en, this message translates to:
  /// **'OTP cannot be more than 6 digits'**
  String get otpMaxDigits;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String fieldRequired(String fieldName);

  /// No description provided for @doNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'DO Number is required'**
  String get doNumberRequired;

  /// No description provided for @doNumberOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'DO Number must contain only numbers'**
  String get doNumberOnlyNumbers;

  /// No description provided for @sampleCodeNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Sample Code Number is required'**
  String get sampleCodeNumberRequired;

  /// No description provided for @sampleCodeNumberOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'Sample Code Number must contain only numbers'**
  String get sampleCodeNumberOnlyNumbers;

  /// No description provided for @slipNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Slip Number is required'**
  String get slipNumberRequired;

  /// No description provided for @slipNumberOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'Slip Number must contain only numbers'**
  String get slipNumberOnlyNumbers;

  /// No description provided for @numberOfSlipsRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of Slips is required'**
  String get numberOfSlipsRequired;

  /// No description provided for @numberOfSlipsOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'Number of Slips must contain only numbers'**
  String get numberOfSlipsOnlyNumbers;

  /// No description provided for @numberOfSlipsGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Number of Slips must be greater than 0'**
  String get numberOfSlipsGreaterThanZero;

  /// No description provided for @numberOfSlipsMaxFive.
  ///
  /// In en, this message translates to:
  /// **'Number of Slips must not be greater than 5'**
  String get numberOfSlipsMaxFive;

  /// No description provided for @codeNumberOnWrapperRequired.
  ///
  /// In en, this message translates to:
  /// **'Code Number on Wrapper is required'**
  String get codeNumberOnWrapperRequired;

  /// No description provided for @codeNumberOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'Code Number must contain only numbers'**
  String get codeNumberOnlyNumbers;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date is required'**
  String get dateRequired;

  /// No description provided for @dateCannotBeBeforeToday.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be before today'**
  String get dateCannotBeBeforeToday;

  /// No description provided for @dateMustBeWithinDays.
  ///
  /// In en, this message translates to:
  /// **'Date must be within the next {days} days'**
  String dateMustBeWithinDays(int days);

  /// No description provided for @senderNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Sender Name is required'**
  String get senderNameRequired;

  /// No description provided for @senderDesignationRequired.
  ///
  /// In en, this message translates to:
  /// **'Sender Designation is required'**
  String get senderDesignationRequired;

  /// No description provided for @areaRequired.
  ///
  /// In en, this message translates to:
  /// **'Area is required'**
  String get areaRequired;

  /// No description provided for @sampleCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Sample Code is required'**
  String get sampleCodeRequired;

  /// No description provided for @collectionDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Collection Date is required'**
  String get collectionDateRequired;

  /// No description provided for @placeOfCollectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Place of Collection is required'**
  String get placeOfCollectionRequired;

  /// No description provided for @sampleNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Sample Name is required'**
  String get sampleNameRequired;

  /// No description provided for @quantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required'**
  String get quantityRequired;

  /// No description provided for @articleRequired.
  ///
  /// In en, this message translates to:
  /// **'Article is required'**
  String get articleRequired;

  /// No description provided for @preservativeInfoRequired.
  ///
  /// In en, this message translates to:
  /// **'Preservative info required'**
  String get preservativeInfoRequired;

  /// No description provided for @preservativeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Preservative Name required'**
  String get preservativeNameRequired;

  /// No description provided for @preservativeQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Preservative Quantity required'**
  String get preservativeQuantityRequired;

  /// No description provided for @signatureConfirmationRequired.
  ///
  /// In en, this message translates to:
  /// **'Signature confirmation required'**
  String get signatureConfirmationRequired;

  /// No description provided for @doSignatureRequired.
  ///
  /// In en, this message translates to:
  /// **'DO Signature required'**
  String get doSignatureRequired;

  /// No description provided for @sealImpressionRequired.
  ///
  /// In en, this message translates to:
  /// **'Seal Impression is required'**
  String get sealImpressionRequired;

  /// No description provided for @formVICheckRequired.
  ///
  /// In en, this message translates to:
  /// **'Form VI check required'**
  String get formVICheckRequired;

  /// No description provided for @wrapperCheckRequired.
  ///
  /// In en, this message translates to:
  /// **'Wrapper check required'**
  String get wrapperCheckRequired;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
