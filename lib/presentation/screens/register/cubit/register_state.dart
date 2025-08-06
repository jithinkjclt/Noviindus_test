// lib/cubit/register_state.dart

part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}

class RegisterValidationError extends RegisterState {
  final String message;
  RegisterValidationError(this.message);
}

class TreatmentsLoaded extends RegisterState {}