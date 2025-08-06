import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:noviindus_test/core/constants/variables.dart';
import '../../../../data/datasources/api_service.dart';
import '../../../../data/models/patient_list_model.dart';
import '../../../../presentation/widget/custome_snackbar.dart';

part 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  PatientListCubit() : super(PatientListInitial());

  Future<void> getPatients(BuildContext context) async {
    emit(PatientListLoading());

    try {
      final response = await ApiService.get(
        context: context,
        endpoint: "PatientList",
        requiresAuth: true,
        token: token,
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        final PatientList patientList = PatientList.fromJson(response['data']);

        if (patientList.status) {
          emit(PatientListLoaded(patientList.patients));
        } else {
          final errorMessage = patientList.message;
          emit(PatientListFailure(errorMessage));
          ShowCustomSnackbar.error(context, message: errorMessage);
        }
      } else {
        final errorMessage =
            response['error'] ??
            'Something went wrong while fetching patient data.';
        emit(PatientListFailure(errorMessage));
        ShowCustomSnackbar.error(context, message: errorMessage);
      }
    } catch (e) {
      emit(PatientListFailure(e.toString()));
      ShowCustomSnackbar.error(context, message: e.toString());
    }
  }
}
