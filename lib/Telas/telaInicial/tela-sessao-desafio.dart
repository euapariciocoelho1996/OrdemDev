import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:OrdemDev/routes.dart';
import '../../Cores/app_colors.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class ChallengesSection extends StatelessWidget {
  final bool hasInternetConnection;
  final BuildContext parentContext;

  const ChallengesSection({
    super.key,
    required this.hasInternetConnection,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(title: 'DESAFIOS E PONTUAÇÃO', description: 'Complete atividades, resolva desafios e participe de quizzes para acumular pontos e subir no ranking!'),
        
        const SizedBox(height: 20),
        Card(
      
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: hasInternetConnection
                ? () {
                    Navigator.pushNamed(parentContext, AppRoutes.challengeHub);
                  }
                : null,
            borderRadius: BorderRadius.circular(16),
            child: // Defina sua cor de destaque para fácil reutilização


// ... dentro do seu widget
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
   
    color: AppColors.neutral80,
       
  ),
  child: Row(
    children: [
      if (!hasInternetConnection) ...[
        // A aparência "desativada" permanece a mesma (cinza)
        Icon(
          Icons.wifi_off,
          size: 44,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sem conexão',
                style: GoogleFonts.robotoMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Conecte-se à internet para acessar os desafios',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ] else ...[
        // Ícone com a nova cor de destaque
        Icon(
          Icons.psychology,
          size: 44,
          color: AppColors.icon,
          
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título com a cor de destaque
              Text(
                '+ Desafios',
                style: GoogleFonts.robotoMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary, // Cor do título alterada
                ),
              ),
              const SizedBox(height: 4),
              // Subtítulo em branco para boa legibilidade
              Text(
                'Teste seus conhecimentos em desafios únicos e ganhe pontos!',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary // Cor do subtítulo alterada
                ),
              ),
            ],
          ),
        ),
        // Ícone de seta com a cor de destaque
        Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: AppColors.textPrimary,
        ),
      ],
    ],
  ),
)
          ),
        ).animate().scale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            ),
      ],
    );
  }
}
