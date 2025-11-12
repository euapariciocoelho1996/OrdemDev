import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart'; // ← IMPORTANTE

import '../../Cores/app_colors.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class StudyReferencesScreen extends StatelessWidget {
  const StudyReferencesScreen({Key? key}) : super(key: key);

  // Função para abrir links
  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Não foi possível abrir o link $url";
    }
  }

  static const List<StudyReference> _books = [
    StudyReference(
      title: "The C Programming Language",
      description: "Brian W. Kernighan e Dennis M. Ritchie.",
      icon: Icons.book,
      link: "https://books.google.com.br/books?hl=pt-BR&lr=&id=OpJ_0zpF7jIC&oi=fnd&pg=PP11",
    ),
    StudyReference(
      title: "C: Como Programar (6ª edição)",
      description: "Paul Deitel & Harvey Deitel.",
      icon: Icons.menu_book,
      link: "https://archive.org/details/c-como-programar-6ed-deitel",
    ),
    StudyReference(
      title: "C: Completo e Total",
      description: "Herbert Schildt.",
      icon: Icons.book_outlined,
      link: "https://d1wqtxts1xzle7.cloudfront.net/59132884/c_completo_e_total.pdf",
    ),
  ];

  static const List<StudyReference> _websites = [
    StudyReference(
      title: "GeeksforGeeks",
      description: "Tutoriais, exercícios e explicações detalhadas.",
      icon: Icons.public,
      link: "https://www.geeksforgeeks.org/",
    ),
    StudyReference(
      title: "W3Schools",
      description: "Introdução simples e direta à linguagem C.",
      icon: Icons.web,
      link: "https://www.w3schools.com/c/",
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
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _buildReferenceList(_books),
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Websites"),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: _buildReferenceList(_websites),
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
    return references.map((ref) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          onTap: () => _openLink(ref.link),
          child: Card(
            elevation: 2,
            color: AppColors.primaryCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: Icon(ref.icon, color: AppColors.icon, size: 28),
              title: Text(ref.title,
                  style: GoogleFonts.robotoMono(
                      color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              subtitle: Text(ref.description,
                  style: GoogleFonts.robotoMono(color: AppColors.textSecondary)),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class StudyReference {
  final String title;
  final String description;
  final IconData icon;
  final String link;

  const StudyReference({
    required this.title,
    required this.description,
    required this.icon,
    required this.link,
  });
}
