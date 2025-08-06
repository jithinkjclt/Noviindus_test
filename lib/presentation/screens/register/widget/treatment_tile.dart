import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../widget/custom_text.dart';

class TreatmentTile extends StatelessWidget {
  final int leadingIndex;
  final String title;
  final int maleCount;
  final int femaleCount;
  final VoidCallback? onEditTap;
  final VoidCallback? onCloseTap;

  const TreatmentTile({
    super.key,
    required this.leadingIndex,
    required this.title,
    required this.maleCount,
    required this.femaleCount,
    this.onEditTap,
    this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: tileFillColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Index + Title + Close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  '$leadingIndex. $title',
                  size: 16.0,
                  weight: FontWeight.w500,
                  color: Colors.black87,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: onCloseTap,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE0E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFFD32F2F),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          /// Gender Counts + Edit
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildGenderCounter('Male', maleCount),
              const SizedBox(width: 16.0),
              _buildGenderCounter('Female', femaleCount),
              const SizedBox(width: 16.0),
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: buttonPrimaryColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCounter(String gender, int count) {
    return Row(
      children: [
        AppText(
          gender,
          size: 16.0,
          weight: FontWeight.w400,
          color: buttonPrimaryColor,
        ),
        const SizedBox(width: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: AppText(
            count.toString(),
            size: 16.0,
            weight: FontWeight.w400,
            color: buttonPrimaryColor,
          ),
        ),
      ],
    );
  }
}