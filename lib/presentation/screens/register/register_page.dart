import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noviindus_test/presentation/screens/register/widget/payment_selector.dart';
import 'package:noviindus_test/presentation/screens/register/widget/treatment_add.dart';
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
      body: SingleChildScrollView(
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
                  CustomTextField(hintText: "Enter your Name", boxname: "Name"),
                  15.hBox,
                  CustomTextField(
                    hintText: "Enter your Whatsapp Number",
                    boxname: "Whatsapp Number",
                    keyboardType: TextInputType.number,
                  ),
                  15.hBox,
                  CustomTextField(
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
                    onItemSelected: (String? selectedLocation) {},
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
                    onItemSelected: (String? selectedLocation) {},
                    fillColor: textFieldFillColor,
                    borderColor: textFormBorder,
                    hintTextColor: textFormGrey,
                  ),
                  15.hBox,
                  CustomButton(
                    iconSize: 18,
                    icon: Icons.add,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddPatientsDialog();
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
                    hintText: "",
                    boxname: "Total Amount",
                    keyboardType: TextInputType.number,
                  ),
                  15.hBox,
                  CustomTextField(
                    hintText: "",
                    boxname: "Discount Amount",
                    keyboardType: TextInputType.number,
                  ),
                  15.hBox,

                  AppText("Payment Option", size: 16, weight: FontWeight.w400),
                  5.hBox,
                  PaymentMethodSelector(
                    selectedMethod: "Cash",
                    onChanged: (value) {},
                  ),
                  15.hBox,
                  CustomTextField(
                    hintText: "",
                    boxname: "Advance Amount",
                    keyboardType: TextInputType.number,
                  ),
                  15.hBox,
                  CustomTextField(
                    hintText: "",
                    boxname: "Balance Amount",
                    keyboardType: TextInputType.number,
                  ),
                  15.hBox,
                  CustomTextField(
                    boxname: "Select Date",
                    hintText: "yyyy-MM-dd",
                    controller: TextEditingController(),
                    showCalendar: true,
                    onChanged: (value) {},
                  ),
                  15.hBox,
                  AppText("Treatment Time", size: 16, weight: FontWeight.w400),

                  10.hBox,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomDropdownField<String>(
                        width: MediaQuery.of(context).size.width / 2.3,
                        hintText: 'Hour',
                        items: List.generate(
                          12,
                          (index) => (index + 1).toString().padLeft(2, '0'),
                        ),
                        itemAsString: (String hour) => hour,
                        onItemSelected: (String? selectedHour) {
                          // This is where you would handle the selected hour
                          print('Selected hour: $selectedHour');
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
                          (index) => (index + 1).toString().padLeft(2, '0'),
                        ),
                        itemAsString: (String location) => location,
                        onItemSelected: (String? selectedLocation) {},
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
                            treatments: [
                              {
                                'name': 'Panchakarma',
                                'price': '₹300',
                                'male': '2',
                                'female': '1',
                                'total': '₹900',
                              },
                              {
                                'name': 'Abhyanga',
                                'price': '₹500',
                                'male': '1',
                                'female': '0',
                                'total': '₹500',
                              },
                            ],
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
      ),
    );
  }
}
