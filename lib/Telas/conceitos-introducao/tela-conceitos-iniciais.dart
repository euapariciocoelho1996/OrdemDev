import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../routes.dart';
import '../../appBar/app-bar.dart';
import '../../body/BodyContainer.dart';
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

class BasicConceptsScreen extends StatelessWidget {
  const BasicConceptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Conceitos fundamentais',
      ),
      body: Container(
        
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Conceitos Básicos',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 24),
                  _buildConceptButton(
                    context,
                    'Tipos de Dados',
                    'Aprenda sobre os diferentes tipos de dados em Python',
                    Icons.data_array,
                    AppRoutes.dataTypes,
                  ),
                  const SizedBox(height: 16),
                  _buildConceptButton(
                    context,
                    'Operadores',
                    'Conheça os operadores aritméticos, lógicos e de comparação',
                    Icons.calculate,
                    AppRoutes.operators,
                  ),
                  const SizedBox(height: 16),
                  _buildConceptButton(
                    context,
                    'If/Else',
                    'Entenda as estruturas condicionais',
                    Icons.call_split,
                    AppRoutes.ifElse,
                  ),
                  const SizedBox(height: 16),
                  _buildConceptButton(
                    context,
                    'Laços de Repetição',
                    'Aprenda sobre loops for e while',
                    Icons.loop,
                    AppRoutes.loops,
                  ),
                  const SizedBox(height: 16),
                  _buildConceptButton(
                    context,
                    'Vetores',
                    'Manipule coleções de dados com listas',
                    Icons.list,
                    AppRoutes.lists,
                  ),
                  const SizedBox(height: 16),
                  _buildConceptButton(
                    context,
                    'Funções',
                    'Crie e utilize funções em Python',
                    Icons.functions,
                    AppRoutes.functions,
                  ),
                  _buildConceptButton(
                    context,
                    'Ponteiros',
                    'Crie e utilize funções em Python',
                    Icons.functions,
                    AppRoutes.functions,
                  ),
                  const SizedBox(height: 16),
                  _buildConceptButton(
                    context,
                    'Entrada e Saída',
                    'Interaja com o usuário e manipule arquivos',
                    Icons.input,
                    AppRoutes.inputOutput,
                  ),
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

  Widget _buildConceptButton(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String route,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }
} 