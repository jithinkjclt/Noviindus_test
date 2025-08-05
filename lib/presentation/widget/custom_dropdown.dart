import 'package:flutter/material.dart';
import '../../core/constants/colors.dart'; // Ensure this import is correct

typedef ItemAsString<T> = String Function(T item);

class CustomDropdownField<T> extends StatefulWidget {
  final String? boxname;
  final String hintText;
  final List<T> items;
  final ItemAsString<T> itemAsString;
  final ValueChanged<T?>? onItemSelected;
  final T? initialValue;
  final String? Function(String?)? validator;
  final Color? hintTextColor;
  final double? width;
  final Color? highlightColor;
  final bool isTypable;
  final Color? fillColor;
  final Color? borderColor;
  final double? boxNameSize;
  final Color? boxNameColor;
  final FontWeight? boxNameWeight;
  final double? hintTextSize;
  final FontWeight? hintTextWeight;

  const CustomDropdownField({
    Key? key,
    this.boxname,
    this.hintText = 'Select an item',
    required this.items,
    required this.itemAsString,
    this.onItemSelected,
    this.initialValue,
    this.validator,
    this.hintTextColor,
    this.width,
    this.highlightColor,
    this.isTypable = true,
    this.fillColor,
    this.borderColor,
    this.boxNameSize,
    this.boxNameColor,
    this.boxNameWeight,
    this.hintTextSize,
    this.hintTextWeight,
  }) : super(key: key);

  @override
  _CustomDropdownFieldState<T> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  late TextEditingController _autocompleteController;
  late FocusNode _autocompleteFocusNode;
  final GlobalKey _inputFieldKey = GlobalKey();

  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _autocompleteController = TextEditingController();
    _autocompleteFocusNode = FocusNode();

    if (widget.initialValue != null) {
      _selectedItem = widget.initialValue;
      _autocompleteController.text = widget.itemAsString(_selectedItem!);
    }
  }

  @override
  void dispose() {
    _autocompleteController.dispose();
    _autocompleteFocusNode.dispose();
    super.dispose();
  }

  Iterable<String> _filterItems(TextEditingValue textEditingValue) {
    final List<String> itemStrings = widget.items
        .map((e) => widget.itemAsString(e))
        .toList();

    if (widget.isTypable) {
      if (textEditingValue.text.isEmpty) return itemStrings;
      return itemStrings.where(
        (name) =>
            name.toLowerCase().contains(textEditingValue.text.toLowerCase()),
      );
    } else {
      return itemStrings;
    }
  }

  String _displayStringForOption(String option) => option;

  @override
  Widget build(BuildContext context) {
    // Use colors from widget properties or fall back to local constants
    final fillColor = widget.fillColor ?? textFieldFillColor;
    final borderColor = widget.borderColor ?? textFormBorder;

    OutlineInputBorder _outlineBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.boxname != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.boxname!,
              // Match boxname style with CustomTextField
              style: TextStyle(
                fontSize: widget.boxNameSize ?? 16,
                color: widget.boxNameColor ?? textSecondaryColor,
                fontWeight: widget.boxNameWeight ?? FontWeight.w400,
              ),
            ),
          ),
        SizedBox(
          key: _inputFieldKey,
          width: widget.width,
          child: Autocomplete<String>(
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              _autocompleteController = controller;
              _autocompleteFocusNode = focusNode;

              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                validator: widget.validator,
                readOnly: !widget.isTypable,
                onTap: () => focusNode.requestFocus(),
                style: const TextStyle(fontSize: 14),
                // Match font size
                decoration: InputDecoration(
                  isDense: true,
                  // Match isDense
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: widget.hintTextSize ?? 14,
                    fontWeight: widget.hintTextWeight ?? FontWeight.w300,
                    color: widget.hintTextColor ?? Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  fillColor: fillColor,
                  filled: true,
                  border: _outlineBorder(borderColor),
                  focusedBorder: _outlineBorder(borderColor),
                  enabledBorder: _outlineBorder(borderColor),
                  errorBorder: _outlineBorder(Colors.red),
                  focusedErrorBorder: _outlineBorder(Colors.red),
                  errorStyle: const TextStyle(height: 0.01),
                  suffixIcon: _selectedItem != null
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: textFormGrey,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedItem = null;
                              _autocompleteController.clear();
                            });
                            widget.onItemSelected?.call(null);
                            _autocompleteFocusNode.unfocus();
                          },
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: iconGreenColor,
                            // Use the icon color from your CustomTextField
                            size: 24,
                          ),
                          onPressed: () => focusNode.requestFocus(),
                        ),
                ),
                onFieldSubmitted: (_) => onSubmitted(),
              );
            },
            optionsBuilder: _filterItems,
            onSelected: (String selected) {
              final selectedItem = widget.items.firstWhere(
                (item) => widget.itemAsString(item) == selected,
              );
              setState(() {
                _selectedItem = selectedItem;
                _autocompleteController.text = widget.itemAsString(
                  _selectedItem!,
                );
              });
              widget.onItemSelected?.call(_selectedItem);
              _autocompleteFocusNode.unfocus();
            },
            displayStringForOption: _displayStringForOption,
            optionsViewBuilder: (context, onSelected, options) {
              final RenderBox? box =
                  _inputFieldKey.currentContext?.findRenderObject()
                      as RenderBox?;
              final double inputWidth =
                  box?.size.width ?? MediaQuery.of(context).size.width;

              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                      minWidth: inputWidth,
                      maxWidth: inputWidth,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Scrollbar(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            thickness: 1,
                            color: textFormBorder,
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (_, index) {
                            final option = options.elementAt(index);
                            final item = widget.items.firstWhere(
                              (e) => widget.itemAsString(e) == option,
                              orElse: () => null as T,
                            );
                            final isSelected = (_selectedItem == item);

                            return InkWell(
                              onTap: () => onSelected(option),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? widget.highlightColor ??
                                            Colors.blue.withOpacity(0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.zero,
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: colorBlack,
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
            },
          ),
        ),
      ],
    );
  }
}
