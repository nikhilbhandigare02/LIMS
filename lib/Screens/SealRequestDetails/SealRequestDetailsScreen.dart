import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'dart:collection';
import '../../core/widgets/AppHeader/AppHeader.dart';
import '../../common/ApiResponse.dart';
import '../../core/utils/enums.dart';
import 'bloc/SealRequestBloc.dart';
import 'model/SealRequestModel.dart';
import '../RequestSealNumber/repository/requestRepository.dart';

class SealRequestDetailsScreen extends StatefulWidget {
  const SealRequestDetailsScreen({super.key});

  @override
  State<SealRequestDetailsScreen> createState() => _SealRequestDetailsScreenState();
}

class _SealRequestDetailsScreenState extends State<SealRequestDetailsScreen> {
  void _showUpdateCountDialog(BuildContext context, num requestId, List<Data> group) {
    final TextEditingController countController = TextEditingController();
    final currentTotalCount = group.fold<num>(0, (sum, e) => sum + (e.count ?? 0));
    countController.text = currentTotalCount.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel',style: TextStyle(color: Colors.blue),),
            ),
            ElevatedButton(
              onPressed: () {
                final newCount = int.tryParse(countController.text);
                if (newCount != null && newCount > 0) {
                  print('Updating count for Request ID $requestId to $newCount');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Count updated to $newCount')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid count')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.blue),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                minimumSize: const Size(100, 48),
              ),
              child: const Text('Update Count',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SealRequestBloc>(
      create: (_) => SealRequestBloc(requestedSealRepository: RequestedSealRepository())
        ..add(const getRequestDataEvent(userId: 0)),
      child: Scaffold(
        appBar: AppHeader(
          screenTitle: 'seal number info',
          username: '',
          userId: '',
          showBack: true,
        ),
        body: BlocBuilder<SealRequestBloc, SealRequestState>(
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
                final dateText = first.sealRequestDate ?? '';
                final totalCount = group.fold<num>(0, (sum, e) => sum + (e.count ?? 0));

                final sealNumbers = subtitle == 'Seal number has been sent to FSO'
                    ? group.map((e) => e.sealNumber ?? '-').toList()
                    : [];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (subtitle == 'Request for a seal number')
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: IconButton(
                                  onPressed: () => _showUpdateCountDialog(context, reqId, group),
                                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                                  tooltip: 'Update Count',
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Requested Date :",
                                style: TextStyle(color: customColors.grey, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 3, // right side bigger (value)
                              child: Text(
                                dateText,
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
                                style: TextStyle(color: customColors.grey, fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                first.sealSendDate?.toString() ?? 'N/A',
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
                          style: const TextStyle(fontWeight: FontWeight.w600, color: customColors.grey),
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        if (sealNumbers.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: sealNumbers.map((seal) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
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