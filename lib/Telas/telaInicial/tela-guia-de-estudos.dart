import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Cores/app_colors.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class StudyGuideScreen extends StatelessWidget {
  const StudyGuideScreen({Key? key}) : super(key: key);

  // Lista de dados para as dicas
  static const List<StudyTip> _studyTips = [
    StudyTip(
      tip: "Pratique todos os dias, mesmo que por pouco tempo.",
      icon: Icons.timer,
      color: AppColors.cardBlue,
    ),
    StudyTip(
      tip: "Não copie e cole. Digite o código para fixar.",
      icon: Icons.keyboard,
      color: AppColors.cardPurple,
    ),
    StudyTip(
      tip: "Compile e execute seu código frequentemente.",
      icon: Icons.play_circle_fill,
      color: AppColors.cardTeal,
    ),
    StudyTip(
      tip: "Entenda os ponteiros. Eles são o coração de C.",
      icon: Icons.link,
      color: AppColors.cardOrange,
    ),
    StudyTip(
      tip: "Leia códigos de outros desenvolvedores.",
      icon: Icons.group,
      color: AppColors.cardPink,
    ),
  ];

  // Lista de dados para os tópicos de estudo
  static const List<StudyTopic> _studyTopics = [
    StudyTopic(
      title: "Fundamentos",
      description: "Variáveis, tipos de dados e operadores.",
      icon: Icons.foundation,
    ),
    StudyTopic(
      title: "Estruturas de Controle",
      description: "Loops e condicionais (if, for, while).",
      icon: Icons.alt_route,
    ),
    StudyTopic(
      title: "Funções",
      description: "Crie blocos de código reutilizáveis.",
      icon: Icons.functions,
    ),
    StudyTopic(
      title: "Ponteiros e Memória",
      description: "Domine o gerenciamento de memória.",
      icon: Icons.memory,
    ),
    StudyTopic(
      title: "Arrays e Strings",
      description: "Trabalhe com coleções de dados.",
      icon: Icons.data_array,
    ),
    StudyTopic(
      title: "Structs e Unions",
      description: "Crie seus próprios tipos de dados.",
      icon: Icons.schema,
    ),
    StudyTopic(
      title: "Manipulação de Arquivos",
      description: "Leia e escreva em arquivos (I/O).",
      icon: Icons.folder_open,
    ),
    StudyTopic(
      title: "Pré-processador",
      description: "Macros e diretivas.",
      icon: Icons.settings_ethernet,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Guia de Estudos - C'),
      body: BodyContainer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Dicas de Estudo",
              style: GoogleFonts.robotoMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            // Animação em cascata para as dicas
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _studyTips.map(
                    (tip) => Card(
                      color: tip.color,
                      child: ListTile(
                        leading: Icon(tip.icon, color: Colors.white),
                        title: Text(
                          tip.tip,
                          style: GoogleFonts.robotoMono(color: Colors.white),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Tópicos de Estudo",
              style: GoogleFonts.robotoMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            // Animação em cascata para os tópicos
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _studyTopics.map(
                    (topic) => Card(
                      color: AppColors.primaryCard,
                      child: ListTile(
                        leading: Icon(topic.icon, color: AppColors.icon),
                        title: Text(
                          topic.title,
                          style: GoogleFonts.robotoMono(
                              color: AppColors.textPrimary),
                        ),
                        subtitle: Text(
                          topic.description,
                          style: GoogleFonts.robotoMono(
                              color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ).toList(),
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
}

// Modelo para dicas
class StudyTip {
  final String tip;
  final IconData icon;
  final Color color;

  const StudyTip({
    required this.tip,
    required this.icon,
    required this.color,
  });
}

// Modelo para tópicos
class StudyTopic {
  final String title;
  final String description;
  final IconData icon;

  const StudyTopic({
    required this.title,
    required this.description,
    required this.icon,
  });
}
