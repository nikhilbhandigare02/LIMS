import 'package:flutter/material.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';

import '../../../core/widgets/AppHeader/AppHeader.dart';
import '../../../core/widgets/SampleLIstWidgets/ViewDialog.dart';
import '../../../core/widgets/SampleLIstWidgets/edit.dart';

class SampleAnalysisScreen extends StatefulWidget {
  @override
  _SampleAnalysisScreenState createState() => _SampleAnalysisScreenState();
}

class _SampleAnalysisScreenState extends State<SampleAnalysisScreen>
    with SingleTickerProviderStateMixin {
  bool isCardView = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Sample data
  List<SampleData> sampleDataList = [
    SampleData(
      serialNo: "001",
      sampleSentDate: "2024-01-15",
      sampleResentDate: "",
      sampleRequestedDate: "2024-01-12",
      status: "re-requested",
      labLocation: "Mumbai",
    ),
    SampleData(
      serialNo: "002",
      sampleSentDate: "2024-01-20",
      sampleResentDate: "-",
      sampleRequestedDate: "-",
      status: "sample receive entry pending",
      labLocation: "Nagpur",
    ),
    SampleData(
      serialNo: "003",
      sampleSentDate: "2024-01-25",
      sampleResentDate: " ",
      sampleRequestedDate: " ",
      status: "sample receive entry pending",
      labLocation: "Nashik",
    ),
    SampleData(
      serialNo: "004",
      sampleSentDate: "2024-02-01",
      sampleResentDate: "-",
      sampleRequestedDate: " ",
      status: "send for codeing",
      labLocation: "Mumbai",
    ),
  ];

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      isCardView = !isCardView;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'send for codeing':
        return Colors.green;
      case 'sample receive entry pending':
        return Colors.orange;
      case 're-requested':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              tooltip: isCardView ? 'Switch to Table View' : 'Switch to Card View',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: isCardView ? _buildCardView() : _buildTableView(),
        ),
      ),
    );
  }

  Widget _buildCardView() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Header
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
                Icon(
                  Icons.science,
                  color: customColors.primary,
                  size: 22,
                ),
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

  Widget _buildSampleCard(SampleData data, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 6,
        shadowColor: customColors.primary.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compact Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [customColors.primary, customColors.primary.withOpacity(0.8)],
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [getStatusColor(data.status), getStatusColor(data.status).withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        data.status,
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

                // Compact Info Grid
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildCompactInfoRow(Icons.location_on, data.labLocation),
                          SizedBox(height: 8),
                          _buildCompactInfoRow(Icons.send, data.sampleSentDate),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildCompactInfoRow(Icons.refresh, data.sampleResentDate.isEmpty || data.sampleResentDate.trim() == '-' ? 'N/A' : data.sampleResentDate),
                          SizedBox(height: 8),
                          _buildCompactInfoRow(Icons.calendar_today, data.sampleRequestedDate.isEmpty || data.sampleRequestedDate.trim() == '-' ? 'N/A' : data.sampleRequestedDate),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Compact Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildCompactActionButton(
                      icon: Icons.visibility,
                      color: Colors.blue,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ViewSampleDialog(data: data),
                      ),
                    ),
                    if (data.status.toLowerCase() == 're-requested') ...[
                      SizedBox(width: 8),
                      _buildCompactActionButton(
                        icon: Icons.edit,
                        color: Colors.green,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => EditSampleDialog(data: data),
                        ),
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
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
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

  Widget _buildTableView() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Header for Table
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
                Icon(
                  Icons.table_chart,
                  color: customColors.primary,
                  size: 22,
                ),
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
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
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
                    headingRowColor: MaterialStateProperty.all(customColors.primary),
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
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [customColors.primary.withOpacity(0.1), customColors.primary.withOpacity(0.2)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                data.serialNo,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataCell(Text(data.sampleSentDate)),
                          DataCell(Text(data.sampleResentDate)),
                          DataCell(Text(data.sampleRequestedDate)),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [getStatusColor(data.status), getStatusColor(data.status).withOpacity(0.8)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                data.status,
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
                                data.labLocation,
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
                                    gradient: LinearGradient(colors: [Colors.blue, Colors.blue.withOpacity(0.8)]),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.visibility, color: Colors.white),
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => ViewSampleDialog(data: data),
                                    ),
                                    iconSize: 18,
                                  ),
                                ),
                                if (data.status.toLowerCase() == 're-requested') ...[
                                  SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Colors.green, Colors.green.withOpacity(0.8)]),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.edit, color: Colors.white),
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) => EditSampleDialog(data: data),
                                      ),
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
}

class SampleData {
  final String serialNo;
  final String sampleSentDate;
  final String sampleResentDate;
  final String sampleRequestedDate;
  final String status;
  final String labLocation;

  SampleData({
    required this.serialNo,
    required this.sampleSentDate,
    required this.sampleResentDate,
    required this.sampleRequestedDate,
    required this.status,
    required this.labLocation,
  });
}