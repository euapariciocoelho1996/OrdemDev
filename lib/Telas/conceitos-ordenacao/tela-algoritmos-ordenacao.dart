import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:flutter/material.dart';
import 'tela-bubble-sort.dart';
import 'tela-selection-sort.dart';
import 'tela-insertion-sort.dart';
import 'tela-quick-sort.dart';
import 'tela-merge-sort.dart';
import 'tela-heap-sort.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/menu_card.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class SortingAlgorithmsScreen extends StatelessWidget {
  const SortingAlgorithmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Algoritmos de Ordenação',
      ),
      body: BodyContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    title: 'Algoritmos de Ordenação',
                    description:
                        'Descubra como organizar dados de forma eficiente com diferentes algoritmos de ordenação. '
                        'Explore o funcionamento do QuickSort, MergeSort, BubbleSort e outros, '
                        'aprenda suas vantagens, desvantagens e como aplicá-los em listas e coleções.',
                  ),

                  const SizedBox(height: 24),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      MenuCard(
                        title: 'Bubble Sort',
                        icon: Icons.bubble_chart,
                        subtitle: 'Simples e didático',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BubbleSortScreen(),
                          ),
                        ),
                        cardIndex: 0,
                      ),
                      MenuCard(
                        title: 'Selection Sort',
                        icon: Icons.select_all,
                        subtitle: 'Seleciona o menor a cada passo',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectionSortScreen(),
                          ),
                        ),
                        cardIndex: 1,
                      ),
                      MenuCard(
                        title: 'Insertion Sort',
                        icon: Icons.input,
                        subtitle: 'Insere ordenando',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InsertionSortScreen(),
                          ),
                        ),
                        cardIndex: 2,
                      ),
                      MenuCard(
                        title: 'QuickSort',
                        icon: Icons.flash_on,
                        subtitle: 'Rápido e eficiente',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuickSortScreen(),
                          ),
                        ),
                        cardIndex: 3,
                      ),
                      MenuCard(
                        title: 'Merge Sort',
                        icon: Icons.merge_type,
                        subtitle: 'Divide e conquista',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MergeSortScreen(),
                          ),
                        ),
                        cardIndex: 4,
                      ),
                      MenuCard(
                        title: 'HeapSort',
                        icon: Icons.account_tree,
                        subtitle: 'Usa estrutura de heap',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HeapSortScreen(),
                          ),
                        ),
                        cardIndex: 5,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
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
}
