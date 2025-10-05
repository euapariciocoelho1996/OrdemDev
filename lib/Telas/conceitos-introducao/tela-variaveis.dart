import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para o Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../jogo-introducao/tela-niveis-intro.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

// Paleta de cores para consistência visual
class AppColors {
  static const Color background = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF16213E);
  static const Color accent = Color(0xFF00BFFF); // DeepSkyBlue
  static const Color text = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color cardBackground = Color(0xFF1F294A);
}

class VariablesScreen extends StatelessWidget {
  const VariablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Variáveis em C'),
      body: BodyContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoCard(
                        icon: Icons.inventory_2,
                        title: 'O que é uma Variável?',
                        content:
                            'Uma variável é como uma "caixa" na memória do computador. Ela tem um rótulo (o tipo), um nome e guarda um conteúdo (o valor). Usamos variáveis para armazenar informações que podem ser usadas e modificadas durante a execução do programa.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.biotech,
                        title: 'Anatomia da Declaração',
                        content:
                            'Declarar uma variável em C segue uma estrutura simples:\n`tipo nome = valor;`\n● Tipo: Define o que a "caixa" pode guardar (ex: `int`, `float`).\n● Nome: O identificador que você usará para acessar a "caixa".\n● Valor: (Opcional na declaração) O conteúdo inicial da "caixa".',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    // Declaração e inicialização de variáveis
    int pontuacao = 100;         // Tipo 'int', nome 'pontuacao', valor '100'
    float media_final = 9.5;     // Tipo 'float', nome 'media_final', valor '9.5'
    char classe_personagem = 'M'; // Tipo 'char', nome 'classe_personagem', valor 'M'

    // Você pode alterar o valor depois
    pontuacao = 150;
    
    printf("Nova pontuação: %d\\n", pontuacao);

    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.rule,
                        title: 'Regras e Convenções de Nomenclatura',
                        content:
                            '● Regras (Obrigatório): Nomes devem começar com letra ou `_`. Não podem conter espaços ou caracteres especiais (exceto `_`).\n● Convenções (Boa Prática): Use nomes descritivos. Escolha um padrão como `snake_case` (total_de_pontos) ou `camelCase` (totalDePontos) e mantenha a consistência.',
                      ),
                       const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.lock,
                        title: 'Variáveis que Não Variam: Constantes',
                        content:
                            'Quando você tem um valor que nunca deve mudar durante a execução (como o valor de PI), declare-o como uma constante usando a palavra-chave `const`. Isso previne modificações acidentais e torna o código mais seguro.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    const float PI = 3.14159;
    const int MESES_NO_ANO = 12;

    // Tentar fazer isso geraria um erro de compilação!
    // PI = 3.14; 

    printf("O valor de PI é: %f\\n", PI);
    
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.visibility,
                        title: 'Escopo: Local vs. Global',
                        content:
                            'O escopo define onde uma variável é "visível".\n● Variáveis Locais: Declaradas dentro de uma função. Só existem e podem ser usadas dentro daquela função.\n● Variáveis Globais: Declaradas fora de todas as funções. São acessíveis por qualquer parte do seu código (use com moderação!).',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int vidas_global = 3; // Variável Global

void perder_vida() {
    vidas_global--; // Acessando e modificando a variável global
    printf("Vida perdida! Vidas restantes: %d\\n", vidas_global);
}

int main() {
    int pontuacao_local = 0; // Variável Local da main

    pontuacao_local += 10;
    perder_vida(); // Chama função que usa a variável global

    printf("Pontuação na main: %d\\n", pontuacao_local);
    printf("Vidas na main: %d\\n", vidas_global);
    
    return 0;
}
''',
                      ),
                      const SizedBox(height: 32),
                      _buildPracticeButton(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        icon: Icons.home,
        color: AppColors.accent,
        navigateTo: const HomeScreen(),
      ),
    );
  }

  Widget _buildPracticeButton(BuildContext context) {
    return Center(
      child: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, streamSnapshot) {
          return FutureBuilder<ConnectivityResult>(
            future: Connectivity().checkConnectivity(),
            builder: (context, initialSnapshot) {
              final result = streamSnapshot.data ?? initialSnapshot.data;
              final hasInternet = result != ConnectivityResult.none;

              return ElevatedButton.icon(
                onPressed: hasInternet
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const CodeCompletionLevelsScreen()),
                        )
                    : null,
                icon: Icon(hasInternet ? Icons.play_arrow : Icons.wifi_off,
                    color: AppColors.primary),
                label: Text(
                  hasInternet ? 'Quero praticar' : 'Sem conexão',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          );
        },
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3);
  }
}

// --- Widgets de Suporte (Reutilizados) ---

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard(
      {required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1);
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  final String language;

  const _CodeBlock({required this.code, required this.language});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF282c34),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.toUpperCase(),
                  style: GoogleFonts.robotoMono(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: Colors.white54),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado!')),
                    );
                  },
                ),
              ],
            ),
          ),
          HighlightView(
            code,
            language: language,
            theme: atomOneDarkTheme,
            padding: const EdgeInsets.all(16),
            textStyle: GoogleFonts.robotoMono(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.95);
  }
}