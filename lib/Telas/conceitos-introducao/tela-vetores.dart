import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

// Paleta de cores para consistência visual
class AppColors {
  static const Color background = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF16213E);
  static const Color accent = Color(0xFF00BFFF); // DeepSkyBlue
  static const Color text = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color cardBackground = Color(0xFF1F294A);
}

class ArraysScreenC extends StatelessWidget {
  const ArraysScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Vetores (Arrays) em C'),
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
                        icon: Icons.view_module,
                        title: 'O que são Vetores?',
                        content:
                            'Pense em um vetor como um armário com gavetas numeradas. É uma coleção de itens do mesmo tipo (só inteiros, só floats, etc.) guardados em sequência. Em C, o número de "gavetas" (tamanho) é fixo e definido na criação.',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.create,
                        title: 'Declarando e Acessando',
                        content:
                            'Para declarar, você define o `tipo`, o `nome` e o `tamanho` entre colchetes. Para acessar uma "gaveta", você usa o nome do vetor e o número (índice) da gaveta.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    // Declara um vetor de 5 inteiros (gavetas de 0 a 4)
    int notas[5]; 

    // Atribui valores às primeiras duas "gavetas"
    notas[0] = 10;
    notas[1] = 8;

    // Acessa e imprime o valor da primeira gaveta
    printf("A primeira nota é: %d\\n", notas[0]); // Saída: 10

    // Declara e inicializa um vetor ao mesmo tempo
    float alturas[] = {1.75, 1.80, 1.65};
    
    return 0;
}
''',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.looks_one,
                        title: 'Ponto Crucial: Índices Começam em Zero!',
                        content:
                            'A primeira "gaveta" de um vetor é sempre a de número 0, não 1. Um vetor de 5 elementos terá os índices 0, 1, 2, 3 e 4. Esquecer isso é uma das fontes de erros mais comuns!',
                      ),
                      const SizedBox(height: 20),
                       _InfoCard(
                        icon: Icons.sync,
                        title: 'Percorrendo um Vetor',
                        content:
                            'O laço `for` é perfeito para visitar cada elemento do vetor. Usamos a fórmula `sizeof(vetor) / sizeof(vetor[0])` para calcular dinamicamente quantos elementos ele possui.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    int idades[] = {22, 35, 19, 41};
    // tamanho total em bytes / tamanho de um elemento em bytes = nº de elementos
    int total_de_idades = sizeof(idades) / sizeof(idades[0]);

    for (int i = 0; i < total_de_idades; i++) {
        printf("Idade na posição %d: %d\\n", i, idades[i]);
    }

    return 0;
}
''',
                      ),
                       const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.warning_amber_rounded,
                        title: 'Cuidado: Acesso Fora dos Limites!',
                        content:
                            'C não impede você de tentar acessar um índice que não existe (ex: `idades[10]` em um vetor de 4 posições). Isso é chamado de acesso "out of bounds" e causa comportamento indefinido, podendo corromper dados ou travar seu programa.',
                      ),
                       const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.grid_on,
                        title: 'Matrizes (Vetores 2D)',
                        content:
                            'Uma matriz é um vetor de vetores. É como uma planilha ou tabuleiro, onde você precisa de dois índices para acessar um elemento: `matriz[linha][coluna]`.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

int main() {
    // Matriz de 2 linhas e 3 colunas
    int tabuleiro[2][3] = { {1, 2, 3}, {4, 5, 6} };

    // Acessa o elemento na linha 1, coluna 2 (lembre-se que começa em 0)
    printf("Elemento [1][2] = %d\\n", tabuleiro[1][2]); // Saída: 6

    return 0;
}
''',
                      ),
                       const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.input,
                        title: 'Passando Vetores para Funções',
                        content:
                            'Você pode passar um vetor como argumento para uma função. Ao fazer isso, a função recebe um ponteiro para o primeiro elemento, permitindo que ela leia e até modifique o vetor original.',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

// A função recebe um vetor de inteiros e seu tamanho
void imprimir_vetor(int vec[], int tamanho) {
    printf("Conteúdo do vetor: ");
    for (int i = 0; i < tamanho; i++) {
        printf("%d ", vec[i]);
    }
    printf("\\n");
}

int main() {
    int meus_numeros[] = {5, 10, 15};
    int total = sizeof(meus_numeros) / sizeof(meus_numeros[0]);
    
    // Passa o vetor e seu tamanho para a função
    imprimir_vetor(meus_numeros, total);

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