import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noviindus_test/core/constants/colors.dart';
import 'package:noviindus_test/presentation/screens/patient_list/cubit/patient_list_cubit.dart';
import 'package:noviindus_test/presentation/screens/patient_list/widgets/patient_tile.dart';
import 'package:noviindus_test/presentation/widget/custom_appbar.dart';
import 'package:noviindus_test/presentation/widget/custom_button.dart';
import 'package:noviindus_test/presentation/widget/custom_text.dart';
import 'package:noviindus_test/presentation/widget/customtextfield.dart';
import 'package:noviindus_test/presentation/widget/spacing_extensions.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => PatientListCubit()..getPatients(),
        child: BlocBuilder<PatientListCubit, PatientListState>(
          builder: (context, state) {
            final cubit = context.read<PatientListCubit>();
            return Column(
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
                            child: Row(
                              children: [
                                const AppText(
                                  'Date',
                                  size: 14,
                                  color: Colors.black87,
                                ),
                                50.wBox,
                                const Icon(
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
                  child: ListView.builder(
                    itemCount: cubit.patients.length,
                    itemBuilder: (context, index) {
                      final patient = cubit.patients[index];
                      return PatientListTile(
                        patientNumber: patient['patientNumber'],
                        patientName: patient['patientName'],
                        packageName: patient['packageName'],
                        bookingDate: patient['bookingDate'],
                        assignedTo: patient['assignedTo'],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomButton(
                    onTap: () {},
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
            );
          },
        ),
      ),
    );
  }
}
