
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/Screens/FORM6/repository/form6Repository.dart';
import 'package:food_inspector/Screens/login/OTPVerification/View/OtpVerification.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:local_auth/local_auth.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/core/utils/Message.dart';
import 'package:food_inspector/common/device/device_id.dart';
import 'package:food_inspector/Screens/login/repository/login_log_repository.dart';
import '../../../Screens/FORM6/bloc/Form6Bloc.dart';
import '../../../Screens/FORM6/view/form6_landing_screen.dart';
import '../../../Screens/login/bloc/loginBloc.dart';
import '../../../Screens/update_password/view/UpdatePassword.dart';
class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  final VoidCallback? onLoginSuccess;
  const LoginButton({super.key, required this.formkey, this.onLoginSuccess});
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (current, previous) =>
      current.apiStatus != previous.apiStatus,
      listener: (context, state) async {
        switch (state.apiStatus) {
          case ApiStatus.loading:
            Message.showTopRightOverlay(
              context,
              'Logging in...',
              MessageType.info,
            );
            break;
          case ApiStatus.success:
            Message.showTopRightOverlay(
              context,
              state.message,
              MessageType.success,
            );
            await Future.delayed(const Duration(seconds: 1));
            final secureStorage = FlutterSecureStorage();
            final loginDataStr = await secureStorage.read(key: 'loginData');
            int passResetFlag = 0;
            if (loginDataStr != null) {
              final loginDataMap = jsonDecode(loginDataStr) as Map<String, dynamic>;
              final passResetStr = loginDataMap['PassResetFlag'] ?? '0';
              passResetFlag = int.tryParse(passResetStr.toString()) ?? 0;
            }
            // Fire-and-forget login log (password method)
            try {
              final String? userId = await secureStorage.read(key: 'user_id');
              final deviceId = await DeviceIdProvider.getDeviceId();
              if (userId != null && userId.isNotEmpty) {
                final repo = LoginLogRepository();
                // do not await to avoid blocking navigation
                // ignore: unawaited_futures
                repo.logUserLogin(body: {
                  'user_id': userId,
                  'device_id': deviceId,
                });
              }
            } catch (_) {}
            if (passResetFlag == 0) {
              Navigator.pushNamed(context, RouteName.updateScreen);
            } else if (passResetFlag == 1) {
              // Decide based on isLogin flag for first-time post-login flow
              final String? isLogin = await secureStorage.read(key: 'isLogin');
              if (isLogin != '1') {
                bool canCheck = false;
                bool supported = false;
                try {
                  final localAuth = LocalAuthentication();
                  canCheck = await localAuth.canCheckBiometrics;
                  supported = await localAuth.isDeviceSupported();
                } catch (_) {}
                if (canCheck && supported) {
                  Navigator.pushReplacementNamed(context, RouteName.biometricOptInScreen);
                } else {
                  await secureStorage.write(key: 'isLogin', value: '1');
                  Navigator.pushReplacementNamed(context, RouteName.SampleAnalysisScreen);
                }
              } else {
                Navigator.pushReplacementNamed(context, RouteName.SampleAnalysisScreen);
              }
            } else {
              Navigator.pushReplacementNamed(context, RouteName.loginScreen);
            }
            break;
          case ApiStatus.error:
            Message.showTopRightOverlay(
              context,
              state.message,
              MessageType.error,
            );
            break;
          default:
            break;
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (current, previous) => current.apiStatus != previous.apiStatus,
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              onPressed: state.apiStatus == ApiStatus.loading
                  ? null
                  : () {
                if (formkey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginButtonEvent());
                }
                onLoginSuccess?.call();
              },
              child: state.apiStatus == ApiStatus.loading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(

                'SIGN IN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

