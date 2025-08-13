import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/HomeWidgets/HomeWidgets.dart';
import '../bloc/Form6Bloc.dart';

List<List<Widget>> getOtherInformationSteps(SampleFormState state, SampleFormBloc bloc) => [
  [
    BlocTextInput(
      label: "Name of Sender",
      icon: Icons.person,
      initialValue: state.senderName,

      onChanged: (val) => bloc.add(senderNameChanged(val)),
    ),
    SizedBox(height: 16),
    BlocTextInput(
      label: "Sender Official Designation",
      icon: Icons.badge,
      initialValue: state.senderDesignation,
      onChanged: (val) => bloc.add(senderDesignationChanged(val)),
    ),
    SizedBox(height: 16),
    BlocTextInput(
      label: "DO Number",
      icon: Icons.numbers,
      initialValue: state.DONumber,
      onChanged: (val) => bloc.add(DONumberChanged(val)),

    ),
    SizedBox(height: 16),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, s) {
        const placeholder = "Select District";
        final items = s.districtOptions.isNotEmpty ? [placeholder, ...s.districtOptions] : ["Loading..."];
        final selected = s.district.isNotEmpty ? s.district : items.first;
        final enabled = s.districtOptions.isNotEmpty;
        return Opacity(
          opacity: enabled ? 1.0 : 0.7,
          child: IgnorePointer(
            ignoring: !enabled,
            child: BlocDropdown(
              label: "District",
              icon: Icons.location_city,
              value: selected,
              items: items,
              onChanged: (val) {
                if (val == placeholder) return;
                bloc.add(DistrictChanged(val));
              },
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
                label: "Region",
                icon: Icons.map,
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
                icon: Icons.map,
                value: loading,
                items: const [loading],
                onChanged: (_) {},
              ),
            ),
          );
        }
        const placeholder = "Select Region";
        final items = [placeholder, ...s.regionOptions];
        final selected = s.region.isNotEmpty ? s.region : items.first;
        return BlocDropdown(
          label: "Region",
          icon: Icons.map,
          value: selected,
          items: items,
          onChanged: (val) {
            if (val == placeholder) return;
            bloc.add(RegionChanged(val));
          },
        );
      },
    ),
    SizedBox(height: 16),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, s) {
        if (s.region.isEmpty) {
          const blockMsg = "Select region first";
          return Opacity(
            opacity: 0.7,
            child: IgnorePointer(
              ignoring: true,
              child: BlocDropdown(
                label: "Division",
                icon: Icons.apartment,
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
                icon: Icons.apartment,
                value: loading,
                items: const [loading],
                onChanged: (_) {},
              ),
            ),
          );
        }
        const placeholder = "Select Division";
        final items = [placeholder, ...s.divisionOptions];
        final selected = s.division.isNotEmpty ? s.division : items.first;
        return BlocDropdown(
          label: "Division",
          icon: Icons.apartment,
          value: selected,
          items: items,
          onChanged: (val) {
            if (val == placeholder) return;
            bloc.add(DivisionChanged(val));
          },
        );
      },
    ),
    SizedBox(height: 16),
    BlocTextInput(
      label: "Area",
      icon: Icons.home,
      initialValue: state.area,
      onChanged: (val) => bloc.add(AreaChanged(val)),
    ),

    SizedBox(height: 16),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocTextInput(
          label: "Latitude",
          icon: Icons.explore,
          initialValue: state.Lattitude,
          onChanged: (val) => context.read<SampleFormBloc>().add(Lattitude(val)),
        );
      },
    ),
    SizedBox(height: 16),
    BlocBuilder<SampleFormBloc, SampleFormState>(
      builder: (context, state) {
        return BlocTextInput(
          label: "Longitude",
          icon: Icons.navigation_outlined,
          initialValue: state.Longitude,
          onChanged: (val) => context.read<SampleFormBloc>().add(Longitude(val)),
        );
      },
    ),

  ],
];

