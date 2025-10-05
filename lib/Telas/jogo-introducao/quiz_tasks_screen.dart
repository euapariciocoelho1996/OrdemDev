import 'package:OrdemDev/body/BodyContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para o Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart'; // Tema mais moderno
import '../../models/quiz_models.dart';
import '../../services/audio_service.dart';
import '../../appBar/app-bar.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';
class QuizTasksScreen extends StatefulWidget {
  final QuizLevel level;

  const QuizTasksScreen({
    super.key,
    required this.level,
  });

  @override
  State<QuizTasksScreen> createState() => _QuizTasksScreenState();
}

class _QuizTasksScreenState extends State<QuizTasksScreen> {
  late final AudioService _audioService;
  late ConfettiController _confettiController;
  int currentTaskIndex = 0;
  bool showFeedback = false;
  bool isCorrect = false;
  int? selectedOptionIndex;
  List<bool> taskResults = [];

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    taskResults = List.filled(widget.level.tasks.length, false);
    _reshuffleAllTasks();
  }

  void _reshuffleAllTasks() {
    for (var task in widget.level.tasks) {
      task.reshuffle();
    }
  }


  @override
  void dispose() {
    _audioService.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  QuizTask get currentTask => widget.level.tasks[currentTaskIndex];

  void _nextTask() {
    if (currentTaskIndex < widget.level.tasks.length - 1) {
      setState(() {
        currentTaskIndex++;
        showFeedback = false;
        selectedOptionIndex = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hora de Jogar!',
      ),
      body: BodyContainer(
        
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.cyanAccent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Tarefa ${currentTaskIndex + 1}/${widget.level.tasks.length}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF101A2C),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.greenAccent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.quiz, size: 18, color: Color(0xFF101A2C)),
                          const SizedBox(width: 6),
                          Text(
                            'Quiz',
                            style: GoogleFonts.robotoMono(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF101A2C),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Container com a descrição da tarefa
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currentTask.description,
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Bloco de código formatado (se existir)
                if (currentTask.question.isNotEmpty) ...[
                  _CodeBlock(code: currentTask.question),
                  const SizedBox(height: 20),
                ],

                const SizedBox(height: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...List.generate(
                      currentTask.shuffledOptions.length,
                      (index) {
                        final option = currentTask.shuffledOptions[index];
                        final isSelected = selectedOptionIndex == index;
                        final isCorrectOption = index == currentTask.shuffledCorrectIndex;
                        

                        Color backgroundColor = Colors.white.withOpacity(0.05);
                        Color borderColor = Colors.grey.shade800;
                        Color textColor = Colors.white;
                        IconData? icon;
                        Color? iconColor;

                        if (showFeedback) {
                          if (isSelected) {
                            backgroundColor = isCorrect
                                ? Colors.green.withOpacity(0.25)
                                : Colors.red.withOpacity(0.25);
                            borderColor = isCorrect ? Colors.green : Colors.red;
                            textColor = isCorrect
                                ? Colors.greenAccent
                                : Colors.redAccent;
                            icon = isCorrect ? Icons.check_circle : Icons.cancel;
                            iconColor = isCorrect
                                ? Colors.greenAccent
                                : Colors.redAccent;
                          } else if (isCorrectOption && isCorrect) {
                            backgroundColor = Colors.green.withOpacity(0.18);
                            borderColor = Colors.green;
                            textColor = Colors.greenAccent;
                            icon = Icons.check_circle_outline;
                            iconColor = Colors.greenAccent;
                          } else {
                            icon = Icons.radio_button_unchecked;
                            iconColor = Colors.grey.shade600;
                          }
                        } else if (isSelected) {
                          backgroundColor = Colors.blue.withOpacity(0.18);
                          borderColor = Colors.blueAccent;
                          textColor = Colors.blueAccent;
                          icon = Icons.radio_button_checked;
                          iconColor = Colors.blueAccent;
                        } else {
                          icon = Icons.radio_button_unchecked;
                          iconColor = Colors.grey.shade600;
                        }

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              if (isSelected || (isCorrectOption && isCorrect))
                                BoxShadow(
                                  color: borderColor.withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: showFeedback
                                  ? null
                                  : () => _checkAnswer(index),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 18),
                                child: Row(
                                  children: [
                                    Icon(icon, color: iconColor, size: 28),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: GoogleFonts.robotoMono(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn().slideX();
                      },
                    ),
                  ],
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

  void _showFeedbackDialog(
      bool isCorrect, String feedback, VoidCallback onNext) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF23272F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
                color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                width: 2),
          ),
          title: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.error,
                color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                size: 28,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  isCorrect ? 'Correto!' : 'Incorreto!',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isCorrect ? Colors.greenAccent : Colors.redAccent),
                ),
                child: Text(
                  feedback,
                  style: GoogleFonts.robotoMono(
                    fontSize: 15,
                    color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onNext();
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    isCorrect ? Colors.greenAccent : Colors.redAccent,
                textStyle:
                    GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: Text(
                currentTaskIndex < widget.level.tasks.length - 1
                    ? 'Próxima Tarefa'
                    : 'Concluir Nível',
              ),
            ),
          ],
        );
      },
    );
  }

  void _checkAnswer(int selectedIndex) {
    final isCorrect = selectedIndex == currentTask.shuffledCorrectIndex;
    setState(() {
      showFeedback = true;
      this.isCorrect = isCorrect;
      selectedOptionIndex = selectedIndex;
    });
    _showFeedbackDialog(
      isCorrect,
      isCorrect ? currentTask.feedbackCorrect : currentTask.feedbackIncorrect,
      _nextTask,
    );
  }
}

// --- Widget de Bloco de Código ---
class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF282c34), // Cor base do tema atom-one-dark
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'C',
                  style: GoogleFonts.robotoMono(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: Colors.white54),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado!')),
                    );
                  },
                ),
              ],
            ),
          ),
          HighlightView(
            code,
            language: 'c',
            theme: atomOneDarkTheme,
            padding: const EdgeInsets.all(16),
            textStyle: GoogleFonts.robotoMono(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.95);
  }
}
