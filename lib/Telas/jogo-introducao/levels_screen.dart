// main.dart ou onde sua tela de níveis é chamada

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Dependências que estamos simulando ---
// Supondo que estes arquivos existam no seu projeto
import 'package:OrdemDev/body/BodyContainer.dart'; // Seu widget de container
import 'package:OrdemDev/models/code_completion_models.dart'; // Seus modelos de dados
import 'package:OrdemDev/services/progress_service.dart'; // Seu serviço de progresso
import 'package:OrdemDev/appBar/app-bar.dart'; // Sua AppBar customizada
import 'package:OrdemDev/Telas/jogo-introducao/tela-quizz-intro.dart'; // Tela do Quizz
import 'package:OrdemDev/body/BodyContainer.dart';
//==============================================================================
// ARQUIVO: lib/theme/app_colors.dart
// (Idealmente, as cores ficam em um arquivo de tema separado)
//==============================================================================

class AppColors {
  static const Color background = Color(0xFF1C2128);
  static const Color primary = Color(0xFF00E5FF); // Ciano
  static const Color primaryDark = Color(0xFF00B8D4);
  static const Color success = Color(0xFF4CAF50); // Verde
  static const Color locked = Color(0xFF757575); // Cinza
  static const Color unlockedCard = Color(0xFFF0F2F5);
  static const Color lockedCard = Color(0xFFE0E0E0);
  static const Color textLight = Colors.white;
  static const Color textDark = Colors.black87;
  static const Color textFaded = Colors.white70;
}

//==============================================================================
// ARQUIVO: lib/screens/levels/levels_screen.dart
//==============================================================================

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  // O Future armazena o resultado da operação assíncrona
  late Future<Map<String, List<int>>> _progressFuture;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // Carrega os dados e retorna um Future com eles
  Future<Map<String, List<int>>> _fetchProgressData() async {
    // Adicionando um pequeno delay para simular uma chamada de rede real
    await Future.delayed(const Duration(milliseconds: 500)); 
    final completed = await ProgressService.getCompletedLevels();
    final unlocked = await ProgressService.getUnlockedLevels();
    return {'completed': completed, 'unlocked': unlocked};
  }

  // Atribui um novo Future para forçar a reconstrução do FutureBuilder
  void _loadProgress() {
    setState(() {
      _progressFuture = _fetchProgressData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Níveis',
        // Assumindo que sua AppBar pode ser estilizada
        // backgroundColor: AppColors.background,
      ),
      body: BodyContainer( // Usando seu widget de container
        child: SafeArea(
          child: FutureBuilder<Map<String, List<int>>>(
            future: _progressFuture,
            builder: (context, snapshot) {
              // 1. Estado de Carregamento
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              // 2. Estado de Erro
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar o progresso.',
                    style: GoogleFonts.robotoMono(color: Colors.redAccent),
                  ),
                );
              }

              // 3. Estado de Sucesso (com dados)
              if (snapshot.hasData) {
                final completedLevels = snapshot.data!['completed']!;
                final unlockedLevels = snapshot.data!['unlocked']!;

                return ListView( // Usar ListView diretamente é mais limpo que SingleChildScrollView+Column
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    Text(
                      'Escolha um nível para começar',
                      style: GoogleFonts.robotoMono(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Gera a lista de cards dinamicamente
                    ...List.generate(
                      codeCompletionLevels.length,
                      (index) {
                        final level = codeCompletionLevels[index];
                        final isCompleted = completedLevels.contains(level.id);
                        final isUnlocked = unlockedLevels.contains(level.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: LevelCard(
                            level: level,
                            isCompleted: isCompleted,
                            isUnlocked: isUnlocked,
                            onRefresh: _loadProgress, // Passa a função de refresh
                          ),
                        );
                      },
                    ),
                  ],
                );
              }

              // Estado inicial ou sem dados
              return Center(child: Text('Nenhum nível encontrado.', style: GoogleFonts.robotoMono(color: AppColors.textFaded)));
            },
          ),
        ),
      ),
      floatingActionButton: const HelpFloatingActionButton(),
    );
  }
}

