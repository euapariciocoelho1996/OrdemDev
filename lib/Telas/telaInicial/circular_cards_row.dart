import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:OrdemDev/Telas/comentarios/comentarios_screen.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-ranking.dart';
import 'package:OrdemDev/Telas/desafios/tela-novos-desafios.dart';

class CircularCardsRow extends StatefulWidget {
  const CircularCardsRow({super.key});

  @override
  _CircularCardsRowState createState() => _CircularCardsRowState();
}

class _CircularCardsRowState extends State<CircularCardsRow> {
  bool _hasInternetConnection = true;
  late StreamSubscription<ConnectivityResult> _connectivitySub;
  Timer? _timer; // 👈 novo timer

  @override
  void initState() {
    super.initState();
    _startConnectivityWatcher();
    _checkInitialInternet();

    // 👇 Atualiza a cada 1 segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkInternetPeriodically();
    });
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    _timer?.cancel(); // 👈 cancela o timer
    super.dispose();
  }

  void _startConnectivityWatcher() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((result) async {
      bool quickStatus = result != ConnectivityResult.none;
      if (mounted) {
        setState(() {
          _hasInternetConnection = quickStatus;
        });
      }

      final confirmed = await _hasInternetAccess();
      if (mounted) {
        setState(() {
          _hasInternetConnection = confirmed;
        });
      }
    });
  }

  Future<void> _checkInitialInternet() async {
    final hasNet = await _hasInternetAccess();
    if (mounted) {
      setState(() {
        _hasInternetConnection = hasNet;
      });
    }
  }

  // 👇 chamado a cada 1s pelo Timer
  Future<void> _checkInternetPeriodically() async {
    final confirmed = await _hasInternetAccess();
    if (mounted) {
      setState(() {
        _hasInternetConnection = confirmed;
      });
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('one.one.one.one').timeout(
        const Duration(seconds: 1),
        onTimeout: () => [],
      );
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cards = [
      {
        'title': '+ Desafios',
        'subtitle': 'Explore desafios únicos!',
        'icon': Icons.school,
        'color': Colors.deepPurple,
        'screen': const ChallengeHubScreen(),
      },
      {
        'title': 'Ranking',
        'subtitle': 'Pontuação Geral!',
        'icon': Icons.trending_up,
        'color': Colors.teal,
        'screen': const RankingScreen(),
      },
      {
        'title': 'Comunidade',
        'subtitle': 'Compartilhe suas ideias!!',
        'icon': Icons.comment,
        'color': Colors.orange,
        'screen': const ComentariosScreen(),
      },
    ];

    final List<Map<String, dynamic>> displayedCards = _hasInternetConnection
        ? cards
        : cards
            .map((_) => {
                  'title': 'Sem conexão',
                  'subtitle': '',
                  'icon': Icons.wifi_off,
                  'color': Colors.grey,
                  'screen': null,
                })
            .toList();

    return SizedBox(
      height: 180,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: displayedCards.map((card) {
            final bool enabled =
                _hasInternetConnection && card['screen'] != null;

            return Padding(
              padding: const EdgeInsets.only(right: 13),
              child: Opacity(
                opacity: enabled ? 1.0 : 0.5,
                child: IgnorePointer(
                  ignoring: !enabled,
                  child: GestureDetector(
                    onTap: () {
                      if (enabled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => card['screen']),
                        );
                      }
                    },
                    child: Container(
                      width: 140,
                      decoration: BoxDecoration(
                        color: card['color'],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                card['icon'],
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              card['title'],
                              style: GoogleFonts.robotoMono(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              card['subtitle'],
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
