import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/Screens/Sample%20list/repository/sampleRepository.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/config/Routes/RouteName.dart';
import '../../../core/utils/enums.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';
import '../../../core/widgets/SampleLIstWidgets/ViewDialog.dart';
import '../../FORM6/bloc/Form6Bloc.dart';
import '../../FORM6/repository/form6Repository.dart';
import '../../FORM6/view/form6_landing_screen.dart';
import '../bloc/sampleBloc.dart';
import '../model/sampleData.dart';

class SampleAnalysisScreen extends StatefulWidget {
  @override
  _SampleAnalysisScreenState createState() => _SampleAnalysisScreenState();
}

class _SampleAnalysisScreenState extends State<SampleAnalysisScreen>
  with SingleTickerProviderStateMixin {
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isCardView = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late SampleBloc sampleBloc;
  // Date filtering state
  DateTime _currentDay = DateTime.now();
  DateTimeRange? _selectedRange;
  bool _useRange = false;
  DateTime? _fromDate;
  DateTime? _toDate;

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
  int getTotalPages(int totalItems) {
    return (totalItems / itemsPerPage).ceil();
  }
  List<SampleList> getPaginatedData(List<SampleList> allData) {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, allData.length);
    return allData.sublist(startIndex, endIndex);
  }

  Widget _buildStaticDateFilterBar() {
    final today = DateTime.now();
    String f(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Container(
      width: double.infinity, // take full width
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // From picker
          Expanded(
            flex: 3,
            child: _buildDateBox(
              label: _fromDate == null
                  ? 'Select From Date'
                  : 'From: ${f(_fromDate!)}',
              date: _fromDate ?? today,
              onPicked: (picked) => setState(() => _fromDate = picked),
            ),
          ),
          const SizedBox(width: 8),

          // To picker
          Expanded(
            flex: 3,
            child: _buildDateBox(
              label: _toDate == null
                  ? 'Select To Date'
                  : 'To: ${f(_toDate!)}',
              date: _toDate ?? _fromDate ?? today,
              onPicked: (picked) => setState(() => _toDate = picked),
            ),
          ),
          const SizedBox(width: 8),

          // Submit button
          SizedBox(
            width: 48,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final fromDate = _fromDate;
                final toDate = _toDate;

                if (fromDate != null &&
                    toDate != null &&
                    toDate.isBefore(fromDate)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text('Invalid range: To date must be on/after From date')),
                  );
                  return;
                }

                setState(() => currentPage = 0);

                sampleBloc.add(
                  getSampleListEvent(fromDate: fromDate, toDate: toDate),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fetching filtered records...')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: customColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Icon(Icons.check, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBox({
    required String label,
    required DateTime date,
    required ValueChanged<DateTime> onPicked,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: date,
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today, size: 16, color: customColors.primary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: label.contains('Select') ? Colors.grey[600] : Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
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
    if (s.contains('tampered')) return Colors.red;
    if (s.contains('decoded') && s.contains('report'))
      return Colors.indigo;
    if (s.contains('decoded')) return Colors.deepPurple;
    if (s.contains('dispatched') || s.contains('dispatch'))
      return Colors.teal;
    if (s.contains('generated') && s.contains('report'))
      return Colors.blueGrey;

    if (s.contains('verification'))
      return Colors.blue;
    if (s.contains('coding') || s.contains('decode'))
      return Colors.cyan;
    if (s.contains('assignment') ||
        s.contains('allocated') ||
        s.contains('allocation'))
      return Colors.orange;
    if (s.contains('analysis'))
      return Colors.green;
    if (s.contains('received'))
      return Colors.purple;

    if (s.contains('pending')) return Colors.amber;
    if (s.contains('sent')) return Colors.lightBlue;

    if (s == 're-requested' || s.contains('re-request'))
      return Colors.redAccent;

    return Colors.grey;
  }

  bool _isTampered(String? status) {
    if (status == null) return false;
    final s = status.toLowerCase();
    return s.contains('tampered') || s.contains('resubmit');
  }



  // void _showEditDialog(BuildContext context, SampleList data) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return AlertDialog(
  //         title: Text('Edit Sample'),
  //         content: Text(
  //           'Edit functionality for sample ${data.serialNo} will be implemented here.',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(ctx).pop(),
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sampleBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppHeader(
          screenTitle: 'Sample Analysis',
          // username: 'Username',
          userId: 'UserID',
          showBack: false,
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
                icon: Icon(Icons.add, color: Colors.white),
                tooltip: 'Go to Home',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => SampleFormBloc(form6repository: Form6Repository()),
                      child: Form6LandingScreen(),
                    ),
                  ),
                ),
              ),
            ),
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
                tooltip: isCardView ? 'Switch to Table View' : 'Switch to Card View',
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: true,
          child: BlocBuilder<SampleBloc, getSampleListState>(
            bloc: sampleBloc,
            builder: (context, state) {
              switch (state.fetchSampleList.status) {
                case Status.loading:
                  return Center(child: const CircularProgressIndicator());
                case Status.complete:
                  // Build table layout regardless of having records; show message within table when empty
                  final rawData = state.fetchSampleList.data as List<SampleData>?;
                  final sampleDataList = (rawData ?? const <SampleData>[]) 
                      .expand((sampleData) => sampleData.sampleList ?? [])
                      .toList();

                  final filteredSampleDataList = sampleDataList; // static design only, no filtering applied
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
                          ? _buildCardView(filteredSampleDataList.cast<SampleList>())
                          : _buildTableView(filteredSampleDataList.cast<SampleList>()),
                    ),
                  );
                case Status.error:
                  // Preserve table/header UI and show message row inside the table
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
                      child: _buildTableView(const <SampleList>[]),
                    ),
                  );
                default:
                  return Center(child: Text('Unexpected state'));
              }
            },
          ),
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
              //  Icon(Icons.science, color: customColors.primary, size: 22),
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
          SizedBox(height: 4),
          // Static date bar (design only)
          // NOTE: This is non-functional for now; API integration can wire it later.
          // Keeping it only in card view was not requested; thus we remove it here.
          SizedBox(height: 12),
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
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: sampleBloc,
                            child: SampleDetailsScreen(serialNo: data.serialNo ?? ''),
                          ),
                        ),
                      ),

                    ),
                    // if (_isTampered(data.statusName)) ...[
                    //   SizedBox(width: 8),
                    //   _buildCompactActionButton(
                    //     icon: Icons.edit,
                    //     color: Colors.green,
                    //     onPressed: () => _showEditDialog(context, data),
                    //   ),
                    // ],
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
  Widget _buildCompactActionButton({ required IconData icon, required Color color, required VoidCallback onPressed,}) {
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
    List<SampleList> paginatedData = getPaginatedData(sampleDataList);
    int totalPages = getTotalPages(sampleDataList.length);

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
                  ' Table View',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: customColors.primary,
                  ),
                ),
                Spacer(),
                // Page info
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: customColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Page ${currentPage + 1} of ${totalPages == 0 ? 1 : totalPages}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: customColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          // Static date filter below table header card (design only)
          _buildStaticDateFilterBar(),
          SizedBox(height: 12),
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
                  scrollDirection: Axis.vertical,
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
                        DataColumn(label: Text('Requested Date')),
                        DataColumn(label: Text('Resent Date')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Lab Location')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: paginatedData.isEmpty
                          ? [
                              DataRow(
                                cells: const [
                                  DataCell(Text(
                                    'Currently, no records exist.',
                                    style: TextStyle( color: Colors.black87),
                                  )),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                ],
                              ),
                            ]
                          : paginatedData.map((data) {
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
                                  DataCell(Text(_formatDate(data.sampleReRequestedDate))),
                                  DataCell(
                                    Text(_formatDate(data.sampleResentDate)),
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
                                            getStatusColor(data.statusName).withOpacity(0.8),
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
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => BlocProvider.value(
                                                  value: sampleBloc,
                                                  child: SampleDetailsScreen(
                                                      serialNo: data.serialNo ?? ''),
                                                ),
                                              ),
                                            ),
                                            iconSize: 18,
                                          ),
                                        ),
                                        // if (_isTampered(data.statusName)) ...[
                                        // if (_isTampered(data.statusName)) ...[
                                        //   SizedBox(width: 4),
                                        //   Container(
                                        //     decoration: BoxDecoration(
                                        //       gradient: LinearGradient(
                                        //         colors: [
                                        //           Colors.green,
                                        //           Colors.green.withOpacity(0.8),
                                        //         ],
                                        //       ),
                                        //       borderRadius: BorderRadius.circular(6),
                                        //     ),
                                        //     child: IconButton(
                                        //       icon: Icon(
                                        //         Icons.edit,
                                        //         color: Colors.white,
                                        //       ),
                                        //       onPressed: () =>
                                        //           _showEditDialog(context, data),
                                        //       iconSize: 18,
                                        //     ),
                                        //   ),
                                        // ],
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
          ),
          SizedBox(height: 16),
          // Pagination Controls
          _buildPaginationControls(sampleDataList.length, totalPages),
        ],
      ),
    );
  }
  String _formatDate(String? date) {
       if (date == null) return 'N/A';
    final raw = date.trim();
    if (raw.isEmpty) return 'N/A';
    final lower = raw.toLowerCase();
    if (lower == 'null' || lower == 'n/a' || lower == 'na' || lower == '-') {
      return 'N/A';
    }

    try {
      DateTime? parsedDate;

      // Try ISO-8601 first (e.g., 2025-09-22T11:20:45Z or 2025-09-22)
      if (raw.contains('T') || raw.contains('-')) {
        parsedDate = DateTime.tryParse(raw);
      }

      // Handle slashed formats from API e.g., "9/22/2025 4:20:45 PM" or "9/22/2025 16:20:45" or just "9/22/2025"
      if (parsedDate == null && raw.contains('/')) {
        final datePart = raw.split(' ').first; // take part before space
        final parts = datePart.split('/');
        if (parts.length == 3) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (month != null && day != null && year != null) {
            parsedDate = DateTime(year, month, day);
          }
        }
      }

      if (parsedDate == null) return 'N/A';

      final d = parsedDate.day.toString().padLeft(2, '0');
      final m = parsedDate.month.toString().padLeft(2, '0');
      final y = parsedDate.year.toString();
      return '$d/$m/$y';
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing date: $date - Error: $e');
      return 'N/A';
    }
  }


  DateTime? _parseDate(String? date) {
    if (date == null) return null;
    final raw = date.trim();
    if (raw.isEmpty) return null;
    final lower = raw.toLowerCase();
    if (lower == 'null' || lower == 'n/a' || lower == 'na' || lower == '-') {
      return null;
    }

    try {
      // Try ISO formats
      if (raw.contains('T') || raw.contains('-')) {
        final p = DateTime.tryParse(raw);
        if (p != null) return DateTime(p.year, p.month, p.day);
      }

      // Handle slashed formats with or without time
      if (raw.contains('/')) {
        final datePart = raw.split(' ').first; // "9/22/2025"
        final parts = datePart.split('/');
        if (parts.length == 3) {
          final month = int.tryParse(parts[0]);
          final day = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (month != null && day != null && year != null) {
            return DateTime(year, month, day);
          }
        }
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing date for filtering: $date - Error: $e');
      return null;
    }
  }
  DateTime? _getRecordDate(SampleList s) {
    return _parseDate(s.sampleSentDate) ??
        _parseDate(s.sampleResentDate) ??
        _parseDate(s.sampleReRequestedDate);
  } 
  Widget _buildPaginationControls(int totalItems, int totalPages) {
    return Container(
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
      child: Column(
        children: [
          // Records info (moved to top)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Showing ${(currentPage * itemsPerPage) + 1}-${((currentPage + 1) * itemsPerPage).clamp(0, totalItems)} of $totalItems records',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: currentPage > 0
                          ? [customColors.primary, customColors.primary.withOpacity(0.8)]
                          : [Colors.grey[300]!, Colors.grey[400]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: currentPage > 0
                          ? () {
                        setState(() {
                          currentPage--;
                        });
                      }
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: currentPage > 0 ? Colors.white : Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Prev',
                              style: TextStyle(
                                color: currentPage > 0 ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Page numbers (simplified for small screens)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(totalPages, (index) {
                        bool isCurrentPage = index == currentPage;
                        // Show fewer pages on small screens
                        bool shouldShow = (index >= currentPage - 1 && index <= currentPage + 1) ||
                            index == 0 ||
                            index == totalPages - 1;

                        if (!shouldShow && totalPages > 5) {
                          if (index == currentPage - 2 || index == currentPage + 2) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Text('...', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            );
                          }
                          return SizedBox.shrink();
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isCurrentPage
                                    ? [customColors.primary, customColors.primary.withOpacity(0.8)]
                                    : [Colors.transparent, Colors.transparent],
                              ),
                              borderRadius: BorderRadius.circular(4),
                              border: isCurrentPage
                                  ? null
                                  : Border.all(color: Colors.grey[300]!),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    currentPage = index;
                                  });
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isCurrentPage ? Colors.white : customColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              // Next button
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: currentPage < totalPages - 1
                          ? [customColors.primary, customColors.primary.withOpacity(0.8)]
                          : [Colors.grey[300]!, Colors.grey[400]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: currentPage < totalPages - 1
                          ? () {
                        setState(() {
                          currentPage++;
                        });
                      }
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                color: currentPage < totalPages - 1 ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: currentPage < totalPages - 1 ? Colors.white : Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
