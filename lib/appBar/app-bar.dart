import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cores/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  

  const CustomAppBar({
    super.key,
    required this.title,
    th
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 2,
   
      iconTheme: const IconThemeData(
        color: Colors.orangeAccent,
      ),
      title: Text(
        title,
        style: GoogleFonts.robotoMono(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}