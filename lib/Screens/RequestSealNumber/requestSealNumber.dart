import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:food_inspector/Screens/RequestSealNumber/bloc/request_bloc.dart';
import 'package:food_inspector/Screens/RequestSealNumber/repository/requestRepository.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import '../../core/utils/Message.dart';
import '../../core/utils/enums.dart';
import '../../core/widgets/AppHeader/AppHeader.dart';

class Requestsealnumber extends StatefulWidget {
  const Requestsealnumber({super.key});

  @override
  State<Requestsealnumber> createState() => _RequestsealnumberState();
}

class _RequestsealnumberState extends State<Requestsealnumber> {
  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
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
          screenTitle: 'Request for seal number',
          username: '',
          userId: '',
          showBack: false,
        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Request Seal Number',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Date',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? 'DD/MM/YYYY'
                              : dateFormat.format(selectedDate!),
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedDate == null ? Colors.grey : Colors.black,
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<RequestStateBloc, RequestSealState>(
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
                            // if (formkey.currentState!.validate()) {
                            //   context.read<RequestStateBloc>().add(SubmitRequestEvent());
                            // }
                            context.read<RequestStateBloc>().add(SubmitRequestEvent());
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
                            'Send Request',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
