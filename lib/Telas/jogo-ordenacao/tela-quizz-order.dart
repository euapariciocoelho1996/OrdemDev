// Dart & Flutter Imports
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart'; // MUDANÇA: Tema padronizado
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart'; // MUDANÇA: Pacote de vibração adicionado

// Project Imports
import 'package:OrdemDev/body/BodyContainer.dart';
import '../../appBar/app-bar.dart';
import '../../models/new_content_models.dart';
import '../../routes.dart';
import '../../services/audio_service.dart';
import '../../services/new_content_progress_service.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class NewContentTaskScreen extends StatefulWidget {
  final NewContentLevel level;

  const NewContentTaskScreen({super.key, required this.level});

  @override
  State<NewContentTaskScreen> createState() => _NewContentTaskScreenState();
}

class _NewContentTaskScreenState extends State<NewContentTaskScreen> {
  // ===== VARIÁVEIS DE ESTADO =====
  late final AudioService _audioService;
  late ConfettiController _confettiController;
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  Timer? _connectivityTimer;

  int currentTaskIndex = 0;
  bool showFeedback = false;
  bool isCorrect = false;
  int? selectedOptionIndex;
  late List<bool> taskResults;
  bool _navigatingHome = false;
  int lives = 3;
  bool usedHelperThisRound = false;

  @override
  void initState() {
    super.initState();

    _audioService = AudioService();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    taskResults = List.filled(widget.level.tasks.length, false);

    _reshuffleAllTasks();
    _startConnectivityWatcher();
    _startPeriodicConnectivityCheck();
  }

  @override
  void dispose() {
    _audioService.dispose();
    _connectivitySub?.cancel();
    _connectivityTimer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  /// Getter for the current task based on the index.
  NewContentTask get currentTask => widget.level.tasks[currentTaskIndex];

  //============================================================================
  // Core Game Logic
  //============================================================================

  /// Checks the user's selected answer.
  void _checkAnswer(int selectedIndex) async {
    if (showFeedback) return;

    setState(() {
      selectedOptionIndex = selectedIndex;
      isCorrect = selectedIndex == currentTask.shuffledCorrectIndex;
      showFeedback = true;
    });

    // MUDANÇA: Lógica de vibração padronizada
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator ?? false) {
        if (isCorrect) {
          Vibration.vibrate(duration: 100); // Vibração curta para sucesso
        } else {
          Vibration.vibrate(pattern: [0, 200, 100, 200]); // Padrão para erro
        }
      }
    } catch (e) {
      print('Could not run vibration: $e');
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (isCorrect) {
      _audioService.playCongratulationsSound();
      taskResults[currentTaskIndex] = true;
      await _showCorrectAnswerDialog();
      _nextTask();
    } else {
      _audioService.playErrorSound();
      setState(() {
        lives--;
      });

      if (lives <= 0) {
        _showGameOverDialog();
      } else {
        await _showIncorrectAnswerDialog();
        setState(() {
          showFeedback = false;
          selectedOptionIndex = null;
        });
      }
    }
  }

  /// Moves to the next task or ends the level.
  void _nextTask() {
    if (currentTaskIndex < widget.level.tasks.length - 1) {
      setState(() {
        currentTaskIndex++;
        showFeedback = false;
        selectedOptionIndex = null;
      });
    } else {
      bool allTasksCorrect = taskResults.every((result) => result);
      if (allTasksCorrect) {
        _showLevelCompletionDialog();
      } else {
        _showMotivationalMessage();
      }
    }
  }

  /// Resets the level to its initial state.
  void _resetTasks() {
    setState(() {
      lives = 3;
      currentTaskIndex = 0;
      showFeedback = false;
      selectedOptionIndex = null;
      usedHelperThisRound = false;
      taskResults = List.filled(widget.level.tasks.length, false);
      _reshuffleAllTasks();
    });
  }

  /// Shuffles the options for all tasks in the level.
  void _reshuffleAllTasks() {
    for (var task in widget.level.tasks) {
      task.reshuffle();
    }
  }

  /// Logic for the helper button to eliminate a wrong option.
  void _useHelper() {
    if (usedHelperThisRound || lives <= 0 || showFeedback) return;

    final correctOption =
        currentTask.shuffledOptions[currentTask.shuffledCorrectIndex];
    final wrongOptions = currentTask.shuffledOptions
        .where((option) => option != correctOption)
        .toList();

    if (wrongOptions.isNotEmpty) {
      wrongOptions.shuffle();
      final optionToRemove = wrongOptions.first;

      final indexToRemove = currentTask.shuffledOptions.indexOf(optionToRemove);
      if (indexToRemove != -1) {
        setState(() {
          currentTask.shuffledOptions.removeAt(indexToRemove);
          usedHelperThisRound = true;

          if (indexToRemove < currentTask.shuffledCorrectIndex) {
            currentTask.shuffledCorrectIndex--;
          }
        });
      }
    }
  }

