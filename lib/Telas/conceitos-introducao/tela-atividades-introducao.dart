import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../jogo-introducao/quiz_levels_screen.dart';
import '../../appBar/app-bar.dart';
import '../jogo-introducao/tela-niveis-intro.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';
class ReviewActivitiesScreen extends StatelessWidget {
  const ReviewActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Atividades Introdutórias',
      ),
      body: BodyContainer(
        
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code, color: Colors.blue.shade300, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Hora de Começar!!!',
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bem-vindo à sua zona de prática! 🚀',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aqui você encontrará exercícios práticos que vão desde conceitos básicos até tópicos mais avançados da linguagem Python. Cada nível é uma oportunidade de fortalecer seus conhecimentos e desbloquear novas habilidades!',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber.shade300, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Progresso gradual e conquistas',
                            style: GoogleFonts.robotoMono(
                              color: Colors.amber.shade200,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.emoji_objects, color: Colors.orange.shade300, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dicas e curiosidades em cada exercício',
                            style: GoogleFonts.robotoMono(
                              color: Colors.orange.shade200,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.lock_open, color: Colors.green.shade300, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Desbloqueie novos níveis conforme avança',
                            style: GoogleFonts.robotoMono(
                              color: Colors.green.shade200,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Clique no botão abaixo para começar a prática!',
                style: GoogleFonts.robotoMono(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildActivityCard(
                      context,
                      'Completar Código',
                      Icons.code,
                      Colors.blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CodeCompletionLevelsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
            icon: Icons.home,
            color: Colors.deepPurple,
            navigateTo: const HomeScreen(),
          ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    String title,
    IconData icon,
    MaterialColor color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.shade700,
                color.shade900,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.robotoMono(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}
