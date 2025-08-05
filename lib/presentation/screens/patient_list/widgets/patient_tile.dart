import 'package:flutter/material.dart';
import 'package:noviindus_test/presentation/widget/spacing_extensions.dart';

import '../../../../core/constants/colors.dart';
import '../../../widget/custom_text.dart';

class PatientListTile extends StatelessWidget {
  final int patientNumber;
  final String patientName;
  final String packageName;
  final String bookingDate;
  final String assignedTo;

  const PatientListTile({
    Key? key,
    required this.patientNumber,
    required this.patientName,
    required this.packageName,
    required this.bookingDate,
    required this.assignedTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: tileBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      '$patientNumber.',
                      weight: FontWeight.w500,
                      size: 18,
                    ),
                    10.wBox, // Adjust this spacing as needed
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(patientName, weight: FontWeight.w500, size: 18),
                        8.hBox,
                        AppText(
                          packageName,
                          color: textGreenColor,
                          size: 14,
                          weight: FontWeight.w400,
                        ),
                        8.hBox,
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 13.0,
                              color: redColor,
                            ),
                            4.wBox,
                            AppText(
                              bookingDate,
                              color: Colors.grey,
                              size: 15,
                              weight: FontWeight.w400,
                            ),
                            16.wBox,
                            const Icon(
                              Icons.person,
                              size: 13.0,
                              color: redColor,
                            ),
                            4.wBox,
                            AppText(
                              assignedTo,
                              color: Colors.grey,
                              size: 15,
                              weight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            indent: 16.0,
            endIndent: 16.0,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'View Booking details',
                  color: Colors.black,
                  size: 14,
                  weight: FontWeight.w300,
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 20.0,
                  color: iconGreenColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
