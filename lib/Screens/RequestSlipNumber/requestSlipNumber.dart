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



  Future<void> _pickDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? today,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year, today.month, today.day).add(
        const Duration(days: _maxDaysAhead),
      ),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateError = null;
      });

      final String apiDate = DateFormat("dd/MM/yyyy HH:mm:ss").format(
        DateTime(picked.year, picked.month, picked.day, 0, 0, 0),
      );

      context.read<RequestStateBloc>().add(RequestDateEvent(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestStateBloc>(
      create: (_) => RequestStateBloc(
        requestedSealRepository: RequestedSealRepository(),
      ),
      child: Scaffold(
        appBar: AppHeader(
          screenTitle: 'Request for slip number',

          showBack: false,
        ),
        drawer: CustomDrawer(),

        body: BlocListener<RequestStateBloc, RequestSealState>(
          listener: (context, state) async {
            switch (state.apiStatus) {
              case ApiStatus.loading:
                Message.showTopRightOverlay(
                  context,
                  'Loading...',
                  MessageType.info,
                );
                break;
              case ApiStatus.success:
                Message.showTopRightOverlay(
                  context,
                  state.message,
                  MessageType.success,
                );
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
                      SizedBox(height: 15,),
                      Text(
                        'Request for a slip number on ${dateFormat.format(selectedDate)}', // always shows current date
                        style: const TextStyle(
                          fontSize: 16,
                          color: customColors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Enter count',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter slip number count',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:  BorderSide(color: customColors.primary), // default
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:  BorderSide(color: customColors.primary, width: 0.8), // blue when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:  BorderSide(color: customColors.primary, width: 0.8), // blue when focused
                          ),
                        ),
                        validator: (value) => Validators.validateNumberOfSeals(value),
                        onChanged: (value) {
                          context.read<RequestStateBloc>().add(RequestCountEvent(value));
                        },
                      ),
                      const SizedBox(height: 8),
                      // const Text(
                      //   'Select Date',
                      //   style: TextStyle(fontSize: 16),
                      // ),
                      // const SizedBox(height: 8),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: _dateError == null ? customColors.primary : Colors.red),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         selectedDate == null
                      //             ? 'DD/MM/YYYY'
                      //             : dateFormat.format(selectedDate!),
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           color: selectedDate == null ? Colors.grey : Colors.black,
                      //         ),
                      //       ),
                      //       const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                      //     ],
                      //   ),
                      // ),


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
                              selectedDate,
                              minDaysFromToday: 0,
                              maxDaysFromToday: _maxDaysAhead,
                            );
                            setState(() {
                              _dateError = dateValidation;
                            });

                            if (_formKey.currentState?.validate() == true && dateValidation == null) {
                              if (selectedDate != null) {
                                final DateTime normalized = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, 0, 0, 0);
                                context.read<RequestStateBloc>().add(RequestDateEvent(normalized));
                              }
                              context.read<RequestStateBloc>().add(SubmitRequestEvent());
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
                              : const Text(
                            'Send Request',
                            style: TextStyle(
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
