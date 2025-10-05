import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para o Clipboard
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Imports (mantenha os seus imports originais aqui)
import '../jogo-introducao/tela-niveis-intro.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

// Paleta de cores para consistência visual (reutilizada da tela anterior)
class AppColors {
  static const Color background = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF16213E);
  static const Color accent = Color(0xFF00BFFF); // DeepSkyBlue
  static const Color text = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color cardBackground = Color(0xFF1F294A);
}

class InputOutputScreen extends StatelessWidget {
  const InputOutputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Entrada e Saída em C'),
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
                        icon: Icons.sync_alt,
                        title: 'Comunicando-se com o Programa',
                        content:
                            'As operações de Entrada e Saída (I/O) são a forma como seu programa "conversa" com o mundo exterior. A Saída (`printf`) mostra informações ao usuário, enquanto a Entrada (`scanf`) permite que o usuário envie dados para o programa.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.output,
                        title: 'Saída Formatada com `printf`',
                        content:
                            'A função `printf` (print formatted) é a principal ferramenta para exibir texto e valores de variáveis no console. Você pode controlar exatamente como os dados aparecem usando os especificadores de formato.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
// Exibindo texto e valores de variáveis
#include <stdio.h>

int main() {
    int gols = 3;
    printf("O Brasil marcou %d gols!\\n", gols); // %d é substituído pelo valor da variável 'gols'
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.key,
                        title: 'Especificadores de Formato',
                        content:
                            'Estes códigos especiais dizem ao `printf` e `scanf` qual tipo de dado esperar.',
                      ),
                      const SizedBox(height: 16),
                      _SpecifierGrid(specifiers: const [
                        ['%d', 'Inteiro (int)'],
                        ['%f', 'Ponto flutuante (float)'],
                        ['%lf', 'Ponto flutuante duplo (double)'],
                        ['%c', 'Caractere (char)'],
                        ['%s', 'String (texto)'],
                      ]),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.input,
                        title: 'Entrada Formatada com `scanf`',
                        content:
                            'A função `scanf` (scan formatted) pausa o programa e espera que o usuário digite um valor, que é então armazenado em uma variável.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.help_outline,
                        title: 'O Mistério do `&`',
                        content:
                            'O `&` antes do nome da variável é o operador "endereço de". Ele informa ao `scanf` exatamente onde na memória do computador ele deve guardar o valor digitado pelo usuário. Sem ele, o `scanf` não sabe onde salvar a informação!',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
// Lendo a idade do usuário
#include <stdio.h>

int main() {
    int idade;
    printf("Digite sua idade: ");
    scanf("%d", &idade); // Lê um inteiro e armazena no endereço de 'idade'
    
    printf("Você tem %d anos.\\n", idade);
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.text_fields,
                        title: 'Lendo Textos (Strings)',
                        content:
                            'Ler textos requer atenção. `scanf("%s", ...)` lê apenas uma palavra (até o primeiro espaço). Para ler uma linha completa com espaços, a função `fgets` é a mais segura e recomendada.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
// Lendo um nome completo
#include <stdio.h>

int main() {
    char nome[50]; // Reserva espaço para 50 caracteres

    printf("Digite seu nome completo: ");
    fgets(nome, 50, stdin); // Lê até 49 caracteres (ou até o Enter) da entrada padrão (stdin)

    printf("Olá, %s", nome);
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.warning_amber_rounded,
                        title: 'Pontos Cruciais',
                        content:
                            '● `scanf` pode ser inseguro para ler strings, pois não limita o tamanho, podendo causar "buffer overflow". Prefira `fgets`.\n● Ao ler um número e depois um texto, um `\\n` (Enter) pode ficar "preso" no buffer, atrapalhando a próxima leitura. É um bug comum que exige limpeza do buffer.',
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
    // ... (código do botão é idêntico ao da tela anterior)
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

// --- Widgets de Suporte (Reutilizados e Adaptados) ---

class _InfoCard extends StatelessWidget {
  // ... (código idêntico ao da tela anterior)
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
  // ... (código idêntico ao da tela anterior)
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

class _SpecifierGrid extends StatelessWidget {
  final List<List<String>> specifiers;

  const _SpecifierGrid({required this.specifiers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        alignment: WrapAlignment.center,
        children: specifiers.map((spec) {
          return Chip(
            backgroundColor: AppColors.primary,
            avatar: CircleAvatar(
              backgroundColor: AppColors.accent,
              child: Text(
                spec[0],
                style: GoogleFonts.robotoMono(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            label: Text(spec[1]),
            labelStyle: GoogleFonts.poppins(
              color: AppColors.textSecondary,
            ),
            side: BorderSide(color: AppColors.accent.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}