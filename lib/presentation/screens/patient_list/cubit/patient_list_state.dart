part of 'patient_list_cubit.dart';

@immutable
sealed class PatientListState {}

final class PatientListInitial extends PatientListState {}

final class PatientListLoading extends PatientListState {}

final class PatientListLoaded extends PatientListState {
  final List<Map<String, dynamic>> patients;

  PatientListLoaded(this.patients);
}

final class PatientListFailure extends PatientListState {
  final String error;

  PatientListFailure(this.error);
}
