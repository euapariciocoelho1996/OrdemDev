// Dart & Flutter Imports
import 'dart:async';
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
import '../../routes.dart';
import 'dart:io';
import '../../appBar/app-bar.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class RandomChallengeScreen extends StatefulWidget {
  const RandomChallengeScreen({super.key});

  @override
  State<RandomChallengeScreen> createState() => _RandomChallengeScreenState();
}

class _RandomChallengeScreenState extends State<RandomChallengeScreen> {
  static const int maxTime = 60; // segundos por pergunta
  late List<NewContentTask> allTasks;
  late NewContentTask currentTask;
  late List<NewContentTask> usedTasks;
  int questionNumber = 1;
  int scoreThisRun = 0;
  int timeLeft = maxTime;
  Timer? timer;
  bool showFeedback = false;
  bool isCorrect = false;
  int? selectedOptionIndex;
  bool challengeOver = false;
  bool started = false;
  int currentStreak = 0;
  int bestStreak = 0;
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  bool _navigatingHome = false;

  final List<String> correctTitles = ["Mandou bem! 🚀", "É isso aí! ✨", "Na mosca! 🎯", "Genial! 🧠"];
  final List<String> incorrectTitles = ["Opa, quase! 🤔", "Não foi dessa vez...", "Essa pegou, hein? 😅", "Continue tentando! 💪"];

  @override
  void initState() {
    super.initState();
    allTasks = _getAllTasks();
    usedTasks = [];
    Future.delayed(Duration.zero, _showOnboardingDialog);
    _loadFirstQuestion();
    _loadBestStreak();
    _startConnectivityWatcher();
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
        const Duration(seconds: 5),
        onTimeout: () => [],
      );
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loadBestStreak() async {
    bestStreak = await NewContentProgressService.getUserBestStreak();
    if (mounted) setState(() {});
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
              const Icon(Icons.flash_on, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Como funciona o Desafio Aleatório?',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
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
                  const Icon(Icons.timer, color: Colors.orangeAccent, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Você tem 60 segundos para cada pergunta! Responda rápido para ganhar mais pontos.',
                      style: GoogleFonts.robotoMono(
                          color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cada resposta certa soma pontos iguais ao tempo restante. Quanto mais rápido, maior a sua pontuação!',
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
                      'O desafio termina se errar uma resposta ou se o tempo acabar. Tente bater seu recorde! 🧠⚡',
                      style: GoogleFonts.robotoMono(
                          color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '🔥 Hardcore: Só os fortes sobrevivem!',
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
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
                _startTimer();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber,
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

  void _startTimer({bool reset = true}) {
    timer?.cancel();
    if (reset) {
      setState(() {
        timeLeft = maxTime;
      });
    }
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        t.cancel();
        await AudioService().playWrongSound();
        _endChallenge(timeout: true);
      }
    });
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
    if (started) {
      _startTimer(reset: true);
    }
    setState(() {});
  }

  void _checkAnswer(int selectedIndex) async {
    timer?.cancel();
    final isCorrectAnswer = selectedIndex == currentTask.shuffledCorrectIndex;
    
    // Feedback de vibração
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator ?? false) {
        if (isCorrectAnswer) {
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
      isCorrect = isCorrectAnswer;
      selectedOptionIndex = selectedIndex;
    });

    if (isCorrect) {
      await AudioService().playCorrectSound();
      final pointsGained = timeLeft;
      scoreThisRun += pointsGained;
      currentStreak++;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
        await NewContentProgressService.saveUserBestStreak(bestStreak);
      }
      _showFeedbackDialog(isCorrect: true, value: pointsGained, onNext: _nextQuestion);
    } else {
      await AudioService().playWrongSound();
      final streakBeforeReset = currentStreak;
      currentStreak = 0;
      _showFeedbackDialog(isCorrect: false, value: streakBeforeReset, onNext: null);
    }
  }

