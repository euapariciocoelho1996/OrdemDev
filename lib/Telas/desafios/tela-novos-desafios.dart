import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:OrdemDev/body/BodyContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tela-desafio-aleatorio.dart';
import 'tela-desafio-acerto-ou-perda.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../../routes.dart';
import 'dart:io';
import 'tela-desafio-combo-com-risco.dart';
import '../../appBar/app-bar.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ChallengeHubScreen extends StatefulWidget {
  const ChallengeHubScreen({super.key});

  @override
  State<ChallengeHubScreen> createState() => _ChallengeHubScreenState();
}

class _ChallengeHubScreenState extends State<ChallengeHubScreen> {
  StreamSubscription<ConnectivityResult>? _connectivitySub;
  Timer? _connectivityTimer;
  bool _isNoInternetDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _startConnectivityWatcher();
    _startPeriodicConnectivityCheck();
  }

  void _startConnectivityWatcher() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((_) async {
      final hasNet = await _hasInternetAccess();
      if (!hasNet && mounted) {
        if (!_isNoInternetDialogShowing) {
          _isNoInternetDialogShowing = true;
          _showNoInternetDialog();
        }
      } else if (hasNet && mounted) {
        _isNoInternetDialogShowing = false;
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

  void _startPeriodicConnectivityCheck() {
    _connectivityTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
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
                  _isNoInternetDialogShowing = false;
                },
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _isNoInternetDialogShowing = false;
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _connectivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenges = [
      _buildChallengeCard(
        context,
        icon: Icons.flash_on,
        iconColor: Colors.amber.shade200,
        title: 'Exercícios Aleatórios',
        description: 'Responda perguntas aleatórias e acumule pontos!',
        subtitle: '',
        gradientColors: [Colors.red.shade800.withOpacity(0.7), Colors.red.shade800],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RandomChallengeScreen()),
          );
        },
      ),
      _buildChallengeCard(
        context,
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.yellow.shade700,
        title: 'Combo com Risco',
        description: 'Multiplique sua pontuação, mas cuidado com a pergunta coringa!',
        subtitle: '',
        gradientColors: [Colors.deepOrange.shade900.withOpacity(0.7), Colors.deepOrange.shade900],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComboRiskChallengeScreen()),
          );
        },
      ),
      _buildChallengeCard(
        context,
        icon: Icons.balance,
        iconColor: Colors.lightBlueAccent,
        title: 'Acerto ou Perda',
        description: 'Ganhe +5 por acerto, perca -3 por erro. Você decide quando parar!',
        subtitle: '',
        gradientColors: [Colors.blueGrey.shade800.withOpacity(0.7), Colors.blueGrey.shade800],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AcertoOuPerdaChallengeScreen()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Desafios'),
      body: BodyContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                const SizedBox(height: 16),
                PageHeader(
                  title: '🏆 Hora de Acumular Pontos!',
                  description: 'Participe de missões divertidas e coloque suas habilidades à prova! Complete desafios para conquistar pontos e subir no ranking!',
                ),
                const SizedBox(height: 32),

                // Aplicando animação cascata
                AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 150),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: challenges,
                    ),
                  ),
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
    );
  }

  Widget _buildChallengeCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.robotoMono(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GoogleFonts.robotoMono(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
