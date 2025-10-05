import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Imports (mantenha os seus imports originais aqui)
import 'package:OrdemDev/body/BodyContainer.dart';
import '../jogo-ordenacao/tela-niveis-order.dart';
import '../../appBar/app-bar.dart';
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

class HeapSortScreen extends StatelessWidget {
  const HeapSortScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Heap Sort'),
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
                        icon: Icons.hub_outlined,
                        title: 'O que é um Heap?',
                        content:
                            'Um Heap é uma estrutura de dados de árvore binária especializada. No Heap Sort, usamos um "Max-Heap", onde o valor de cada nó pai é sempre maior ou igual aos seus filhos. Isso garante que o maior elemento da coleção esteja sempre na raiz da árvore (o primeiro elemento do array).',
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.sync_alt,
                        title: 'Conceitos Chave: Heapify e Swap',
                        content:
                            '● Heapify: É o processo de reorganizar a árvore para manter a propriedade de Max-Heap. Quando um elemento é removido ou trocado, o heapify "conserta" a estrutura, garantindo que o maior elemento volte para a raiz.\n\n'
                            '● Swap (Troca): O algoritmo repetidamente troca o elemento raiz (o maior) com o último elemento da porção não ordenada do array e, em seguida, reduz o tamanho do heap em um.',
                      ),
                      const SizedBox(height: 20),
                      _VisualStepCard(
                        icon: Icons.visibility,
                        title: 'Passo a Passo Visual',
                        children: [
                          _buildStepImage('assets/All_Itens/heap1.png',
                              '1. Primeiro, construímos um Max-Heap a partir do array desordenado. O maior elemento (16) vai para a raiz.'),
                          _buildStepImage('assets/All_Itens/heap2.png',
                              '2. Trocamos a raiz (16) com o último elemento (7). O 16 agora está em sua posição final e ordenada.'),
                          _buildStepImage('assets/All_Itens/heap3.png',
                              '3. Reduzimos o tamanho do heap (ignorando o 16) e aplicamos o "heapify" na nova raiz para restaurar a propriedade de Max-Heap.'),
                          _buildStepImage('assets/All_Itens/heap4.png',
                              '4. Repetimos o processo: trocamos a nova raiz (14) com o último elemento (1), e assim por diante, até que todo o array esteja ordenado.'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _InfoCard(
                        icon: Icons.bar_chart,
                        title: 'Complexidade de Tempo',
                        content:
                            'O Heap Sort é notavelmente consistente. Sua complexidade de tempo é a mesma em todos os cenários:\n\n'
                            '● Melhor Caso: O(n log n)\n'
                            '● Médio Caso: O(n log n)\n'
                            '● Pior Caso: O(n log n)\n\n'
                            'Isso o torna mais eficiente que o Bubble Sort e o Quick Sort (no pior caso).',
                      ),
                      const SizedBox(height: 20),
                      _CodeBlock(
                        language: 'c',
                        code: '''
#include <stdio.h>

// Função para trocar dois elementos
void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Função para manter a propriedade de max-heap
void heapify(int arr[], int n, int i) {
    int largest = i; // Inicializa o maior como a raiz
    int left = 2 * i + 1; // Filho da esquerda
    int right = 2 * i + 2; // Filho da direita

    // Se o filho da esquerda for maior que a raiz
    if (left < n && arr[left] > arr[largest])
        largest = left;

    // Se o filho da direita for maior que o maior até agora
    if (right < n && arr[right] > arr[largest])
        largest = right;

    // Se o maior não for a raiz
    if (largest != i) {
        swap(&arr[i], &arr[largest]);
        // Aplica heapify recursivamente na sub-árvore afetada
        heapify(arr, n, largest);
    }
}

// Função principal do Heap Sort
void heapSort(int arr[], int n) {
    // Constrói o max-heap (reorganiza o array)
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(arr, n, i);

    // Extrai um por um os elementos do heap
    for (int i = n - 1; i > 0; i--) {
        // Move a raiz atual (maior elemento) para o fim
        swap(&arr[0], &arr[i]);
        // Chama heapify no heap reduzido
        heapify(arr, i, 0);
    }
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

  // Helper para construir os passos visuais
  Widget _buildStepImage(String imagePath, String caption) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
                              builder: (_) => const NewContentLevelsScreen()),
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

// --- Widgets de Suporte ---

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

class _VisualStepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _VisualStepCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.accent, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
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
                    Clipboard.setData(ClipboardData(text: code.trim()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado!')),
                    );
                  },
                ),
              ],
            ),
          ),
          HighlightView(
            code.trim(),
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