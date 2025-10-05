import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/new_content_progress_service.dart';
import '../../Telas/telaInicial/tela-ranking-widget.dart';
import '../../Telas/telaInicial/tela-ranking.dart';
import '../../Cores/app_colors.dart';
// --- WIDGET 1: O CARD DE INTRODUÇÃO AO RANKING ---

class RankingIntroCard extends StatelessWidget {
  final bool hasInternetConnection;
  final VoidCallback onPressed;

  const RankingIntroCard({
    super.key,
    required this.hasInternetConnection,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PageHeader(
        title: 'RANKING DE USUÁRIOS',
        description: 'Veja como você se posiciona em relação aos outros usuários.',
      ),
      const SizedBox(height: 20),
      Center(
        child: Container(
          width: double.infinity,
          child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.neutral80, // Fundo transparente
            foregroundColor: hasInternetConnection
                ? AppColors.icon
                : Colors.grey.shade500,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              
            ),
            elevation: hasInternetConnection ? 12 : 0,
            
          ),
          icon: hasInternetConnection
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.query_stats,
                      size: 32,
                      color: AppColors.icon, // Sombra do ícone
                    ),
                    const Icon(
                      Icons.query_stats,
                      size: 28,
                      color: AppColors.icon, // Ícone amarelo principal
                    ),
                  ],
                )
              : Icon(
                  Icons.wifi_off,
                  size: 28,
                  
                ),
          label: Text(
            hasInternetConnection ? 'Ver Ranking Completo' : 'Sem conexão',
            style: GoogleFonts.robotoMono(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: hasInternetConnection
                  ? AppColors.textPrimary // Texto com cor de destaque
                  : Colors.grey.shade500,
            ),
          ),
          onPressed: hasInternetConnection ? onPressed : null,
        ),
        )
        
      ),
    ],
  );
}

}

class RankingWidget extends StatefulWidget {
  const RankingWidget({Key? key}) : super(key: key);

  @override
  State<RankingWidget> createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingWidget> {
  late Future<List<Map<String, dynamic>>> _rankingFuture;

  @override
  void initState() {
    super.initState();
    _rankingFuture = NewContentProgressService.getRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.amber.shade50.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events,
                    color: Colors.amber.shade700, size: 32),
                const SizedBox(width: 10),
                Text(
                  'Top Usuários', // Título alterado para diferenciar
                  style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _rankingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Nenhum usuário no ranking ainda.',
                      style: GoogleFonts.robotoMono(
                          fontSize: 14, color: Colors.grey.shade700));
                }
                final ranking = snapshot.data!;
                return Column( // Usar Column para evitar erros de scroll aninhado
                  children: List.generate(ranking.length, (index) {
                     final user = ranking[index];
                      final isTop3 = index < 3;
                      IconData icon;
                      Color iconColor;
                      switch (index) {
                        case 0:
                          icon = Icons.emoji_events;
                          iconColor = Colors.amber.shade700;
                          break;
                        case 1:
                          icon = Icons.emoji_events;
                          iconColor = Colors.grey.shade400;
                          break;
                        case 2:
                          icon = Icons.emoji_events;
                          iconColor = Colors.brown.shade400;
                          break;
                        default:
                          icon = Icons.person;
                          iconColor = Colors.blueGrey.shade300;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isTop3
                                ? iconColor.withOpacity(0.2)
                                : Colors.grey.shade200,
                            child: Icon(icon,
                                color: iconColor, size: isTop3 ? 28 : 22),
                          ),
                          title: Text(
                            user['nome'] ?? 'Usuário',
                            style: GoogleFonts.robotoMono(
                              fontWeight:
                                  isTop3 ? FontWeight.bold : FontWeight.w500,
                              color: isTop3 ? iconColor : Colors.blueGrey.shade800,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber.shade600, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                user['score'].toString(),
                                style: GoogleFonts.robotoMono(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}