List<List<Widget>> getSampleDetailsSteps(SampleFormState state, SampleFormBloc bloc) {
  return [
    [
      BlocTextInput(
        label: "Sample Code Number",
        icon: Icons.qr_code,
        initialValue: state.sampleCodeData,
        onChanged: (val) => bloc.add(SampleCodeDataChanged(val)),
      ),
      SizedBox(height: 16),
      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocDatePicker(
            label: "Date of Collection",
            selectedDate: state.collectionDate, // coming from BLoC
            onChanged: (date) {
              context.read<SampleFormBloc>().add(CollectionDateChanged(date));
            },
          );
        },
      ),

      SizedBox(height: 16),
      BlocTextInput(
        label: "Place of Collection",
        icon: Icons.place,
        initialValue: state.placeOfCollection,
        onChanged: (val) => bloc.add(PlaceChanged(val)),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Sample Name",
        icon: Icons.label,
        initialValue: state.SampleName,
        onChanged: (val) => bloc.add(SampleNameChanged(val)),
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Quantity of Sample",
        icon: Icons.scale,
        initialValue: state.QuantitySample,
        onChanged: (val) => bloc.add(QuantitySampleChanged(val)),
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
                  icon: Icons.category,
                  value: loading,
                  items: const [loading],
                  onChanged: (_) {},
                ),
              ),
            );
          }
          const placeholder = "Select Nature of Sample";
          final items = [placeholder, ...s.natureOptions];
          final selected = s.article.isNotEmpty ? s.article : items.first;
          return BlocDropdown(
            label: "Nature of Sample",
            icon: Icons.category,
            value: selected,
            items: items,
            onChanged: (val) {
              if (val == placeholder) return;
              bloc.add(articleChanged(val));
            },
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
                value: state.preservativeAdded, // ← from BLoC state
                icon: Icons.add_circle_outline,
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
                  icon: Icons.medication,
                  initialValue: state.preservativeName,
                  onChanged: (val) => context.read<SampleFormBloc>().add(preservativeNameChanged(val)),
                ),
                SizedBox(height: 16),
                BlocTextInput(
                  label: "Quantity of Preservative",
                  icon: Icons.scale,
                  initialValue: state.preservativeQuantity,
                  onChanged: (val) => context.read<SampleFormBloc>().add(preservativeQuantityChanged(val)),
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
            icon: Icons.fingerprint,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(personSignatureChanged(newValue));
            },
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Paper Slip Number",
        icon: Icons.sticky_note_2,
        initialValue: state.slipNumber,
        onChanged: (val) => bloc.add(slipNumberChanged(val)),
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: 'Signature of DO OR any officer authorized by \nFSO',
            value: state.DOSignature, // ← from BLoC state
            icon: Icons.verified_user,
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
        icon: Icons.code,
        initialValue: state.sampleCodeNumber,
        onChanged: (val) => bloc.add(sampleCodeNumberChanged(val)),
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: 'Impression of seal of the sender ',
            value: state.sealImpression, // ← from BLoC state
            icon: Icons.verified,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(sealImpressionChanged(newValue)); // ← dispatch event
            },
          );
        },
      ),
      SizedBox(height: 16),
      BlocTextInput(
        label: "Number of Seal",
        icon: Icons.lock,
        initialValue: state.numberofSeal,
        onChanged: (val) => bloc.add(numberofSealChanged(val)),
      ),
      SizedBox(height: 16),

      BlocBuilder<SampleFormBloc, SampleFormState>(
        builder: (context, state) {
          return BlocYesNoRadio(
            label: 'Memorandum in Form VI (Sealed packed & \nSpecimen of the seal) ',
            value: state.formVI, // ← from BLoC state
            icon: Icons.description,
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
            label: 'Form VI is inside the sample Wrapper? ',
            value: state.FoemVIWrapper,
            icon: Icons.inventory,
            onChanged: (newValue) {
              context.read<SampleFormBloc>().add(FoemVIWrapperChanged(newValue)); // ← dispatch event
            },
          );
        },
      ),
    ],
  ];
}
 