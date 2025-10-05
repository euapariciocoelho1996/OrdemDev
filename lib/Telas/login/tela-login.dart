import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Se você tiver um arquivo de cores, pode remover a classe AppColors daqui
// e importar o seu. Coloquei aqui para o código ser autossuficiente.
class AppColors {
  static const Color background = Color(0xFF0F172A); // Azul Ardósia Escuro
  static const Color primary = Color(0xFF38BDF8); // Azul Elétrico
  static const Color accent = Color(0xFF4ADE80); // Verde Neon
  static const Color textPrimary = Color(0xFFE2E8F0); // Quase Branco
  static const Color textSecondary = Color(0xFF94A3B8); // Cinza Azulado
  static const Color card = Color(0xFF1E293B); // Card Azul Escuro
  static const Color error = Color(0xFFF87171); // Vermelho Claro
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  // =======================================================================
  // TODA A LÓGICA DE NEGÓCIO FOI MANTIDA EXATAMENTE COMO A ORIGINAL
  // =======================================================================

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
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

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao fazer login.';
      switch (e.code) {
        case 'invalid-email':
          msg = 'Formato de e-mail inválido.';
          break;
        case 'user-disabled':
          msg = 'Esta conta foi desativada.';
          break;
        case 'user-not-found':
          msg = 'Usuário não encontrado.';
          break;
        case 'wrong-password':
          msg = 'Senha incorreta.';
          break;
        case 'too-many-requests':
          msg = 'Muitas tentativas. Tente novamente mais tarde.';
          break;
        // Adicionando um caso para credenciais inválidas em geral
        case 'invalid-credential':
            msg = 'Credenciais inválidas. Verifique seu e-mail e senha.';
            break;
      }
      setState(() => _errorMessage = msg);
    } catch (_) {
      setState(() => _errorMessage = 'Erro inesperado. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Informe seu e-mail para redefinir a senha.');
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => _errorMessage = 'Digite um e-mail válido.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'E-mail de recuperação enviado! Verifique sua caixa de entrada.',
            ),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao solicitar redefinição de senha.';
      if (e.code == 'user-not-found') msg = 'Usuário não encontrado com esse e-mail.';
      if (e.code == 'invalid-email') msg = 'Formato de e-mail inválido.';
      setState(() => _errorMessage = msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo com efeito de brilho
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
                  child: const Icon(Icons.code_off_outlined,
                      size: 50, color: AppColors.primary),
                ),
                const SizedBox(height: 32),

                // Título
                Text(
                  'Quase lá',
                  style: GoogleFonts.robotoMono(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Acesse sua conta para continuar sua jornada dev.',
                  style: GoogleFonts.robotoMono(
                      fontSize: 16, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Campo de e-mail
                _buildTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    icon: Icons.alternate_email_rounded),
                const SizedBox(height: 20),

                // Campo de senha
                _buildTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                const SizedBox(height: 12),

                // Esqueci minha senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: Text('Esqueceu a senha?',
                        style: GoogleFonts.robotoMono(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Exibição de Erro
                if (_errorMessage != null)
                  _buildErrorMessage(_errorMessage!),
                  
                const SizedBox(height: 24),

                // Botão Entrar
                _buildLoginButton(),
                const SizedBox(height: 24),

                // Link para Criar Conta
                _buildCreateAccountLink(),

              ],
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
          ),
        ),
      ),
    );
  }
  
  // =======================================================================
  // WIDGETS DE UI REFEITOS COM O NOVO DESIGN
  // =======================================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.robotoMono(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
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

Widget _buildLoginButton() {
  return ElevatedButton(
    onPressed: _isLoading ? null : _signInWithEmail,
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
                'Entrar',
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


  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta?',
          style: GoogleFonts.robotoMono(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.pushNamed(context, '/register'),
          child: Text(
            'Crie uma',
            style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
        ),
      ],
    );
  }
}