import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../Cores/app_colors.dart';

class WelcomeSection extends StatefulWidget {
  const WelcomeSection({super.key});

  @override
  State<WelcomeSection> createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection> {
  final List<String> messages = [
    "Vamos codar!",
    "Novos desafios",
    "Foco & aprendizado",
    "Seu código, seu mundo",
    "Preparado para bugs?",
    "Vai ser épico!",
    "Prepare-se!",
    "Desafio aceito",
  ];

  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Atualiza a mensagem a cada 2 minutos
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone elegante com animação lenta
              const Icon(Icons.code, size: 30, color: Color.fromARGB(255, 99, 241, 130))
                  .animate()
                  .rotate(duration: const Duration(seconds: 4)),

              const SizedBox(width: 12),

              // Texto com AnimatedSwitcher para transição suave
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  messages[currentIndex],
                  key: ValueKey<int>(currentIndex),
                  style: GoogleFonts.robotoMono(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.textPrimary,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 0),
                        blurRadius: 8,
                        color: AppColors.accent.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
         
        ],
      ),
    )
        .animate()
        .scale(duration: 600.ms, curve: Curves.easeOutBack)
        .slide(begin: const Offset(0, -0.05), end: Offset.zero);
  }
}
