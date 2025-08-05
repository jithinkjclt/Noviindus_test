import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noviindus_test/presentation/screens/login_page/cubit/login_cubit.dart';
import 'package:noviindus_test/presentation/widget/custom_button.dart';
import 'package:noviindus_test/presentation/widget/custom_text.dart';
import 'package:noviindus_test/presentation/widget/customtextfield.dart';
import 'package:noviindus_test/presentation/widget/page_navigation.dart';
import 'package:noviindus_test/presentation/widget/spacing_extensions.dart';

import '../../../core/constants/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: context.deviceSize.height / 3.5,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/loginimage.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(color: Colors.black.withOpacity(0.3)),
                  Positioned(
                    bottom: 50.0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        "assets/logo.png",
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: BlocProvider(
                create: (context) => LoginCubit(),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    // No listener actions defined in this version
                  },
                  builder: (context, state) {
                    final cubit = context.read<LoginCubit>();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        30.hBox,
                        AppText(
                          "Login or Register\nTo Book Your Appointments",
                          size: 24,
                          weight: FontWeight.w600,
                          color: textSecondaryColor,
                        ),
                        20.hBox,
                        CustomTextField(
                          controller: cubit.emailController,
                          hintText: "Enter your email",
                          boxname: "Email",
                        ),
                        25.hBox,
                        CustomTextField(
                          controller: cubit.passwordController,
                          hintText: "Enter password",
                          boxname: "Password",
                          isPassword: true,
                        ),
                        40.hBox,
                        CustomButton(
                          onTap: () {
                            // Screen.open(context, target)
                            // cubit.login(context);
                          },
                          fontSize: 17,
                          weight: FontWeight.w600,
                          text: "Login",
                          boxColor: buttonPrimaryColor,
                          textColor: Colors.white,
                          height: 50,
                          width: double.infinity,
                          borderRadius: 10,
                          isLoading: state is LoginLoading,
                        ),
                        SizedBox(height: context.deviceSize.height / 7),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  'By creating or logging into an account you are agreeing\nwith our ',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                height: 1.5,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                    color: textBlueColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy.',
                                  style: TextStyle(
                                    color: textBlueColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        10.hBox,
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
