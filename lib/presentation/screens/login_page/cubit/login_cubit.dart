import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../../../data/datasources/api_service.dart';
import '../../../../data/local/shared_pref.dart';
import '../../../widget/custome_snackbar.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(context) async {
    emit(LoginLoading());
    try {
      final response = await ApiService.post(
        context: context,
        endpoint: "Login",
        body: {
          "username": emailController.text,
          "password": passwordController.text,
        },
        requiresAuth: false,
      );

      if (response['statusCode'] == 200) {
      } else {
        final String errorMessage =
            response['error'] ?? 'Login failed. Please try again.';
        emit(LoginFailure(errorMessage));
        ShowCustomSnackbar.error(context, message: errorMessage);
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
      ShowCustomSnackbar.error(
        context,
        message: "An unexpected error occurred.",
      );
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
