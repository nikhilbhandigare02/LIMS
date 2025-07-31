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
      sampleResentDate: "2024-01-18",
      sampleRequestedDate: "2024-01-12",
      status: "Completed",
      labLocation: "Lab A - Mumbai",
    ),
    SampleData(
      serialNo: "002",
      sampleSentDate: "2024-01-20",
      sampleResentDate: "-",
      sampleRequestedDate: "2024-01-18",
      status: "In Progress",
      labLocation: "Lab B - Delhi",
    ),
    SampleData(
      serialNo: "003",
      sampleSentDate: "2024-01-25",
      sampleResentDate: "2024-01-28",
      sampleRequestedDate: "2024-01-22",
      status: "Pending",
      labLocation: "Lab C - Bangalore",
    ),
    SampleData(
      serialNo: "004",
      sampleSentDate: "2024-02-01",
      sampleResentDate: "-",
      sampleRequestedDate: "2024-01-30",
      status: "Completed",
      labLocation: "Lab A - Mumbai",
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
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
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
          IconButton(
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
          SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isCardView ? _buildCardView() : _buildTableView(),
      ),
    );
  }

  Widget _buildCardView() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sample Records',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: customColors.primary,
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

      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shadowColor: Colors.indigo.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: customColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Serial: ${data.serialNo}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(data.status),
                        borderRadius: BorderRadius.circular(20),
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
                  ],
                ),
                SizedBox(height: 16),
                _buildInfoRow(Icons.location_on, 'Lab Location', data.labLocation),
                SizedBox(height: 12),
                _buildInfoRow(Icons.calendar_today, 'Requested Date', data.sampleRequestedDate),
                SizedBox(height: 12),
                _buildInfoRow(Icons.send, 'Sent Date', data.sampleSentDate),
                SizedBox(height: 12),
                _buildInfoRow(Icons.refresh, 'Resent Date', data.sampleResentDate),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      icon: Icons.visibility,
                      color: Colors.blue,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => ViewSampleDialog(data: data),
                      ),
                    ),
                    SizedBox(width: 12),
                    _buildActionButton(
                      icon: Icons.edit,
                      color: Colors.green,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => EditSampleDialog(data: data),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: customColors.primary),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }

  Widget _buildTableView() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sample Records - Table View',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: customColors.primary,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
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
                              color: Colors.indigo[100],
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
                              color: getStatusColor(data.status),
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
                              IconButton(
                                icon: Icon(Icons.visibility, color: Colors.blue),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => ViewSampleDialog(data: data),
                                ),
                                iconSize: 20,
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => EditSampleDialog(data: data),
                                ),
                                iconSize: 20,
                              ),
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
        ],
      ),
    );
  }



  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
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