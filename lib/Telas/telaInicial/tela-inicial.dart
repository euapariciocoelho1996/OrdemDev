import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:OrdemDev/Telas/comentarios/botao-ir-para-comentarios.dart';
import 'package:OrdemDev/Telas/comentarios/comentarios_screen.dart';
import 'package:OrdemDev/body/BodyContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../Telas/telaInicial/tela-ranking-widget.dart';
import '../../Telas/conceitos-introducao/tela-conceitos-fundamentais.dart';
import '../../Telas/telaInicial/tela-ranking.dart';
import '../../Telas/jogo-introducao/tela-niveis-intro.dart';
import 'package:OrdemDev/routes.dart';
import '../../Telas/telaInicial/profile_drawer.dart';
import '../../Telas/jogo-ordenacao/tela-niveis-order.dart';
import '../../Telas/conceitos-ordenacao/tela-algoritmos-ordenacao.dart';
import '../../Telas/telaInicial/tela-sessao-desafio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Telas/desafios/tela-desafio-aleatorio.dart';
import '../../services/new_content_progress_service.dart';
import '../../conexao/tela-perfil-usuario.dart';
import '../../Telas/telaInicial/menu_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Telas/telaInicial/mensagens.dart';
import '../../Telas/telaInicial/welcome_section.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../Telas/telaInicial/about_app_section.dart';
import '../../Cores/app_colors.dart';
import '../../Telas/telaInicial/circular_cards_row.dart';

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
          _hasInternetConnection = connectivityResult != ConnectivityResult.none;
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
      // 1. Fundo escuro e moderno
      backgroundColor: const Color(0xFF23272F),

      // 2. Bordas arredondadas e com um leve contorno
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: Color(0xFF3C4250), width: 2),
      ),

      // 3. Estilo do título
      title: Text(
        'Deseja sair?',
        style: GoogleFonts.robotoMono(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),

      // 4. Estilo do conteúdo
      content: Text(
        'Você realmente deseja fazer logout e voltar para a tela de login?',
        style: GoogleFonts.robotoMono(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),

      // 5. Botões estilizados
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            // Cor do texto para a ação secundária
            foregroundColor: Colors.grey[400],
          ),
          child: Text(
            'Cancelar',
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            // Cor de destaque para a ação principal/destrutiva
            foregroundColor: Colors.redAccent,
          ),
          child: Text(
            'Sair',
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  // A lógica de logout permanece a mesma
  if (shouldLogout == true) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacementNamed('/login');
    }
    return false; // Previne o pop padrão
  }
  return false; // Previne o pop padrão
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColors.background,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),

          // Usamos flexibleSpace para adicionar uma decoração com sombra de brilho
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1A1D29).withOpacity(0.2), // Cor do brilho
                  blurRadius: 20.0,
                  spreadRadius: -5.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),

          title: ShaderMask(
            // Aplica um gradiente sobre o texto
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              '<OrdemDev />', // Título formatado como uma tag
              style: GoogleFonts.firaCode( // Outra ótima fonte para programação
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // A cor base do ShaderMask deve ser branca
              ),
            ),
          ),
          
        ),


        drawer: const ProfileDrawer(),
        body: BodyContainer(
          
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Seção de Boas-vindas
                  const WelcomeSection(),
                  
                  Center(child: CCarousel()),
                  // Seção Sobre o Aplicativo
                  const AboutAppSection(),
                  const SizedBox(height: 20),
                  PageHeader(title: 'COMECE SUA JORNADA', description: 'Descubra todo o nosso acervo de estudos!'),
                  const SizedBox(height: 24),

                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seção: conceitos básicos
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_fill, // ícone mais moderno
                              color: Color(0xFF00BFFF),
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Conceitos Básicos',
                              style: GoogleFonts.robotoMono(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
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
                            MenuCard(
                              cardIndex: 0,
                              title: 'Fundamentos',
                              subtitle: 'Conceitos básicos para começar',
                              icon: Icons.school,
                           
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BasicConceptsScreen(),
                                  ),
                                );
                              },
                            ),
                            MenuCard(
                              cardIndex: 1,
                              title: 'Atividades Iniciais',
                              subtitle: 'Reforce seu aprendizado',
                              icon: Icons.data_object_rounded,
                              
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CodeCompletionLevelsScreen(),
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
                              color: Color(0xFF00BFFF), // Ícone suavizado
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Algoritmos de Ordenação',
                              style: GoogleFonts.robotoMono(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                          children: [
                            MenuCard(
                              cardIndex: 2,
                              title: 'Algoritmos de Ordenação',
                              subtitle: 'Estude métodos de ordenação',
                              icon: Icons.sort,
                         
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SortingAlgorithmsScreen(),
                                  ),
                                );
                              },
                            ),
                            MenuCard(
                              cardIndex: 3,
                              title: 'Atividades Principais',
                              subtitle: 'Pratique com exercícios',
                              icon: Icons.code,
                              
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NewContentLevelsScreen(),
                                  ),
                                );
                              },
                              hasInternet: _hasInternetConnection,
                            )
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Seção: Guia de estudos e referências
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_outlined, // ícone moderno
                              color: Color(0xFF00BFFF),
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Saiba mais..',
                              style: GoogleFonts.robotoMono(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.85),
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
                            MenuCard(
                              cardIndex: 4,
                              title: 'Guia de Estudos',
                              subtitle: 'Planejamento de estudos',
                              icon: Icons.menu_book,
                            
                              onTap: () {
                                // O 'context' aqui já está disponível no escopo do seu widget
                                Navigator.pushNamed(context, AppRoutes.studyGuide);
                              },
                              
                            ),
                            MenuCard(
                              cardIndex: 5,
                              title: 'Referências',
                              subtitle: 'Material complementar',
                              icon: Icons.book,
                            
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.references);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 24),

                  Center(child: 
                     PageHeader(
                    title: 'NAVEGUE PELO CONTEÚDO',
                    description: 'Explore mais funcionalidades!',
                  ),
                  ),
                 
                  const SizedBox(height: 24),
                  CircularCardsRow(),
            
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
       
      ),
    );
  }
}



