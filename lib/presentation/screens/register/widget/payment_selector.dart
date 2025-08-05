import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class PaymentMethodSelector extends StatefulWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildRadioOption('Cash'),
        buildRadioOption('Card'),
        buildRadioOption('UPI'),
      ],
    );
  }

  Widget buildRadioOption(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          activeColor: iconGreenColor,
          value: value,
          groupValue: _selected,
          onChanged: (newValue) {
            setState(() {
              _selected = newValue!;
            });
            widget.onChanged(newValue!);
          },
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
