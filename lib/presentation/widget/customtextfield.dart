import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/colors.dart';
import 'custom_text.dart';

class CustomTextField extends StatefulWidget {
  final String? boxname;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? trailingIconSize;
  final Color? trailingIconColor;
  final double? height;
  final double? width;
  final bool readOnly;
  final double? textFieldHeight;
  final VoidCallback? onTrailingIconTap;
  final bool isEditable;
  final bool showCalendar;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color? hintTextColor;
  final Color? fillColor;
  final Color? borderColor;
  final bool noBorder;
  final double? boxNameSize;
  final Color? boxNameColor;
  final FontWeight? boxNameWeight;
  final double? hintTextSize;
  final FontWeight? hintTextWeight;

  const CustomTextField({
    super.key,
    this.boxname,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingIconSize = 24.0,
    this.trailingIconColor = Colors.black,
    this.height,
    this.width,
    this.onChanged,
    this.textFieldHeight = 50.0,
    this.onTrailingIconTap,
    this.isEditable = true,
    this.validator,
    this.readOnly = false,
    this.showCalendar = false,
    this.hintTextColor,
    this.fillColor,
    this.borderColor,
    this.noBorder = false,
    this.boxNameSize,
    this.boxNameColor,
    this.boxNameWeight,
    this.hintTextSize,
    this.hintTextWeight,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  void _showCustomCalendarDialog() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        widget.controller?.text = formattedDate;
        widget.onChanged?.call(formattedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color activeBorderColor = widget.noBorder
        ? Colors.transparent
        : (widget.borderColor ?? Colors.grey.shade300);

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: activeBorderColor, width: 1),
    );

    final InputBorder noBorderInput = InputBorder.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.boxname != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AppText(
              widget.boxname!,
              size: widget.boxNameSize ?? 16,
              color: widget.boxNameColor ?? textSecondaryColor,
              weight: widget.boxNameWeight ?? FontWeight.w400,
            ),
          ),
        SizedBox(
          width: widget.width,
          height: 48.0,
          child: TextFormField(
            validator: widget.validator,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _isObscured : false,
            readOnly: widget.readOnly || widget.showCalendar,
            enabled: widget.isEditable,
            onChanged: widget.onChanged,
            style: TextStyle(height: widget.height, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: widget.hintTextSize ?? 14,
                fontWeight: widget.hintTextWeight ?? FontWeight.w300,
                color: widget.hintTextColor ?? Colors.grey,
                height: 1.5,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              fillColor: widget.fillColor ?? textFieldFillColor,
              filled: true,
              border: widget.noBorder ? noBorderInput : baseBorder,
              focusedBorder: widget.noBorder ? noBorderInput : baseBorder,
              enabledBorder: widget.noBorder ? noBorderInput : baseBorder,
              disabledBorder: widget.noBorder ? noBorderInput : baseBorder,
              errorBorder: widget.noBorder
                  ? noBorderInput
                  : baseBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.red),
                    ),
              focusedErrorBorder: widget.noBorder
                  ? noBorderInput
                  : baseBorder.copyWith(
                      borderSide: const BorderSide(color: Colors.red),
                    ),
              errorStyle: const TextStyle(height: 0.01),
              prefixIcon: widget.leadingIcon != null
                  ? Icon(widget.leadingIcon, color: Colors.black, size: 20)
                  : null,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.trailingIcon != null)
                    GestureDetector(
                      onTap: widget.onTrailingIconTap,
                      child: Icon(
                        widget.trailingIcon,
                        size: widget.trailingIconSize,
                        color: widget.trailingIconColor,
                      ),
                    ),
                  if (widget.showCalendar)
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      onPressed: _showCustomCalendarDialog,
                      iconSize: 20,
                    ),
                  if (widget.isPassword)
                    IconButton(
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
