import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../Screens/FORM6/bloc/Form6Bloc.dart';
import '../../../Screens/Sample list/bloc/sampleBloc.dart';
import '../../../Screens/Sample list/model/view_form6_model.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../l10n/app_localizations.dart';
import '../../utils/Message.dart';
import '../../utils/enums.dart';
import '../AppDrawer/Drawer.dart';

class SampleDetailsScreen extends StatefulWidget {
  final String serialNo;

   SampleDetailsScreen({Key? key, required this.serialNo})
    : super(key: key);

  State<SampleDetailsScreen> createState() => _SampleDetailsScreenState();
}

class _SampleDetailsScreenState extends State<SampleDetailsScreen> {
  List<UploadedDoc> parseUploadedDocuments(String encodedDocuments) {
    final parts = encodedDocuments.split(","); // if multiple docs stored as CSV

    final docs = <UploadedDoc>[];
    for (var part in parts) {
      part = part.trim();
      if (part.isEmpty) continue;

      try {
        docs.add(UploadedDoc.fromBase64(part));
      } catch (e) {
        debugPrint("Error decoding document: $e");
      }
    }
    return docs;
  }


  static  Color primaryColor = Color(0xFF2E7D8A);
  static  Color secondaryColor = Color(0xFF4A90A4);
  static  Color accentColor = Color(0xFF6CB4C7);
  static  Color backgroundColor = Color(0xFFF5F9FA);
  static  Color cardColor = Color(0xFFFFFFFF);
  static  Color textPrimary = Color(0xFF1A1A1A);
  static  Color textSecondary = Color(0xFF6B7280);
  static  Color dividerColor = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SampleBloc>().add(getFormEvent(serialNo: widget.serialNo));
      }
    });
  }

  String formatDate(dynamic date) {
    if (date == null) return AppLocalizations.of(context)!.na;
    try {
      if (date is DateTime) {
        return DateFormat('dd/MM/yyyy').format(date);
      }
      final inputFormat = DateFormat("M/d/yyyy h:mm:ss a");
      final parsed = inputFormat.parse(date.toString());
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (e) {
      return date.toString();
    }
  }

  String formatYesNo(dynamic value) {
    if (value == null) return AppLocalizations.of(context)!.na;
    if (value.toString() == "1") return 'YES';
    if (value.toString() == "0") return 'NO';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppHeader(
        screenTitle: AppLocalizations.of(context)!.sampleFormViDetails,

        showBack: false,
      ),
      drawer: CustomDrawer(),

      body: BlocBuilder<SampleBloc, getSampleListState>(
        builder: (context, state) {
          final currentStatus = state.getFormData.status;
          if (currentStatus == null) {
            return _buildLoadingState();
          }
          switch (currentStatus) {
            case Status.loading:
              return _buildLoadingState();
            case Status.error:
              return _buildErrorState(
                state.getFormData.message ?? AppLocalizations.of(context)!.error,
              );
            case Status.complete:
              final ViewForm6Model data = state.getFormData.data;
              if (data.form6Details == null || data.form6Details!.isEmpty) {
                return _buildEmptyState();
              }
              final Form6Details details = data.form6Details!.first;
              return _buildDetailsView(details);
            default:
              return  SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loadingSampleDetails,
            style: TextStyle(color: textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
           SizedBox(height: 16),
          Text(
            message,
            style:  TextStyle(color: textPrimary, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: textSecondary),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noDetailsFound,
            style: TextStyle(color: textPrimary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsView(Form6Details details) {
    return SingleChildScrollView(
      padding:  EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildHeaderCard(details),
           SizedBox(height: 12),

          _buildSection(
            title: AppLocalizations.of(context)!.basicInformation,

            color:  Color(0xFF3B82F6),
            fields: [
              {
                "label": "${AppLocalizations.of(context)!.serialNo}:",
                "value": details.serialNo,

              },
              {
                "label": "${AppLocalizations.of(context)!.senderNameLabel}:",
                "value": details.senderName,

              },
              {
                "label": "${AppLocalizations.of(context)!.senderDesignationLabel}:",
                "value": details.senderDesignation,

              },
              {
                "label": "${AppLocalizations.of(context)!.doNumberLabel}:",
                "value": details.DONumber,

              },
            ],
          ),

          _buildSection(
            title: AppLocalizations.of(context)!.locationDetails,

            color:  Color(0xFF3B82F6),

            fields: [
              {
                "label": "${AppLocalizations.of(context)!.district}:",
                "value": details.district,
                "icon": Icons.map,
              },
              {
                "label": "${AppLocalizations.of(context)!.division}:",
                "value": details.division,
                "icon": Icons.location_city,
              },
              {"label": "${AppLocalizations.of(context)!.area}:", "value": details.area, "icon": Icons.place},
              {
                "label": "${AppLocalizations.of(context)!.latitude}:",
                "value": details.latitude,
                "icon": Icons.gps_fixed,
              },
              {
                "label": "${AppLocalizations.of(context)!.longitude}:",
                "value": details.longitude,
                "icon": Icons.gps_not_fixed,
              },
            ],
          ),

          _buildSection(
            title: AppLocalizations.of(context)!.sampleInformation,

            color:  Color(0xFF3B82F6),

            fields: [
              {
                "label": "${AppLocalizations.of(context)!.sampleCode}:",
                "value": details.sampleCodeNumber,
                "icon": Icons.qr_code,
              },
              {
                "label": "${AppLocalizations.of(context)!.slipNumber}:",
                "value": details.slip_number,
                "icon": Icons.qr_code,
              },
              {
                "label": "${AppLocalizations.of(context)!.collectionDate}:",
                "value": formatDate(details.collectionDate),
                "icon": Icons.calendar_today,
              },

              {
                "label": "${AppLocalizations.of(context)!.sampleName}:",
                "value": details.sampleName,
                "icon": Icons.label,
              },
              {
                "label": "${AppLocalizations.of(context)!.quantity}:",
                "value": details.quantityOfSample,
                "icon": Icons.scale,
              },
              {
                "label": "Number Of Sample:",
                "value": details.numberOfSample,
                "icon": Icons.numbers,
              },
              {
                "label": "${AppLocalizations.of(context)!.preservativeName}:",
                "value": details.preservativeName,
                "icon": Icons.science,
              },
              {
                "label": "${AppLocalizations.of(context)!.sealNumber}:",
                "value": details.sealNumber,
                "icon": Icons.science,
              },

            ],
          ),



          _buildSection(
            title: "Additional Information",
            color: const Color(0xFF3B82F6),
            fields: [
              {
                "label": "Special Request Reason:",
                "value": details.specialRequestReason,
              },
              {
                "label": "Additional Relevant Information:",
                "value": details.additionalRelevantInfo,
              },
              {
                "label": "Parameters As Per FSSAI:",
                "value": details.parametersAsPerFssai,
              },
              {
                "label": "Additional Tests:",
                "value": details.additionalTests,
              },
              {"label": AppLocalizations.of(context)!.uploadedDocument, "value": _buildDocumentsList(details),  },
            ],
          ),

          if (_buildStatusTransactionFields(details.status).isNotEmpty)
            _buildSection(
              title: AppLocalizations.of(context)!.statusTransactions,
              color: const Color(0xFF3B82F6),
              fields: _buildStatusTransactionFields(details.status),
            ),

           SizedBox(height: 30),
        ],
      ),
    );
  }


  List<Map<String, dynamic>> _buildStatusTransactionFields(String? statusJson) {
    if (statusJson == null || statusJson.trim().isEmpty) return const [];
    try {
      // Some APIs may double-encode or include surrounding quotes; ensure it's JSON array
      final dynamic parsed = json.decode(statusJson);
      if (parsed is! List) return const [];
      // Build temp list with parsed DateTime for sorting (most recent first)
      final List<Map<String, dynamic>> temp = [];
      DateTime? _tryParse(String? raw) {
        if (raw == null) return null;
        final s = raw.trim();
        return DateFormat('yyyy-MM-dd HH:mm:ss').tryParse(s) ??
            DateTime.tryParse(s.replaceFirst(' ', 'T')) ??
            DateFormat('M/d/yyyy h:mm:ss a').tryParse(s);
      }
      for (final item in parsed) {
        if (item is Map) {
          final status = item['Status']?.toString() ?? 'Status';
          final txn = item['TransactionDate']?.toString();
          temp.add({
            'label': _wrapStatusLabel(status),
            'value': _formatStatusDateTime(txn) ?? 'N/A',
            '_dt': _tryParse(txn),
          });
        }
      }
      temp.sort((a, b) {
        final ad = a['_dt'] as DateTime?;
        final bd = b['_dt'] as DateTime?;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1; // nulls last
        if (bd == null) return -1;
        return bd.compareTo(ad); // descending (recent first)
      });
      // Strip helper key before returning
      return temp.map((e) => {
        'label': e['label'],
        'value': e['value'],
      }).toList();
    } catch (e) {

      return const [];
    }
  }

  // Try to format transaction date in multiple formats -> dd/MM/yyyy hh:mm a (12-hour)
  String? _formatStatusDateTime(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    final raw = input.trim();
    try {
      // Try common API format: yyyy-MM-dd HH:mm:ss
      final dt = DateFormat('yyyy-MM-dd HH:mm:ss').tryParse(raw) ??
          // Try ISO parse by normalizing space to 'T'
          DateTime.tryParse(raw.replaceFirst(' ', 'T')) ??
          // Try M/d/yyyy h:mm:ss a
          DateFormat('M/d/yyyy h:mm:ss a').tryParse(raw);
      if (dt == null) return raw; // fallback to raw
      final d = DateFormat('dd/MM/yyyy').format(dt);
      final t = DateFormat('hh:mm a').format(dt);
      return '$d   $t'; // add extra spaces between date and time
    } catch (_) {
      return raw;
    }
  }

  // Insert a newline after every 3 words to make long statuses easier to read
  String _wrapStatusLabel(String input, {int wordsPerLine = 3}) {
    final words = input.split(RegExp(r"\s+"));
    if (words.length <= wordsPerLine) return input;
    final buffer = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      buffer.write(words[i]);
      if (i < words.length - 1) buffer.write(' ');
      if ((i + 1) % wordsPerLine == 0 && i < words.length - 1) {
        buffer.write('\n');
      }
    }
    return buffer  .toString();
  }
  //       gradient: LinearGradient(
  //         colors: [primaryColor, secondaryColor],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: primaryColor.withOpacity(0.3),
  //           blurRadius: 12,
  //           offset:  Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding:  EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child:  Icon(Icons.biotech, color: Colors.white, size: 24),
  //             ),
  //              SizedBox(width: 12),
  //              Text(
  //               "Sample Code",
  //               style: TextStyle(
  //                 color: Colors.white70,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ],
  //         ),
  //          SizedBox(height: 8),
  //         Text(
  //           details.sampleCodeNumber?.isNotEmpty == true
  //               ? details.sampleCodeNumber!
  //               : "N/A",
  //           style:  TextStyle(
  //             color: Colors.white,
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSection({
    required String title,
    // required IconData icon,
    required Color color,
    required List<Map<String, dynamic>> fields,
  }) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset:  Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding:  EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [

                 SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // Section content
          Padding(
            padding:  EdgeInsets.all(16),
            child: Column(
              children: fields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                return Column(
                  children: [
                    _buildDetailRow(
                      field["label"]!,
                      field["value"],

                    ),
                    if (index < fields.length - 1)
                       Divider(
                        color: dividerColor,
                        height: 20,
                        thickness: 1,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    Widget valueWidget;

    if (value is Widget) {
      valueWidget = value;
    } else {
      final valueStr = value?.toString() ?? "N/A";
      valueWidget = Text(
        valueStr.isNotEmpty ? valueStr : "N/A",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: valueStr.isNotEmpty ? textPrimary : textSecondary,
          height: 1.4,
        ),
        textAlign: TextAlign.start,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:  EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
         SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style:  TextStyle(
              fontSize: 14,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: valueWidget,
        ),
      ],
    );
  }

  Widget _buildDocumentsList(Form6Details details) {
    final urls = details.documentUrls ?? const [];
    final names = details.documentNames ?? const [];
    if (urls.isEmpty) {
      return Text("No documents uploaded");
    }

    String _nameFor(int index) {
      if (index < names.length && (names[index]).toString().isNotEmpty) {
        return names[index];
      }
      final u = index < urls.length ? urls[index] : '';
      final idx = u.lastIndexOf('/');
      return idx >= 0 ? u.substring(idx + 1) : u;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(urls.length, (index) {
        final docUrl = urls[index];
        final docName = _nameFor(index);
        final lower = docName.toLowerCase();
        final isImage = lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png') || lower.endsWith('.gif');
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () async {
              try {
                if (docUrl.isNotEmpty) {
                  if (docUrl.startsWith('http')) {
                    final uri = Uri.parse(docUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  } else {
                    await OpenFilex.open(docUrl);
                  }
                } else {
                  Message.showTopRightOverlay(
                    context,
                    'No file path available for $docName',
                    MessageType.error,
                  );
                }
              } catch (e) {
                Message.showTopRightOverlay(
                  context,
                  'Cannot open $docName: $e',
                  MessageType.error,
                );
              }
            },
            child: Row(
              children: [
                Icon(
                  isImage ? Icons.image : Icons.insert_drive_file,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Tooltip(
                    message: docName,
                    child: Text(
                      docName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMentionedDocuments(Form6Details details) {
    final names = details.documentNames ?? const [];
    final urls = details.documentUrls ?? const [];
    if (names.isEmpty || urls.isEmpty) {
      return Text("N/A");
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(names.length, (index) {
        final docName = names[index];
        final docUrl = index < urls.length ? (urls[index] ?? '') : '';
        return InkWell(
          onTap: () async {
            try {
              if (docUrl.isNotEmpty) {
                if (docUrl.startsWith('http')) {
                  final uri = Uri.parse(docUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                } else {
                  await OpenFilex.open(docUrl);
                }
              }
            } catch (_) {}
          },
          child: Text(
            docName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
              decoration: TextDecoration.underline,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }),
    );
  }

}
