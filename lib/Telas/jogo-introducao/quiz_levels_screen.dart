import 'package:OrdemDev/body/BodyContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/quiz_models.dart';
import '../../services/quiz_progress_service.dart';
import 'quiz_tasks_screen.dart';
import '../../appBar/app-bar.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';
class QuizLevelsScreen extends StatefulWidget {
  const QuizLevelsScreen({super.key});

  @override
  State<QuizLevelsScreen> createState() => _QuizLevelsScreenState();
}

class _QuizLevelsScreenState extends State<QuizLevelsScreen> {
  List<int> completedLevels = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedLevels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCompletedLevels();
  }

  Future<void> _loadCompletedLevels() async {
    final levels = await QuizProgressService.getCompletedLevels();
    if (mounted) {
      setState(() {
        completedLevels = levels;
      });
    }
  }

  bool isLevelUnlocked(int levelId) {
    if (levelId == 1) return true;
    final previousLevelId = levelId - 1;
    return completedLevels.contains(previousLevelId);
  }

  Future<void> _handleLevelCompletion(QuizLevel level) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizTasksScreen(level: level),
      ),
    ).then((_) {
      _loadCompletedLevels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Variáveis',
        
      ),
      body: BodyContainer(
        
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Escolha seu nível',
                  style: GoogleFonts.robotoMono(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 8),
                Text(
                  'Complete os níveis em sequência para desbloquear novos desafios',
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: quizLevels.length,
                    itemBuilder: (context, index) {
                      final level = quizLevels[index];
                      final isUnlocked = isLevelUnlocked(level.id);
                      final isCompleted = completedLevels.contains(level.id);
                      return _buildLevelCard(
                        context,
                        level: level,
                        isUnlocked: isUnlocked,
                        isCompleted: isCompleted,
                        onTap: isUnlocked
                            ? () => _handleLevelCompletion(level)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
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

  Widget _buildLevelCard(
    BuildContext context, {
    required QuizLevel level,
    required bool isUnlocked,
    required bool isCompleted,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: !isUnlocked
                  ? [Colors.grey.shade400, Colors.grey.shade600]
                  : isCompleted
                      ? [Colors.green.shade400, Colors.green.shade600]
                      : [Colors.orange.shade400, Colors.orange.shade600],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    !isUnlocked
                        ? Icons.lock
                        : isCompleted
                            ? Icons.check_circle
                            : Icons.star,
                    size: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nível ${level.id}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().scale(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
  }
}
