// Dart & Flutter Imports
import 'dart:math';
import 'package:OrdemDev/body/BodyContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart'; // Pacote para vibração

// Project Imports
import '../../models/new_content_models.dart';
import '../../services/new_content_progress_service.dart';
import '../../services/audio_service.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../../routes.dart';
import 'dart:io';
import '../../appBar/app-bar.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class AcertoOuPerdaChallengeScreen extends StatefulWidget {
  const AcertoOuPerdaChallengeScreen({super.key});

  @override
  State<AcertoOuPerdaChallengeScreen> createState() =>
      _AcertoOuPerdaChallengeScreenState();
}

class _AcertoOuPerdaChallengeScreenState
    extends State<AcertoOuPerdaChallengeScreen> {
  late List<NewContentTask> allTasks;
  late NewContentTask currentTask;
  late List<NewContentTask> usedTasks;
  int questionNumber = 1;
  int score = 0; // Pontos da rodada atual
  int totalScore = 0; // Pontos totais do usuário
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool showFeedback = false;
  bool isCorrect = false;
  int? selectedOptionIndex;
  bool challengeOver = false;
  bool started = false;
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  bool _navigatingHome = false;

  final List<String> correctTitles = ["Mandou bem! 🚀", "É isso aí! ✨", "Na mosca! 🎯", "Genial! 🧠"];
  final List<String> incorrectTitles = ["Opa, quase! 🤔", "Não foi dessa vez...", "Essa pegou, hein? 😅", "Continue tentando! 💪"];


  @override
  void initState() {
    super.initState();
    allTasks = _getAllTasks();
    usedTasks = [];
    _loadUserTotalScore();
    Future.delayed(Duration.zero, _showOnboardingDialog);
    _loadFirstQuestion();
    _startConnectivityWatcher();
  }

  Future<void> _loadUserTotalScore() async {
    totalScore = await NewContentProgressService.getUserScore();
  }

  void _startConnectivityWatcher() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((result) async {
      final hasNet = await _hasInternetAccess();

      if (!hasNet && mounted && !_navigatingHome) {
        _navigatingHome = true;
        if (context.mounted) {
          _showNoInternetDialog();
        }
      }
    });
  }

  void _showNoInternetDialog() {
    String statusMessage = "";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.redAccent.shade400,
                width: 3,
              ),
            ),
            title: Row(
              children: [
                const Icon(Icons.wifi_off,
                    color: Colors.redAccent, size: 28),
                const SizedBox(width: 10),
                Text(
                  "Sem conexão!",
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sua conexão com a internet foi perdida. 🤔\n\n"
                  "Para continuar estudando, volte para a Home!",
                  style: GoogleFonts.robotoMono(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                if (statusMessage.isNotEmpty)
                  Text(
                    statusMessage,
                    style: GoogleFonts.robotoMono(
                      color: Colors.redAccent.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.home, color: Colors.blue),
                label: Text(
                  "Ir para Home",
                  style: GoogleFonts.robotoMono(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.home,
                    (route) => false,
                  );
                  _navigatingHome = false;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('one.one.one.one').timeout(
        const Duration(seconds: 2),
        onTimeout: () => [],
      );
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  void _loadFirstQuestion() {
    if (allTasks.isEmpty) {
      allTasks = _getAllTasks();
      usedTasks.clear();
    }
    
    // Procura por uma questão válida (content vazio ou '[OPCAO]')
    NewContentTask? validTask;
    int attempts = 0;
    const maxAttempts = 100; // Evita loop infinito
    
    while (validTask == null && attempts < maxAttempts && allTasks.isNotEmpty) {
      final random = Random();
      final idx = random.nextInt(allTasks.length);
      final task = allTasks[idx];
      
      // Verifica se o content está vazio ou é '[OPCAO]'
      if (task.content.trim().isEmpty || task.content.trim() == '[OPCAO]') {
        validTask = task;
        allTasks.removeAt(idx);
      } else {
        // Remove a tarefa inválida da lista
        allTasks.removeAt(idx);
      }
      attempts++;
    }
    
    // Se não encontrou uma tarefa válida, recarrega todas as tarefas
    if (validTask == null) {
      allTasks = _getAllTasks();
      usedTasks.clear();
      return _loadFirstQuestion(); // Tenta novamente
    }
    
    currentTask = validTask;
    usedTasks.add(currentTask);
    currentTask.reshuffle();
    questionNumber = usedTasks.length;
    showFeedback = false;
    isCorrect = false;
    selectedOptionIndex = null;
    challengeOver = false;
    setState(() {});
  }

  void _showOnboardingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope( // Adicionado
        onWillPop: () async => false, // Adicionado
        child: AlertDialog(
          backgroundColor: const Color(0xFF23272F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF3C4250), width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.balance, color: Colors.lightBlueAccent, size: 28),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Como funciona o Acerto ou Perda?',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                    fontSize: 20,
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
              Row(
                children: [
                  const Icon(Icons.check, color: Colors.green, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cada resposta correta vale +5 pontos.',
                      style: GoogleFonts.robotoMono(
                          color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.close, color: Colors.redAccent, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cada resposta errada tira -3 pontos.',
                      style: GoogleFonts.robotoMono(
                          color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.timer_off, color: Colors.blueGrey, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sem limite de tempo. Você decide quando parar!',
                      style: GoogleFonts.robotoMono(
                          color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  started = true;
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlueAccent,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Começar!'),
            ),
          ],
        ),
      ),
    );
  }

  List<NewContentTask> _getAllTasks() {
    final List<NewContentTask> tasks = [];
    for (final level in newContentLevels) {
      tasks.addAll(level.tasks);
    }
    return tasks;
  }

  void _nextQuestion() {
    if (allTasks.isEmpty) {
      allTasks = _getAllTasks();
      usedTasks.clear();
    }
    
    // Procura por uma questão válida (content vazio ou '[OPCAO]')
    NewContentTask? validTask;
    int attempts = 0;
    const maxAttempts = 100; // Evita loop infinito
    
    while (validTask == null && attempts < maxAttempts && allTasks.isNotEmpty) {
      final random = Random();
      final idx = random.nextInt(allTasks.length);
      final task = allTasks[idx];
      
      // Verifica se o content está vazio ou é '[OPCAO]'
      if (task.content.trim().isEmpty || task.content.trim() == '[OPCAO]') {
        validTask = task;
        allTasks.removeAt(idx);
      } else {
        // Remove a tarefa inválida da lista
        allTasks.removeAt(idx);
      }
      attempts++;
    }
    
    // Se não encontrou uma tarefa válida, recarrega todas as tarefas
    if (validTask == null) {
      allTasks = _getAllTasks();
      usedTasks.clear();
      return _nextQuestion(); // Tenta novamente
    }
    
    currentTask = validTask;
    usedTasks.add(currentTask);
    currentTask.reshuffle();
    questionNumber = usedTasks.length;
    showFeedback = false;
    isCorrect = false;
    selectedOptionIndex = null;
    challengeOver = false;
    setState(() {});
  }

  void _checkAnswer(int selectedIndex) async {
    final isCorrect = selectedIndex == currentTask.shuffledCorrectIndex;
    
    // Feedback de vibração
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator ?? false) {
        if (isCorrect) {
          Vibration.vibrate(duration: 100);
        } else {
          Vibration.vibrate(pattern: [0, 200, 100, 200]);
        }
      }
    } catch (e) {
      print("Erro ao tentar vibrar: $e");
    }

    setState(() {
      showFeedback = true;
      this.isCorrect = isCorrect;
      selectedOptionIndex = selectedIndex;
    });

    if (isCorrect) {
      await AudioService().playCorrectSound();
      score += 5;
      correctAnswers++;
    } else {
      await AudioService().playWrongSound();
      totalScore = max(0, totalScore - 3);
      await NewContentProgressService.addUserScore(-3); 
      wrongAnswers++;
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {}); 

    _showFeedbackDialog(
      isCorrect,
      isCorrect ? currentTask.feedbackCorrect : currentTask.feedbackIncorrect,
      _nextQuestion,
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    if (!started || challengeOver || score == 0 || showFeedback) {
      return true;
    }
    bool? shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope( // Adicionado
        onWillPop: () async => false, // Adicionado
        child: AlertDialog(
          backgroundColor: const Color(0xFF23272F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF3C4250), width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.amber, size: 26),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Sair do Desafio?',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 19,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Text(
            score > 0 
            ? 'Se sair agora, você perderá os $score pontos conquistados nesta rodada!\n\nOs pontos já perdidos por erros continuarão perdidos.\n\nTem certeza que deseja abandonar o desafio?'
            : 'Se sair agora, você não ganhará pontos nesta rodada.\n\nOs pontos já perdidos por erros continuarão perdidos.\n\nTem certeza que deseja abandonar o desafio?',
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.greenAccent,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Continuar Jogando'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Sair e Perder Pontos'),
            ),
          ],
        ),
      ),
    );
    return shouldExit == true;
  }

  void _showFeedbackDialog(bool isCorrect, String feedback, VoidCallback onNext) {
    final title = isCorrect ? (correctTitles..shuffle()).first : (incorrectTitles..shuffle()).first;

    final Color primaryColor = isCorrect ? Colors.greenAccent : Colors.redAccent;
    final Color secondaryColor = isCorrect ? const Color(0xFF43E97B) : const Color(0xFFF9385C);
    final String pointsText = isCorrect ? "+5 PONTOS RODADA" : "-3 PONTOS TOTAL";
    final String pointsLabel = isCorrect ? "Você ganhou na rodada:" : "Pontos perdidos do total:";
    final IconData icon = isCorrect ? Icons.celebration_rounded : Icons.trending_down_rounded;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope( // Adicionado
        onWillPop: () async => false, // Adicionado
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: primaryColor.withOpacity(0.5), width: 2),
          ),
          title: Row(
            children: [
              Icon(icon, color: primaryColor, size: 28),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [secondaryColor, primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      pointsLabel,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pointsText,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ).animate()
               .scale(duration: 400.ms, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5))
               .fadeIn(),
              const SizedBox(height: 20),
              Text(
                feedback,
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(
                color: Color(0xFF3C4250),
                height: 32,
                thickness: 1,
              ),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 14),
                  children: [
                    const TextSpan(text: 'Placar da Rodada: '),
                    TextSpan(
                      text: '$correctAnswers',
                      style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' acertos vs '),
                    TextSpan(
                      text: '$wrongAnswers',
                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' erros'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.exit_to_app, size: 20),
              label: const Text('Encerrar'),
              onPressed: () {
                Navigator.of(context).pop();
                _endChallenge();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade400,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: const Text('Bora pra próxima!'),
              onPressed: () {
                Navigator.of(context).pop();
                onNext();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF101A2C),
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ).animate()
         .fadeIn(duration: 200.ms)
         .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
      ),
    );
  }

  void _endChallenge() async {
    setState(() {
      challengeOver = true;
      showFeedback = false;
    });

    if (score > 0) {
      await NewContentProgressService.addUserScore(score);
      totalScore += score; 
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope( // Adicionado
        onWillPop: () async => false, // Adicionado
        child: AlertDialog(
          backgroundColor: const Color(0xFF23272F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF3C4250), width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Desafio Encerrado',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
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
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Pontuação da Rodada',
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$score pontos',
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.check, color: Colors.greenAccent, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        '$correctAnswers',
                        style: GoogleFonts.robotoMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      Text(
                        'Acertos',
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade600,
                  ),
                  Column(
                    children: [
                      const Icon(Icons.cancel, color: Colors.redAccent, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        '$wrongAnswers',
                        style: GoogleFonts.robotoMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        'Erros',
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.blueAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Seus pontos totais: $totalScore',
                        style: GoogleFonts.robotoMono(
                          color: Colors.blueAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  score = 0; 
                  correctAnswers = 0;
                  wrongAnswers = 0;
                  usedTasks.clear();
                });
                _nextQuestion();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Jogar Novamente'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog();
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Acerto ou Perda',
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
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.cyanAccent, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.18),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'Pergunta $questionNumber',
                            style: GoogleFonts.robotoMono(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF101A2C),
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.greenAccent, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.18),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Color(0xFF101A2C)),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '$score pts rodada',
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF101A2C),
                                        letterSpacing: 0.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.account_balance_wallet,
                                      size: 16, color: Color(0xFF101A2C)),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '$totalScore total',
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF101A2C),
                                        letterSpacing: 0.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        currentTask.description,
                        style: GoogleFonts.robotoMono(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.4,
                          shadows: [
                            Shadow(
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(1, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 4,
                      radius: const Radius.circular(2),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 4,
                            radius: const Radius.circular(2),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: HighlightView(
                                currentTask.content.replaceAll(
                                    '[OPCAO]', 'Por enquanto não há código aqui 😄'),
                                language: 'python',
                                theme: monokaiSublimeTheme,
                                padding: const EdgeInsets.all(12),
                                textStyle: GoogleFonts.robotoMono(
                                  fontSize: 15,
                                  height: 1.4,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...List.generate(
                        currentTask.shuffledOptions.length,
                        (index) {
                          final option = currentTask.shuffledOptions[index];
                          final isSelected = selectedOptionIndex == index;
                          final isCorrectOption =
                              index == currentTask.shuffledCorrectIndex;

                          Color backgroundColor =
                              Colors.white.withOpacity(0.05);
                          Color borderColor = Colors.grey.shade800;
                          Color textColor = Colors.white;
                          IconData? icon;
                          Color? iconColor;

                          if (showFeedback) {
                            if (isSelected) {
                              backgroundColor = isCorrect
                                  ? Colors.green.withOpacity(0.25)
                                  : Colors.red.withOpacity(0.25);
                              borderColor =
                                  isCorrect ? Colors.green : Colors.red;
                              textColor = isCorrect
                                  ? Colors.greenAccent
                                  : Colors.redAccent;
                              icon =
                                  isCorrect ? Icons.check_circle : Icons.cancel;
                              iconColor = isCorrect
                                  ? Colors.greenAccent
                                  : Colors.redAccent;
                            } else if (isCorrectOption) { // Alterado para não mostrar a correta
                              icon = Icons.radio_button_unchecked;
                              iconColor = Colors.grey.shade600;
                            } else {
                              icon = Icons.radio_button_unchecked;
                              iconColor = Colors.grey.shade600;
                            }
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
                              border:
                                  Border.all(color: borderColor, width: 2),
                              boxShadow: [
                                if (isSelected)
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
                                onTap:
                                    showFeedback || challengeOver || !started
                                        ? null
                                        : () => _checkAnswer(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 18),
                                  child: Row(
                                    children: [
                                      Icon(icon,
                                          color: iconColor, size: 28),
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
      ),
    );
  }
}