import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Screens/FORM6/bloc/Form6Bloc.dart';
import '../../l10n/app_localizations.dart';

class Validators {
  static String? validateUsername(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.usernameRequired;
    }
    return null;
  }
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.emailInvalid;
    }
    return null;
  }
  static String? validateOldPassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.oldPasswordRequired;
    }
    return null;
  }

  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.nameRequired;
    }
    return null;
  }
  static String? validateOTP(BuildContext context, String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.otpRequired;
    } else if (value.trim().length != length) {
      return AppLocalizations.of(context)!.otpMustBeDigits(length);
    } else if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.otpOnlyDigits;
    }
    return null;
  }

  static String? validateCaptcha(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.captchaRequired;
    }
    return null;
  }

  static String? validateCountry(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.countryRequired;
    }
    return null;
  }

  static String? validateState(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.stateRequired;
    }
    return null;
  }

  static String? validateDistrict(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.districtRequired;
    }
    return null;
  }

  static String? validateDivision(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.divisionRequired;
    }
    return null;
  }

  static String? validateRegion(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.regionRequired;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < 8) {
      return AppLocalizations.of(context)!.passwordMinLength;
    }
    return null;
  }



  static String? validateMobileNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.mobileRequired;
    }
    if (value.length != 10) {
      return AppLocalizations.of(context)!.mobileExactDigits;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return AppLocalizations.of(context)!.mobileOnlyDigits;
    }
    return null;
  }

  static String? validateOtp(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.otpRequired;
    }
    if (value.length > 6) {
      return AppLocalizations.of(context)!.otpMaxDigits;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return AppLocalizations.of(context)!.otpOnlyDigits;
    }
    return null;
  }

  static String? validateConfirmPassword(BuildContext context, String? value, String? newPassword) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.confirmPasswordRequired;
    }
    if (newPassword != null && value != newPassword) {
      return AppLocalizations.of(context)!.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateEmptyField(BuildContext context, String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired(fieldName);
    }
    return null;
  }

  static String? validateDONumber(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.doNumberRequired;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.doNumberOnlyNumbers;
    }
    return null;
  }

  static String? validateSampleCodeNumber(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.sampleCodeNumberRequired;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.sampleCodeNumberOnlyNumbers;
    }
    return null;
  }

  static String? validateSlipNumber(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.slipNumberRequired;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.slipNumberOnlyNumbers;
    }
    return null;
  }

  static String? validateNumberOfSeals(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.numberOfSlipsRequired;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.numberOfSlipsOnlyNumbers;
    }
    int? number = int.tryParse(value.trim());
    if (number != null && number <= 0) {
      return AppLocalizations.of(context)!.numberOfSlipsGreaterThanZero;
    } else if (number != null && number > 5) {
      return AppLocalizations.of(context)!.numberOfSlipsMaxFive;
    }
    return null;
  }

  static String? validateCodeNumberOnWrapper(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.codeNumberOnWrapperRequired;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.codeNumberOnlyNumbers;
    }
    return null;
  }

  static List<TextInputFormatter> getNumberOnlyInputFormatters() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(20),
    ];
  }

  static List<TextInputFormatter> getNumberInputFormatters({int? maxLength}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
  }

  static String? validateDateInRange(
      BuildContext context,
      DateTime? value, {
        int minDaysFromToday = 0,
        int maxDaysFromToday = 30,
      }) {
    if (value == null) {
      return AppLocalizations.of(context)!.dateRequired;
    }

    final DateTime today = DateTime.now();
    final DateTime start = DateTime(today.year, today.month, today.day).add(Duration(days: minDaysFromToday));
    final DateTime end = DateTime(today.year, today.month, today.day).add(Duration(days: maxDaysFromToday));
    final DateTime candidate = DateTime(value.year, value.month, value.day);

    if (candidate.isBefore(start)) {
      return AppLocalizations.of(context)!.dateCannotBeBeforeToday;
    }
    if (candidate.isAfter(end)) {
      return AppLocalizations.of(context)!.dateMustBeWithinDays(maxDaysFromToday);
    }
    return null;
  }
}

class Form6Validators {
  static Map<String, String?> validateStep(BuildContext context, List<String> fieldNames, SampleFormState state) {
    final Map<String, String?> errors = {};
    for (final field in fieldNames) {
      switch (field) {
        case 'senderName':
          errors[field] = state.senderName.isEmpty ? AppLocalizations.of(context)!.senderNameRequired : null;
          break;
        case 'DONumber':
          errors[field] = Validators.validateDONumber(context, state.DONumber);
          break;
        case 'senderDesignation':
          errors[field] = state.senderDesignation.isEmpty ? AppLocalizations.of(context)!.senderDesignationRequired : null;
          break;
        case 'district':
          errors[field] = state.district.isEmpty ? AppLocalizations.of(context)!.districtRequired : null;
          break;
        case 'region':
          errors[field] = state.region.isEmpty ? AppLocalizations.of(context)!.regionRequired : null;
          break;
        case 'division':
          errors[field] = state.division.isEmpty ? AppLocalizations.of(context)!.divisionRequired : null;
          break;
        case 'area':
          errors[field] = state.area.isEmpty ? AppLocalizations.of(context)!.areaRequired : null;
          break;
        case 'sampleCodeData':
          errors[field] = state.sampleCodeData.isEmpty ? AppLocalizations.of(context)!.sampleCodeRequired : null;
          break;
        case 'collectionDate':
          errors[field] = state.collectionDate == null ? AppLocalizations.of(context)!.collectionDateRequired : null;
          break;

        case 'SampleName':
          errors[field] = state.SampleName.isEmpty ? AppLocalizations.of(context)!.sampleNameRequired : null;
          break;
        case 'QuantitySample':
          errors[field] = state.QuantitySample.isEmpty ? AppLocalizations.of(context)!.quantityRequired : null;
          break;

        case 'preservativeAdded':
          errors[field] = state.preservativeAdded == null ? AppLocalizations.of(context)!.preservativeInfoRequired : null;
          break;
        case 'preservativeName':
          errors[field] = state.preservativeAdded == true && state.preservativeName.isEmpty
              ? AppLocalizations.of(context)!.preservativeNameRequired : null;
          break;
        case 'preservativeQuantity':
          errors[field] = state.preservativeAdded == true && state.preservativeQuantity.isEmpty
              ? AppLocalizations.of(context)!.preservativeQuantityRequired : null;
          break;
        case 'personSignature':
          errors[field] = state.personSignature == null ? AppLocalizations.of(context)!.signatureConfirmationRequired : null;
          break;
        case 'DOSignature':
          errors[field] = state.DOSignature == null ? AppLocalizations.of(context)!.doSignatureRequired : null;
          break;
        case 'sampleCodeNumber':
          errors[field] = Validators.validateSampleCodeNumber(context, state.sampleCodeNumber);
          break;
        case 'sealImpression':
          errors[field] = state.sealImpression == null ? AppLocalizations.of(context)!.sealImpressionRequired : null;
          break;
        case 'numberofSeal':
          errors[field] = Validators.validateNumberOfSeals(context, state.numberofSeal);
          break;
        case 'formVI':
          errors[field] = state.formVI == null ? AppLocalizations.of(context)!.formVICheckRequired : null;
          break;
        case 'FoemVIWrapper':
          errors[field] = state.FoemVIWrapper == null ? AppLocalizations.of(context)!.wrapperCheckRequired : null;
          break;
        default:
          errors[field] = null;
      }
    }
    return errors;
  }
}