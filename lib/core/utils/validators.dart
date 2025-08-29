import 'package:flutter/services.dart';
import '../../Screens/FORM6/bloc/Form6Bloc.dart';

class Validators {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    return null;
  }

  static String? validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Old password is required';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    return null;
  }

  static String? validateOTP(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    } else if (value.trim().length != length) {
      return 'OTP must be $length digits';
    } else if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'OTP must contain only digits';
    }
    return null; // valid
  }

  static String? validateCaptcha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Captcha is required';
    }
    // Captcha correctness is validated inside CaptchaWidget where the generated code is available
    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Country is required';
    }

    return null;
  }

  static String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State is required';
    }

    return null;
  }

  static String? validateDistrict(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'District is required';
    }

    return null;
  }

  static String? validateDivision(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Division is required';
    }
    return null;
  }

  static String? validateRegion(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Region is required';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Basic email format regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }

    if (value.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }

    // Check if it contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must contain only digits';
    }

    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length > 6) {
      return 'OTP cannot be more than 6 digits';
    }

    // Check if it contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? newPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (newPassword != null && value != newPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? validateEmptyField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateDONumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'DO Number is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'DO Number must contain only numbers';
    }

    return null;
  }

  static String? validateSampleCodeNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Sample Code Number is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Sample Code Number must contain only numbers';
    }

    return null;
  }

  static String? validateSlipNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Slip Number is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Slip Number must contain only numbers';
    }

    return null;
  }

  static String? validateNumberOfSeals(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Number of Seals is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Number of Seals must contain only numbers';
    }

    int? number = int.tryParse(value.trim());
    if (number != null && number <= 0) {
      return 'Number of Seals must be greater than 0';
    }

    return null;
  }

  static String? validateCodeNumberOnWrapper(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Code Number on Wrapper is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Code Number must contain only numbers';
    }

    return null;
  }

  // Input formatter to allow only numbers
  static List<TextInputFormatter> getNumberOnlyInputFormatters() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(20), // Adjust max length as needed
    ];
  }

  // Input formatter for specific field length limits
  static List<TextInputFormatter> getNumberInputFormatters({int? maxLength}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
  }
}

class Form6Validators {
  static Map<String, String?> validateStep(List<String> fieldNames, SampleFormState state) {
    final Map<String, String?> errors = {};

    for (final field in fieldNames) {
      switch (field) {
        case 'senderName':
          errors[field] = state.senderName.isEmpty ? 'Sender Name is required' : null;
          break;
        case 'DONumber':
          errors[field] = Validators.validateDONumber(state.DONumber);
          break;
        case 'senderDesignation':
          errors[field] = state.senderDesignation.isEmpty ? 'Sender Designation is required' : null;
          break;
        case 'district':
          errors[field] = state.district.isEmpty ? 'District is required' : null;
          break;
        case 'region':
          errors[field] = state.region.isEmpty ? 'Region is required' : null;
          break;
        case 'division':
          errors[field] = state.division.isEmpty ? 'Division is required' : null;
          break;
        case 'area':
          errors[field] = state.area.isEmpty ? 'Area is required' : null;
          break;
        case 'sampleCodeData':
          errors[field] = state.sampleCodeData.isEmpty ? 'Sample Code is required' : null;
          break;
        case 'collectionDate':
          errors[field] = state.collectionDate == null ? 'Collection Date is required' : null;
          break;
        case 'placeOfCollection':
          errors[field] = state.placeOfCollection.isEmpty ? 'Place of Collection is required' : null;
          break;
        case 'SampleName':
          errors[field] = state.SampleName.isEmpty ? 'Sample Name is required' : null;
          break;
        case 'QuantitySample':
          errors[field] = state.QuantitySample.isEmpty ? 'Quantity is required' : null;
          break;
        case 'article':
          errors[field] = state.article.isEmpty ? 'Article is required' : null;
          break;
        case 'preservativeAdded':
          errors[field] = state.preservativeAdded == null ? 'Preservative info required' : null;
          break;
        case 'preservativeName':
          errors[field] = state.preservativeAdded == true && state.preservativeName.isEmpty
              ? 'Preservative Name required' : null;
          break;
        case 'preservativeQuantity':
          errors[field] = state.preservativeAdded == true && state.preservativeQuantity.isEmpty
              ? 'Preservative Quantity required' : null;
          break;
        case 'personSignature':
          errors[field] = state.personSignature == null ? 'Signature confirmation required' : null;
          break;
        case 'slipNumber':
          errors[field] = Validators.validateSlipNumber(state.slipNumber);
          break;
        case 'DOSignature':
          errors[field] = state.DOSignature == null ? 'DO Signature required' : null;
          break;
        case 'sampleCodeNumber':
          errors[field] = Validators.validateSampleCodeNumber(state.sampleCodeNumber);
          break;
        case 'sealImpression':
          errors[field] = state.sealImpression == null ? 'Seal Impression is required' : null;
          break;
        case 'numberofSeal':
          errors[field] = Validators.validateNumberOfSeals(state.numberofSeal);
          break;
        case 'formVI':
          errors[field] = state.formVI == null ? 'Form VI check required' : null;
          break;
        case 'FoemVIWrapper':
          errors[field] = state.FoemVIWrapper == null ? 'Wrapper check required' : null;
          break;
        default:
          errors[field] = null;
      }
    }

    return errors;
  }
}