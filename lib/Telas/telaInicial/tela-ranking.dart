import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../routes.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';
import '../../services/new_content_progress_service.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Ranking'),
      body: BodyContainer(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    // Card motivacional
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: MotivationalRankingCard(),
                    ),
                    RankingContainer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        icon: Icons.home,
        color: Colors.deepPurple,
        navigateTo: HomeScreen(),
      ),
    );
  }
}

/// Card motivacional moderno com imagem local
class MotivationalRankingCard extends StatelessWidget {
  const MotivationalRankingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Imagem local
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/All_Itens/trofeu.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          // Título e mensagem motivacional
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Melhores Pontuações',
                  style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cada ponto conta! Continue jogando para subir no ranking!',
                  style: GoogleFonts.robotoMono(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    ).animate().fade(duration: 600.ms).slideY(duration: 600.ms, curve: Curves.easeOutBack);
  }
}

// Container do ranking
class RankingContainer extends StatelessWidget {
  const RankingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: RankingContent(),
      ),
    );
  }
}

/// Conteúdo do ranking
class RankingContent extends StatefulWidget {
  const RankingContent({Key? key}) : super(key: key);

  @override
  State<RankingContent> createState() => _RankingContentState();
}

class _RankingContentState extends State<RankingContent> {
  late Future<List<Map<String, dynamic>>> _rankingFuture;
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  Timer? _connectivityTimer;
  bool _isNoInternetDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _startConnectivityWatcher();
    _startPeriodicConnectivityCheck();
    _rankingFuture = NewContentProgressService.getRanking();
  }

  void _startConnectivityWatcher() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((_) async {
      final hasNet = await _hasInternetAccess();
      if (!hasNet && mounted && !_isNoInternetDialogShowing) {
        _isNoInternetDialogShowing = true;
        _showNoInternetDialog();
      } else if (hasNet && mounted) {
        _isNoInternetDialogShowing = false;
      }
    });
  }

  void _startPeriodicConnectivityCheck() {
    _connectivityTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (mounted) {
        final hasNet = await _hasInternetAccess();
        if (!hasNet && !_isNoInternetDialogShowing) {
          _isNoInternetDialogShowing = true;
          _showNoInternetDialog();
        } else if (hasNet) {
          _isNoInternetDialogShowing = false;
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
      builder: (BuildContext context) {
        return WillPopScope(
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
                      fontSize: 20),
                ),
              ],
            ),
            content: Text(
              "Sua conexão com a internet foi perdida. 🤔\n\n"
              "Para continuar estudando, volte para a Home!",
              style:
                  GoogleFonts.robotoMono(color: Colors.white70, fontSize: 16),
            ),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.home, color: Colors.blue),
                label: Text(
                  "Ir para Home",
                  style: GoogleFonts.robotoMono(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
                  _isNoInternetDialogShowing = false;
                },
              ),
            ],
          ),
        );
      },
    ).then((_) => _isNoInternetDialogShowing = false);
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _connectivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _rankingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.amber));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Nenhum usuário no ranking ainda.',
              style: GoogleFonts.robotoMono(fontSize: 14, color: Colors.white70),
            ),
          );
        }
        final ranking = snapshot.data!;
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: ranking.length,
          separatorBuilder: (_, __) =>
              Divider(height: 12, color: Colors.white.withOpacity(0.1)),
          itemBuilder: (context, index) {
            final user = ranking[index];
            return RankingCard(user: user, index: index)
                .animate()
                .fade(duration: 500.ms)
                .slideX(duration: 500.ms, curve: Curves.easeOutBack);
          },
        );
      },
    );
  }
}

/// Card individual de cada usuário
class RankingCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final int index;
  const RankingCard({super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    bool isTop3 = index < 3;
    IconData icon;
    LinearGradient gradient;

    switch (index) {
      case 0:
        icon = Icons.auto_graph;
        gradient = const LinearGradient(colors: [Colors.amber, Colors.orangeAccent]);
        break;
      case 1:
        icon = Icons.auto_graph;
        gradient = const LinearGradient(colors: [Colors.grey, Colors.blueGrey]);
        break;
      case 2:
        icon = Icons.auto_graph;
        gradient = const LinearGradient(colors: [Colors.brown, Colors.deepOrange]);
        break;
      default:
        icon = Icons.person;
        gradient = const LinearGradient(colors: [Colors.blueGrey, Colors.grey]);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(bounds),
          child: Icon(icon, color: Colors.white, size: isTop3 ? 28 : 22),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user['nome'] ?? 'Usuário',
              style: GoogleFonts.robotoMono(
                  fontWeight: isTop3 ? FontWeight.bold : FontWeight.w500,
                  color: Colors.white),
              overflow: TextOverflow.ellipsis, // evita overflow em nomes grandes
              maxLines: 1,
            ),
            Text(
              'Sequência: ${user['bestStreak'] ?? 0}',
              style: GoogleFonts.robotoMono(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.orangeAccent),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                user['score'].toString(),
                style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                overflow: TextOverflow.ellipsis, // evita overflow em pontuações grandes
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