  //============================================================================
  // Connectivity Management (Sem alterações)
  //============================================================================

  void _startConnectivityWatcher() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((result) async {
      final hasNet = await _hasInternetAccess();

      if (!hasNet && mounted) {
        if (!_navigatingHome) {
          _navigatingHome = true;
          if (context.mounted) {
            _showNoInternetDialog();
          }
        }
      } else if (hasNet && mounted) {
        _navigatingHome = false;
      }
    });
  }

  void _startPeriodicConnectivityCheck() {
    _connectivityTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (mounted) {
        final hasNet = await _hasInternetAccess();

        if (!hasNet && !_navigatingHome) {
          _navigatingHome = true;
          if (context.mounted) {
            _showNoInternetDialog();
          }
        } else if (hasNet) {
          _navigatingHome = false;
        }
      }
    });
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

  //============================================================================
  // Dialogs & UI Feedback (Estrutura mantida)
  //============================================================================

  void _showNoInternetDialog() {
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
            content: Text(
              "Sua conexão com a internet foi perdida. 🤔\n\nPara continuar estudando, volte para a Home!",
              style: GoogleFonts.robotoMono(
                color: Colors.white70,
                fontSize: 16,
              ),
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
    ).then((_) {
      _navigatingHome = false;
    });
  }
  
  Future<void> _showCorrectAnswerDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side:
                  BorderSide(color: Colors.greenAccent.withOpacity(0.5), width: 2),
            ),
            title: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.greenAccent, size: 28),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "Correto!",
                    style: GoogleFonts.robotoMono(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  child: Text(
                    currentTask.feedbackCorrect.isNotEmpty
                        ? currentTask.feedbackCorrect
                        : "Excelente! Vamos para a próxima. 😉",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF101A2C),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    .animate()
                    .scale(
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                        begin: const Offset(0.5, 0.5))
                    .fadeIn(),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Próxima Questão',
                  style: GoogleFonts.robotoMono(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 200.ms)
              .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
        );
      },
    );
  }

  Future<void> _showIncorrectAnswerDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side:
                  BorderSide(color: Colors.redAccent.withOpacity(0.5), width: 2),
            ),
            title: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.redAccent, size: 28),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    "Incorreto!",
                    style: GoogleFonts.robotoMono(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  child: Text(
                    "Não desista! Você ainda tem $lives ${lives == 1 ? 'vida' : 'vidas'}.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF101A2C),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    .animate()
                    .scale(
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                        begin: const Offset(0.5, 0.5))
                    .fadeIn(),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Tentar Novamente',
                  style: GoogleFonts.robotoMono(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 200.ms)
              .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
        );
      },
    );
  }

  void _showGameOverDialog() {
    _audioService.playGameOverSound();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.redAccent.withOpacity(0.5), width: 3),
          ),
          title: Row(
            children: [
              const Icon(Icons.heart_broken, color: Colors.redAccent, size: 28),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  "Fim de Jogo!",
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                child: Text(
                  "Você perdeu todas as suas vidas! 💔\n\nO nível será reiniciado.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    color: const Color(0xFF101A2C),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  .animate()
                  .scale(
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0.5, 0.5))
                  .fadeIn(),
            ],
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.refresh, color: Colors.orangeAccent),
              label: Text(
                "Reiniciar",
                style: GoogleFonts.robotoMono(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _resetTasks();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMotivationalMessage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF23272F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side:
                BorderSide(color: Colors.orangeAccent.withOpacity(0.5), width: 2),
          ),
          title: Row(
            children: [
              const Icon(Icons.terminal, color: Colors.orangeAccent, size: 28),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Continue Tentando! 💪',
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.amberAccent.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Você está quase lá! Continue praticando para dominar o conteúdo.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    color: const Color(0xFF101A2C),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  .animate()
                  .scale(
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0.5, 0.5))
                  .fadeIn(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey.shade800),
                ),
                child: Text(
                  widget.level.feedbackFailure,
                  style: GoogleFonts.robotoMono(
                    fontSize: 14,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 14),
                  children: [
                    const TextSpan(text: 'Corretas: '),
                    TextSpan(
                        text: '${taskResults.where((e) => e).length}',
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' de '),
                    TextSpan(
                        text: '${widget.level.tasks.length}',
                        style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTasks();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.orangeAccent,
                textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
              ),
              child: const Text('Tentar Novamente'),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 200.ms)
            .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
      ),
    );
  }

  Future<void> _showLevelCompletionDialog() async {
    try {
      await _audioService.playCongratulationsSound();
      final completedLevels =
          await NewContentProgressService.getCompletedLevels();
      if (!completedLevels.contains(widget.level.id)) {
        completedLevels.add(widget.level.id);
        await NewContentProgressService.saveCompletedLevels(completedLevels);
        await NewContentProgressService.addUserScore(10);
      }
      final nextLevelId = widget.level.id + 1;
      final unlockedLevels =
          await NewContentProgressService.getUnlockedLevels();
      if (!unlockedLevels.contains(nextLevelId)) {
        unlockedLevels.add(nextLevelId);
        await NewContentProgressService.saveUnlockedLevels(unlockedLevels);
      }
      if (!mounted) return;
      _confettiController.play();

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              AlertDialog(
                backgroundColor: const Color(0xFF23272F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFF3C4250), width: 2),
                ),
                title: Row(
                  children: [
                    const Icon(Icons.terminal,
                        color: Colors.greenAccent, size: 28),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Parabéns! 🎉',
                        style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
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
                      'Você completou o nível com sucesso!',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueGrey.shade800),
                      ),
                      child: Text(
                        widget.level.feedbackSuccess,
                        style: GoogleFonts.robotoMono(
                          fontSize: 14,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.greenAccent, size: 20),
                        Text(
                          'Corretas: ${taskResults.where((e) => e).length} de ${widget.level.tasks.length} perguntas.',
                          style: GoogleFonts.robotoMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        const Icon(Icons.rocket_launch,
                            color: Colors.blueAccent, size: 20),
                        Text(
                          'Próximo nível desbloqueado!',
                          style: GoogleFonts.robotoMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.greenAccent,
                      textStyle:
                          GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Voltar aos Níveis'),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  maxBlastForce: 5,
                  minBlastForce: 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 15,
                  gravity: 0.1,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Erro ao salvar progresso: $e');
    }
  }
  
  //============================================================================
  // Build Method
  //============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Hora do QUIZZ!',
      ),
      body: BodyContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Task Counter & Lives
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
                        'Exercício ${currentTaskIndex + 1}/${widget.level.tasks.length}',
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
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade900,
                            Colors.redAccent.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.redAccent.shade100, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Animate(
                              target: lives > index ? 0.0 : 1.0,
                              effects: const [
                                ShakeEffect(
                                    duration: Duration(milliseconds: 300),
                                    hz: 4,
                                    rotation: 0.05)
                              ],
                              child: Icon(
                                index < lives
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Question Description
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                const SizedBox(height: 24),

                // MUDANÇA: Bloco de código com o novo widget estilizado
                if (currentTask.content.isNotEmpty) ...[
                  _CodeBlock(
                      code: currentTask.content.replaceAll('[OPCAO]', '___')),
                  const SizedBox(height: 20),
                ],

                // Answer Options
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...List.generate(
                      currentTask.shuffledOptions.length,
                      (index) {
                        final option = currentTask.shuffledOptions[index];
                        final isSelected = selectedOptionIndex == index;

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
                            icon =
                                isCorrect ? Icons.check_circle : Icons.cancel;
                            iconColor = isCorrect
                                ? Colors.greenAccent
                                : Colors.redAccent;
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!usedHelperThisRound && lives > 0 && !showFeedback)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 53, 164, 255),
                    Color.fromARGB(255, 83, 183, 255)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 0, 170, 255).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                heroTag: "helperBtn",
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: _useHelper,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.highlight_remove,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      'AJUDA',
                      style: GoogleFonts.robotoMono(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .scale(duration: 300.ms, curve: Curves.elasticOut)
                .fadeIn(),
          if (!usedHelperThisRound && lives > 0 && !showFeedback)
            const SizedBox(height: 16),
          CustomFloatingButton(
            icon: Icons.home,
            color: Colors.deepPurple,
            navigateTo: const HomeScreen(),
          ),
        ],
      ),
    );
  }
}

// MUDANÇA: Widget de Bloco de Código adicionado para consistência visual
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
                  'C', // Ajustado para o contexto da tela
                  style: GoogleFonts.robotoMono(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.copy, size: 18, color: Colors.white54),
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
            language: 'C', // Linguagem para o highlight
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