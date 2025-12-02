import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_inspector/core/widgets/RegistrationInput/CustomTextField.dart';
import 'package:intl/intl.dart';
import 'package:food_inspector/Screens/RequestSlipNumber/bloc/request_bloc.dart';
import 'package:food_inspector/Screens/RequestSlipNumber/repository/requestRepository.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import '../../core/utils/Message.dart';
import '../../core/utils/enums.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/AppDrawer/Drawer.dart';
import '../../core/widgets/AppHeader/AppHeader.dart';
import '../../l10n/app_localizations.dart';

class Requestslipnumber extends StatefulWidget {
  const Requestslipnumber({super.key});

  @override
  State<Requestslipnumber> createState() => _RequestslipnumberState();
}

class _RequestslipnumberState extends State<Requestslipnumber> {
  DateTime selectedDate = DateTime.now(); // default = current date
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _dateError;
  static const int _maxDaysAhead = 30;

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();
    selectedDate = DateTime(today.year, today.month, today.day, 0, 0, 0);
    _dateError = null;
  }

  static String? validateDateInRange(
      BuildContext context,
      DateTime? selectedDate, {
        int minDaysFromToday = 0,
        int maxDaysFromToday = 30,
      }) {
    if (selectedDate == null) {
      return AppLocalizations.of(context)!.dateRequired;
    }

    final now = DateTime.now();
    final minDate = now.add(Duration(days: minDaysFromToday));
    final maxDate = now.add(Duration(days: maxDaysFromToday));



    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestStateBloc>(
      create: (_) =>
          RequestStateBloc(requestedSealRepository: RequestedSealRepository()),
      child: Scaffold(
        appBar: AppHeader(
          screenTitle: AppLocalizations.of(context)!.requestForSlipNumber,

          showBack: false,
        ),
        drawer: CustomDrawer(),

        body: BlocListener<RequestStateBloc, RequestSealState>(
          listener: (context, state) async {
            switch (state.apiStatus) {
              case ApiStatus.loading:
                Message.showTopRightOverlay(
                  context,
                  AppLocalizations.of(context)!.loading,
                  MessageType.info,
                );
                break;
              case ApiStatus.success:
                Message.showTopRightOverlay(
                  context,
                  state.message,
                  MessageType.success,
                );
                await Future.delayed(const Duration(milliseconds: 500));

                if (mounted) {
                  Navigator.pop(context);
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<RequestStateBloc, RequestSealState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        '${AppLocalizations.of(context)!.requestForSlipNumber} ${dateFormat.format(selectedDate)}', // shows current date
                        style: const TextStyle(
                          fontSize: 16,
                          color: customColors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        AppLocalizations.of(context)!.enterCount,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            context,
                          )!.slipNumberCount,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: customColors.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: customColors.primary,
                              width: 0.8,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: customColors.primary,
                              width: 0.8,
                            ),
                          ),
                        ),
                        validator: (value) =>
                         Validators.validateNumberOfSeals(context, value),
                        onChanged: (value) {
                          context.read<RequestStateBloc>().add(
                            RequestCountEvent(value),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
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
                            final String? dateValidation = Validators.validateDateInRange(
                              context,
                              selectedDate,
                              minDaysFromToday: 0,
                              maxDaysFromToday: _maxDaysAhead,
                            );  ;
                                  setState(() {
                                    _dateError = dateValidation;
                                  });
                                  if (_formKey.currentState?.validate() ==
                                          true &&
                                      dateValidation == null) {
                                    final DateTime normalized = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      0,
                                      0,
                                      0,
                                    );
                                    context.read<RequestStateBloc>().add(
                                      RequestDateEvent(normalized),
                                    );
                                    context.read<RequestStateBloc>().add(
                                      SubmitRequestEvent(),
                                    );
                                  }
                                },
                          child: state.apiStatus == ApiStatus.loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: customColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.sendRequest,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: customColors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
