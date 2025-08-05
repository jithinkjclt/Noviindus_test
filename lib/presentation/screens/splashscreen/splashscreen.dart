import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..splashing(context),
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          return Scaffold(
            body: SizedBox.expand(
              child: Image.asset(
                "assets/splashimage.png",
                fit: BoxFit.cover, // Makes the image cover the entire screen
              ),
            ),
          );
        },
      ),
    );
  }
}
