import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:intl/intl.dart';
import 'dart:collection';
import '../../core/utils/Message.dart';
import '../../core/widgets/AppDrawer/Drawer.dart';
import '../../core/widgets/AppHeader/AppHeader.dart';
import '../../common/ApiResponse.dart';
import '../../core/utils/enums.dart';
import 'bloc/SlipRequestBloc.dart';
import 'model/SlipRequestModel.dart';
import '../RequestSlipNumber/repository/requestRepository.dart';

class SealRequestDetailsScreen extends StatefulWidget {
  const SealRequestDetailsScreen({super.key});

  @override
  State<SealRequestDetailsScreen> createState() => _SealRequestDetailsScreenState();
}

class _SealRequestDetailsScreenState extends State<SealRequestDetailsScreen> {
  void _showUpdateCountDialog(
      BuildContext context, num requestId, List<Data> group) {
    final TextEditingController countController = TextEditingController();
    final currentTotalCount =
    group.fold<num>(0, (sum, e) => sum + (e.count ?? 0));
    countController.text = currentTotalCount.toString();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return BlocProvider.value(
          value: context.read<SlipRequestBloc>(),
          child: AlertDialog(
            backgroundColor: customColors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text('Update Count - Request ID: $requestId'),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current total count: $currentTotalCount'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: countController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'New Count',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: customColors.primary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newCount = int.tryParse(countController.text);

                  if (newCount == null || newCount <= 0) {
                    Message.showTopRightOverlay(
                      context,
                      'Please enter a valid count',
                      MessageType.error,
                    );
                    return;
                  }

                  if (newCount > 5) {
                    Message.showTopRightOverlay(
                      context,
                      'Count cannot be more than 5',
                      MessageType.error,
                    );
                    return;
                  }

                  // ✅ Valid count (1–5), proceed
                  context.read<SlipRequestBloc>().add(
                    updateSlipCountEvent(
                      requestId: requestId as int,
                      newCount: newCount,
                    ),
                  );
                  Navigator.of(dialogCtx).pop();
                  Message.showTopRightOverlay(
                    context,
                    'Slip number count updated to $newCount',
                    MessageType.success,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: customColors.primary),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  minimumSize: const Size(100, 48),
                ),
                child: const Text(
                  'Update Count',
                  style: TextStyle(color: customColors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<SlipRequestBloc>(
      create: (_) => SlipRequestBloc(
        requestedSealRepository: RequestedSealRepository(),
      )..add(const getRequestDataEvent(userId: 0)),

      child: Scaffold(
        backgroundColor: customColors.white,
        appBar: AppHeader(
          screenTitle: 'slip number info',
          // username: '',

          showBack: false,
        ),
        drawer: CustomDrawer(),

        body: BlocBuilder<SlipRequestBloc, SlipRequestState>(
          builder: (context, state) {
            final resp = state.fetchRequestData;
            if (resp.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (resp.status == Status.error) {
              return Center(child: Text(resp.message ?? 'Failed to load'));
            }
            final SealRequestModel? model = resp.data as SealRequestModel?;
            final List<Data> items = model?.data ?? [];
            if (items.isEmpty) {
              return const Center(child: Text('No requests found'));
            }

            // Group by request_id
            final Map<num, List<Data>> grouped = <num, List<Data>>{};
            for (final d in items) {
              final key = d.requestId ?? -1;
              grouped.putIfAbsent(key, () => <Data>[]).add(d);
            }

            final entries = grouped.entries.toList()
              ..sort((a, b) => (b.key).compareTo(a.key));

             return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final reqId = entry.key;
                final group = entry.value;
                final first = group.first;

                final title = 'Request ID: ${reqId.toString()}';
                final subtitle = first.status ?? '';
                final dateText = first.slipRequestDate ?? '';
                final totalCount =
                group.fold<num>(0, (sum, e) => sum + (e.count ?? 0));

                // ✅ Use statusID instead of raw text compare
                final sealNumbers = first.status_ID == 31
                    ? group.map((e) => e.slipNumber ?? '-').toList()
                    : [];

                final DateFormat inputFormat = DateFormat('M/d/yyyy h:mm:ss a');
                final DateFormat outputFormat = DateFormat('dd/MM/yyyy');

                String formatDate(String? dateStr) {
                  if (dateStr == null || dateStr.isEmpty) return 'N/A';
                  try {
                    final DateTime parsed = inputFormat.parse(dateStr);
                    return outputFormat.format(parsed);
                  } catch (_) {
                    return 'N/A';
                  }
                }

                final String requestedDateText = formatDate(first.slipRequestDate);
                final String sendDateText = formatDate(first.slipSendDate);

                return Card(
                  color: customColors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (first.status_ID == 30)
                              Container(
                                decoration: BoxDecoration(
                                  color: customColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: customColors.primary.withOpacity(0.2)),
                                ),
                                child: IconButton(
                                  onPressed: () => _showUpdateCountDialog(
                                      context, reqId, group),
                                  icon: const Icon(Icons.edit,
                                      size: 20, color: customColors.primary),
                                  tooltip: 'Update Count',
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(subtitle,
                            style: TextStyle(color: customColors.grey600)),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Requested Date :",
                                style: TextStyle(
                                    color: customColors.grey, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                requestedDateText,
                                style: TextStyle(
                                  color: customColors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Send Date :",
                                style: TextStyle(
                                    color: customColors.grey, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                sendDateText,
                                style: TextStyle(
                                  color: customColors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Slip Numbers: $totalCount',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: customColors.grey),
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // ✅ Show slip numbers only if status_ID = 31
                        if (sealNumbers.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: sealNumbers.map((seal) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: customColors.grey100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: customColors.grey300),
                                ),
                                child: Text(seal),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );

          },
        ),
      ),
    );
  }
}
