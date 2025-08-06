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
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText('$patientNumber.', weight: FontWeight.w600, size: 18),
                10.wBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        patientName.isNotEmpty ? patientName : 'Unknown',
                        weight: FontWeight.w600,
                        size: 16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.hBox,
                      AppText(
                        packageName.isNotEmpty ? packageName : 'N/A',
                        color: buttonPrimaryColor,
                        size: 14,
                        weight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      10.hBox,
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: redColor,
                          ),
                          4.wBox,
                          AppText(
                            bookingDate,
                            color: Colors.grey,
                            size: 13,
                            weight: FontWeight.w400,
                          ),
                          16.wBox,
                          const Icon(Icons.person, size: 14, color: redColor),
                          4.wBox,
                          AppText(
                            assignedTo,
                            color: Colors.grey,
                            size: 13,
                            weight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'View Booking details',
                    color: Colors.black87,
                    size: 14,
                    weight: FontWeight.w400,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: iconGreenColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
