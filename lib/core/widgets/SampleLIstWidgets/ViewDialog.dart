import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/core/widgets/AppHeader/AppHeader.dart';
import 'package:intl/intl.dart';

import '../../../Screens/Sample list/bloc/sampleBloc.dart';
import '../../../Screens/Sample list/model/view_form6_model.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../utils/enums.dart';

class SampleDetailsScreen extends StatefulWidget {
  final String serialNo;

  const SampleDetailsScreen({Key? key, required this.serialNo})
    : super(key: key);

  State<SampleDetailsScreen> createState() => _SampleDetailsScreenState();
}

class _SampleDetailsScreenState extends State<SampleDetailsScreen> {
  // 🎨 Enhanced color scheme
  static const Color primaryColor = Color(0xFF2E7D8A);
  static const Color secondaryColor = Color(0xFF4A90A4);
  static const Color accentColor = Color(0xFF6CB4C7);
  static const Color backgroundColor = Color(0xFFF5F9FA);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color dividerColor = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SampleBloc>().add(getFormEvent(serialNo: widget.serialNo));
      }
    });
  }

  // ✅ Date formatter (handles multiple formats)
  String formatDate(dynamic date) {
    if (date == null) return "N/A";
    try {
      if (date is DateTime) {
        return DateFormat('dd/MM/yyyy').format(date);
      }
      // Parse backend string like "8/13/2025 10:00:00 AM"
      final inputFormat = DateFormat("M/d/yyyy h:mm:ss a");
      final parsed = inputFormat.parse(date.toString());
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (e) {
      return date.toString();
    }
  }

  // ✅ Yes/No formatter (for 0/1 values)
  String formatYesNo(dynamic value) {
    if (value == null) return "N/A";
    if (value.toString() == "1") return "Yes";
    if (value.toString() == "0") return "No";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppHeader(
        screenTitle: 'Sample Form VI Details',
        username: 'Username',
        userId: 'UserID',
        showBack: true,
      ),
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
                state.getFormData.message ?? "Error occurred",
              );
            case Status.complete:
              final ViewForm6Model data = state.getFormData.data;
              if (data.form6Details == null || data.form6Details!.isEmpty) {
                return _buildEmptyState();
              }
              final Form6Details details = data.form6Details!.first;
              return _buildDetailsView(details);
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            "Loading sample details...",
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
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: textPrimary, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: textSecondary),
          SizedBox(height: 16),
          Text(
            "No details found",
            style: TextStyle(color: textPrimary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsView(Form6Details details) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildHeaderCard(details),
          const SizedBox(height: 12),

          _buildSection(
            title: "Basic Information",

            color: const Color(0xFF3B82F6),
            fields: [
              {
                "label": "Serial No:",
                "value": details.serialNo,

              },
              {
                "label": "Sender Name:",
                "value": details.senderName,

              },
              {
                "label": "Sender Designation:",
                "value": details.senderDesignation,

              },
              {
                "label": "DO Number:",
                "value": details.doNumber,

              },
            ],
          ),

          _buildSection(
            title: "Location Details",

            color: const Color(0xFF3B82F6),

            fields: [
              {
                "label": "District:",
                "value": details.district,
                "icon": Icons.map,
              },
              {
                "label": "Division:",
                "value": details.division,
                "icon": Icons.location_city,
              },
              {"label": "Area:", "value": details.area, "icon": Icons.place},
              {
                "label": "Latitude:",
                "value": details.latitude,
                "icon": Icons.gps_fixed,
              },
              {
                "label": "Longitude:",
                "value": details.longitude,
                "icon": Icons.gps_not_fixed,
              },
            ],
          ),

          _buildSection(
            title: "Sample Information",

            color: const Color(0xFF3B82F6),

            fields: [
              {
                "label": "Sample Code:",
                "value": details.sampleCodeNumber,
                "icon": Icons.qr_code,
              },
              {
                "label": "Collection Date:",
                "value": formatDate(details.collectionDate),
                "icon": Icons.calendar_today,
              },
              {
                "label": "Collection Place:",
                "value": details.placeOfCollection,
                "icon": Icons.location_pin,
              },
              {
                "label": "Sample Name:",
                "value": details.sampleName,
                "icon": Icons.label,
              },
              {
                "label": "Quantity:",
                "value": details.quantityOfSample,
                "icon": Icons.scale,
              },
            ],
          ),

          _buildSection(
            title: "Preservative Details",
            color: const Color(0xFF3B82F6),

            fields: [
              {
                "label": "Preservative Added:",
                "value": formatYesNo(details.preservativeAdded),
                "icon": Icons.add_circle_outline,
              },
              {
                "label": "Preservative Name:",
                "value": details.preservativeName,
                "icon": Icons.science,
              },
              {
                "label": "Quantity:",
                "value": details.quantityOfPreservative,
                "icon": Icons.water_drop,
              },
            ],
          ),

          _buildSection(
            title: "Verification & Security",

            color: const Color(0xFF3B82F6),

            fields: [
              {
                "label": "Witness Signature:",
                "value": formatYesNo(details.witnessSignature),

              },
              {
                "label": "Paper Slip No:",
                "value": details.paperSlipNumber,

              },
              {
                "label": "DO Signature:",
                "value": formatYesNo(details.signatureOfDO),
                "icon": Icons.draw,
              },
              {
                "label": "Seal Impression:",
                "value": formatYesNo(details.sealImpression),
                "icon": Icons.verified,
              },
              {
                "label": "Seal Number:",
                "value": details.sealNumber,
                "icon": Icons.security,
              },
            ],
          ),

          _buildSection(
            title: "Form VI Details",
            // icon: Icons.description_outlined,
            color: const Color(0xFF3B82F6),

            fields: [
              {
                "label": "Memo Form VI",
                "value": formatYesNo(details.memoFormVI),

              },
              {
                "label": "Inside Wrapper",
                "value": formatYesNo(details.wrapperFormVI),

              },
              {
                "label": "Wrapper Code",
                "value": details.wrapperCodeNumber,

              },
              {"label": "Status", "value": details.status,  },
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget _buildHeaderCard(Form6Details details) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
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
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(Icons.biotech, color: Colors.white, size: 24),
  //             ),
  //             const SizedBox(width: 12),
  //             const Text(
  //               "Sample Code",
  //               style: TextStyle(
  //                 color: Colors.white70,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           details.sampleCodeNumber?.isNotEmpty == true
  //               ? details.sampleCodeNumber!
  //               : "N/A",
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// ✅ Enhanced Section Card with icons and colors
  Widget _buildSection({
    required String title,
    // required IconData icon,
    required Color color,
    required List<Map<String, dynamic>> fields,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [

                const SizedBox(width: 8),
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
            padding: const EdgeInsets.all(16),
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
                      const Divider(
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

  Widget _buildDetailRow(String label, dynamic value, ) {
    final valueStr = value?.toString() ?? "N/A";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),

        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            valueStr.isNotEmpty ? valueStr : "N/A",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueStr.isNotEmpty ? textPrimary : textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
