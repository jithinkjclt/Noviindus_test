import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../widget/custom_dropdown.dart';

class AddPatientsDialog extends StatefulWidget {
  final Function(String treatmentName, int maleCount, int femaleCount) onSave;
  final String? initialTreatmentName;
  final int? initialMaleCount;
  final int? initialFemaleCount;

  const AddPatientsDialog({
    super.key,
    required this.onSave,
    this.initialTreatmentName,
    this.initialMaleCount,
    this.initialFemaleCount,
  });

  @override
  _AddPatientsDialogState createState() => _AddPatientsDialogState();
}

class _AddPatientsDialogState extends State<AddPatientsDialog> {
  int _maleCount = 0;
  int _femaleCount = 0;
  String? _selectedTreatment;
  String? _validationMessage;

  final List<String> _treatments = const [
    'Couple Combo Package',
    'Abhyanga',
    'Panchakarma',
    'Shirodhara',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTreatmentName != null) {
      _selectedTreatment = widget.initialTreatmentName;
      _maleCount = widget.initialMaleCount ?? 0;
      _femaleCount = widget.initialFemaleCount ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomDropdownField<String>(
                boxname: 'Choose Treatment',
                hintText: _selectedTreatment ?? 'Choose preferred treatment',
                items: _treatments,
                itemAsString: (String treatment) => treatment,
                onItemSelected: (String? selectedTreatment) {
                  setState(() {
                    _selectedTreatment = selectedTreatment;
                    _validationMessage = null;
                  });
                },
                initialValue: _selectedTreatment,
                fillColor: textFieldFillColor,
                borderColor: textFormBorder,
                hintTextColor: textFormGrey,
              ),
              const SizedBox(height: 10),
              if (_validationMessage != null)
                Text(
                  _validationMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              const SizedBox(height: 14),
              const Text(
                "Add Patients",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPatientCounter("Male", _maleCount, (count) {
                setState(() {
                  _maleCount = count;
                  _validationMessage = null;
                });
              }),
              const SizedBox(height: 16),
              _buildPatientCounter("Female", _femaleCount, (count) {
                setState(() {
                  _femaleCount = count;
                  _validationMessage = null;
                });
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_selectedTreatment == null) {
                    setState(() {
                      _validationMessage = "Please choose a treatment.";
                    });
                    return;
                  }

                  if (_maleCount == 0 && _femaleCount == 0) {
                    setState(() {
                      _validationMessage = "Please add at least one patient.";
                    });
                    return;
                  }

                  widget.onSave(_selectedTreatment!, _maleCount, _femaleCount);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.initialTreatmentName != null ? "Update" : "Save",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCounter(String gender, int count, Function(int) onCountChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              gender,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                mini: true,
                backgroundColor: buttonPrimaryColor,
                child: const Icon(Icons.remove, color: Colors.white, size: 20),
                onPressed: () {
                  if (count > 0) {
                    onCountChanged(count - 1);
                  }
                },
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: buttonPrimaryColor,
                child: const Icon(Icons.add, color: Colors.white, size: 20),
                onPressed: () {
                  onCountChanged(count + 1);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}