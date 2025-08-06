import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../data/datasources/api_service.dart';
import '../../../widget/custome_snackbar.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  List<Map<String, dynamic>> treatments = [];

  // controllers

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? location;
  String? branch;

  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController =
      TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? hour;
  String? minutes;

  void addTreatment(String treatmentName, int maleCount, int femaleCount) {
    final newTreatment = {
      'title': treatmentName,
      'maleCount': maleCount,
      'femaleCount': femaleCount,
    };
    treatments.add(newTreatment);
    emit(RegisterInitial());
  }

  void updateTreatment(
    int index,
    String treatmentName,
    int maleCount,
    int femaleCount,
  ) {
    if (index >= 0 && index < treatments.length) {
      treatments[index] = {
        'title': treatmentName,
        'maleCount': maleCount,
        'femaleCount': femaleCount,
      };
      emit(RegisterInitial());
    }
  }

  void removeTreatment(int index) {
    if (index >= 0 && index < treatments.length) {
      treatments.removeAt(index);
      emit(RegisterInitial());
    }
  }

  valueUpdate(String varible, String value) {
    varible = value;
    emit(RegisterInitial());

    print(varible);
  }

  void registor(BuildContext context) async {
    emit(RegisterLoading());

    final body = {
      "name": nameController.text.trim(),
      "phone": whatsappController.text.trim(),
      "address": addressController.text.trim(),
      "location": location,
      "branch": branch,
      "total_amount": totalAmountController.text.trim(),
      "discount_amount": discountAmountController.text.trim(),
      "advance_amount": advanceAmountController.text.trim(),
      "balance_amount": balanceAmountController.text.trim(),
      "date": dateController.text.trim(),
      "hour": hour,
      "minutes": minutes,
      "treatments": treatments,
    };

    final response = await ApiService.post(
      context: context,
      endpoint: "ApiEndpoints.register", // Replace with your actual endpoint
      body: body,
    );

    if (response['statusCode'] == 200 || response['statusCode'] == 201) {
      ShowCustomSnackbar.success(context, message: "Registration successful!");
      emit(RegisterSuccess());
      // Optionally clear controllers or reset form
    } else {
      final error = response['error'] ?? 'Registration failed';
      ShowCustomSnackbar.error(context, message: error);
      emit(RegisterError(error));
    }
  }

}
