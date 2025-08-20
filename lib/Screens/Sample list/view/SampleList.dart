import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/Sample%20list/repository/sampleRepository.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import '../../../core/utils/enums.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';
import '../bloc/sampleBloc.dart';
import '../model/sampleData.dart';

class SampleAnalysisScreen extends StatefulWidget {
  @override
  _SampleAnalysisScreenState createState() => _SampleAnalysisScreenState();
}

class _SampleAnalysisScreenState extends State<SampleAnalysisScreen>
    with SingleTickerProviderStateMixin {
  bool isCardView = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late SampleBloc sampleBloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    sampleBloc = SampleBloc(sampleRepository: SampleRepository());
    sampleBloc.add(getSampleListEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    sampleBloc.close();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      isCardView = !isCardView;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Color getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    final s = status.toLowerCase().trim();

    // High-priority keywords
    if (s.contains('tampered')) return Colors.red;
    if (s.contains('decoded') && s.contains('report'))
      return Colors.indigo; // "Sample Decoded, Generate Report"
    if (s.contains('decoded')) return Colors.deepPurple; // "Sample Decoded"
    if (s.contains('dispatched') || s.contains('dispatch'))
      return Colors.teal; // "Report Dispatched", "Pending for Dispatch"
    if (s.contains('generated') && s.contains('report'))
      return Colors.blueGrey; // "Report Generated"

    // Workflow-specific
    if (s.contains('verification'))
      return Colors.blue; // Sent/Pending for Verification
    if (s.contains('coding') || s.contains('decode'))
      return Colors
          .cyan; // Sent for coding/decoding, Pending for Coding/Decoding
    if (s.contains('assignment') ||
        s.contains('allocated') ||
        s.contains('allocation'))
      return Colors.orange; // sent for assignment/allocation
    if (s.contains('analysis'))
      return Colors.green; // sent for analysis / analysis successful
    if (s.contains('received'))
      return Colors.purple; // received by courier/physically / entry successful

    // Generic fallbacks for common words
    if (s.contains('pending')) return Colors.amber;
    if (s.contains('sent')) return Colors.lightBlue;

    // Specific edge cases
    if (s == 're-requested' || s.contains('re-request'))
      return Colors.redAccent;

    return Colors.grey;
  }

  bool _isTampered(String? status) {
    if (status == null) return false;
    final s = status.toLowerCase();
    return s.contains('tampered') || s.contains('resubmit');
  }

  void _showSampleDetailsDialog(BuildContext context, SampleList data) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey[50]!],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: customColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.science,
                        color: customColors.primary,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sample Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: customColors.primary,
                            ),
                          ),
                          Text(
                            'Serial: ${data.serialNo ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Divider(height: 32, thickness: 1),

                // Details
                _buildDetailRow(
                  icon: Icons.send,
                  label: 'Sent Date',
                  value: _formatDate(data.sampleSentDate),
                  color: Colors.blue,
                ),
                SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.refresh,
                  label: 'Resent Date',
                  value: _formatDate(data.sampleResentDate),
                  color: Colors.orange,
                ),
                SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Re-requested Date',
                  value: _formatDate(data.sampleReRequestedDate),
                  color: Colors.purple,
                ),
                SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.info,
                  label: 'Status',
                  value: data.statusName ?? 'N/A',
                  color: getStatusColor(data.statusName),
                ),
                SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.location_on,
                  label: 'Lab Location',
                  value: data.labLocation ?? 'N/A',
                  color: Colors.green,
                ),

                SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isTampered(data.statusName)) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _showEditDialog(context, data);
                        },
                        icon: Icon(Icons.edit, size: 16),
                        label: Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Close'),
                      style: TextButton.styleFrom(
                        foregroundColor: customColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, SampleList data) {
    // This is a placeholder for the edit functionality
    // You can implement your edit dialog here
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Edit Sample'),
          content: Text(
            'Edit functionality for sample ${data.serialNo} will be implemented here.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sampleBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppHeader(
          screenTitle: 'Sample Analysis',
          username: 'Username',
          userId: 'UserID',
          showBack: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white24, Colors.white12],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    isCardView ? Icons.table_chart : Icons.view_agenda,
                    key: ValueKey(isCardView),
                    color: Colors.white,
                  ),
                ),
                onPressed: toggleView,
                tooltip: isCardView
                    ? 'Switch to Table View'
                    : 'Switch to Card View',
              ),
            ),
          ],
        ),
        body: BlocBuilder<SampleBloc, getSampleListState>(
          builder: (context, state) {
            switch (state.fetchSampleList.status) {
              case Status.loading:
                return Center(child: const CircularProgressIndicator());
              case Status.complete:
                if (state.fetchSampleList.data == null ||
                    state.fetchSampleList.data.isEmpty) {
                  return Center(child: Text('No Data Found'));
                }
                final sampleList =
                    state.fetchSampleList.data as List<SampleData>;
                final sampleDataList = sampleList
                    .expand((sampleData) => sampleData.sampleList ?? [])
                    .toList();
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey[50]!, Colors.grey[100]!],
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: isCardView
                        ? _buildCardView(sampleDataList.cast<SampleList>())
                        : _buildTableView(sampleDataList.cast<SampleList>()),
                  ),
                );
              case Status.error:
                return Center(
                  child: Text('Error: ${state.fetchSampleList.message}'),
                );
              default:
                return Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCardView(List<SampleList> sampleDataList) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.science, color: customColors.primary, size: 22),
                SizedBox(width: 12),
                Text(
                  'Sample Records',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: customColors.primary,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: customColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${sampleDataList.length}',
                    style: TextStyle(
                      color: customColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: sampleDataList.length,
              itemBuilder: (context, index) {
                return _buildSampleCard(sampleDataList[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleCard(SampleList data, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 6,
        shadowColor: customColors.primary.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            customColors.primary,
                            customColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Serial: ${data.serialNo}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            getStatusColor(data.statusName),
                            getStatusColor(data.statusName).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        data.statusName ?? 'Unknown',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildCompactInfoRow(
                            Icons.location_on,
                            data.labLocation ?? 'N/A',
                          ),
                          SizedBox(height: 8),
                          _buildCompactInfoRow(
                            Icons.send,
                            _formatDate(data.sampleSentDate),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildCompactInfoRow(
                            Icons.refresh,
                            _formatDate(data.sampleResentDate),
                          ),
                          SizedBox(height: 8),
                          _buildCompactInfoRow(
                            Icons.calendar_today,
                            _formatDate(data.sampleReRequestedDate),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildCompactActionButton(
                      icon: Icons.visibility,
                      color: Colors.blue,
                      onPressed: () => _showSampleDetailsDialog(context, data),
                    ),
                    if (_isTampered(data.statusName)) ...[
                      SizedBox(width: 8),
                      _buildCompactActionButton(
                        icon: Icons.edit,
                        color: Colors.green,
                        onPressed: () => _showEditDialog(context, data),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: customColors.primary),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTableView(List<SampleList> sampleDataList) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.table_chart, color: customColors.primary, size: 22),
                SizedBox(width: 12),
                Text(
                  'Sample Records - Table View',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: customColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey[50]!],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      customColors.primary,
                    ),
                    headingTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    dataRowHeight: 60,
                    headingRowHeight: 50,
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text('Serial No.')),
                      DataColumn(label: Text('Sent Date')),
                      DataColumn(label: Text('Resent Date')),
                      DataColumn(label: Text('Requested Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Lab Location')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: sampleDataList.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    customColors.primary.withOpacity(0.1),
                                    customColors.primary.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                data.serialNo ?? 'N/A',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataCell(Text(_formatDate(data.sampleSentDate))),
                          DataCell(Text(_formatDate(data.sampleResentDate))),
                          DataCell(
                            Text(_formatDate(data.sampleReRequestedDate)),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    getStatusColor(data.statusName),
                                    getStatusColor(
                                      data.statusName,
                                    ).withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                data.statusName ?? 'Unknown',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              width: 120,
                              child: Text(
                                data.labLocation ?? 'N/A',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.blue.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.visibility,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _showSampleDetailsDialog(context, data),
                                    iconSize: 18,
                                  ),
                                ),
                                if (_isTampered(data.statusName)) ...[
                                  SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Colors.green.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          _showEditDialog(context, data),
                                      iconSize: 18,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date == '0001-01-01T00:00:00') return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
}
