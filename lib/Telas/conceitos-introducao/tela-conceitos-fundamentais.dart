import 'package:OrdemDev/Header/titulo-cabecalho.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/menu_card.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class BasicConceptsScreen extends StatelessWidget {
  const BasicConceptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Introdução',
      ),
      body: BodyContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                PageHeader(
                  title: 'Fundamentos essenciais da programação',
                  description:
                      'Explore os conceitos essenciais da programação de forma clara e prática. '
                      'Aprenda sobre variáveis, tipos de dados, estruturas de controle, Ponteiros, Vetores e funções, '
                      'tudo preparado para você estudar e praticar.',
                ),
                const SizedBox(height: 32),

                // Grid de conceitos usando MenuCard
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3 / 4,
                  children: [
                    MenuCard(
                      title: 'Variáveis',
                      icon: Icons.memory,
                      subtitle: 'Tipos e Declarações',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.variables),
                      cardIndex: 0,
                    ),
                    MenuCard(
                      title: 'Tipos de Dados',
                      icon: Icons.data_array,
                      subtitle: 'Int, Float, String, Bool',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.dataTypes),
                      cardIndex: 1,
                    ),
                    MenuCard(
                      title: 'Entrada e Saída',
                      icon: Icons.input,
                      subtitle: 'Input e Print',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.inputOutput),
                      cardIndex: 2,
                    ),
                    MenuCard(
                      title: 'Operadores',
                      icon: Icons.calculate,
                      subtitle: 'Aritméticos e Lógicos',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.operators),
                      cardIndex: 3,
                    ),
                    MenuCard(
                      title: 'If/Else',
                      icon: Icons.call_split,
                      subtitle: 'Estruturas condicionais',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.ifElse),
                      cardIndex: 4,
                    ),
                    MenuCard(
                      title: 'Laços de Repetição',
                      icon: Icons.loop,
                      subtitle: 'For, While e Do-While',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.loops),
                      cardIndex: 5,
                    ),
                    MenuCard(
                      title: 'Vetores',
                      icon: Icons.list_alt,
                      subtitle: 'Arrays e Coleções',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.lists),
                      cardIndex: 6,
                    ),
                    MenuCard(
                      title: 'Funções',
                      icon: Icons.functions,
                      subtitle: 'Definição e Chamadas',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.functions),
                      cardIndex: 7,
                    ),
                    MenuCard(
                      title: 'Ponteiros',
                      icon: Icons.trending_up,
                      subtitle: 'Definição e Chamadas',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.pointers),
                      cardIndex: 8,
                    ),
                  ],
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
}
