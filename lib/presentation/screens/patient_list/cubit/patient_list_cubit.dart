import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/datasources/api_service.dart';
import '../../../../presentation/widget/custome_snackbar.dart';

part 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  PatientListCubit(this.email, this.password) : super(PatientListInitial());
  final List<Map<String, dynamic>> patients = [
    {
      'patientNumber': 1,
      'patientName': 'Vikram Singh',
      'packageName': 'Couple Combo Package (Rejuven...',
      'bookingDate': '31/01/2024',
      'assignedTo': 'Jithesh',
    },
    {
      'patientNumber': 2,
      'patientName': 'Priya Sharma',
      'packageName': 'Detox & Wellness Program',
      'bookingDate': '15/02/2024',
      'assignedTo': 'Anil',
    },
    {
      'patientNumber': 3,
      'patientName': 'Rahul Kumar',
      'packageName': 'Stress Relief Therapy',
      'bookingDate': '01/03/2024',
      'assignedTo': 'Sunita',
    },
    {
      'patientNumber': 4,
      'patientName': 'Sneha Reddy',
      'packageName': 'Ayurvedic Rejuvenation',
      'bookingDate': '10/03/2024',
      'assignedTo': 'Mahesh',
    },
    // Add more patient data as needed
  ];

  final String email;
  final String password;

  Future<void> getPatients(context) async {
    emit(PatientListLoading());
    try {
      final response = await ApiService.post(
        context: context,
        endpoint: "GetPatientList", // 👈 Replace with actual endpoint name
        body: {
          "username": email,
          "password": password,
        },
        requiresAuth: false,
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        final List<Map<String, dynamic>> patients =
        List<Map<String, dynamic>>.from(response['data']);
        emit(PatientListLoaded(patients));
      } else {
        final String errorMessage =
            response['error'] ?? 'Failed to fetch patient list.';
        emit(PatientListFailure(errorMessage));
        ShowCustomSnackbar.error(context, message: errorMessage);
      }
    } catch (e) {
      emit(PatientListFailure(e.toString()));
      ShowCustomSnackbar.error(
        context,
        message: "An unexpected error occurred.",
      );
    }
  }
}
