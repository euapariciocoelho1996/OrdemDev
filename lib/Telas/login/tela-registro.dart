import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Classe de cores unificada (a mesma da tela de login)
class AppColors {
  static const Color background = Color(0xFF0F172A); // Azul Ardósia Escuro
  static const Color primary = Color(0xFF38BDF8); // Azul Elétrico
  static const Color accent = Color(0xFF4ADE80); // Verde Neon
  static const Color textPrimary = Color(0xFFE2E8F0); // Quase Branco
  static const Color textSecondary = Color(0xFF94A3B8); // Cinza Azulado
  static const Color card = Color(0xFF1E293B); // Card Azul Escuro
  static const Color error = Color(0xFFF87171); // Vermelho Claro
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;

  // Controles de visibilidade para os campos de senha
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // A lógica de negócio foi mantida, apenas ajustando as mensagens de erro
  Future<void> _createAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = 'Preencha todos os campos.');
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => _errorMessage = 'Digite um e-mail válido.');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'A senha deve ter pelo menos 6 caracteres.');
      return;
    }
    if (password != confirmPassword) {
      setState(() => _errorMessage = 'As senhas não coincidem.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao criar conta.';
      switch (e.code) {
        case 'weak-password':
          msg = 'A senha fornecida é muito fraca.';
          break;
        case 'email-already-in-use':
          msg = 'Este e-mail já está em uso por outra conta.';
          break;
        case 'invalid-email':
          msg = 'O formato do e-mail é inválido.';
          break;
      }
      setState(() => _errorMessage = msg);
    } catch (e) {
      setState(() => _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Padding ajustado para corresponder à tela de login
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Ícone com o mesmo estilo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.card,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person_add_alt_1_rounded,
                      size: 50, color: AppColors.primary),
                ),
                const SizedBox(height: 32),

                // Títulos com o mesmo estilo
                Text(
                  'Crie sua conta',
                  style: GoogleFonts.robotoMono(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Comece sua jornada dev se juntando à comunidade.',
                  style: GoogleFonts.robotoMono(
                      fontSize: 16, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Campos de texto padronizados
                _buildTextField(
                  controller: _nameController,
                  label: 'Nome',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  icon: Icons.alternate_email_rounded,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Senha',
                  icon: Icons.lock_person_outlined,
                  isPassword: true,
                  isVisible: _isConfirmPasswordVisible,
                  onVisibilityToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                ),
                const SizedBox(height: 24),
                
                // Mensagem de erro padronizada
                if (_errorMessage != null)
                  _buildErrorMessage(_errorMessage!),
                  
                const SizedBox(height: 24),

                // Botão de ação principal padronizado
                _buildRegisterButton(),
                const SizedBox(height: 24),

                // Link secundário padronizado
                _buildLoginLink(),

              ],
            // Animação de entrada
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
          ),
        ),
      ),
    );
  }
  
  // =======================================================================
  // WIDGETS DE UI REUTILIZADOS DA TELA DE LOGIN
  // =======================================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      obscureText: isPassword && !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.robotoMono(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.card.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.robotoMono(color: AppColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
    ).animate().shakeX(amount: 4, duration: 400.ms);
  }

Widget _buildRegisterButton() {
  return ElevatedButton(
    onPressed: _isLoading ? null : _createAccount,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 56), // largura infinita, altura mínima
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: !_isLoading
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                )
              ]
            : null,
      ),
      child: Container(
        height: 56, // 🔑 altura fixa para o botão ficar mais encorpado
        alignment: Alignment.center,
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.background,
                ),
              )
            : Text(
                'Criar Conta',
                style: GoogleFonts.robotoMono(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.background,
                ),
              ),
      ),
    ),
  );
}


  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Já tem uma conta?',
          style: GoogleFonts.robotoMono(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.pop(context), // Ação para voltar
          child: Text(
            'Entrar', // Texto do link alterado
            style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
        ),
      ],
    );
  }
}