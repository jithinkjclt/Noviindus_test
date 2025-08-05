import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  PatientListCubit() : super(PatientListInitial());

  // dummy data
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

  getPatients() {}
}
