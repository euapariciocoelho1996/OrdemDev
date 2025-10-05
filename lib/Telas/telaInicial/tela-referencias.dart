import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Cores/app_colors.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class StudyReferencesScreen extends StatelessWidget {
  const StudyReferencesScreen({Key? key}) : super(key: key);

  // Lista de dados para os livros
  static const List<StudyReference> _books = [
    StudyReference(
      title: "The C Programming Language",
      description: "Por Brian W. Kernighan e Dennis M. Ritchie (K&R). A bíblia do C.",
      icon: Icons.book,
    ),
    StudyReference(
      title: "C Primer Plus",
      description: "Por Stephen Prata. Excelente para iniciantes com exemplos detalhados.",
      icon: Icons.book_outlined,
    ),
    StudyReference(
      title: "Head First C",
      description: "Por David Griffiths & Dawn Griffiths. Uma abordagem visual e divertida.",
      icon: Icons.menu_book,
    ),
  ];

  // Lista de dados para websites e tutoriais
  static const List<StudyReference> _websites = [
    StudyReference(
      title: "Alura",
      description: "Plataforma brasileira com cursos de tecnologia, incluindo a formação em C.",
      icon: Icons.school,
    ),
    StudyReference(
      title: "Digital Innovation One (DIO)",
      description: "Plataforma com bootcamps e cursos gratuitos sobre C e outras tecnologias.",
      icon: Icons.rocket_launch,
    ),
    StudyReference(
      title: "Bóson Treinamentos",
      description: "Site e canal com centenas de aulas gratuitas sobre C, hardware e redes.",
      icon: Icons.desktop_windows,
    ),
    StudyReference(
      title: "GeeksforGeeks",
      description: "Artigos detalhados, tutoriais e problemas de programação.",
      icon: Icons.public,
    ),
    StudyReference(
      title: "TutorialsPoint",
      description: "Um guia completo e direto sobre a linguagem C.",
      icon: Icons.web,
    ),
  ];

  // Lista de dados para canais no YouTube
  static const List<StudyReference> _youtubeChannels = [
    StudyReference(
      title: "freeCodeCamp.org",
      description: "Cursos completos em vídeo, incluindo um sobre a linguagem C.",
      icon: Icons.smart_display,
    ),
    StudyReference(
      title: "The Cherno",
      description: "Vídeos de alta qualidade sobre C++ e conceitos aplicáveis a C.",
      icon: Icons.play_circle_outline,
    ),
  ];

  // Lista de dados para comunidades
  static const List<StudyReference> _communities = [
    StudyReference(
      title: "Stack Overflow",
      description: "A maior comunidade para tirar dúvidas de programação.",
      icon: Icons.forum,
    ),
    StudyReference(
      title: "r/C_Programming (Reddit)",
      description: "Subreddit dedicado a discussões e ajuda sobre a linguagem C.",
      icon: Icons.group,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Referências'),
      body: BodyContainer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle("Livros Essenciais"),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _buildReferenceList(_books),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Websites e Tutoriais"),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _buildReferenceList(_websites),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Canais no YouTube"),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _buildReferenceList(_youtubeChannels),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Comunidades e Fóruns"),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _buildReferenceList(_communities),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        icon: Icons.home,
        color: Colors.deepPurple,
        navigateTo: const HomeScreen(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.robotoMono(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  List<Widget> _buildReferenceList(List<StudyReference> references) {
    return references
        .map((ref) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                elevation: 2,
                color: AppColors.primaryCard,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  leading: Icon(ref.icon, color: AppColors.icon, size: 28),
                  title: Text(
                    ref.title,
                    style: GoogleFonts.robotoMono(
                        color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    ref.description,
                    style: GoogleFonts.robotoMono(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ))
        .toList();
  }
}

class StudyReference {
  final String title;
  final String description;
  final IconData icon;

  const StudyReference({
    required this.title,
    required this.description,
    required this.icon,
  });
}
