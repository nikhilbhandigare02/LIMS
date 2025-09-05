import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

             return Card(
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
                           child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                         ),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                           decoration: BoxDecoration(
                             color: Colors.blue.shade50,
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child: Text('Total: $totalCount', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                         )
                       ],
                     ),
                     const SizedBox(height: 6),
                     Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
                     const SizedBox(height: 4),
                     Text(dateText, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                     const SizedBox(height: 10),
                     const Divider(height: 1),
                     const SizedBox(height: 8),
                     // Show seal numbers in a wrap list
                     Wrap(
                       spacing: 8,
                       runSpacing: 8,
                       children: group.map((e) {
                         final seal = e.sealNumber ?? '-';
                         final cnt = e.count?.toString() ?? '0';
                         return Container(
                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                           decoration: BoxDecoration(
                             color: Colors.grey.shade100,
                             borderRadius: BorderRadius.circular(8),
                             border: Border.all(color: Colors.grey.shade300),
                           ),
                           child: Text('$seal ($cnt)'),
                         );
                       }).toList(),
                     )
                   ],
                 ),
               ),
             );
           },
         );
       },
     ),
   ));
  }
}
