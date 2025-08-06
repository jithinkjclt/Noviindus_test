import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../../../data/datasources/api_service.dart';

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
  final TextEditingController discountAmountController =
      TextEditingController();
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

  Future<void> registor(BuildContext context) async {
    print("registor function started.");
    emit(RegisterLoading());
    print("emitted RegisterLoading state.");
    print("object");
    if (nameController.text.trim().isEmpty) {
      print("nameController is empty. Emitting validation error.");
      emit(RegisterValidationError("Please enter a valid name."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("nameController is valid.");
    if (whatsappController.text.trim().isEmpty) {
      print("whatsappController is empty. Emitting validation error.");
      emit(RegisterValidationError("Please enter a valid WhatsApp number."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("whatsappController is valid.");
    if (addressController.text.trim().isEmpty) {
      print("addressController is empty. Emitting validation error.");
      emit(RegisterValidationError("Please enter a valid address."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("addressController is valid.");
    if (branch == null) {
      print("branch is null. Emitting validation error.");
      emit(RegisterValidationError("Please select a branch."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("branch is valid.");
    if (selectedTreatments.isEmpty) {
      print("selectedTreatments is empty. Emitting validation error.");
      emit(RegisterValidationError("Please add at least one treatment."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("selectedTreatments is valid.");
    if (dateController.text.trim().isEmpty || hour == null || minutes == null) {
      print("Date or time is missing. Emitting validation error.");
      emit(RegisterValidationError("Please select a valid date and time."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("Date and time are valid.");

    final totalAmount = double.tryParse(totalAmountController.text.trim());
    print("Parsed totalAmount: $totalAmount");
    if (totalAmount == null) {
      print("totalAmount is null. Emitting validation error.");
      emit(RegisterValidationError("Please enter a valid total amount."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("totalAmount is valid.");
    final discountAmount = double.tryParse(
      discountAmountController.text.trim(),
    );
    print("Parsed discountAmount: $discountAmount");
    if (discountAmount == null) {
      print("discountAmount is null. Emitting validation error.");
      emit(RegisterValidationError("Please enter a valid discount amount."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("discountAmount is valid.");
    final advanceAmount = double.tryParse(advanceAmountController.text.trim());
    print("Parsed advanceAmount: $advanceAmount");
    if (advanceAmount == null) {
      print("advanceAmount is null. Emitting validation error.");
      emit(RegisterValidationError("Please enter a valid advance amount."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("advanceAmount is valid.");
    final balanceAmount = double.tryParse(balanceAmountController.text.trim());
    print("Parsed balanceAmount: $balanceAmount");
    if (balanceAmount == null) {
      print("balanceAmount is null. Emitting validation error.");
      emit(RegisterValidationError("Please enter a valid balance amount."));
      print("emitted RegisterValidationError. Returning from function.");
      return;
    }
    print("balanceAmount is valid. All validations passed.");

    try {
      print("Starting try block for API call.");
      final List<String> maleTreatmentIds = [];
      print("Initialized maleTreatmentIds list.");
      final List<String> femaleTreatmentIds = [];
      print("Initialized femaleTreatmentIds list.");
      final Set<String> allTreatmentIds = {};
      print("Initialized allTreatmentIds set.");

      for (var treatment in selectedTreatments) {
        print("Processing treatment: ${treatment['title']}");
        if (treatment['maleCount'] > 0) {
          print("  - Adding male treatment ID: ${treatment['id']}");
          maleTreatmentIds.add(treatment['id'].toString());
        }
        if (treatment['femaleCount'] > 0) {
          print("  - Adding female treatment ID: ${treatment['id']}");
          femaleTreatmentIds.add(treatment['id'].toString());
        }
        print("  - Adding all treatment ID: ${treatment['id']}");
        allTreatmentIds.add(treatment['id'].toString());
      }
      print("Finished processing all selected treatments.");

      final date = DateFormat('yyyy-MM-dd').parse(dateController.text.trim());
      print("Parsed date: $date");
      final timeHour = int.tryParse(hour ?? '0') ?? 0;
      print("Parsed hour: $timeHour");
      final timeMinute = int.tryParse(minutes ?? '0') ?? 0;
      print("Parsed minutes: $timeMinute");
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        timeHour,
        timeMinute,
      );
      print("Constructed selectedDateTime: $selectedDateTime");
      final String formattedDateTime = DateFormat(
        'dd/MM/yyyy-hh:mm a',
      ).format(selectedDateTime);
      print("Formatted date and time: $formattedDateTime");

      final body = {
        "id": "",
        "name": nameController.text.trim(),
        "payment": paymentMethod,
        "phone": whatsappController.text.trim(),
        "address": addressController.text.trim(),
        "total_amount": totalAmount,
        "discount_amount": discountAmount,
        "advance_amount": advanceAmount,
        "balance_amount": balanceAmount,
        "date_nd_time": formattedDateTime,
        "male": maleTreatmentIds.join(","),
        "female": femaleTreatmentIds.join(","),
        "branch": branch ?? "",
        "treatments": allTreatmentIds.join(","),
      };
      print("Created API request body.");

      print("Register API Request Body: $body");
      print("Making API call with context: $context");
      final response = await ApiService.post(
        context: context,
        endpoint: "PatientUpdate",
        body: body,
      );
      print("API call returned. Response: $response");

      if (response['statusCode'] == 200) {
        print("API call was successful (status code 200).");
        emit(RegisterSuccess());
        print("emitted RegisterSuccess state.");
      } else {
        print("API call failed (status code was not 200).");
        final error = response['error'] ?? 'Registration failed';
        emit(RegisterError(error));
        print("emitted RegisterError state with message: $error");
      }
    } catch (e) {
      print("Caught an exception in the try block: $e");
      emit(RegisterError("Something went wrong."));
      print("emitted RegisterError state due to exception.");
    }
    print("registor function finished execution.");
  }
}
