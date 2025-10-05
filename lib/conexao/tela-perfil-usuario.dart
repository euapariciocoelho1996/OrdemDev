import 'package:OrdemDev/Telas/jogo-ordenacao/tela-niveis-order.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/new_content_progress_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../appBar/app-bar.dart';
import '../body/BodyContainer.dart';
import '../../Cores/app_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../Telas/jogo-introducao/tela-niveis-intro.dart';
import '../models/new_content_models.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int userScore = 0;
  int bestStreak = 0;
  List<int> completedLevels = [];
  List<int> unlockedLevels = [];
  int totalLevels = 0;
  // Variável para controlar se a lista de níveis está totalmente expandida
  bool _showAllLevels = false;

  @override
  void initState() {
    super.initState();
    _loadScore();
    _loadBestStreak();
    _loadLevels();
  }

  Future<void> _loadScore() async {
    final score = await NewContentProgressService.getUserScore();
    if (mounted) setState(() => userScore = score);
  }

  Future<void> _loadBestStreak() async {
    final streak = await NewContentProgressService.getUserBestStreak();
    if (mounted) setState(() => bestStreak = streak);
  }

  Future<void> _loadLevels() async {
    try {
      final completed = await NewContentProgressService.getCompletedLevels();
      final unlocked = await NewContentProgressService.getUnlockedLevels();
      final officialTotal = newContentLevels.length;
      final maxId = [...completed, ...unlocked]
          .fold<int>(0, (prev, el) => el > prev ? el : prev);
      final estimatedTotal =
          officialTotal > 0 ? officialTotal : (maxId > 0 ? maxId : 10);
      if (!mounted) return;
      setState(() {
        completedLevels = List<int>.from(completed)..sort();
        unlockedLevels = List<int>.from(unlocked)..sort();
        totalLevels = estimatedTotal;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        completedLevels = [];
        unlockedLevels = [];
        totalLevels = 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Fundo escuro
      appBar: CustomAppBar(
        title: 'Seu Perfil',
      ),
      body: BodyContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confira seu status!',
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(duration: 700.ms).slideY(begin: -0.2),

                  const SizedBox(height: 14),
                  Text(
                    'Sua pontuação acumulada:',
                    style: GoogleFonts.robotoMono(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),

                  const SizedBox(height: 18),

                  _buildInfoCard(
                    icon: Icons.emoji_events,
                    text: '$userScore pts',
                    colors: [
                      AppColors.primaryCard,
                      AppColors.secondaryCard,
                    ],
                    iconColor: Colors.amber[700]!,
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),

                  const SizedBox(height: 22),
                  Text(
                    'Sua melhor sequência de desafios concluídos:',
                    style: GoogleFonts.robotoMono(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),

                  const SizedBox(height: 18),

                  _buildInfoCard(
                    icon: Icons.local_fire_department,
                    text: '$bestStreak',
                    colors: [
                      AppColors.primaryCard,
                      AppColors.secondaryCard,
                    ],
                    iconGradient: const LinearGradient(
                      colors: [Colors.orange, Colors.redAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),

                  const SizedBox(height: 30),
                  Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Continue jogando, completando desafios e acumulando pontos! 🏆\n',
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'O progresso de porcentagem aumenta quando você responde as atividades principais.',
                            style: GoogleFonts.robotoMono(
                              color: Colors.yellowAccent, // destaque na cor
                              fontSize: 16, // um pouco maior
                              fontWeight: FontWeight.bold, // em negrito
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),


                  const SizedBox(height: 32),

                  // ===== Progresso geral =====
                  _buildProgressSection()
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.1),

                  const SizedBox(height: 24),

                  // ===== Tabela de progresso dos níveis (MODIFICADO) =====
                  _buildLevelsProgressSection(context)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.1),

                  const SizedBox(height: 32),

                  // Botão "Quero praticar"
                  Center(
                    child: StreamBuilder<ConnectivityResult>(
                      stream: Connectivity().onConnectivityChanged,
                      builder: (context, streamSnapshot) {
                        return FutureBuilder<ConnectivityResult>(
                          future: Connectivity().checkConnectivity(),
                          builder: (context, initialSnapshot) {
                            final result =
                                streamSnapshot.data ?? initialSnapshot.data;
                            final hasInternet =
                                result != ConnectivityResult.none;

                            return ElevatedButton.icon(
                              onPressed: hasInternet
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const NewContentLevelsScreen(),
                                        ),
                                      );
                                    }
                                  : null,
                              icon: Icon(hasInternet
                                  ? Icons.play_arrow
                                  : Icons.wifi_off),
                              label: Text(hasInternet
                                  ? 'Quero praticar'
                                  : 'Sem conexão'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hasInternet
                                    ? Colors.amberAccent
                                    : Colors.grey.shade400,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                textStyle: GoogleFonts.robotoMono(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String text,
    required List<Color> colors,
    Color? iconColor,
    LinearGradient? iconGradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          if (iconGradient != null)
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return iconGradient.createShader(bounds);
              },
              child: Icon(icon, color: Colors.white, size: 30),
            )
          else
            Icon(icon, color: iconColor ?? AppColors.cardPink, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final completedCount = completedLevels.length;
    final total = totalLevels > 0
        ? totalLevels
        : (completedCount > 0 ? completedCount : 10);
    final progress = (completedCount / total).clamp(0.0, 1.0);
    final percentage = (progress * 100).toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1623), Color(0xFF0B1220)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3C4250), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.explore, color: Colors.cyanAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                'Progresso geral',
                style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF43E97B), Color(0xFF38F9D7)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: GoogleFonts.robotoMono(
                      color: const Color(0xFF101A2C),
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.isNaN ? 0 : progress,
              minHeight: 12,
              backgroundColor: const Color(0xFF1E2533),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF43E97B)),
            ),
          ),
        ],
      ),
    );
  }

  // MODIFICADO: Widget agora inclui o botão de "Ver Menos"
  Widget _buildLevelsProgressSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1623),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3C4250), width: 1),
      ),
      child: Column(
        children: [
          // Cabeçalho da seção
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.view_list_rounded,
                    color: Colors.cyanAccent, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Progresso dos Níveis',
                  style: GoogleFonts.robotoMono(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          // Tabela com os níveis
          _buildLevelsTable(context),

          // Lógica condicional para mostrar "Ver Todos" ou "Ver Menos"
          // O botão só aparece se houver mais de 4 níveis no total.
          if (totalLevels > 4)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16.0),
              child: _showAllLevels
                  ? // Se todos os níveis estiverem visíveis, mostra "Ver Menos"
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showAllLevels = false; // Recolhe a lista
                        });
                      },
                      icon: const Icon(Icons.unfold_less_rounded, color: Colors.white),
                      label: Text('Ver Menos',
                          style: GoogleFonts.robotoMono(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    )
                  : // Caso contrário, mostra "Ver Todos os Níveis"
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showAllLevels = true; // Expande a lista
                        });
                      },
                      icon: const Icon(Icons.unfold_more_rounded, color: Colors.black87),
                      label: Text('Ver Todos os Níveis',
                          style: GoogleFonts.robotoMono(
                              color: Colors.black87, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildLevelsTable(BuildContext context) {
    final total = totalLevels > 0
        ? totalLevels
        : (completedLevels.isNotEmpty || unlockedLevels.isNotEmpty
            ? [...completedLevels, ...unlockedLevels]
                .fold<int>(0, (prev, el) => el > prev ? el : prev)
            : 10);

    final displayedLevelsCount =
        _showAllLevels ? total : (total > 4 ? 4 : total);

    if (displayedLevelsCount == 0) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Nenhum progresso ainda. Comece a jogar!", style: GoogleFonts.robotoMono(color: Colors.white70)),
      );
    }

    final rows = List.generate(displayedLevelsCount, (index) {
      final levelId = index + 1;
      final isCompleted = completedLevels.contains(levelId);
      final isUnlocked = isCompleted || unlockedLevels.contains(levelId);
      return DataRow(
        color: MaterialStateProperty.resolveWith((states) =>
            index.isEven ? const Color(0xFF0F1623) : const Color(0xFF0C131E)),
        cells: [
          DataCell(
            Text('Nível $levelId',
                style: GoogleFonts.robotoMono(color: Colors.white)),
          ),
          DataCell(
            Row(
              children: [
                Icon(
                  isCompleted
                      ? Icons.check_circle
                      : (isUnlocked ? Icons.lock_open : Icons.lock),
                  color: isCompleted
                      ? Colors.greenAccent
                      : (isUnlocked ? Colors.amberAccent : Colors.grey),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  isCompleted
                      ? 'Concluído'
                      : (isUnlocked ? 'Desbloqueado' : 'Bloqueado'),
                  style: GoogleFonts.robotoMono(
                    color: isCompleted
                        ? Colors.greenAccent
                        : (isUnlocked ? Colors.amberAccent : Colors.grey),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: GoogleFonts.robotoMono(
            color: Colors.cyanAccent, fontWeight: FontWeight.bold),
        dataTextStyle: GoogleFonts.robotoMono(color: Colors.white),
        columns: const [
          DataColumn(label: Text('Nível')),
          DataColumn(label: Text('Status')),
        ],
        rows: rows,
        dataRowColor:
            MaterialStateProperty.resolveWith((states) => Colors.transparent),
        headingRowColor: MaterialStateProperty.resolveWith(
            (states) => const Color(0xFF101828)),
        dividerThickness: 0.6,
        border: TableBorder.symmetric(
            inside: BorderSide(
                color: const Color(0xFF3C4250).withOpacity(0.6), width: 0.6)),
      ),
    );
  }
}