import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Cores/app_colors.dart';

class AboutAppSection extends StatefulWidget {
  const AboutAppSection({super.key});

  @override
  State<AboutAppSection> createState() => _AboutAppSectionState();
}

class _AboutAppSectionState extends State<AboutAppSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // efeito cascata
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final listItems = const [
      _ListItem(
        icon: Icons.bolt,
        text: 'Acumular pontos a cada desafio concluído!',
        iconColor: Colors.amber,
      ),
      _ListItem(
        icon: Icons.emoji_events,
        text: 'Subir no ranking e comparar sua performance!',
        iconColor: Colors.purpleAccent,
      ),
      _ListItem(
        icon: Icons.extension,
        text: 'Ganhar pontos de diversas formas criativas!',
        iconColor: Colors.tealAccent,
      ),
      _ListItem(
        icon: Icons.more_horiz,
        text: 'E muito mais funções e conquistas te aguardam!',
        iconColor: Colors.orangeAccent,
      ),
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
      
        Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            // ALTERADO: Cor de fundo para uma cor sólida e consistente com o tema.
            color: Colors.white.withOpacity(0.08), 
            borderRadius: BorderRadius.circular(24.0),
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              RichText(
                text: TextSpan(
                  style: textTheme.titleLarge?.copyWith(
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                  children: [
                    const TextSpan(text: 'O que rola por '),
                    TextSpan(
                      text: 'aqui',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Lista animada
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(listItems.length, (index) {
                  final animation = CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      index * 0.2,
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  );
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: listItems[index],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        const Positioned(
          top: 8,
          right: 8,
          child: _PulsingFire(),
        ),
      ],
    );
  }
}

class _PulsingFire extends StatefulWidget {
  const _PulsingFire();

  @override
  State<_PulsingFire> createState() => _PulsingFireState();
}

class _PulsingFireState extends State<_PulsingFire>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: const Icon(
        Icons.workspace_premium,
        color: Colors.amberAccent,
        size: 30,
      ),
    );
  }
}

// 🌟 Itens da lista estilizados
class _ListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const _ListItem({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // ALTERADO: de 'gradient' para uma cor sólida para remover o brilho.
              color: iconColor.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyLarge?.copyWith(
                fontFamily: GoogleFonts.robotoMono().fontFamily,
                color: AppColors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}