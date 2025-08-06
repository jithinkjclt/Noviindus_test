import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noviindus_test/presentation/screens/register/cubit/register_cubit.dart';
import 'package:noviindus_test/presentation/screens/register/widget/payment_selector.dart';
import 'package:noviindus_test/presentation/screens/register/widget/treatment_add.dart';
import 'package:noviindus_test/presentation/screens/register/widget/treatment_tile.dart';
import 'package:noviindus_test/presentation/widget/custom_text.dart';
import 'package:noviindus_test/presentation/widget/page_navigation.dart';
import 'package:noviindus_test/presentation/widget/pdf_preview_widget.dart';
import 'package:noviindus_test/presentation/widget/spacing_extensions.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/colors.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/customtextfield.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: colorWhite,
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            final cubit = context.read<RegisterCubit>();
            final treatments = cubit.treatments;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: AppText(
                      "Register",
                      weight: FontWeight.w600,
                      size: 24,
                      color: textSecondaryColor,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: cubit.nameController,
                          hintText: "Enter your Name",
                          boxname: "Name",
                        ),
                        15.hBox,
                        CustomTextField(
                          controller: cubit.whatsappController,

                          hintText: "Enter your Whatsapp Number",
                          boxname: "Whatsapp Number",
                          keyboardType: TextInputType.number,
                        ),
                        15.hBox,
                        CustomTextField(
                          controller: cubit.addressController,
                          hintText: "Enter your Address",
                          boxname: "Address",
                        ),
                        15.hBox,
                        CustomDropdownField<String>(
                          boxname: 'Location',
                          hintText: 'Choose your location',
                          items: const [
                            'Kozhikode',
                            'Bangalore',
                            'Chennai',
                            'Mumbai',
                            'Delhi',
                            'Hyderabad',
                          ],
                          itemAsString: (String location) => location,
                          onItemSelected: (String? selectedLocation) {
                            cubit.valueUpdate(
                              cubit.location!,
                              selectedLocation!,
                            );
                          },
                          fillColor: textFieldFillColor,
                          borderColor: textFormBorder,
                          hintTextColor: textFormGrey,
                        ),
                        15.hBox,
                        CustomDropdownField<String>(
                          boxname: 'Branch',
                          hintText: 'Choose your Branch',
                          items: const [
                            'Kozhikode',
                            'Bangalore',
                            'Chennai',
                            'Mumbai',
                            'Delhi',
                            'Hyderabad',
                          ],
                          itemAsString: (String location) => location,
                          onItemSelected: (String? selectedLocation) {
                            cubit.valueUpdate(cubit.branch!, selectedLocation!);
                          },
                          fillColor: textFieldFillColor,
                          borderColor: textFormBorder,
                          hintTextColor: textFormGrey,
                        ),
                        15.hBox,
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: treatments.length,
                          itemBuilder: (context, index) {
                            final treatment = treatments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: TreatmentTile(
                                leadingIndex: index + 1,
                                title: treatment['title'],
                                maleCount: treatment['maleCount'],
                                femaleCount: treatment['femaleCount'],
                                onEditTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddPatientsDialog(
                                        initialTreatmentName:
                                            treatment['title'],
                                        initialMaleCount:
                                            treatment['maleCount'],
                                        initialFemaleCount:
                                            treatment['femaleCount'],
                                        onSave:
                                            (
                                              treatmentName,
                                              maleCount,
                                              femaleCount,
                                            ) {
                                              cubit.updateTreatment(
                                                index,
                                                treatmentName,
                                                maleCount,
                                                femaleCount,
                                              );
                                            },
                                      );
                                    },
                                  );
                                },
                                onCloseTap: () {
                                  cubit.removeTreatment(index);
                                },
                              ),
                            );
                          },
                        ),
                        CustomButton(
                          iconSize: 18,
                          icon: Icons.add,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddPatientsDialog(
                                  onSave:
                                      (treatmentName, maleCount, femaleCount) {
                                        cubit.addTreatment(
                                          treatmentName,
                                          maleCount,
                                          femaleCount,
                                        );
                                      },
                                );
                              },
                            );
                          },
                          fontSize: 15,
                          weight: FontWeight.w500,
                          text: "Add Treatments",
                          boxColor: buttonSecondaryColor,
                          textColor: colorBlack,
                          height: 50,
                          width: double.infinity,
                          borderRadius: 10,
                        ),
                        15.hBox,
                        CustomTextField(
                          controller: cubit.totalAmountController,

                          hintText: "",
                          boxname: "Total Amount",
                          keyboardType: TextInputType.number,
                        ),
                        15.hBox,
                        CustomTextField(
                          controller: cubit.discountAmountController,

                          hintText: "",
                          boxname: "Discount Amount",
                          keyboardType: TextInputType.number,
                        ),
                        15.hBox,
                        AppText(
                          "Payment Option",
                          size: 16,
                          weight: FontWeight.w400,
                        ),
                        5.hBox,
                        PaymentMethodSelector(
                          selectedMethod: "Cash",
                          onChanged: (value) {},
                        ),
                        15.hBox,
                        CustomTextField(
                          controller: cubit.advanceAmountController,
                          hintText: "",
                          boxname: "Advance Amount",
                          keyboardType: TextInputType.number,
                        ),
                        15.hBox,
                        CustomTextField(
                          controller: cubit.balanceAmountController,
                          hintText: "",
                          boxname: "Balance Amount",
                          keyboardType: TextInputType.number,
                        ),
                        15.hBox,
                        CustomTextField(
                          controller: cubit.dateController,

                          boxname: "Select Date",
                          hintText: "yyyy-MM-dd",
                          showCalendar: true,
                          onChanged: (value) {},
                        ),
                        15.hBox,
                        AppText(
                          "Treatment Time",
                          size: 16,
                          weight: FontWeight.w400,
                        ),
                        10.hBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomDropdownField<String>(
                              width: MediaQuery.of(context).size.width / 2.3,
                              hintText: 'Hour',
                              items: List.generate(
                                12,
                                (index) =>
                                    (index + 1).toString().padLeft(2, '0'),
                              ),
                              itemAsString: (String hour) => hour,
                              onItemSelected: (String? selectedLocation) {
                                cubit.valueUpdate(
                                  cubit.hour!,
                                  selectedLocation!,
                                );
                              },
                              fillColor: textFieldFillColor,
                              borderColor: textFormBorder,
                              hintTextColor: textFormGrey,
                              isTypable: false,
                            ),
                            CustomDropdownField<String>(
                              width: context.deviceSize.width / 2.3,
                              hintText: 'Minutes',
                              items: List.generate(
                                60,
                                (index) =>
                                    (index + 1).toString().padLeft(2, '0'),
                              ),
                              itemAsString: (String location) => location,
                              onItemSelected: (String? selectedLocation) {
                                cubit.valueUpdate(
                                  cubit.minutes!,
                                  selectedLocation!,
                                );
                              },
                              fillColor: textFieldFillColor,
                              borderColor: textFormBorder,
                              isTypable: false,
                              hintTextColor: textFormGrey,
                            ),
                          ],
                        ),
                        50.hBox,
                        CustomButton(
                          iconSize: 18,
                          onTap: () async {
                            Screen.open(
                              context,
                              PdfPreview(
                                build: (format) => generatePdf(
                                  name: 'John Doe',
                                  whatsappNumber: '+91 9876543210',
                                  address: '123 Demo Street, Bangalore',
                                  bookedDate: '06/08/2025 at 10:30 AM',
                                  treatmentDate: '10/08/2025',
                                  treatmentTime: '12:00 PM',
                                  treatments: treatments
                                      .map(
                                        (e) => {
                                          'name': e['title'],
                                          'price': '₹300',
                                          'male': e['maleCount'].toString(),
                                          'female': e['femaleCount'].toString(),
                                          'total': '₹900',
                                        },
                                      )
                                      .toList(),
                                  totalAmount: '₹1400',
                                  discount: '₹200',
                                  advance: '₹500',
                                  balance: '₹700',
                                ),
                              ),
                            );
                          },
                          fontSize: 15,
                          weight: FontWeight.w500,
                          text: "Save",
                          boxColor: buttonPrimaryColor,
                          textColor: colorWhite,
                          height: 50,
                          width: double.infinity,
                          borderRadius: 10,
                        ),
                        100.hBox,
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
