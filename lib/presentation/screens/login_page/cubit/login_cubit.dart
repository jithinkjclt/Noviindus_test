import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:noviindus_test/core/constants/variables.dart';
import 'package:noviindus_test/data/datasources/api_service.dart';
import 'package:noviindus_test/data/models/login_response_model.dart'; // Import the model
import '../../../widget/custome_snackbar.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> login(context) async {
    emit(LoginLoading());
    final Map<String, dynamic> requestBody = {
      "username": emailController.text,
      "password": passwordController.text,
    };
    try {
      final response = await ApiService.post(
        context: context,
        endpoint: "Login",
        body: requestBody,
        requiresAuth: false,
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        final LoginResponseModel loginResponse = LoginResponseModel.fromJson(
          response['data'],
        );
        if (loginResponse.status) {
          token = loginResponse.token;
          print(token);
          emit(LoginSuccess());
          ShowCustomSnackbar.success(context, message: loginResponse.message);
          return true;
        } else {
          final errorMessage =
              loginResponse.message ??
              'Login failed. Please check your credentials.';
          emit(LoginFailure(errorMessage));
          ShowCustomSnackbar.error(context, message: errorMessage);
          return false;
        }
      } else {
        final errorMessage =
            response['error'] ?? 'Login failed. Please check your credentials.';
        emit(LoginFailure(errorMessage));
        ShowCustomSnackbar.error(context, message: errorMessage);
        return false;
      }
    } catch (e) {
      emit(
        LoginFailure('An unexpected error occurred. Please try again later.'),
      );
      ShowCustomSnackbar.error(
        context,
        message: 'An unexpected error occurred. Please try again later.',
      );
      return false;
    }
  }
}
