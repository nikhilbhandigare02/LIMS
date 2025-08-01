class ForgotPasswordRepository {
  Future<bool> sendOtp(String mobileNumber) async {


    await Future.delayed(const Duration(seconds: 2));
    

    return true;
  }
  
  Future<bool> verifyOtp(String mobileNumber, String otp) async {

    await Future.delayed(const Duration(seconds: 1));

    return true;
  }
} 