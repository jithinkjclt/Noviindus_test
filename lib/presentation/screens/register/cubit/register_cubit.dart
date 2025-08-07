import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/variables.dart';
import '../../../../data/datasources/api_service.dart';
import 'package:meta/meta.dart';
part 'register_state.dart';
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  List<Map<String, dynamic>> allTreatments = [];
  List<Map<String, dynamic>> allBranches = [];
  List<Map<String, dynamic>> selectedTreatments = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController = TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? location;
  String? branch;
  String? hour;
  String? minutes;
  String paymentMethod = "Cash";
  void addTreatment(String treatmentName, int maleCount, int femaleCount) {
    final treatment = allTreatments.firstWhere(
          (t) => t['name'] == treatmentName,
      orElse: () => {},
    );
    if (treatment.isNotEmpty) {
      final newTreatment = {
        'id': treatment['id'],
        'title': treatmentName,
        'maleCount': maleCount,
        'femaleCount': femaleCount,
      };
      selectedTreatments.add(newTreatment);
      emit(RegisterInitial());
    }
  }
  void updateTreatment(
      int index,
      String treatmentName,
      int maleCount,
      int femaleCount,
      ) {
    if (index >= 0 && index < selectedTreatments.length) {
      selectedTreatments[index] = {
        'id': selectedTreatments[index]['id'],
        'title': treatmentName,
        'maleCount': maleCount,
        'femaleCount': femaleCount,
      };
      emit(RegisterInitial());
    }
  }
  void removeTreatment(int index) {
    if (index >= 0 && index < selectedTreatments.length) {
      selectedTreatments.removeAt(index);
      emit(RegisterInitial());
    }
  }
  void updateLocation(String? newLocation) {
    location = newLocation;
    emit(RegisterInitial());
  }
  void updateBranch(String? newBranch) {
    branch = newBranch;
    emit(RegisterInitial());
  }
  void updateHour(String? newHour) {
    hour = newHour;
    emit(RegisterInitial());
  }
  void updateMinutes(String? newMinutes) {
    minutes = newMinutes;
    emit(RegisterInitial());
  }
  void updatePaymentMethod(String method) {
    paymentMethod = method;
    emit(RegisterInitial());
  }
  Future<void> getTreatment(BuildContext context) async {
    emit(RegisterLoading());
    const String endpoint = "TreatmentList";
    final response = await ApiService.get(
      context: context,
      endpoint: endpoint,
      requiresAuth: true,
    );
    if (response['statusCode'] == 200 && response['data'] != null) {
      final data = response['data'];
      if (data['status'] == true && data['treatments'] is List) {
        final List<dynamic> treatmentData = data['treatments'];
        allTreatments = treatmentData.map((treatment) {
          return {'id': treatment['id'], 'name': treatment['name']};
        }).toList();
        emit(TreatmentsLoaded());
      } else {
        allTreatments = [];
        emit(RegisterError("Failed to load treatments."));
      }
    } else {
      allTreatments = [];
      emit(RegisterError("Failed to fetch data."));
    }
  }
  Future<void> getBranches(BuildContext context) async {
    const String endpoint = "BranchList";
    final response = await ApiService.get(
      context: context,
      endpoint: endpoint,
      requiresAuth: true,
    );
    if (response['statusCode'] == 200 && response['data'] != null) {
      final data = response['data'];
      if (data['status'] == true && data['branches'] is List) {
        final List<dynamic> branchData = data['branches'];
        allBranches = branchData.map((branch) {
          return {'id': branch['id'], 'name': branch['name']};
        }).toList();
        emit(RegisterInitial());
      } else {
        allBranches = [];
        emit(RegisterError("Failed to load branches."));
      }
    } else {
      allBranches = [];
      emit(RegisterError("Failed to fetch data."));
    }
  }
  Future<Map<String, dynamic>> registor(BuildContext context) async {
    emit(RegisterLoading());
    if (nameController.text.trim().isEmpty) {
      emit(RegisterValidationError("Please enter a valid name."));
      return {};
    }
    if (whatsappController.text.trim().isEmpty) {
      emit(RegisterValidationError("Please enter a valid WhatsApp number."));
      return {};
    }
    if (addressController.text.trim().isEmpty) {
      emit(RegisterValidationError("Please enter a valid address."));
      return {};
    }
    if (branch == null) {
      emit(RegisterValidationError("Please select a branch."));
      return {};
    }
    if (selectedTreatments.isEmpty) {
      emit(RegisterValidationError("Please add at least one treatment."));
      return {};
    }
    if (dateController.text.trim().isEmpty || hour == null || minutes == null) {
      emit(RegisterValidationError("Please select a valid date and time."));
      return {};
    }
    final totalAmount = double.tryParse(totalAmountController.text.trim());
    if (totalAmount == null) {
      emit(RegisterValidationError("Please enter a valid total amount."));
      return {};
    }
    final discountAmount = double.tryParse(
      discountAmountController.text.trim(),
    );
    if (discountAmount == null) {
      emit(RegisterValidationError("Please enter a valid discount amount."));
      return {};
    }
    final advanceAmount = double.tryParse(advanceAmountController.text.trim());
    if (advanceAmount == null) {
      emit(RegisterValidationError("Please enter a valid advance amount."));
      return {};
    }
    final balanceAmount = double.tryParse(balanceAmountController.text.trim());
    if (balanceAmount == null) {
      emit(RegisterValidationError("Please enter a valid balance amount."));
      return {};
    }
    try {
      final List<String> maleTreatmentIds = [];
      final List<String> femaleTreatmentIds = [];
      final Set<String> allTreatmentIds = {};
      for (var treatment in selectedTreatments) {
        if (treatment['maleCount'] > 0) {
          maleTreatmentIds.add(treatment['id'].toString());
        }
        if (treatment['femaleCount'] > 0) {
          femaleTreatmentIds.add(treatment['id'].toString());
        }
        allTreatmentIds.add(treatment['id'].toString());
      }
      final date = DateFormat('yyyy-MM-dd').parse(dateController.text.trim());
      final timeHour = int.tryParse(hour ?? '0') ?? 0;
      final timeMinute = int.tryParse(minutes ?? '0') ?? 0;
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        timeHour,
        timeMinute,
      );
      final String formattedDateTime = DateFormat(
        'dd/MM/yyyy-hh:mm a',
      ).format(selectedDateTime);
      final Map<String, String> body = {
        "id": "",
        "name": nameController.text.trim(),
        "excecutive": "Anjali R",
        "payment": paymentMethod,
        "phone": whatsappController.text.trim(),
        "address": addressController.text.trim(),
        "total_amount": totalAmount.toInt().toString(),
        "discount_amount": discountAmount.toInt().toString(),
        "advance_amount": advanceAmount.toInt().toString(),
        "balance_amount": balanceAmount.toInt().toString(),
        "date_nd_time": formattedDateTime,
        "male": maleTreatmentIds.join(","),
        "female": femaleTreatmentIds.join(","),
        "branch": branch.toString(),
        "treatments": allTreatmentIds.join(","),
      };
      final response = await ApiService.postFormData(
        context: context,
        endpoint: "PatientUpdate",
        body: body,
        token: token,
      );
      if (response['statusCode'] == 200) {
        emit(RegisterSuccess());
        return body;
      } else {
        final error = response['error'] ?? 'Registration failed';
        emit(RegisterError(error));
        return {};
      }
    } catch (e) {
      emit(RegisterError("Something went wrong."));
      return {};
    }
  }
}