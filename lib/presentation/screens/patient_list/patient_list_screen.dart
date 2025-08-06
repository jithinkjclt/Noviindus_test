import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:noviindus_test/core/constants/colors.dart';
import 'package:noviindus_test/presentation/screens/patient_list/cubit/patient_list_cubit.dart';
import 'package:noviindus_test/presentation/screens/patient_list/widgets/patient_tile.dart';
import 'package:noviindus_test/presentation/widget/custom_appbar.dart';
import 'package:noviindus_test/presentation/widget/custom_button.dart';
import 'package:noviindus_test/presentation/widget/custom_text.dart';
import 'package:noviindus_test/presentation/widget/customtextfield.dart';
import 'package:noviindus_test/presentation/widget/spacing_extensions.dart';

import '../../widget/page_navigation.dart';
import '../register/register_page.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      backgroundColor: colorWhite,
      body: BlocProvider(
        create: (context) => PatientListCubit()..getPatients(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(
                        width: context.deviceSize.width / 1.5,
                        hintText: 'Search for treatments',
                        hintTextWeight: FontWeight.w400,
                        hintTextSize: 14,
                        leadingIcon: Icons.search,
                        borderColor: Colors.grey.shade400,
                        fillColor: Colors.white,
                        hintTextColor: Colors.grey.shade400,
                        noBorder: false,
                      ),
                      CustomButton(
                        onTap: () {},
                        fontSize: 12,
                        weight: FontWeight.w500,
                        text: "Search",
                        boxColor: buttonPrimaryColor,
                        textColor: Colors.white,
                        height: 45,
                        width: context.deviceSize.width / 4,
                        borderRadius: 10,
                      ),
                    ],
                  ),
                  15.hBox,
                  Row(
                    children: [
                      const AppText(
                        'Sort by :',
                        size: 16,
                        weight: FontWeight.w500,
                        color: textSecondaryColor,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Row(
                          children: [
                            AppText('Date', size: 14, color: Colors.black87),
                            SizedBox(width: 50),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: iconGreenColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            5.hBox,
            const Divider(),
            Expanded(
              child: BlocBuilder<PatientListCubit, PatientListState>(
                builder: (context, state) {
                  if (state is PatientListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: iconGreenColor),
                    );
                  } else if (state is PatientListLoaded) {
                    if (state.patients.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/empty.png',
                              height: context.deviceSize.height / 1.8,
                            ),
                            const SizedBox(height: 10),
                            // const Text("No patients found."),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: iconGreenColor,
                      onRefresh: () async {
                        await context.read<PatientListCubit>().getPatients(
                          context,
                        );
                      },
                      child: ListView.builder(
                        itemCount: state.patients.length,
                        itemBuilder: (context, index) {
                          final patient = state.patients[index];
                          final patientDetails =
                              patient.patientDetails.isNotEmpty
                              ? patient.patientDetails.first
                              : null;
                          final formattedDate = patient.dateAndTime != null
                              ? DateFormat(
                                  'dd MMM yyyy, hh:mm a',
                                ).format(patient.dateAndTime!)
                              : 'N/A';
                          return PatientListTile(
                            patientNumber: patient.id,
                            patientName: patient.name,
                            packageName: patientDetails?.treatmentName ?? 'N/A',
                            bookingDate: formattedDate,
                            assignedTo: patient.user,
                          );
                        },
                      ),
                    );
                  } else if (state is PatientListFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Something went wrong!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: iconGreenColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              context.read<PatientListCubit>().getPatients(
                                context,
                              );
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Reload',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomButton(
                onTap: () {
                  Screen.open(context, RegisterPage());
                },
                fontSize: 17,
                weight: FontWeight.w600,
                text: "Register Now",
                boxColor: buttonPrimaryColor,
                textColor: Colors.white,
                height: 50,
                width: double.infinity,
                borderRadius: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
