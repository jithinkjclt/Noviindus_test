import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:noviindus_test/presentation/screens/login_page/loginpage.dart';
import 'package:noviindus_test/presentation/widget/page_navigation.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  splashing(context) async {
    await Future.delayed(Duration(seconds: 1));
    Screen.open(isAnimate: true, context, LoginPage());
    emit(SplashInitial());
  }
}
