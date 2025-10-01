import 'package:flutter/material.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';
import 'package:food_inspector/l10n/gen/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Sample list/model/sampleData.dart';
import '../bloc/resubmit_bloc.dart';
import '../repository/resubmit_repository.dart';
import '../../../core/utils/enums.dart';
import '../../../core/utils/Message.dart';

class ResubmitSample extends StatefulWidget {
  const ResubmitSample({super.key});

  @override
  State<ResubmitSample> createState() => _ResubmitSampleState();
}

class _ResubmitSampleState extends State<ResubmitSample> {
  late ResubmitBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ResubmitBloc(repository: ResubmitRepository());
    _bloc.add(const FetchApprovedSamplesByUser());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppHeader(
          screenTitle: AppLocalizations.of(context)!.resubmitSample,
          showBack: false,
        ),
        drawer: CustomDrawer(),
        body: SafeArea(
          child: BlocListener<ResubmitBloc, ResubmitState>(
            listener: (context, state) {
              // Handle updateStatus side effects
              final status = state.updateStatus.status;
              if (status == Status.loading) {
                // show loading popup
                AppDialog.show(
                  context,
                  AppLocalizations.of(context)!.submittingRequest,
                  MessageType.info,
                );
              } else {
                // Close loading if open
                AppDialog.closePopup(context);
                if (status == Status.complete) {
                  final msg = state.updateStatus.data?.toString();
                  if (msg != null && msg.trim().isNotEmpty) {
                    Message.showTopRightOverlay(
                      context,
                      msg,
                      MessageType.success,
                      title: AppLocalizations.of(context)!.success,
                    );
                  }
                } else if (status == Status.error) {
                  final msg = state.updateStatus.message ?? '';
                  Message.showTopRightOverlay(
                    context,
                    msg.isEmpty ? AppLocalizations.of(context)!.error : msg,
                    MessageType.error,
                    title: AppLocalizations.of(context)!.error,
                  );
                }
              }
            },
            child: BlocBuilder<ResubmitBloc, ResubmitState>(
              builder: (context, state) {
                switch (state.fetchList.status) {
                  case Status.loading:
                    return const Center(child: CircularProgressIndicator());
                  case Status.complete:
                    final items = (state.fetchList.data as List<SampleList>? ?? const <SampleList>[]);
                    if (items.isEmpty) {
                      return Center(
                        child: Text(AppLocalizations.of(context)!.noSamplesToResubmit),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildCard(items[index]),
                    );
                  case Status.error:
                    final msg = state.fetchList.message?.toLowerCase() ?? '';
                    final isNotFound = msg.contains('404') || msg.contains('not found');
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          isNotFound
                              ? AppLocalizations.of(context)!.noSamplesToResubmit
                              : (state.fetchList.message ?? AppLocalizations.of(context)!.error),
                        ),
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(SampleList data) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.blue.shade50.withOpacity(0.2),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.science_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Serial: ${data.serialNo ?? '-'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            data.statusName ?? 'Unknown',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _row('Sample Sent Date', data.sampleSentDate, Icons.calendar_today_outlined),
                        _row('Sample Re-Requested Date', data.sampleReRequestedDate, Icons.update_outlined),
                        _row('Lab Location', data.labLocation, Icons.location_on_outlined),
                        //_row('User ID', data.userID?.toString(), Icons.person_outline),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final serial = data.serialNo?.toString().trim();
                      final insertedBy = data.userID;
                      if (serial == null || serial.isEmpty || insertedBy == null) {
                        Message.showTopRightOverlay(
                          context,
                          AppLocalizations.of(context)!.missingFields,
                          MessageType.error,
                          title: AppLocalizations.of(context)!.validation,
                        );
                        return;
                      }

                      await Message.showPopup(
                        context,
                        message: '${AppLocalizations.of(context)!.confirmResubmit} '+serial+'?',
                        type: MessageType.info,
                        title: AppLocalizations.of(context)!.confirmResubmit,
                        onOk: () {
                          _bloc.add(
                            UpdateStatusResubmitRequested(
                              serialNo: serial,
                              insertedBy: insertedBy.toInt(),
                            ),
                          );
                        },
                      );

                    },
                    icon: const Icon(Icons.send_rounded, size: 16,color: Colors.white,),
                    label: Text(
                      AppLocalizations.of(context)!.sendRequest,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, size: 14, color: Colors.blue.shade600),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value == null || value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}