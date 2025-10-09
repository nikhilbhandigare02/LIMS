import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_inspector/config/Themes/colors/colorsTheme.dart';
import 'package:food_inspector/core/utils/Message.dart';
import 'package:food_inspector/core/utils/enums.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/HomeWidgets/HomeWidgets.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/Form6Bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import 'package:image_picker/image_picker.dart';


String _formatBytes(int bytes) {
  const int kb = 1024;
  const int mb = 1024 * 1024;
  if (bytes >= mb) return (bytes / mb).toStringAsFixed(2) + ' MB';
  if (bytes >= kb) return (bytes / kb).toStringAsFixed(2) + ' KB';
  return bytes.toString() + ' B';
}


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
    BuildContext context,
    ) {
  final l = AppLocalizations.of(context)!;

  loadSenderNameIfNeeded(state, bloc);
  setDesignationIfNeeded(state, bloc);
  setCollectionDateIfNeeded(state, bloc);
  return [
    [
      BlocTextInput(
        label: l.nameOfSender,
        //icon: Icons.person,
        initialValue: state.senderName,
        onChanged: (val) => bloc.add(senderNameChanged(val)),
        readOnly: true,
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: l.senderOfficialDesignation,
        // icon: Icons.badge,
        initialValue: state.senderDesignation,
        onChanged: (val) => bloc.add(senderDesignationChanged(val)),
        readOnly: true,
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: l.doNumber,
        //icon: Icons.numbers,
        initialValue: state.DONumber,
        onChanged: (val) => bloc.add(DONumberChanged(val)),
        validator: (v) => Validators.validateEmptyField(context,v, l.doNumber),
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
              child: BlocSearchableDropdown(
                label: l.district,
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
                validator: (value)=>Validators.validateDistrict(context,value),
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.district.isEmpty) {
            final blockMsg = l.selectDistrictFirst;
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: l.division,
                  // icon: Icons.apartment,
                  value: blockMsg,
                  items:   [blockMsg],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          if (s.divisionOptions.isEmpty) {
            final loading = l.loading;
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: l.division,
                  // icon: Icons.apartment,
                  value: loading,
                  items:   [loading],
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
              child: BlocSearchableDropdown(
                label: l.division,
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
                validator:  (value)=>Validators.validateDivision(context,value),
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.division.isEmpty) {
            final blockMsg = l.selectDivisionFirst;
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: l.region,
                  // icon: Icons.map,
                  value: blockMsg,
                  items:   [blockMsg],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          if (s.regionOptions.isEmpty) {
            final loading = l.loading;
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: l.region,
                  // icon: Icons.map,
                  value: loading,
                  items:   [loading],
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
              child: BlocSearchableDropdown(
                label: l.region,
                // icon: Icons.map,
                value: selected.isEmpty ? null : selected,
                items: items.isEmpty ? [] : items,
                onChanged: (val) {
                  if (val == null) return;
                  bloc.add(RegionChanged(val));
                },
                validator:  (value)=>Validators.validateRegion(context,value),
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: l.area,
        //icon: Icons.home,
        initialValue: state.area,
        onChanged: (val) => bloc.add(AreaChanged(val)),
        validator: (v) => Validators.validateEmptyField(context,v, l.area),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: l.sendingSampleLocation,
        //  icon: Icons.location_city,
        initialValue: state.sendingSampleLocation ??  '',
        onChanged: (val) => bloc.add(SendingSampleLocationChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(context,v, l.sendingSampleLocation),
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, s) {
          if (s.labOptions.isEmpty) {
            // Trigger fetch if not already fetched
            bloc.add(FetchLabMasterRequested());
            final loading = l.loadingLabs;
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: l.labMaster,
                  // icon: Icons.science,
                  value: loading,
                  items:   [loading],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          final selected = s.lab;
          final items = s.labOptions;
          return BlocSearchableDropdown(
            label: l.labLabel,
            //  icon: Icons.science,
            value: selected.isEmpty ? null : selected,
            items: items,
            onChanged: (val) {
              if (val == null) return;
              bloc.add(LabChanged(val));
            },
            validator: (v) => Validators.validateEmptyField(context,v, l.labLabel),
          );
        },
      ),

      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocTextInput(
            label: l.latitude,
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
            label: l.longitude,
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
    BuildContext context,
    ) {
  final l = AppLocalizations.of(context)!;
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
            final loading = l.loading;
            return Opacity(
              opacity: 0.7,
              child: IgnorePointer(
                ignoring: true,
                child: BlocDropdown(
                  label: l.doSlipNumbers,
                  // icon: Icons.science,
                  value: loading,
                  items:   [loading],
                  onChanged: (_) {},

                ),
              ),
            );
          }
          final selected = s.doSlipNumbers;
          final items = s.doSealNumbersOptions;
          return BlocDropdown(
            label: l.doSlipNumbers,
            //  icon: Icons.science,
            value: selected.isEmpty ? null : selected,
            items: items,
            onChanged: (val) {
              if (val == null) return;
              bloc.add(DoSealNumbersChanged(val));
            },
            validator: (v) => Validators.validateEmptyField(context,v, l.doSlipNumbers),
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: l.sampleCodeNumber,
        // icon: Icons.qr_code,
        initialValue: state.sampleCodeData,
        onChanged: (val) => bloc.add(SampleCodeDataChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(context,v, l.sampleCodeNumber),
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
                label: l.collectionDate,
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
        label: l.collectionPlace,
        // icon: Icons.place,
        initialValue: state.placeOfCollection,
        onChanged: (val) => bloc.add(PlaceChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(context,v, l.collectionPlace),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: l.sampleName,
        // icon: Icons.label,
        initialValue: state.SampleName,
        onChanged: (val) => bloc.add(SampleNameChanged(val)),
        validator: (v) => Validators.validateEmptyField(context,v, l.sampleName),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: l.quantity,
        //icon: Icons.scale,
        initialValue: state.QuantitySample,
        onChanged: (val) => bloc.add(QuantitySampleChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(context,v, l.quantity),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: 'Number Of Sample',
        //icon: Icons.scale,
        initialValue: state.NumberOfSample,
        onChanged: (val) => bloc.add(NumberOfSampleChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(context,v, 'Number Of Sample'),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: 'Nature of Sample',
        //icon: Icons.scale,
        initialValue: state.article,
        onChanged: (val) => bloc.add(articleChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(context,v, 'Nature Of Sample'),
      ),
      // BlocBuilder<SampleFormBloc, SampleFormState>(
      //   builder: (context, s) {
      //     if (s.natureOptions.isEmpty) {
      //       final loading = l.loading;
      //       return Opacity(
      //         opacity: 0.7,
      //         child: IgnorePointer(
      //           ignoring: true,
      //           child: BlocDropdown(
      //             label: l.natureOfSample,
      //             // icon: Icons.category,
      //             value: loading,
      //             items:   [loading],
      //             onChanged: (_) {},
      //           ),
      //         ),
      //       );
      //     }
      //     final items = s.natureOptions;
      //     final selected = null
      //         : null;
      //     return BlocDropdown(
      //       label: l.natureOfSample,
      //       // icon: Icons.category,
      //       value: null,
      //       items: items,
      //       onChanged: (val) {
      //         if (val == null) return;
      //         // removed
      //       },
      //       validator: (v) =>
      //           Validators.validateEmptyField(context,v, l.natureOfSample),
      //     );
      //   },
      // ),
      ///////////////////////////////////////////////////
    ],
    [
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          final l = AppLocalizations.of(context)!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocYesNoRadio(
                label: l.preservativeAdded,
                value: state.preservativeAdded,
                autovalidate: true, // Enable auto-validation
                validator: (value) {
                  if (value == null) {
                    return l.pleaseSelectYesOrNo;
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
                  label: l.preservativeName,
                  // icon: Icons.medication,
                  initialValue: state.preservativeName,
                  onChanged: (val) => context.read<SampleFormBloc>().add(
                    preservativeNameChanged(val),
                  ),
                  validator: (v) => state.preservativeAdded == true
                      ? Validators.validateEmptyField(context,v, l.preservativeName)
                      : null,
                ),
                SizedBox(height: 16),
                BlocTextInput(
                  label: l.preservativeQuantity,
                  //  icon: Icons.scale,
                  initialValue: state.preservativeQuantity,
                  onChanged: (val) => context.read<SampleFormBloc>().add(
                    preservativeQuantityChanged(val),
                  ),
                  validator: (v) => state.preservativeAdded == true
                      ? Validators.validateEmptyField(
                    context,v,
                    l.preservativeQuantity,
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
            label: l.witnessSignature,
            value: state.personSignature,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return l.pleaseSelectYesOrNo;
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
      // BlocTextInput(
      //   label: "Paper Slip Number",
      //   // icon: Icons.sticky_note_2,
      //   initialValue: state.slipNumber,
      //   onChanged: (val) => bloc.add(slipNumberChanged(val)),
      //   validator: (v) => Validators.validateEmptyField(v, 'Paper Slip Number'),
      //
      //   inputFormatters: Validators.getNumberOnlyInputFormatters(),
      //   keyboardType: TextInputType.number,
      // ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: l.doSignature,
            value: state.DOSignature,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return l.pleaseSelectYesOrNo;
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
        label: l.wrapperCode,
        // icon: Icons.code,
        initialValue: state.sampleCodeNumber,

        onChanged: (val) => bloc.add(sampleCodeNumberChanged(val)),
        validator: (v) =>
            Validators.validateEmptyField(context,v, l.wrapperCode),

        inputFormatters: Validators.getNumberOnlyInputFormatters(),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: l.insideWrapper,
            value: state.FoemVIWrapper,
            // icon: Icons.inventory,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return l.pleaseSelectYesOrNo;
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
        label: l.sealNumber,
        // icon: Icons.lock,
        initialValue: state.numberofSeal,
        onChanged: (val) => bloc.add(numberofSealChanged(val)),
        validator: (v) => Validators.validateEmptyField(context,v, l.sealNumber),

        inputFormatters: Validators.getNumberOnlyInputFormatters(),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: l.memoFormVi,
            value: state.formVI,
            autovalidate: true,
            validator: (value) {
              if (value == null) {
                return l.pleaseSelectYesOrNo;
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
            label: l.sealImpression,
            value: state.sealImpression,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return l.pleaseSelectYesOrNo;
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
          final l = AppLocalizations.of(context)!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.anyOtherDocuments, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),

              // Dynamic document rows
              ...List.generate(state.uploadedDocs.length, (index) {
                final doc = state.uploadedDocs[index];
                return Card(
                  color: customColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (() {
                          // If we have an extension, render a non-editable suffix for it and only allow editing base name
                          final String? ext = (doc.extension != null && doc.extension!.isNotEmpty)
                              ? doc.extension
                              : (() {
                            final n = doc.name;
                            final i = n.lastIndexOf('.');
                            if (i > 0 && i < n.length - 1) return n.substring(i + 1);
                            return null;
                          })();
                          if (ext != null && ext.isNotEmpty) {
                            final String baseName = (() {
                              final n = doc.name;
                              final dotIdx = n.toLowerCase().endsWith('.' + ext.toLowerCase())
                                  ? n.length - (ext.length + 1)
                                  : -1;
                              return dotIdx > 0 ? n.substring(0, dotIdx) : (n.isEmpty ? '' : n);
                            })();
                            return TextFormField(
                              initialValue: baseName,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (v) => Validators.validateEmptyField(context,v, l.documentName),
                              onChanged: (v) {
                                final newName = (v.isEmpty ? '' : v) + '.' + ext;
                                context.read<SampleFormBloc>().add(
                                  UpdateUploadedDocumentName(index: index, name: newName),
                                );
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: customColors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: l.enterDocumentName,
                                hintStyle: TextStyle(fontSize: 16, color: customColors.black87, fontWeight: FontWeight.normal),
                                filled: true,
                                fillColor: customColors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: customColors.primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: customColors.primary),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: customColors.primary, width: 0.5),
                                ),
                                suffix: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: customColors.grey100,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: customColors.grey300, width: 0.5),
                                  ),
                                  child: Text(
                                    '.$ext',
                                    style: TextStyle(color: customColors.primary, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return BlocTextInput(
                              label: l.documentName,
                              initialValue: doc.name,
                              onChanged: (val) => context.read<SampleFormBloc>().add(
                                UpdateUploadedDocumentName(index: index, name: val),
                              ),
                              validator: (v) => Validators.validateEmptyField(context,v, l.documentName),
                            );
                          }
                        })(),
                        SizedBox(height: 12),
                        Row(
                            children: [
                              ElevatedButton.icon(
                                icon: state.isUploading
                                    ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: customColors.white),
                                )
                                    : const Icon(Icons.upload_file),
                                label: Text(state.isUploading ? l.uploading : (doc.base64Data.isEmpty ? l.chooseFile : l.replaceFile)),
                                onPressed: state.isUploading
                                    ? null
                                    : () async {
                                  final result = await FilePicker.platform.pickFiles(
                                    type: FileType.any,
                                    allowMultiple: false,
                                    withData: true,
                                  );
                                  if (result == null || result.files.isEmpty) return;
                                  final f = result.files.first;
                                  final bytes = f.path != null
                                      ? await File(f.path!).readAsBytes()
                                      : f.bytes;
                                  if (bytes == null) return;

                                  const int maxTotalSize = 5 * 1024 * 1024;
                                  int totalSize = 0;
                                  for (int i = 0; i < state.uploadedDocs.length; i++) {
                                    if (i == index) continue; // we'll replace this index
                                    final d = state.uploadedDocs[i];
                                    if (d.base64Data.isNotEmpty) {
                                      totalSize += (d.sizeBytes ?? base64Decode(d.base64Data).length);
                                    }
                                  }
                                  totalSize += bytes.length;
                                  if (totalSize > maxTotalSize) {
                                    Message.showTopRightOverlay(context, 'Total file size must not exceed 5 MB.', MessageType.error);
                                    return;
                                  }

                                  final newDoc = UploadedDoc(
                                    name: (doc.name.isEmpty ? (f.name) : doc.name),
                                    base64Data: base64Encode(bytes),
                                    mimeType: null,
                                    extension: f.extension,
                                    sizeBytes: bytes.length,
                                  );
                                  context.read<SampleFormBloc>().add(ReplaceUploadedDocumentAt(index: index, document: newDoc));

                                  if (doc.name.isEmpty) {
                                    context.read<SampleFormBloc>().add(UpdateUploadedDocumentName(index: index, name: f.name));
                                  }
                                },
                              ),
                              const SizedBox(width: 4),
                              OutlinedButton(
                                onPressed: state.isUploading
                                    ? null
                                    : () async {
                                  final picker = ImagePicker();
                                  final XFile? photo = await picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 85,
                                  );
                                  if (photo == null) return;
                                  final bytes = await photo.readAsBytes();

                                  const int maxTotalSize = 5 * 1024 * 1024;
                                  int totalSize = 0;
                                  for (int i = 0; i < state.uploadedDocs.length; i++) {
                                    if (i == index) continue;
                                    final d = state.uploadedDocs[i];
                                    if (d.base64Data.isNotEmpty) {
                                      totalSize += base64Decode(d.base64Data).length;
                                    }
                                  }
                                  totalSize += bytes.length;
                                  if (totalSize > maxTotalSize) {
                                    Message.showTopRightOverlay(
                                        context,
                                        'Total file size must not exceed 5 MB.',
                                        MessageType.error);
                                    return;
                                  }

                                  final String ext = 'jpg';
                                  final String displayName =
                                  doc.name.isEmpty ? photo.name : doc.name;
                                  final newDoc = UploadedDoc(
                                    name: displayName,
                                    base64Data: base64Encode(bytes),
                                    mimeType: 'image/jpeg',
                                    extension: ext,
                                    sizeBytes: bytes.length,
                                  );
                                  context
                                      .read<SampleFormBloc>()
                                      .add(ReplaceUploadedDocumentAt(index: index, document: newDoc));

                                  if (doc.name.isEmpty) {
                                    context
                                        .read<SampleFormBloc>()
                                        .add(UpdateUploadedDocumentName(index: index, name: displayName));
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(8), // smaller padding
                                  minimumSize: const Size(40, 40), // compact square button
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Icon(Icons.photo_camera, size: 20, color: customColors.black87),
                              ),
                              const SizedBox(width: 8),
                              if (doc.base64Data.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.open_in_new, color: customColors.primary),
                                  tooltip: 'Open',
                                  onPressed: () async {
                                    await _openUploadedDoc(doc);
                                  },
                                ),

                            ]),
                        if (doc.base64Data.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Size: ' + _formatBytes((doc.sizeBytes ?? base64Decode(doc.base64Data).length)),
                              style: TextStyle(fontSize: 12, color: customColors.grey600),
                            ),
                          ),
                        // if (doc.base64Data.isNotEmpty && doc.name.isNotEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 8.0),
                        //     child: InkWell(
                        //         await _openUploadedDoc(doc);
                        //       },
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           const Icon(Icons.insert_drive_file, size: 16),
                        //           const SizedBox(width: 6),
                        //           Text(
                        //             doc.name,
                        //             style: TextStyle(
                        //               color: customColors.primary,
                        //               decoration: TextDecoration.underline,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                );
              }),

              // Add new document row button (conditional)
              if (state.uploadedDocs.isEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add document'),
                    onPressed: () {
                      context.read<SampleFormBloc>().add(const AddEmptyDocumentRow());
                    },
                  ),
                )
              else if (state.uploadedDocs.first.base64Data.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add another document'),
                    onPressed: () {
                      context.read<SampleFormBloc>().add(const AddEmptyDocumentRow());
                    },
                  ),
                ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    state.uploadedDocs.isNotEmpty ? Icons.check_circle : Icons.circle_outlined,
                    color: state.uploadedDocs.isNotEmpty ? customColors.green : customColors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    state.uploadedDocs.isNotEmpty
                        ? (() {
                      final count = state.uploadedDocs.where((d) => d.base64Data.isNotEmpty).length;
                      int total = 0;
                      for (final d in state.uploadedDocs) {
                        if (d.base64Data.isNotEmpty) {
                          total += (d.sizeBytes ?? base64Decode(d.base64Data).length);
                        }
                      }
                      return '$count file(s) selected • ' + _formatBytes(total);
                    })()
                        : 'No documents added',
                    style: TextStyle(
                      fontSize: 12,
                      color: state.uploadedDocs.isNotEmpty ? customColors.green : customColors.grey600,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ],


    // New Step: (vi)-(viii) Additional details
    [
      Text(
        '(vi) Special request with reason',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      BlocTextArea(
        label: 'Special request with reason',
        initialValue: state.specialRequestReason.isEmpty
            ? 'Suspected adulteration with argemone oil'
            : state.specialRequestReason,
        onChanged: (val) => bloc.add(SpecialRequestReasonChanged(val)),
        validator: (v) => Validators.validateEmptyField(context, v, 'Special request with reason'),
        maxLines: 4,
      ),
      const SizedBox(height: 16),
      Text(
        '(vii) Any additional relevant information',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      BlocTextArea(
        label: 'Any additional relevant information',
        initialValue: state.additionalRelevantInfo.isEmpty
            ? 'Sample collected during routine market inspection'
            : state.additionalRelevantInfo,
        onChanged: (val) => bloc.add(AdditionalInfoChanged(val)),
        validator: (v) => Validators.validateEmptyField(context, v, 'Additional relevant information'),
        maxLines: 4,
      ),
      const SizedBox(height: 16),
      Text(
        '(viii) Parameter to be tested',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      BlocTextArea(
        label: '(a) As per the Food Safety and Standards Authority of India Standards for the specific products',
        initialValue: state.parametersAsPerFSSAI,
        onChanged: (val) => bloc.add(ParametersAsPerFSSAIChanged(val)),
        validator: (v) => Validators.validateEmptyField(context, v, 'Parameters as per FSSAI'),
        maxLines: 5,
      ),
      const SizedBox(height: 12),
      BlocTextArea(
        label: '(b) Any additional test to be performed if any',
        initialValue: state.additionalTests,
        onChanged: (val) => bloc.add(AdditionalTestsChanged(val)),
        validator: (v) => null, // optional
        maxLines: 4,
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
