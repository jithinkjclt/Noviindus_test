import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;

  const CustomAppBar({super.key, this.isBack = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      title: null,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                size: 28,
                Icons.notifications_none,
                color: Colors.black,
              ),
              onPressed: () {
                // Handle notification tap
              },
            ),
            Positioned(
              right: 11,
              top: 11,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
