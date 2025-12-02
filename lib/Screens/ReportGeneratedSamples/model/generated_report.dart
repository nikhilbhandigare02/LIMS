class GeneratedReport {
  final int reportId;
  final String   serialNo;
  final String inwardNo;
  final String report_filename;
  final String fileWebPath;
  final String reportNo;
  final String? insertedDate;
  final String labName;
  final String labAddress;
  final String sampleName;
  final String? dispatchDate;
  final String currentStatus;
  final String? filePath;

  GeneratedReport({
    required this.reportId,
    required this.serialNo,
    required this.inwardNo,
    required this.report_filename,
    required this.fileWebPath,
    required this.reportNo,
    this.insertedDate,
    required this.labName,
    required this.labAddress,
    required this.sampleName,
    this.dispatchDate,
    required this.currentStatus,
    this.filePath,
  });

  factory GeneratedReport.fromJson(Map<String, dynamic> json) {
    return GeneratedReport(
      reportId: (json['report_id'] ?? json['ReportId'] ?? json['id'] ?? 0) as int,
      serialNo: (json['serial_no'] ?? json['SerialNo'] ?? '').toString(),
      inwardNo: (json['inward_no'] ?? json['InwardNo'] ?? '').toString(),
      report_filename: (json['report_filename'] ?? json['report_filename'] ?? '').toString(),
      fileWebPath: (json['file_web_path'] ?? json['FileWebPath'] ?? '').toString(),
      reportNo: (json['report_no'] ?? json['ReportNo'] ?? '').toString(),
      insertedDate: (json['inserted_date'] ?? json['InsertedDate'])?.toString(),
      labName: (json['lab_name'] ?? json['LabName'] ?? '').toString(),
      labAddress: (json['lab_address'] ?? json['LabAddress'] ?? '').toString(),
      sampleName: (json['sample_name'] ?? json['SampleName'] ?? '').toString(),
      dispatchDate: (json['dispatch_date'] ?? json['DispatchDate'])?.toString(),
      currentStatus: (json['current_status'] ?? json['CurrentStatus'] ?? '').toString(),
      filePath: (json['file_path'] ?? json['FilePath'])?.toString(),
    );
  }
}

class GeneratedReportsEnvelope {
  final List<GeneratedReport> reportList;
  final bool success;
  final String? message;
  final int statusCode;

  GeneratedReportsEnvelope({
    required this.reportList,
    required this.success,
    required this.message,
    required this.statusCode,
  });

  factory GeneratedReportsEnvelope.fromJson(dynamic decoded) {
    if (decoded is List) {
      return GeneratedReportsEnvelope(
        reportList: decoded
            .map((e) => GeneratedReport.fromJson(e as Map<String, dynamic>))
            .toList(),
        success: true,
        message: 'OK',
        statusCode: 200,
      );
    }
    if (decoded is Map<String, dynamic>) {
      final listDyn = decoded['ReportList'] ?? decoded['reportList'] ?? decoded['data'] ?? decoded['Data'] ?? [];
      final list = (listDyn is List) ? listDyn : <dynamic>[];
      return GeneratedReportsEnvelope(
        reportList: list
            .map((e) => GeneratedReport.fromJson(e as Map<String, dynamic>))
            .toList(),
        success: (decoded['Success'] ?? decoded['success'] ?? true) == true,
        message: (decoded['Message'] ?? decoded['message'])?.toString(),
        statusCode: (decoded['StatusCode'] ?? decoded['statusCode'] ?? 200) as int,
      );
    }
    return GeneratedReportsEnvelope(
      reportList: const <GeneratedReport>[],
      success: false,
      message: 'Unexpected response',
      statusCode: 0,
    );
  }
}
