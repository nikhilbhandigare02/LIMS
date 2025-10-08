import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/l10n/app_localizations.dart';
import 'package:food_inspector/Screens/ForgotScreen/repository/ForgotPasswordRepository.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/utils/Message.dart';
import '../../../core/utils/footer.dart';
import '../../../core/widgets/RegistrationInput/CustomTextField.dart';
import '../../../core/utils/validators.dart';
import '../BLOC/ForgotPasswordBloc.dart';
import '../../../core/utils/enums.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(forgotPasswordRepository: ForgotPasswordRepository()),   // ✅ provide the bloc here
      child: const _ResetPasswordView(),
    );
  }
}
final _formKey = GlobalKey<FormState>();

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView({super.key});

  void _onSubmit(BuildContext context) {
    final state = context.read<ForgotPasswordBloc>().state;



    if (state.newPassword != state.confirmPassword) {
      final l10n = AppLocalizations.of(context);
      final msg = l10n != null ? l10n.error : 'Error';
      Message.showTopRightOverlay(context, msg, MessageType.error);
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordBloc>().add(SubmitResetPasswordEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.grey100,
      body: SafeArea(
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            String _localizedMessage(String msg) {
              final l10n = AppLocalizations.of(context);
              if (l10n == null || msg.isEmpty) return msg;
              if (msg == 'No response from server') return l10n.serverNoResponse;
              if (msg.startsWith('Something went wrong:')) {
                final idx = msg.indexOf(':');
                final err = idx != -1 && idx + 1 < msg.length ? msg.substring(idx + 1).trim() : '';
                return l10n.somethingWentWrong(err);
              }
              if (msg == 'Failed to decrypt server response.') return l10n.error;
              if (msg == 'Password Changed successfully') return l10n.success;
              return msg;
            }
            if (state.apiStatus == ApiStatus.success) {
              Message.showTopRightOverlay(
                context,
                _localizedMessage(state.message),
                MessageType.success,
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.loginScreen, (route) => false);
              });
            } else if (state.apiStatus == ApiStatus.error) {
              Message.showTopRightOverlay(
                context,
                _localizedMessage(state.message),
                MessageType.error,
              );
            }
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 20),
              // Header with back button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios, color: customColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          (AppLocalizations.of(context)?.updatePass) ?? 'Reset Password',
                          style: const TextStyle(
                            color: customColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Decorative avatar
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 70,
                      backgroundColor: customColors.lightGreyCircle,
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: customColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: customColors.primary,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: customColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: customColors.shadowGrey08,
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          // New Password
                          CustomTextField(
                            label: (AppLocalizations.of(context)?.newPass) ?? 'New Password',
                            icon: Icons.lock,
                            obscureText: true,
                            isPassword: true,
                            validator: Validators.validatePassword,
                            onChanged: (value) {
                              context.read<ForgotPasswordBloc>().add(
                                NewForgotPassEvent(newPassword: value),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            label: 'Confirm Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            isPassword: true,
                            validator: (value) =>
                                Validators.validateConfirmPassword(
                                    value, state.newPassword),
                            onChanged: (value) {
                              context.read<ForgotPasswordBloc>().add(
                                ConfirmForgotPassEvent(
                                    confirmPassword: value),
                              );
                            },
                          ),
                          const SizedBox(height: 25),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 18),
                                elevation: 0,
                              ),
                              onPressed: () => _onSubmit(context),
                              child: state.apiStatus == ApiStatus.loading
                                  ? const CircularProgressIndicator(
                                color: customColors.white,
                              )
                                  : Text(
                                (AppLocalizations.of(context)?.updatePass) ?? 'Reset Password',
                                style: const TextStyle(
                                  color: customColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Back to login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Remember your password? ",
                                style: TextStyle(color: customColors.black87),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteName.loginScreen,
                                        (route) => false,
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: customColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Footer(),
                        ],

                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

