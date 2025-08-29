import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/HomeWidgets/HomeWidgets.dart';
import '../bloc/Form6Bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';

// Helper to load user name from secure storage and update the bloc
Future<void> loadSenderNameIfNeeded(SampleFormState state, SampleFormBloc bloc) async {
  if (state.senderName.isEmpty) {
    const storage = FlutterSecureStorage();
    final String? jsonString = await storage.read(key: 'loginData');
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;
        String? name;
        for (final k in ['fullName', 'FullName', 'name', 'Name', 'username', 'Username']) {
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

// Helper to set designation if not set
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

List<List<Widget>> getOtherInformationSteps(SampleFormState state, SampleFormBloc bloc) {
  // Trigger auto-population when this is built
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
        initialValue: state.sendingSampleLocation ?? '',
        onChanged: (val) => bloc.add(SendingSampleLocationChanged(val)),
        validator: (v) => Validators.validateEmptyField(v, 'Sending Sample Location'),
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
            onChanged: (val) => context.read<SampleFormBloc>().add(Lattitude(val)),
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
            onChanged: (val) => context.read<SampleFormBloc>().add(Longitude(val)),
            readOnly: true,
          );
        },
      ),

    ],
  ];
}

List<List<Widget>> getSampleDetailsSteps(SampleFormState state, SampleFormBloc bloc) {
  return [
    [
      BlocTextInput(
        label: "Sample Code Number",
       // icon: Icons.qr_code,
        initialValue: state.sampleCodeData,
        onChanged: (val) => bloc.add(SampleCodeDataChanged(val)),
        validator: (v) => Validators.validateEmptyField(v, 'Place of Collection'),
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
                  context.read<SampleFormBloc>().add(CollectionDateChanged(date));
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
        validator: (v) => Validators.validateEmptyField(v, 'Place of Collection'),
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
        validator: (v) => Validators.validateEmptyField(v, 'Quantity of Sample'),
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
          final selected = (s.article.isNotEmpty && items.contains(s.article)) ? s.article : null;
          return BlocDropdown(
            label: "Nature of Sample",
           // icon: Icons.category,
            value: selected,
            items: items,
            onChanged: (val) {
              if (val == null) return;
              bloc.add(articleChanged(val));
            },
            validator: (v) => Validators.validateEmptyField(v, 'Nature of Sample'),
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
                },// ← from BLoC state
               // icon: Icons.add_circle_outline,
                onChanged: (newValue) {
                  context.read<SampleFormBloc>().add(PreservativeAddedChanged(newValue));

                  // Optional: clear fields when "No" is selected
                  if (newValue == false) {
                    context.read<SampleFormBloc>().add(preservativeNameChanged(''));
                    context.read<SampleFormBloc>().add(preservativeQuantityChanged(''));
                  }
                },

              ),
              if (state.preservativeAdded == true) ...[
                SizedBox(height: 16),
                BlocTextInput(
                  label: "If yes, mention the name of Preservative",
                 // icon: Icons.medication,
                  initialValue: state.preservativeName,
                  onChanged: (val) => context.read<SampleFormBloc>().add(preservativeNameChanged(val)),
                  validator: (v) => state.preservativeAdded == true
                      ? Validators.validateEmptyField(v, 'Preservative Name')
                      : null,
                ),
                SizedBox(height: 16),
                BlocTextInput(
                  label: "Quantity of Preservative",
                //  icon: Icons.scale,
                  initialValue: state.preservativeQuantity,
                  onChanged: (val) => context.read<SampleFormBloc>().add(preservativeQuantityChanged(val)),
                  validator: (v) => state.preservativeAdded == true
                      ? Validators.validateEmptyField(v, 'Preservative Quantity')
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
            label: 'Signature & thumb impression of the person/\nwitness from whom the sample \nhas been taken',
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
              context.read<SampleFormBloc>().add(personSignatureChanged(newValue));

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
            },// ← from BLoC state
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
        validator: (v) => Validators.validateEmptyField(v, 'Code Number on Wrapper'),

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
              context.read<SampleFormBloc>().add(FoemVIWrapperChanged(newValue)); // ← dispatch event
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
            label: 'Memorandum of Form VI and Specimen Impression \n of the Sealed packet',
            value: state.formVI,
            autovalidate: true, // Enable auto-validation
            validator: (value) {
              if (value == null) {
                return 'Please select Yes or No';
              }

              return null; // Valid
            },// ← from BLoC state
            //icon: Icons.description,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(formVIChanged(newValue)); // ← dispatch event
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
            },// ← from BLoC state
           // icon: Icons.verified,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(sealImpressionChanged(newValue)); // ← dispatch event
            },
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Mention any other documents",
        // icon: Icons.lock,
        initialValue: state.numberofSeal,
        onChanged: (val) => bloc.add(documentEvent(val)),
        validator: (v) => Validators.validateEmptyField(v, 'Mention the document name'),

        keyboardType: TextInputType.text,
      ),

    ],
  ];
}
 