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
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../routes.dart';
import 'dart:io';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import '../../appBar/app-bar.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class ComboRiskChallengeScreen extends StatefulWidget {
  const ComboRiskChallengeScreen({super.key});

  @override
  State<ComboRiskChallengeScreen> createState() => _ComboRiskChallengeScreenState();
}

class _ComboRiskChallengeScreenState extends State<ComboRiskChallengeScreen> {
  static const int maxTime = 60;
  static const double coringaChance = 0.2; // 20% de chance de pergunta coringa
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
  int correctAnswers = 0;
  bool isCoringa = false;
  bool lostOnCoringa = false;
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  bool _navigatingHome = false;

  @override
  void initState() {
    super.initState();
    allTasks = _getAllTasks();
    usedTasks = [];
    Future.delayed(Duration.zero, _showOnboardingDialog);
    _loadFirstQuestion();
    _startConnectivityWatcher();
  }

  void _startConnectivityWatcher() {
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((result) async {
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
                const Icon(Icons.wifi_off, color: Colors.redAccent, size: 28),
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
    isCoringa = Random().nextDouble() < coringaChance && questionNumber > 1;
    lostOnCoringa = false;
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
              Icon(Icons.warning_amber_rounded, color: Colors.yellow.shade700, size: 28),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Como funciona o Combo com Risco?',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade700,
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
                      style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 14),
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
                      'Cada resposta certa soma pontos iguais ao tempo restante. No final, sua pontuação será multiplicada pelo número de acertos!',
                      style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.yellow.shade700, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pergunta coringa: se errar, perde todos os pontos acumulados!',
                      style: GoogleFonts.robotoMono(color: Colors.yellow.shade200, fontSize: 14),
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
                _startTimer();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.yellow.shade700,
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
    isCoringa = Random().nextDouble() < coringaChance && questionNumber > 1;
    lostOnCoringa = false;
    if (started) {
      _startTimer(reset: true);
    }
    setState(() {});
  }

  void _checkAnswer(int selectedIndex) async {
    timer?.cancel();
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
      selectedOptionIndex = selectedIndex;
      this.isCorrect = isCorrect;
      showFeedback = true;
    });

    if (isCorrect) {
      await AudioService().playCorrectSound();
      int points = timeLeft;
      scoreThisRun += points;
      correctAnswers++;
      await Future.delayed(const Duration(milliseconds: 500));
      _showCorrectDialog();
    } else {
      await AudioService().playWrongSound();
      if (isCoringa) {
        lostOnCoringa = true;
        scoreThisRun = 0;
        correctAnswers = 0;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      _endChallenge(timeout: false);
    }
  }

  void _showCorrectDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Muito bem!',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Parabéns!',
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Você acertou! Quer continuar ou encerrar o desafio?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5)).fadeIn(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 200), _nextQuestion);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.greenAccent,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Próxima Pergunta'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEndSessionDialog();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Encerrar Desafio'),
            ),
          ],
        ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
      ),
    );
  }

  void _endChallenge({required bool timeout}) async {
    timer?.cancel();
    setState(() {
      challengeOver = true;
      showFeedback = false;
    });
    int finalScore = scoreThisRun * correctAnswers;
    await NewContentProgressService.addUserScore(finalScore);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF23272F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFF3C4250), width: 2),
          ),
          title: Row(
            children: [
              Icon(
                lostOnCoringa ? Icons.warning_amber_rounded : Icons.emoji_events,
                color: lostOnCoringa ? Colors.yellow.shade700 : Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  lostOnCoringa ? 'Pergunta Coringa Errada!' : 'Desafio Encerrado',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: lostOnCoringa ? Colors.yellow.shade700 : Colors.amber,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
                    colors: lostOnCoringa
                        ? [Colors.amberAccent, Colors.orangeAccent]
                        : [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (lostOnCoringa ? Colors.amber : Colors.greenAccent).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      lostOnCoringa ? 'Atenção:' : 'Resumo:',
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lostOnCoringa
                          ? 'Você errou a pergunta coringa e perdeu todos os pontos acumulados!'
                          : (timeout
                              ? 'O tempo acabou! Fique de olho no cronômetro e tente novamente.'
                              : 'Desafio encerrado! Veja sua pontuação abaixo.'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5)).fadeIn(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Pontos acumulados: $scoreThisRun',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, color: Colors.greenAccent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Acertos: $correctAnswers',
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
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
                  correctAnswers = 0;
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
                await NewContentProgressService.addUserScore(finalScore);
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
        ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
      ),
    );
  }

  void _showEndSessionDialog() {
    int finalScore = scoreThisRun * correctAnswers;
    
    // Função para truncar números grandes
    String formatScore(int score) {
      if (score >= 1000000) {
        return '${(score / 1000000).toStringAsFixed(1)}M...';
      } else if (score >= 1000) {
        return '${(score / 1000).toStringAsFixed(1)}K...';
      }
      return '$score';
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF23272F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFF3C4250), width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.flag, color: Colors.redAccent, size: 28),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Sessão Encerrada',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
                    colors: [Colors.pinkAccent.shade100, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Resumo:',
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Você optou por encerrar o desafio. Parabéns pelo seu desempenho até aqui! Continue praticando para superar seus recordes.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF101A2C),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5)).fadeIn(),
              const SizedBox(height: 16),
              
              // Mostra os pontos ganhos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Color(0xFF101A2C), size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Pontos Ganhos: ${formatScore(finalScore)}',
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF101A2C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${formatScore(scoreThisRun)}',
                              style: GoogleFonts.robotoMono(
                                color: const Color(0xFF101A2C),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Base',
                              style: GoogleFonts.robotoMono(
                                color: const Color(0xFF101A2C),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: const Color(0xFF101A2C).withOpacity(0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              '$correctAnswers',
                              style: GoogleFonts.robotoMono(
                                color: const Color(0xFF101A2C),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Acertos',
                              style: GoogleFonts.robotoMono(
                                color: const Color(0xFF101A2C),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: const Color(0xFF101A2C).withOpacity(0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              '×',
                              style: GoogleFonts.robotoMono(
                                color: const Color(0xFF101A2C),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Multiplicador',
                              style: GoogleFonts.robotoMono(
                                color: const Color(0xFF101A2C),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await NewContentProgressService.addUserScore(finalScore);
                Navigator.of(context).pop();
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
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
              const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 26),
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
        title: 'Combo com Risco',
        
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
                          gradient: isCoringa 
                            ? const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCoringa ? Colors.yellow.shade700 : Colors.cyanAccent, 
                            width: 2
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isCoringa ? Colors.yellow.shade700 : Colors.cyanAccent).withOpacity(0.18),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            if (isCoringa) ...[
                              Icon(Icons.warning_amber_rounded, 
                                   color: const Color(0xFF101A2C), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'CORINGA',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF101A2C),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ] else ...[
                              Text(
                                'Pergunta $questionNumber',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF101A2C),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ]
                          ],
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
                            const Icon(Icons.timer, size: 18, color: Color(0xFF101A2C)),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
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
                  Container(
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
                                currentTask.content.replaceAll('[OPCAO]', 'Por enquanto não há código aqui 😄'),
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