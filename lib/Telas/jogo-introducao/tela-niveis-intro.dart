import 'dart:async';
import 'dart:io';

import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:OrdemDev/body/BodyContainer.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../appBar/app-bar.dart';
import '../../Cores/app_colors.dart';
import '../../routes.dart';
import '../../services/botao_vidro.dart';
import '../../services/help_fab.dart';
import '../../services/progress_service.dart';
import '../../models/code_completion_models.dart';
import '../conceitos-introducao/tela-conceitos-fundamentais.dart';
import 'tela-quizz-intro.dart';
import '../../Telas/telaInicial/btn-home.dart';

class CodeCompletionLevelsScreen extends StatefulWidget {
  const CodeCompletionLevelsScreen({super.key});

  @override
  State<CodeCompletionLevelsScreen> createState() =>
      _CodeCompletionLevelsScreenState();
}

class _CodeCompletionLevelsScreenState
    extends State<CodeCompletionLevelsScreen> {
  List<int> completedLevels = [];
  List<int> unlockedLevels = [];
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  Timer? _connectivityTimer;
  bool _isNavigatingHome = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _startConnectivityWatcher();
    _startPeriodicConnectivityCheck();
  }

  Future<void> _loadProgress() async {
    final completed = await ProgressService.getCompletedLevels();
    final unlocked = await ProgressService.getUnlockedLevels();
    if (mounted) {
      setState(() {
        completedLevels = completed;
        unlockedLevels = unlocked;
      });
    }
  }

  void _startConnectivityWatcher() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((_) async {
      final hasNet = await _hasInternetAccess();
      if (!hasNet && !_isNavigatingHome && mounted) {
        _isNavigatingHome = true;
        _showNoInternetDialog();
      } else {
        _isNavigatingHome = false;
      }
    });
  }

  void _startPeriodicConnectivityCheck() {
    _connectivityTimer =
        Timer.periodic(const Duration(seconds: 2), (_) async {
      if (mounted) {
        final hasNet = await _hasInternetAccess();
        if (!hasNet && !_isNavigatingHome) {
          _isNavigatingHome = true;
          _showNoInternetDialog();
        } else {
          _isNavigatingHome = false;
        }
      }
    });
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(seconds: 5), onTimeout: () => []);
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.redAccent.shade400, width: 3),
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
            "Sua conexão com a internet foi perdida. 🤔\n\n"
            "Para continuar estudando, volte para a Home!",
            style: GoogleFonts.robotoMono(
                color: Colors.white70, fontSize: 16, height: 1.4),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.home, color: Colors.blueAccent),
              label: Text(
                "Ir para Home",
                style: GoogleFonts.robotoMono(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
                _isNavigatingHome = false;
              },
            ),
          ],
        ),
      ),
    ).then((_) => _isNavigatingHome = false);
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _connectivityTimer?.cancel();
    super.dispose();
  }

  bool _isLevelUnlocked(int levelId) => unlockedLevels.contains(levelId);
  bool _isLevelCompleted(int levelId) => completedLevels.contains(levelId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Níveis'),
      body: BodyContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: '<> PLAY TIME',
                  description:
                      'Explore os níveis disponíveis e teste suas habilidades de programação!',
                ),
                const SizedBox(height: 18),
                BotaoVidro(
                  texto: "Preciso Revisar",
                  icone: Icons.live_help,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const BasicConceptsScreen()),
                  ),
                ),
                const SizedBox(height: 24),
                // ===== Cards com animação premium =====
                ...List.generate(
                  codeCompletionLevels.length,
                  (index) {
                    final level = codeCompletionLevels[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildLevelCard(level)
                          .animate(
                            delay: Duration(milliseconds: 100 * index),
                          )
                          .fadeIn(duration: const Duration(milliseconds: 500))
                          .slideY(
                              begin: 0.3,
                              end: 0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic)
                          .scale(
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1.0, 1.0),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutBack),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const HelpFAB(),
    );
  }

  Widget _buildLevelCard(CodeCompletionLevel level) {
    final isUnlocked = _isLevelUnlocked(level.id);
    final isCompleted = _isLevelCompleted(level.id);

    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isUnlocked
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CodeCompletionTaskScreen(level: level)),
                ).then((_) => _loadProgress())
            : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isUnlocked
                  ? [AppColors.neutral80, Colors.blueGrey.shade800]
                  : [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _buildLevelCircle(level, isUnlocked, isCompleted),
              const SizedBox(width: 18),
              Expanded(child: _buildLevelInfo(level, isUnlocked, isCompleted)),
              if (!isUnlocked)
                const Icon(Icons.lock, color: Colors.white54, size: 22),
              if (isUnlocked && !isCompleted)
                const Icon(Icons.arrow_forward_ios,
                    color: AppColors.textSecondary, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCircle(
      CodeCompletionLevel level, bool isUnlocked, bool isCompleted) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green
            : isUnlocked
                ? AppColors.neutral80
                : Colors.blueGrey.shade700,
        shape: BoxShape.circle,
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : Text(
                '${level.id}',
                style: GoogleFonts.robotoMono(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
      ),
    );
  }

  Widget _buildLevelInfo(
      CodeCompletionLevel level, bool isUnlocked, bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          level.title,
          style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 17),
        ),
        const SizedBox(height: 4),
        Text(
          level.description,
          style: GoogleFonts.robotoMono(
              color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildDifficultyChip(level.difficulty),
            const SizedBox(width: 10),
            Icon(Icons.code, color: AppColors.textSecondary, size: 18),
            const SizedBox(width: 4),
            Text(
              '${level.tasks.length} tarefas',
              style: GoogleFonts.robotoMono(
                  color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultyChip(Difficulty difficulty) {
    final colorMap = {
      Difficulty.iniciante: Colors.green,
      Difficulty.basico: Colors.blue,
      Difficulty.intermediario: Colors.orange,
      Difficulty.avancado: Colors.red,
    };

    final textMap = {
      Difficulty.iniciante: 'Iniciante',
      Difficulty.basico: 'Básico',
      Difficulty.intermediario: 'Médio',
      Difficulty.avancado: 'Difícil',
    };

    final color = colorMap[difficulty]!;
    final text = textMap[difficulty]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.speed, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.robotoMono(
                color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
