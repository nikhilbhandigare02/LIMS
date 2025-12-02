import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_inspector/core/utils/enums.dart';
import 'package:food_inspector/common/ApiResponse.dart';
import 'package:food_inspector/Screens/ReportGeneratedSamples/model/generated_report.dart';
import 'package:food_inspector/Screens/ReportGeneratedSamples/bloc/generated_reports_bloc.dart';
import 'package:food_inspector/Screens/ReportGeneratedSamples/repository/generated_reports_repository.dart';

class FinalReports extends StatefulWidget {
  const FinalReports({super.key});

  @override
  State<FinalReports> createState() => _FinalReportsState();
}

class _FinalReportsState extends State<FinalReports> {
  late final GeneratedReportsBloc _bloc;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _bloc = GeneratedReportsBloc(repository: GeneratedReportsRepository());
    _bloc.add(const FetchGeneratedReportsRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppHeader(
          screenTitle: "Testing Reports",
          showBack: true,
        ),
        body: BlocBuilder<GeneratedReportsBloc, GeneratedReportsState>(
          builder: (context, state) {
            final ApiResponse<GeneratedReportsEnvelope> resp = state.reports;
            switch (resp.status) {
              case Status.loading:
                return const Center(child: CircularProgressIndicator());
              case Status.complete:
                final envelope = resp.data;
                final List<GeneratedReport> items = envelope?.reportList ?? const <GeneratedReport>[];
                if (items.isEmpty) return _buildEmptyState();
                final List<GeneratedReport> filtered = _applyFilter(items, _query);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _query = val.trim()),
                        decoration: InputDecoration(
                          hintText: 'Search by any field',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                            icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _buildReportCard(filtered[index], index + 1);
                        },
                      ),
                    ),
                  ],
                );
              case Status.error:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEmptyState(),
                        const SizedBox(height: 16),
                        Text(
                          resp.message ?? 'Failed to load reports',
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _bloc.add(const FetchGeneratedReportsRequested()),
                          child: const Text('Retry'),
                        )
                      ],
                    ),
                  ),
                );
              default:
                return _buildEmptyState();
            }
          },
        ),
      ),
    );
  }

  Widget _buildReportCard(GeneratedReport report, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '#$index',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Content Area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filename
                  Text(
                    report.report_filename.isNotEmpty ? report.report_filename : 'Not Available',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // Report Details in compact format
                  _buildCompactInfo('Serial No', report.serialNo.isNotEmpty ? report.serialNo : 'Not Available'),
                  const SizedBox(height: 6),

                  _buildCompactInfo('Inward No', report.inwardNo.isNotEmpty ? report.inwardNo : 'Not Available'),
                  const SizedBox(height: 6),

                  _buildCompactInfo('Report No', report.reportNo.isNotEmpty ? report.reportNo : 'Not Available'),
                  const SizedBox(height: 6),

                  _buildCompactInfo('Status', report.currentStatus.isNotEmpty ? report.currentStatus : 'Not Available'),
                  const SizedBox(height: 6),

                  _buildCompactInfo('Sample', report.sampleName.isNotEmpty ? report.sampleName : 'Not Available'),
                  const SizedBox(height: 6),

                  _buildCompactInfo('Lab Name', report.labName.isNotEmpty ? report.labName : 'Not Available'),
                  const SizedBox(height: 6),

                  _buildCompactInfo('Lab Address', report.labAddress.isNotEmpty ? report.labAddress : 'Not Available'),
                  const SizedBox(height: 6),

                  _buildCompactInfo(
                      'dispatch Date',
                      report.dispatchDate?.isNotEmpty == true
                          ? _formatDate(report.dispatchDate!)
                          : 'Not Available'
                  ),

                ],
              ),
            ),

            const SizedBox(width: 12),

            // Action Buttons Column
            Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => _viewDocument(report.fileWebPath),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.visibility_outlined, size: 16),
                        SizedBox(width: 4),
                        Text('View', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => _downloadDocument(report.fileWebPath, report.report_filename),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download_outlined, size: 16),
                        SizedBox(width: 4),
                        Text('Save', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 72,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Reports Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Reports will appear here once available',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _viewDocument(String url) async {
    try {
      final cleaned = url.replaceAll('`', '').trim();
      final uri = Uri.tryParse(cleaned);
      if (uri == null) return;
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } catch (_) {}
  }

  Future<void> _downloadDocument(String url, String filename) async {
    try {
      final cleaned = url.replaceAll('`', '').trim();
      final uri = Uri.tryParse(cleaned);
      if (uri == null) return;

      // Launch URL with download mode
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      // Show download started message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloading ${filename.isNotEmpty ? filename : 'document'}...'),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download document'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  List<GeneratedReport> _applyFilter(List<GeneratedReport> items, String query) {
    if (query.isEmpty) return items;
    final q = query.toLowerCase();
    return items.where((r) {
      final buf = [
        r.serialNo,
        r.inwardNo,
        r.report_filename,
        r.reportNo,
        r.dispatchDate ?? '',
        r.labName,
        r.labAddress,
        r.sampleName,
        r.currentStatus,
        r.fileWebPath,
        r.filePath ?? '',
      ].join(' ').toLowerCase();
      return buf.contains(q);
    }).toList();
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime); // Or any other format you prefer
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }
}