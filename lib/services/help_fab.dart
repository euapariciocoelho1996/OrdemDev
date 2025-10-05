// help_fab.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Cores/app_colors.dart';

class HelpFAB extends StatelessWidget {
  const HelpFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: FloatingActionButton(
        tooltip: 'Ajuda Rápida',
        backgroundColor: AppColors.cardYellow,
        elevation: 6,
        shape: const CircleBorder(), // garante que seja totalmente redondo
        child: const Icon(
          Icons.info_outline_rounded,
          size: 32,
          color: AppColors.background,
          semanticLabel: 'Ajuda',
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const HelpDialog(),
          );
        },
      ),
    );
  }
}

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: AppColors.primaryCard, width: 2),
      ),
      title: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.cardYellow, size: 28),
          const SizedBox(width: 10),
          Text(
            'Ajuda Rápida',
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Níveis com número: disponível\n'
              '• Nível com ✅: concluído\n'
              '• Nível com 🔒: bloqueado (complete o nível disponível para desbloquear o próximo)\n'
              '• Sem estresse! 🙂‍↕️ O botão de ajuda durante o quizz elimina uma alternativa errada.',
              style: GoogleFonts.robotoMono(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: AppColors.cardYellow),
          label: Text(
            'Fechar',
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
