import 'package:flutter/material.dart';
import '../../Cores/app_colors.dart';

class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color accentColor;

  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.accentColor = const Color.fromARGB(0, 252, 162, 17),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
         width: double.infinity, 
        margin:EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.cardColor,
          
          boxShadow: [
            BoxShadow(
              
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        ),
      ),
    );
  }
}