  void _showFeedbackDialog({required bool isCorrect, int? value, VoidCallback? onNext}) {
    final title = isCorrect ? (correctTitles..shuffle()).first : (incorrectTitles..shuffle()).first;

    final Color primaryColor = isCorrect ? Colors.greenAccent : Colors.redAccent;
    final Color secondaryColor = isCorrect ? const Color(0xFF43E97B) : const Color(0xFFF9385C);
    final IconData icon = isCorrect ? Icons.celebration_rounded : Icons.trending_down_rounded;

    final String pointsText;
    final String pointsLabel;
    final Widget summaryWidget;

    if (isCorrect) {
      pointsText = "+$value PONTOS";
      pointsLabel = "Você ganhou nesta jogada:";
      summaryWidget = Text.rich(
        TextSpan(
          style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 14),
          children: [
            const TextSpan(text: 'Sequência atual: '),
            TextSpan(
              text: '$currentStreak 🔥',
              style: const TextStyle(
                  color: Colors.orangeAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    } else {
      pointsText = "FIM DE JOGO";
      pointsLabel = "Sua sequência foi quebrada!";
      summaryWidget = Text.rich(
        TextSpan(
          style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 14),
          children: [
            const TextSpan(text: 'Você fez uma sequência de: '),
            TextSpan(
              text: '$value acertos',
              style: const TextStyle(
                  color: Colors.orangeAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    }

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
                      textAlign: TextAlign.center,
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
              )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5))
                  .fadeIn(),
              const SizedBox(height: 20),
              Text(
                isCorrect ? currentTask.feedbackCorrect : currentTask.feedbackIncorrect,
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
              summaryWidget,
            ],
          ),
          actionsAlignment: isCorrect ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          actions: [
            if (isCorrect)
              TextButton.icon(
                icon: const Icon(Icons.exit_to_app, size: 20),
                label: const Text('Encerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _endChallenge(timeout: false);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade400,
                  textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
                ),
              ),

            if(isCorrect)
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                label: const Text('Próxima!'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onNext!();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF101A2C),
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle:
                      GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            
            if (!isCorrect)
              ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart_rounded, size: 20),
                label: const Text('Ver Resultado'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _endChallenge(timeout: false);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF101A2C),
                  backgroundColor: Colors.amber,
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

  void _endChallenge({required bool timeout}) async {
    timer?.cancel();
    setState(() {
      challengeOver = true;
      showFeedback = false;
      currentStreak = 0;
    });

    if(scoreThisRun > 0) {
      await NewContentProgressService.addUserScore(scoreThisRun);
    }
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    int totalScore = await NewContentProgressService.getUserScore();
    int bestStreakSaved = await NewContentProgressService.getUserBestStreak();
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
              const Icon(Icons.flash_on, color: Colors.amber, size: 28),
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
              Text(
                timeout
                    ? 'O tempo acabou! Fique de olho no cronômetro e tente novamente para superar seu recorde.'
                    : '',
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.local_fire_department,
                      color: Colors.orangeAccent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Melhor sequência: $bestStreakSaved',
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Pontuação: $scoreThisRun',
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 22),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Pontuação total: $totalScore',
                      style: GoogleFonts.robotoMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                  scoreThisRun = 0;
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
              onPressed: () async {
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

  Future<bool> _showExitConfirmationDialog() async {
    if (!started || challengeOver || scoreThisRun == 0 || showFeedback) {
      return true;
    }
    
    timer?.cancel();
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Se sair agora, você perderá TODOS os pontos conquistados nesta rodada!\n\nTem certeza que deseja abandonar o desafio?',
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
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
    
    if (shouldExit != true && !challengeOver && started) {
      _startTimer(reset: false);
    }
    return shouldExit == true;
  }

  @override
  void dispose() {
    timer?.cancel();
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog();
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Desafio Aleatório',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.cyanAccent, width: 2),
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
                        ),
                      ),
                      const Spacer(),
                      Container(
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
                        child: Row(
                          children: [
                            Icon(Icons.timer,
                                size: 18, color: const Color(0xFF101A2C)),
                            const SizedBox(width: 6),
                            Text(
                              '$timeLeft s',
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
                            } else if (isCorrectOption) {
                              backgroundColor = Colors.green.withOpacity(0.18);
                              borderColor = Colors.green;
                              textColor = Colors.greenAccent;
                              icon = Icons.check_circle_outline;
                              iconColor = Colors.greenAccent;
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
                                if (isSelected || (isCorrectOption && showFeedback))
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
                                onTap: showFeedback || challengeOver || !started
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
      ),
    );
  }
}