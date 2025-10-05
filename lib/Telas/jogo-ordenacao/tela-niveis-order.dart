import 'dart:async';
import 'dart:io';

import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:OrdemDev/body/BodyContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../appBar/app-bar.dart';
import '../../Cores/app_colors.dart';
import '../../routes.dart';
import '../../services/botao_vidro.dart';
import '../../services/help_fab.dart';
import '../../services/new_content_progress_service.dart';
import '../../models/new_content_models.dart';
import '../desafios/tela-desafio-aleatorio.dart';
import '../conceitos-ordenacao/tela-algoritmos-ordenacao.dart';
import 'tela-quizz-order.dart';
import '../../conexao/tela-perfil-usuario.dart';

class NewContentLevelsScreen extends StatefulWidget {
  const NewContentLevelsScreen({super.key});

  @override
  State<NewContentLevelsScreen> createState() => _NewContentLevelsScreenState();
}

class _NewContentLevelsScreenState extends State<NewContentLevelsScreen> {
  List<int> completedLevels = [];
  List<int> unlockedLevels = [];
  int userScore = 0;
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  Timer? _connectivityTimer;
  bool _navigatingHome = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadScore();
    _startConnectivityWatcher();
    _startPeriodicConnectivityCheck();
  }

  Future<void> _loadProgress() async {
    final completed = await NewContentProgressService.getCompletedLevels();
    final unlocked = await NewContentProgressService.getUnlockedLevels();
    if (mounted) {
      setState(() {
        completedLevels = completed;
        unlockedLevels = unlocked;
      });
    }
  }

  Future<void> _loadScore() async {
    final score = await NewContentProgressService.getUserScore();
    if (mounted) setState(() => userScore = score);
  }

  void _startConnectivityWatcher() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((_) async {
      final hasNet = await _hasInternetAccess();
      if (!hasNet && mounted && !_navigatingHome) {
        _navigatingHome = true;
        _showNoInternetDialog();
      } else if (hasNet && mounted) {
        _navigatingHome = false;
      }
    });
  }

  void _startPeriodicConnectivityCheck() {
    _connectivityTimer =
        Timer.periodic(const Duration(seconds: 2), (_) async {
      if (mounted) {
        final hasNet = await _hasInternetAccess();
        if (!hasNet && !_navigatingHome) {
          _navigatingHome = true;
          _showNoInternetDialog();
        } else {
          _navigatingHome = false;
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
              side: BorderSide(color: Colors.redAccent.shade400, width: 3)),
          title: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.redAccent, size: 28),
              const SizedBox(width: 10),
              Text(
                "Sem conexão!",
                style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontSize: 20),
              ),
            ],
          ),
          content: Text(
            "Sua conexão com a internet foi perdida. 🤔\n\n"
            "Para continuar estudando, volte para a Home!",
            style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 16),
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
                    .pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
                _navigatingHome = false;
              },
            ),
          ],
        ),
      ),
    ).then((_) => _navigatingHome = false);
  }

  bool _isLevelUnlocked(int levelId) => unlockedLevels.contains(levelId);
  bool _isLevelCompleted(int levelId) => completedLevels.contains(levelId);

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _connectivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Níveis'),
      body: BodyContainer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PageHeader(
                  title: '<> PLAY TIME',
                  description:
                      'Explore os níveis disponíveis e teste suas habilidades de programação!'),
              const SizedBox(height: 24),
              BotaoVidro(
                texto: "Preciso Revisar",
                icone: Icons.live_help,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SortingAlgorithmsScreen()),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "Sua Pontuação Atual:",
                  style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 18),
              _buildScoreBanner(),
              const SizedBox(height: 18),
              // ===== Cards de níveis com animação premium =====
              ...List.generate(newContentLevels.length, (index) {
                final level = newContentLevels[index];
                final isUnlocked = _isLevelUnlocked(level.id);
                final isCompleted = _isLevelCompleted(level.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildLevelCard(level, isUnlocked, isCompleted)
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
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: const HelpFAB(),
    );
  }

// Substitua o seu método _buildLevelCard existente por este.
Widget _buildLevelCard(level, bool isUnlocked, bool isCompleted) {
  return Card(
    color: Colors.transparent,
    shadowColor: Colors.transparent,
    clipBehavior: Clip.none,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: isUnlocked
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewContentTaskScreen(level: level),
                ),
              );
              _loadProgress();
              _loadScore();
            }
          : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
      
          Container(
         
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
                Container(
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
                                offset: const Offset(0, 3))
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
                ),
                const SizedBox(width: 18),
                Expanded(
                    child: Column(
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
                        Icon(Icons.code,
                            color: AppColors.textSecondary, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${level.tasks.length} tarefas',
                          style: GoogleFonts.robotoMono(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                )),
                if (!isUnlocked)
                  const Icon(Icons.lock, color: Colors.white54, size: 22),
                if (isUnlocked && !isCompleted)
                  const Icon(Icons.arrow_forward_ios,
                      color: AppColors.textSecondary, size: 22),
              ],
            ),
          ),

          // ===== INDICADOR DE PONTOS COM ANIMAÇÃO FINITA (SEM LOOP) =====
if (isCompleted)
  Positioned(
    top: -12,
    right: -8,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade700,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.military_tech, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            '+10',
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    )
    // ===== ANIMAÇÃO =====
    .animate()
    .fadeIn(duration: 300.ms)
    .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic)
    .shake(duration: 1800.ms, hz: 5, rotation: 0.04)
    // --- Pulso 1 ---
    .scale(end: const Offset(1.2, 1.2), duration: 400.ms, curve: Curves.easeOut)
    .then(delay: 50.ms)
    .scale(end: const Offset(1.0, 1.0), duration: 400.ms, curve: Curves.easeIn)
    // --- Pulso 2 ---
    .then(delay: 50.ms)
    .scale(end: const Offset(1.2, 1.2), duration: 400.ms, curve: Curves.easeOut)
    .then(delay: 50.ms)
    .scale(end: const Offset(1.0, 1.0), duration: 400.ms, curve: Curves.easeIn)
    // --- Final: encolher para versão menor (fixa) ---
    .then(delay: 200.ms)
    .scale(end: const Offset(0.6, 0.6), duration: 300.ms, curve: Curves.easeOut),
  ),

        ],
      ),
    ),
  );
}
  Widget _buildDifficultyChip(difficulty) {
    Color color;
    String text;
    switch (difficulty.toString()) {
      case 'NewContentDifficulty.iniciante':
        color = Colors.green;
        text = 'Básico';
        break;
      case 'NewContentDifficulty.basico':
      case 'NewContentDifficulty.intermediario':
        color = Colors.orange;
        text = 'Médio';
        break;
      case 'NewContentDifficulty.avancado':
        color = Colors.red;
        text = 'Avançado';
        break;
      default:
        color = Colors.grey;
        text = 'Desconhecido';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.speed, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: GoogleFonts.robotoMono(
                  color: color, fontSize: 12, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget _buildScoreBanner() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: userScore.toDouble()),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutExpo,
      builder: (context, value, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
              color: const Color(0xFF23272F),
              border: Border.all(color: const Color(0xFF3C4250), width: 2),
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              const Icon(Icons.emoji_events,
                  color: Colors.orangeAccent, size: 24),
              const SizedBox(width: 12),
              Text(
                '${value.round()} pts',
                style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.1),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    color: Colors.grey[400], size: 20),
                tooltip: 'Ver perfil',
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UserProfileScreen())),
              ),
            ],
          ),
        );
      },
    );
  }
}
