import 'package:OrdemDev/Body/BodyContainer.dart';
import 'package:OrdemDev/Telas/conceitos-introducao/tela-conceitos-fundamentais.dart';
import 'package:OrdemDev/Telas/conceitos-ordenacao/tela-algoritmos-ordenacao.dart';
import 'package:OrdemDev/Telas/jogo-introducao/tela-niveis-intro.dart';
import 'package:OrdemDev/Telas/jogo-ordenacao/tela-niveis-order.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-ranking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../routes.dart';
import '../../widgets/motivational_banner.dart';



import 'package:shared_preferences/shared_preferences.dart';

import '../../services/new_content_progress_service.dart';
import '../../Conexao/tela-perfil-usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mensagens.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasInternetConnection = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    // Adiciona listener para monitorar mudanças na conectividade
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          _hasInternetConnection = result != ConnectivityResult.none;
        });
      }
    });
  }

  Future<void> _checkInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (mounted) {
        setState(() {
          _hasInternetConnection =
              connectivityResult != ConnectivityResult.none;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasInternetConnection = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Deseja sair?',
          style: GoogleFonts.sourceCodePro(),
        ),
        content: Text(
          'Você realmente deseja fazer logout e voltar para a tela de login?',
          style: GoogleFonts.sourceCodePro(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.sourceCodePro(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Sair',
              style: GoogleFonts.sourceCodePro(),
            ),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF000000), // preto puro
                  const Color(0xFF111111), // preto levemente mais claro
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
              'OrdemDev',
              style: GoogleFonts.sourceCodePro(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
       
        drawer: _ProfileDrawer(),
        body: BodyContainer(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Seção de Boas-vindas
                  _buildWelcomeSection(),

                  // Seção Sobre o Aplicativo
                  _buildAboutAppSection(),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // cor padrão
                        ),
                        children: [
                          const TextSpan(text: 'COMECE SUA '),
                          TextSpan(
                            text: 'JORNADA',
                            style: GoogleFonts.sourceCodePro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFFA50)
                                  .withOpacity(0.65), // Neon amarelo suave
                              shadows: [
                                Shadow(
                                  blurRadius: 12.0,
                                  color: const Color(0xFFFFFA50)
                                      .withOpacity(0.8), // brilho leve
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(),
                  ),

                  // Cards Principais

                  const SizedBox(height: 24),
                  // ← Aqui termina o Center
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seção: conceitos básicos
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_fill, // ícone mais moderno
                              color: const Color(0xFF306998),
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Conceitos Básicos',
                              style: GoogleFonts.sourceCodePro(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                          children: [
                            _buildMenuCard(
                              context,
                              'Fundamentos',
                              Icons.school,
                              const Color(0xFF6C88EF).withOpacity(0.75),
                              'Conceitos básicos para começar',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BasicConceptsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildMenuCard(
                              context,
                              'Atividades Iniciais',
                              Icons.refresh,
                              const Color(0xFF6C88EF).withOpacity(0.75),
                              'Reforce seu aprendizado',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CodeCompletionLevelsScreen(),
                                  ),
                                );
                              },
                              hasInternet: _hasInternetConnection,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Seção: Algoritmos de ordenação
                        Row(
                          children: [
                            Icon(
                              Icons.timeline_rounded, // ícone mais moderno
                              color: Colors.blueAccent
                                  .withOpacity(0.75), // Ícone suavizado
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Algoritmos de Ordenação',
                              style: GoogleFonts.sourceCodePro(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                          children: [
                            _buildMenuCard(
                              context,
                              'Algoritmos de Ordenação',
                              Icons.sort,
                              const Color(0xFF6C88EF).withOpacity(0.75),
                              'Estude métodos de ordenação',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SortingAlgorithmsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildMenuCard(
                              context,
                              'Atividades Principais',
                              Icons.code,
                              const Color(0xFF6C88EF).withOpacity(0.75),
                              'Pratique com exercícios interativos',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NewContentLevelsScreen(),
                                  ),
                                );
                              },
                              hasInternet: _hasInternetConnection,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Seção: Guia de estudos e referências
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined, // ícone moderno
                              color: const Color(0xFF306998),
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Saiba mais..',
                              style: GoogleFonts.sourceCodePro(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                          children: [
                            _buildMenuCard(
                              context,
                              'Guia de Estudos',
                              Icons.menu_book,
                              const Color(0xFF6C88EF).withOpacity(0.75),
                              'Planejamento de estudos',
                              () {
                                Navigator.pushNamed(
                                    context, AppRoutes.studyGuide);
                              },
                            ),
                            _buildMenuCard(
                              context,
                              'Referências',
                              Icons.book,
                              const Color(0xFF6C88EF).withOpacity(0.75),
                              'Material complementar',
                              () {
                                Navigator.pushNamed(
                                    context, AppRoutes.references);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Seção de Desafios
                  _buildChallengesSection(),
                  const SizedBox(height: 24),

                  // Ranking
                  _buildRankingSection(),
                  const SizedBox(height: 24),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xFF222222), // tom escuro
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Icon(
                  Icons.local_cafe,
                  size: 28,
                  color:
                      Colors.white, // mantém branco para que o degradê funcione
                ),
              ).animate().rotate(
                    duration: const Duration(seconds: 2),
                  ), // anima apenas o ícone
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                  children: [
                    const TextSpan(
                      text: '< ',
                      style: TextStyle(color: Color(0xFFFFFA50)),
                    ),
                    const TextSpan(
                      text: 'SAUDAÇÕES',
                      style: TextStyle(color: Colors.white),
                    ),
                    const TextSpan(
                      text: ' >',
                      style: TextStyle(color: Color(0xFF6C88EF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
// sem animação no Row

          Center(
            child: CCarousel(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutAppSection() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
            padding: const EdgeInsets.all(3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título como comentário Python
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: '# AQUI VOCÊ '),
                          TextSpan(
                            text: 'PODE',
                            style: TextStyle(
                              color: Color(0xFF6C88EF), // cor de destaque
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.amberAccent.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                          TextSpan(text: ':'),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lista estilo Python
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildListItem(Icons.bolt, 'Acumular Pontos'),
                          _buildListItem(
                              Icons.emoji_events, 'Entrar no Ranking'),
                          _buildListItem(Icons.extension,
                              'Ganhar pontos de diferentes modos'),
                          _buildListItem(
                              Icons.more_horiz, 'print("E muito mais...")'),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    const SizedBox(width: 13),

                    // Imagem à direita
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/audio/py3d.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }

// Função auxiliar para criar itens da lista com ícone
  Widget _buildListItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: Colors.amber.shade400,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.sourceCodePro(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'DESAFIOS E PONTUAÇÃO',
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceCodePro(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Complete atividades, resolva desafios e participe de quizzes para acumular pontos e subir no ranking!',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: _hasInternetConnection ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: _hasInternetConnection
                ? () {
                    Navigator.pushNamed(context, AppRoutes.challengeHub);
                  }
                : null,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _hasInternetConnection
                      ? [
                          Color(0xFFFFFA50),
                          Color(0xFF6C88EF),
                        ]
                      : [
                          Colors.grey.withOpacity(0.3),
                          Colors.grey.withOpacity(0.5),
                        ],
                ),
                boxShadow: _hasInternetConnection
                    ? [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  if (!_hasInternetConnection) ...[
                    Icon(
                      Icons.wifi_off,
                      size: 44,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sem conexão',
                            style: GoogleFonts.sourceCodePro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Conecte-se à internet para acessar os desafios',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 44, // maior para criar a sombra
                          color: Color.fromARGB(
                              150, 0, 0, 0), // sombra escura translúcida
                        ),
                        const Icon(
                          Icons.emoji_events,
                          size: 40,
                          color: Color.fromARGB(
                              255, 255, 226, 98), // ícone dourado
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Desafios Interativos',
                            style: GoogleFonts.sourceCodePro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 7, 7, 7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Teste seus conhecimentos em desafios únicos e ganhe pontos!',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 7, 7, 7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 22, // ligeiramente maior para parecer sombra
                          color: Color.fromARGB(
                              150, 0, 0, 0), // sombra escura translúcida
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Color(0xFF6C88EF),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ).animate().scale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            ),
      ],
    );
  }

  Widget _buildRankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'RANKING DE USUÁRIOS',
            style: GoogleFonts.sourceCodePro(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Veja como você se posiciona em relação aos outros usuários. O ranking é atualizado em tempo real com base nos pontos acumulados através das atividades completadas.',
          style: GoogleFonts.sourceCodePro(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _hasInternetConnection
                  ? const Color(0xFF6C88EF)
                  : Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: _hasInternetConnection ? 8 : 2,
              shadowColor: _hasInternetConnection
                  ? const Color(0xFFFFFA50).withOpacity(0.8)
                  : null,
            ),
            icon: _hasInternetConnection
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.query_stats,
                        size: 32, // um pouco maior para parecer sombra
                        color: Color.fromARGB(
                            150, 0, 0, 0), // sombra escura translúcida
                      ),
                      const Icon(
                        Icons.query_stats,
                        size: 28,
                        color: Color(0xFFFFFA50), // Ícone amarelo destaque
                      ),
                    ],
                  )
                : Icon(
                    Icons.wifi_off,
                    size: 28,
                    color: Colors.grey.shade600,
                  ),
            label: Text(
              _hasInternetConnection ? 'Ver Ranking Completo' : 'Sem conexão',
              style: GoogleFonts.sourceCodePro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: _hasInternetConnection
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RankingScreen()),
                    );
                  }
                : null,
          ),
        )
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon,
      Color color, String subtitle, VoidCallback onTap,
      {bool hasInternet = true}) {
    // Cards clicáveis com elevação maior e ícone de ação para indicar interatividade
    return Card(
      elevation: hasInternet ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: hasInternet ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: hasInternet
                  ? [
                      color.withOpacity(0.8),
                      color,
                    ]
                  : [
                      Colors.grey.withOpacity(0.3),
                      Colors.grey.withOpacity(0.5),
                    ],
            ),
            boxShadow: hasInternet
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!hasInternet) ...[
                  Icon(
                    Icons.wifi_off,
                    size: 32,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sem conexão',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ] else ...[
                  Icon(
                    icon,
                    size: 32,
                    color:
                        const Color.fromARGB(255, 28, 28, 28).withOpacity(0.8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 7, 7, 7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 7, 7, 7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: const Color.fromARGB(255, 7, 7, 7),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
  }
}

class _RandomChallengeOnboardingDialog extends StatelessWidget {
  const _RandomChallengeOnboardingDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Bem-vindo ao Desafio Aleatório!',
        style: GoogleFonts.sourceCodePro(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Este é um desafio interativo onde você pode testar seus conhecimentos de algoritmos de ordenação. Cada rodada é única e cheia de perguntas aleatórias. Você gostaria de tentar? 🚀',
        style: GoogleFonts.sourceCodePro(
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Não, obrigado',
            style: GoogleFonts.sourceCodePro(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Sim, vamos lá!',
            style: GoogleFonts.sourceCodePro(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileDrawer extends StatefulWidget {
  @override
  State<_ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<_ProfileDrawer> {
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final score = await NewContentProgressService.getUserScore();
    if (mounted) {
      setState(() {
        userScore = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      backgroundColor: const Color(0xFF1A2236),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, bottom: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C88EF), Color(0xFFFFFA50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.videogame_asset_rounded,
                      size: 44, color: Color(0xFF6C88EF)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Menu',
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.7),
                        const Color(0xFF306998),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.9, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: Icon(Icons.person, color: Color(0xFF6C88EF), size: 28),
              ),
            ),
            title: Text(
              'Perfil',
              style: GoogleFonts.sourceCodePro(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: Colors.white.withOpacity(0.03),
            hoverColor: Colors.amber.withOpacity(0.08),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const UserProfileScreen()),
              );
            },
          ),
          if (user != null) ...[
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade300, size: 28),
              title: Text(
                'Sair',
                style: GoogleFonts.sourceCodePro(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              tileColor: Colors.white.withOpacity(0.03),
              hoverColor: Colors.red.withOpacity(0.08),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Limpa todos os dados locais
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        ],
      ),
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
                  'Ranking dos Usuários',
                  style: GoogleFonts.sourceCodePro(
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
                      style: GoogleFonts.sourceCodePro(
                          fontSize: 14, color: Colors.grey.shade700));
                }
                final ranking = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ranking.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 12, color: Colors.amberAccent),
                  itemBuilder: (context, index) {
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
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isTop3
                            ? iconColor.withOpacity(0.2)
                            : Colors.grey.shade200,
                        child: Icon(icon,
                            color: iconColor, size: isTop3 ? 28 : 22),
                      ),
                      title: Text(
                        user['nome'] ?? 'Usuário',
                        style: GoogleFonts.sourceCodePro(
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
                            style: GoogleFonts.sourceCodePro(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
