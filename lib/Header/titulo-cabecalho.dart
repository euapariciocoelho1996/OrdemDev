import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Cores/app_colors.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String description;

  const PageHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Coluna para empilhar o título e a descrição verticalmente.
    return Column(
      children: [
        // Título
        Text(
          title, 
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoMono(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),

        const SizedBox(height: 12),

        // Descrição
        Text(
          description, 
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoMono(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
      ],
    );
  }
}