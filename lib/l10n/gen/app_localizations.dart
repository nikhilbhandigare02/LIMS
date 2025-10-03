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
/// import 'gen/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('hi'),
    Locale('mr'),
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

  /// No description provided for @missingFields.
  ///
  /// In en, this message translates to:
  /// **'Missing serial number or user id'**
  String get missingFields;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
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
  /// **'Collection Place'**
  String get collectionPlace;

  /// No description provided for @sampleName.
  ///
  /// In en, this message translates to:
  /// **'Sample Name'**
  String get sampleName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @preservativeDetails.
  ///
  /// In en, this message translates to:
  /// **'Preservative Details'**
  String get preservativeDetails;

  /// No description provided for @preservativeAdded.
  ///
  /// In en, this message translates to:
  /// **'Preservative Added'**
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
  /// **'Witness Signature'**
  String get witnessSignature;

  /// No description provided for @doSignature.
  ///
  /// In en, this message translates to:
  /// **'DO Signature'**
  String get doSignature;

  /// No description provided for @sealImpression.
  ///
  /// In en, this message translates to:
  /// **'Seal Impression'**
  String get sealImpression;

  /// No description provided for @sealNumber.
  ///
  /// In en, this message translates to:
  /// **'Seal Number'**
  String get sealNumber;

  /// No description provided for @formViDetails.
  ///
  /// In en, this message translates to:
  /// **'Form VI Details'**
  String get formViDetails;

  /// No description provided for @memoFormVi.
  ///
  /// In en, this message translates to:
  /// **'Memo Form VI'**
  String get memoFormVi;

  /// No description provided for @insideWrapper.
  ///
  /// In en, this message translates to:
  /// **'Inside Wrapper'**
  String get insideWrapper;

  /// No description provided for @wrapperCode.
  ///
  /// In en, this message translates to:
  /// **'Wrapper Code'**
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
