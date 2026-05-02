import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final double rightPadding;
  final double bottomPadding;

  const CustomFAB({
    super.key,
    required this.onPressed,
    this.rightPadding = 20,
    this.bottomPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding, bottom: bottomPadding),
      child: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: AppColors.neonGreen,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
