import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_inspector/l10n/app_localizations.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../utils/validators.dart';

BoxDecoration fieldBoxDecoration = BoxDecoration(

  color: customColors.white,
  borderRadius: BorderRadius.circular(5),

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ],
);





class BlocTextInput extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final IconData? icon;
  final bool readOnly;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const BlocTextInput({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.icon,
    this.readOnly = false,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  State<BlocTextInput> createState() => _BlocTextInputState();
}

class _BlocTextInputState extends State<BlocTextInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant BlocTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      enabled: !widget.readOnly,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: widget.readOnly ? Colors.black54 : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: '${AppLocalizations.of(context)?.enter ?? "Enter"} ${widget.label ?? ""}',
        hintStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: customColors.primary)
            : null,
        filled: true,
        fillColor: widget.readOnly ? Colors.grey.shade200 : customColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: customColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: customColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: customColors.primary,width: 0.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BlocDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final IconData? icon;
  final String? Function(String?)? validator;
  final Color? dropdownColor;

  const BlocDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.validator,
    this.dropdownColor,

  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return DropdownButtonFormField<String>(
      value: value != null && items.contains(value) ? value : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: theme.bodyMedium?.copyWith( // ✅ uses app default font
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      dropdownColor: dropdownColor ?? customColors.white,
      decoration: InputDecoration(
        hintText: 'Select $label',
        hintStyle: theme.bodyMedium?.copyWith( // ✅ theme font
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: icon != null ? Icon(icon, color: customColors.primary) : null,
        filled: true,
        fillColor: customColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: customColors.greyDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: customColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: customColors.primary, width: 0.5),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: theme.bodyMedium?.copyWith( // ✅ theme font
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
      validator: validator ??
              (val) => val == null || val.isEmpty ? '$label is required' : null,
    );
  }
}


class BlocDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final IconData? icon;

  const BlocDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onChanged(picked); // Trigger BLoC event
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Select Date',
          prefixIcon: icon != null
              ? Icon(icon, color: customColors.primary)
              : null,
          filled: true,
          fillColor: customColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: customColors.greyDivider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: customColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: customColors.primary, width: 0.5),
          ),
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
              : "Select Date",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class BlocSearchableDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final IconData? icon;
  final String? Function(String?)? validator;

  const BlocSearchableDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.validator,
  });

  @override
  State<BlocSearchableDropdown> createState() => _BlocSearchableDropdownState();
}

class _BlocSearchableDropdownState extends State<BlocSearchableDropdown> {
  late TextEditingController _searchController;
  List<String> _filteredItems = [];
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
    
    // Set initial text if value is provided
    if (widget.value != null && widget.value!.isNotEmpty) {
      _searchController.text = widget.value!;
    }
  }

  @override
  void didUpdateWidget(covariant BlocSearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update filtered items if items list changes
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
    
    // Update text field if value changes externally
    if (widget.value != oldWidget.value) {
      if (widget.value != null && widget.value!.isNotEmpty) {
        _searchController.text = widget.value!;
      } else {
        _searchController.clear();
      }
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _showDropdown() {
    if (_isDropdownOpen) return;
    
    _isDropdownOpen = true;
    _filteredItems = widget.items;
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    if (!_isDropdownOpen) return;
    
    _isDropdownOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: customColors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: customColors.primary, width: 0.5),
              ),
              child: _filteredItems.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No items found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return InkWell(
                          onTap: () {
                            _searchController.text = item;
                            widget.onChanged(item);
                            _hideDropdown();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: index < _filteredItems.length - 1
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_isDropdownOpen) {
            _hideDropdown();
          } else {
            _showDropdown();
          }
        },
        child: TextFormField(
          controller: _searchController,
          validator: widget.validator ??
              (val) => val == null || val.isEmpty ? '${widget.label} is required' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          onChanged: (value) {
            _filterItems(value);
            if (!_isDropdownOpen) {
              _showDropdown();
            }
          },
          onTap: () {
            if (!_isDropdownOpen) {
              _showDropdown();
            }
          },
          decoration: InputDecoration(
            hintText: 'Search ${widget.label}',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: customColors.primary)
                : null,
            suffixIcon: Icon(
              _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: customColors.primary,
            ),
            filled: true,
            fillColor: customColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: customColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: customColors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: customColors.primary, width: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    _searchController.dispose();
    super.dispose();
  }
}

class BlocYesNoRadio extends StatefulWidget {
  final String label;
  final bool? value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final String? Function(bool?)? validator;
  final bool autovalidate;

  const BlocYesNoRadio({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.validator,
    this.autovalidate = false,
  });

  @override
  State<BlocYesNoRadio> createState() => _BlocYesNoRadioState();
}

class _BlocYesNoRadioState extends State<BlocYesNoRadio> {
  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: widget.value,
      validator: widget.validator,

      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<bool> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: customColors.white,
                border: Border.all(
                    color: state.hasError
                        ? Colors.red
                        : customColors.primary,
                    width: 0.5
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.icon != null)
                        Icon(
                          widget.icon,
                          color: widget.value != null ? customColors.primary : customColors.primary,
                        ),
                      if (widget.icon != null) const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.label,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: widget.value,
                        visualDensity: VisualDensity.compact,
                        activeColor: customColors.primary,
                        onChanged: (val) {
                          if (val != null) {
                            widget.onChanged(val);
                            state.didChange(val);
                          }
                        },
                      ),
                      const Text("Yes", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 100),
                      Radio<bool>(
                        value: false,
                        groupValue: widget.value,
                        visualDensity: VisualDensity.compact,
                        activeColor: customColors.primary,
                        onChanged: (val) {
                          if (val != null) {
                            widget.onChanged(val);
                            state.didChange(val);
                          }
                        },
                      ),
                      const Text("No", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