//==============================================================================
// ARQUIVO: lib/screens/levels/widgets/level_card.dart
// (Widget extraído para o card de nível)
//==============================================================================

class LevelCard extends StatelessWidget {
  final CodeCompletionLevel level;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onRefresh;

  const LevelCard({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Determina a cor com base no estado
    final Color circleColor = isCompleted ? AppColors.success : (isUnlocked ? AppColors.primary : AppColors.locked);
    final Color cardColor = isUnlocked ? AppColors.unlockedCard : AppColors.lockedCard;
    final Color textColor = isUnlocked ? AppColors.textDark : AppColors.locked;
    final Color subtitleColor = isUnlocked ? AppColors.textDark.withOpacity(0.6) : AppColors.locked;
    
    return Card(
      elevation: isUnlocked ? 4 : 1,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: isUnlocked
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CodeCompletionTaskScreen(level: level)),
                ).then((_) => onRefresh()); // Chama o callback para atualizar a tela
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white)
                      : Text(
                          '${level.id}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? AppColors.background : Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: GoogleFonts.robotoMono(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.description,
                      style: GoogleFonts.robotoMono(fontSize: 14, color: subtitleColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!isUnlocked)
                Icon(Icons.lock, color: AppColors.locked.withOpacity(0.8)),
            ],
          ),
        ),
      ),
    );
  }
}

//==============================================================================
// ARQUIVO: lib/screens/levels/widgets/help_fab.dart
// (Widget extraído para o Floating Action Button)
//==============================================================================

class HelpFloatingActionButton extends StatelessWidget {
  const HelpFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 8,
      highlightElevation: 12,
      backgroundColor: Colors.transparent, // O gradiente vem do container filho
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(child: Icon(Icons.help_outline, size: 30, color: AppColors.background)),
      ),
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'Ajuda',
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => const SizedBox.shrink(),
          transitionBuilder: (context, anim1, anim2, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
                ),
                child: const HelpDialog(), // Mostra o dialog extraído
              ),
            );
          },
        );
      },
    );
  }
}

//==============================================================================
// ARQUIVO: lib/screens/levels/widgets/help_dialog.dart
// (Widget extraído para o AlertDialog de Ajuda)
//==============================================================================

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 1.5),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(Icons.help_outline, color: AppColors.background, size: 26),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              'Central de Ajuda',
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
                fontSize: 21,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orientações sobre a tela de níveis:',
              style: GoogleFonts.robotoMono(color: AppColors.textFaded, fontSize: 15),
            ),
            const SizedBox(height: 22),
            _buildHelpInfo(Icons.check_circle, AppColors.success, 'Verde: Nível concluído.'),
            const SizedBox(height: 12),
            _buildHelpInfo(Icons.radio_button_unchecked, AppColors.primary, 'Ciano: Nível desbloqueado.'),
            const SizedBox(height: 12),
            _buildHelpInfo(Icons.lock, AppColors.locked, 'Cinza: Nível bloqueado.'),
            const SizedBox(height: 22),
            Text(
              'Dicas importantes:',
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '• Complete os níveis em ordem para avançar.\n'
              '• Cada nível contém exercícios de lógica e código.\n'
              '• Toque em um card desbloqueado para iniciar.',
              style: GoogleFonts.robotoMono(
                color: AppColors.textFaded,
                fontSize: 14,
                height: 1.5, // Melhora a legibilidade de textos com múltiplas linhas
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: AppColors.textLight),
            label: Text(
              'Fechar',
              style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, color: AppColors.textLight, fontSize: 16),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // Pequeno helper para construir as linhas de informação no dialog
  Widget _buildHelpInfo(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.robotoMono(color: AppColors.textLight, fontSize: 14),
          ),
        ),
      ],
    );
  }
}