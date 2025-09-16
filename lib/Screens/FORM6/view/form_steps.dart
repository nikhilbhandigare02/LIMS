import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/utils/Message.dart';
import 'package:food_inspector/core/utils/enums.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/HomeWidgets/HomeWidgets.dart';
import '../bloc/Form6Bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> loadSenderNameIfNeeded(
  SampleFormState state,
  SampleFormBloc bloc,
) async {
  if (state.senderName.isEmpty) {
    const storage = FlutterSecureStorage();
    final String? jsonString = await storage.read(key: 'loginData');
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> data =
            jsonDecode(jsonString) as Map<String, dynamic>;
        String? name;
        for (final k in [
          'fullName',
          'FullName',
          'name',
          'Name',
          'username',
          'Username',
        ]) {
          final v = data[k];
          if (v != null && v.toString().trim().isNotEmpty) {
            name = v.toString().trim();
            break;
          }
        }
        if (name != null && name.isNotEmpty) {
          bloc.add(senderNameChanged(name));
        }
      } catch (_) {}
    }
  }
}

void setDesignationIfNeeded(SampleFormState state, SampleFormBloc bloc) {
  if (state.senderDesignation.isEmpty) {
    bloc.add(senderDesignationChanged('Food Safety Officer'));
  }
}

// Helper to set collection date if not set
void setCollectionDateIfNeeded(SampleFormState state, SampleFormBloc bloc) {
  if (state.collectionDate == null) {
    bloc.add(CollectionDateChanged(DateTime.now()));
  }
}

List<List<Widget>> getOtherInformationSteps(
  SampleFormState state,
  SampleFormBloc bloc,
) {

  loadSenderNameIfNeeded(state, bloc);
  setDesignationIfNeeded(state, bloc);
  setCollectionDateIfNeeded(state, bloc);
  return [
    [
      BlocTextInput(
        label: "Name of Sender",
        //icon: Icons.person,
        initialValue: state.senderName,
        onChanged: (val) => bloc.add(senderNameChanged(val)),
        readOnly: true,
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Sender Official Designation",
        // icon: Icons.badge,
        initialValue: state.senderDesignation,
        onChanged: (val) => bloc.add(senderDesignationChanged(val)),
        readOnly: true,
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "DO Number",
        //icon: Icons.numbers,
        initialValue: state.DONumber,
        onChanged: (val) => bloc.add(DONumberChanged(val)),
        validator: (v) => Validators.validateEmptyField(v, 'DO Number'),
        // validator: Validators.validateDONumber,
        inputFormatters: Validators.getNumberOnlyInputFormatters(),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          final selected = s.district;
          final items = s.districtOptions;
          return AbsorbPointer(
            absorbing: items.isEmpty,
            child: Opacity(
              opacity: items.isEmpty ? 0.7 : 1.0,
              child: BlocDropdown(
                label: "District",
                //icon: Icons.location_on,
                value: selected.isEmpty ? null : selected,
                items: items.isEmpty ? [] : items,
                onChanged: (val) {
                  if (val == null) return;
                  bloc.add(DistrictChanged(val));
                  final districtId = bloc.state.districtIdByName[val];
                  if (districtId != null) {
                    bloc.add(FetchDivisionsRequested(districtId));
                  }
                },
                validator: Validators.validateDistrict,
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.district.isEmpty) {
            const blockMsg = "Select district first";
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: "Division",
                  // icon: Icons.apartment,
                  value: blockMsg,
                  items: const [blockMsg],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          if (s.divisionOptions.isEmpty) {
            const loading = "Loading...";
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: "Division",
                  // icon: Icons.apartment,
                  value: loading,
                  items: const [loading],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          final selected = s.division;
          final items = s.divisionOptions;

          return AbsorbPointer(
            absorbing: items.isEmpty,
            child: Opacity(
              opacity: items.isEmpty ? 0.7 : 1.0,
              child: BlocDropdown(
                label: "Division",
                // icon: Icons.apartment,
                value: selected.isEmpty ? null : selected,
                items: items.isEmpty ? [] : items,
                onChanged: (val) {
                  if (val == null) return;
                  bloc.add(DivisionChanged(val));
                  // When division changes, fetch regions for that division
                  final divisionId = bloc.state.divisionIdByName[val];
                  if (divisionId != null) {
                    bloc.add(FetchRegionsRequested(divisionId));
                  }
                },
                validator: Validators.validateDivision,
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.division.isEmpty) {
            const blockMsg = "Select division first";
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: "Region",
                  // icon: Icons.map,
                  value: blockMsg,
                  items: const [blockMsg],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          if (s.regionOptions.isEmpty) {
            const loading = "Loading...";
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: "Region",
                  // icon: Icons.map,
                  value: loading,
                  items: const [loading],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          final selected = s.region;
          final items = s.regionOptions;

          return AbsorbPointer(
            absorbing: items.isEmpty,
            child: Opacity(
              opacity: items.isEmpty ? 0.7 : 1.0,
              child: BlocDropdown(
                label: "Region",
                // icon: Icons.map,
                value: selected.isEmpty ? null : selected,
                items: items.isEmpty ? [] : items,
                onChanged: (val) {
                  if (val == null) return;
                  bloc.add(RegionChanged(val));
                },
                validator: Validators.validateRegion,
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Area",
        //icon: Icons.home,
        initialValue: state.area,
        onChanged: (val) => bloc.add(AreaChanged(val)),
        validator: (v) => Validators.validateEmptyField(v, 'Area'),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Sending Sample Location",
        //  icon: Icons.location_city,
        initialValue: state.sendingSampleLocation ??  '',
        onChanged: (val) => bloc.add(SendingSampleLocationChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(v, 'Sending Sample Location'),
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.labOptions.isEmpty) {
            // Trigger fetch if not already fetched
            bloc.add(FetchLabMasterRequested());
            const loading = "Loading labs...";
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: "Lab Master",
                  // icon: Icons.science,
                  value: loading,
                  items: const [loading],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          final selected = s.lab;
          final items = s.labOptions;
          return BlocDropdown(
            label: "Lab  ",
            //  icon: Icons.science,
            value: selected.isEmpty ? null : selected,
            items: items,
            onChanged: (val) {
              if (val == null) return;
              bloc.add(LabChanged(val));
            },
            validator: (v) => Validators.validateEmptyField(v, 'Lab'),
          );
        },
      ),

      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocTextInput(
            label: "Latitude",
            // icon: Icons.explore,
            initialValue: state.Lattitude,
            onChanged: (val) =>
                context.read<SampleFormBloc>().add(Lattitude(val)),
            readOnly: true,
          );
        },
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocTextInput(
            label: "Longitude",
            // icon: Icons.navigation_outlined,
            initialValue: state.Longitude,
            onChanged: (val) =>
                context.read<SampleFormBloc>().add(Longitude(val)),
            readOnly: true,
          );
        },
      ),
    ],
  ];
}

List<List<Widget>> getSampleDetailsSteps(
  SampleFormState state,
  SampleFormBloc bloc,
) {
  return [
    [
      // BlocBuilder<SampleFormBloc, SampleFormState>(
      //   builder: (context, s) {
      //     if (s.sealNumberOptions.isEmpty) {
      //       bloc.add(FetchSealNumberChanged());
      //       const loading = "Loading slip Number...";
      //       return Opacity(
      //         opacity: 0.7,
      //         child: IgnorePointer(
      //           ignoring: true,
      //           child: BlocDropdown(
      //             label: "Slip Numbers",
      //             // icon: Icons.science,
      //             value: loading,
      //             items: const [loading],
      //             onChanged: (_) {},
      //           ),
      //         ),
      //       );
      //     }
      //     final selected = s.sealNumber;
      //     final items = s.sealNumberOptions;
      //     return BlocDropdown(
      //       label: "Slip Number  ",
      //       //  icon: Icons.science,
      //       value: selected.isEmpty ? null : selected,
      //       items: items,
      //       onChanged: (val) {
      //         if (val == null) return;
      //         bloc.add(SealNumberChanged(val));
      //       },
      //       validator: (v) => Validators.validateEmptyField(v, 'Slip Number'),
      //     );
      //   },
      // ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.doSealNumbersOptions.isEmpty) {
            bloc.add(FetchDoSealNumbersRequested());
            const loading = "Loading DO Seal Numbers...";
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: "DO Seal Numbers",
                  // icon: Icons.science,
                  value: loading,
                  items: const [loading],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          final selected = s.doSlipNumbers;
          final items = s.doSealNumbersOptions;
          return BlocDropdown(
            label: "DO Slip Numbers  ",
            //  icon: Icons.science,
            value: selected.isEmpty ? null : selected,
            items: items,
            onChanged: (val) {
              if (val == null) return;
              bloc.add(DoSealNumbersChanged(val));
            },
            validator: (v) => Validators.validateEmptyField(v, 'DO Slip Numbers'),
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Sample Code Number",
        // icon: Icons.qr_code,
        initialValue: state.sampleCodeData,
        onChanged: (val) => bloc.add(SampleCodeDataChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(v, 'Sample Code Number'),
        inputFormatters: Validators.getNumberOnlyInputFormatters(),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return Opacity(
            opacity: 0.8,
            child: IgnorePointer(
              ignoring: true,
              child: BlocDatePicker(
                label: "Date of Collection",
                selectedDate: state.collectionDate,
                onChanged: (date) {
                  context.read<SampleFormBloc>().add(
                    CollectionDateChanged(date),
                  );
                },
              ),
            ),
          );
        },
      ),

      SizedBox(height: 16),
      BlocTextInput(
        label: "Place of Collection",
        // icon: Icons.place,
        initialValue: state.placeOfCollection,
        onChanged: (val) => bloc.add(PlaceChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(v, 'Place of Collection'),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Sample Name",
        // icon: Icons.label,
        initialValue: state.SampleName,
        onChanged: (val) => bloc.add(SampleNameChanged(val)),
        validator: (v) => Validators.validateEmptyField(v, 'Sample Name'),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Quantity of Sample",
        //icon: Icons.scale,
        initialValue: state.QuantitySample,
        onChanged: (val) => bloc.add(QuantitySampleChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(v, 'Quantity of Sample'),
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.natureOptions.isEmpty) {
            const loading = "Loading...";
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: "Nature of Sample",
                  // icon: Icons.category,
                  value: loading,
                  items: const [loading],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          final items = s.natureOptions;
          final selected = (s.article.isNotEmpty && items.contains(s.article))
              ? s.article
              : null;
          return BlocDropdown(
            label: "Nature of Sample",
            // icon: Icons.category,
            value: selected,
            items: items,
            onChanged: (val) {
              if (val == null) return;
              bloc.add(articleChanged(val));
            },
            validator: (v) =>
                Validators.validateEmptyField(v, 'Nature of Sample'),
          );
        },
      ),
    ],
    [
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocYesNoRadio(
                label: 'Preservative Added?',
                value: state.preservativeAdded,
                autovalidate: true, // Enable auto-validation
                validator: (value) {
                  if (value == null) {
                    return 'Please select Yes or No';
                  }

                  return null; // Valid
                }, // ← from BLoC state
                // icon: Icons.add_circle_outline,
                onChanged: (newValue) {
                  context.read<SampleFormBloc>().add(
                    PreservativeAddedChanged(newValue),
                  );

                  // Optional: clear fields when "No" is selected
                  if (newValue == false) {
                    context.read<SampleFormBloc>().add(
                      preservativeNameChanged(''),
                    );
                    context.read<SampleFormBloc>().add(
                      preservativeQuantityChanged(''),
                    );
                  }
                },
              ),
              if (state.preservativeAdded == true) ...[
                SizedBox(height: 16),
                BlocTextInput(
                  label: "If yes, mention the name of Preservative",
                  // icon: Icons.medication,
                  initialValue: state.preservativeName,
                  onChanged: (val) => context.read<SampleFormBloc>().add(
                    preservativeNameChanged(val),
                  ),
                  validator: (v) => state.preservativeAdded == true
                      ? Validators.validateEmptyField(v, 'Preservative Name')
                      : null,
                ),
                SizedBox(height: 16),
                BlocTextInput(
                  label: "Quantity of Preservative",
                  //  icon: Icons.scale,
                  initialValue: state.preservativeQuantity,
                  onChanged: (val) => context.read<SampleFormBloc>().add(
                    preservativeQuantityChanged(val),
                  ),
                  validator: (v) => state.preservativeAdded == true
                      ? Validators.validateEmptyField(
                          v,
                          'Preservative Quantity',
                        )
                      : null,
                ),
              ],
            ],
          );
        },
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label:
                'Signature & thumb impression of the person/\nwitness from whom the sample \nhas been taken',
            value: state.personSignature,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return 'Please select Yes or No';
              }

              return null; // Valid
            },
            //icon: Icons.fingerprint,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(
                personSignatureChanged(newValue),
              );
            },
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Paper Slip Number",
        // icon: Icons.sticky_note_2,
        initialValue: state.slipNumber,
        onChanged: (val) => bloc.add(slipNumberChanged(val)),
        validator: (v) => Validators.validateEmptyField(v, 'Paper Slip Number'),

        inputFormatters: Validators.getNumberOnlyInputFormatters(),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: 'Signature of DO OR any officer authorized by \nFSO',
            value: state.DOSignature,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return 'Please select Yes or No';
              }

              return null; // Valid
            }, // ← from BLoC state
            // icon: Icons.verified_user,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(DOSignatureChanged(newValue));
            },
          );
        },
      ),
    ],

    [
      BlocTextInput(
        label: "Code Number of sample on Wrapper",
        // icon: Icons.code,
        initialValue: state.sampleCodeNumber,

        onChanged: (val) => bloc.add(sampleCodeNumberChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(v, 'Code Number on Wrapper'),

        inputFormatters: Validators.getNumberOnlyInputFormatters(),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: 'Form VI is inside the sample Wrapper? ',
            value: state.FoemVIWrapper,
            // icon: Icons.inventory,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return 'Please select Yes or No';
              }

              return null; // Valid
            },
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(
                FoemVIWrapperChanged(newValue),
              ); // ← dispatch event
            },
          );
        },
      ),

      SizedBox(height: 16),
      BlocTextInput(
        label: "Number of Seal",
        // icon: Icons.lock,
        initialValue: state.numberofSeal,
        onChanged: (val) => bloc.add(numberofSealChanged(val)),
        validator: (v) => Validators.validateEmptyField(v, 'Number of Seal'),

        inputFormatters: Validators.getNumberOnlyInputFormatters(),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label:
                'Memorandum of Form VI and Specimen Impression \n of the Sealed packet',
            value: state.formVI,
            autovalidate: true,
            validator: (value) {
              if (value == null) {
                return 'Please select Yes or No';
              }

              return null; // Valid
            }, // ← from BLoC state
            //icon: Icons.description,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(
                formVIChanged(newValue),
              ); // ← dispatch event
            },
          );
        },
      ),

      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: 'Impression of seal of the sender ',
            value: state.sealImpression,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return 'Please select Yes or No';
              }

              return null; // Valid
            }, // ← from BLoC state
            // icon: Icons.verified,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(
                sealImpressionChanged(newValue),
              ); // ← dispatch event
            },
          );
        },
      ),
      SizedBox(height: 16),


      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocTextInput(
                label: " any other documents",
                initialValue: state.documentName,
                readOnly: false,
                onChanged: (val) => bloc.add(documentNameChangedEvent(val)),
                validator: (v) => Validators.validateEmptyField(v, 'Document Description'),
              ),
              SizedBox(height: 8),

              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: state.isUploading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.upload_file),
                label: Text(state.isUploading ? "Uploading..." : "Upload Document(s)"),
                onPressed: state.isUploading
                    ? null
                    : () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                    allowMultiple: true,
                    withData: true, // required for web
                  );

                  if (result == null || result.files.isEmpty) return;

                  const int maxTotalSize = 5 * 1024 * 1024; // 5 MB
                  int totalSize = 0;

                  for (final f in result.files) {
                    if (f.path != null) {
                      totalSize += await File(f.path!).length();
                    } else if (f.bytes != null) {
                      totalSize += f.bytes!.length;
                    } else if (f.size != null) {
                      totalSize += f.size!;
                    }
                  }

                  for (final doc in state.uploadedDocs) {
                    totalSize += base64Decode(doc.base64Data).length;
                  }

                  if (totalSize > maxTotalSize) {
                    Message.showTopRightOverlay(context, 'Total file size (including uploaded files) must not exceed 5 MB.', MessageType.error);
                    return;
                  }

                  final List<UploadedDoc> docs = [];
                  for (final f in result.files) {
                    final bytes = f.path != null
                        ? await File(f.path!).readAsBytes()
                        : f.bytes;
                    if (bytes == null) continue;

                    docs.add(UploadedDoc(
                      name: f.name,
                      base64Data: base64Encode(bytes),
                      mimeType: null,
                      extension: f.extension,
                    ));
                  }

                  if (docs.isNotEmpty) {
                    context.read<SampleFormBloc>().add(AddUploadedDocuments(docs));
                  }
                },
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    state.uploadedDocs.isNotEmpty ? Icons.check_circle : Icons.circle_outlined,
                    color: state.uploadedDocs.isNotEmpty ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "File uploads: ${state.uploadedDocs.isNotEmpty ? '${state.uploadedDocs.length} file(s) uploaded' : 'Required'}",
                    style: TextStyle(
                      fontSize: 12,
                      color: state.uploadedDocs.isNotEmpty ? Colors.green : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (state.uploadedDocs.isNotEmpty) ...[
                Text("Uploaded Files:", style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                ...List.generate(state.uploadedDocs.length, (index) {
                  final doc = state.uploadedDocs[index];
                  return Card(
                    color: customColors.white,
                    child: ListTile(
                      leading: Icon(Icons.insert_drive_file, color: customColors.primary),
                      title: Text(doc.name, style: TextStyle(color: customColors.primary),),
                      subtitle: Text(doc.extension != null && doc.extension!.isNotEmpty ? '.${doc.extension}' : '', style: TextStyle(color: customColors.primary),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.open_in_new, color: customColors.primary),
                            tooltip: 'Open',
                            onPressed: () async {
                              await _openUploadedDoc(doc);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: customColors.primary,),
                            tooltip: 'Remove',
                            onPressed: () {
                              context.read<SampleFormBloc>().add(RemoveUploadedDocument(index));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    ],
  ];
}

Future<void> _openUploadedDoc(UploadedDoc doc) async {
  try {
    final Directory dir = await getTemporaryDirectory();
    final String safeName = doc.name.isNotEmpty ? doc.name : 'document';
    final String ext = (doc.extension != null && doc.extension!.isNotEmpty) ? '.${doc.extension}' : '';
    final File out = File('${dir.path}/$safeName$ext');
    final List<int> bytes = base64Decode(doc.base64Data);
    await out.writeAsBytes(bytes, flush: true);
    await OpenFilex.open(out.path);
  } catch (_) {}
}
