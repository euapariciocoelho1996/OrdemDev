import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/new_content_progress_service.dart';
import '../../conexao/tela-perfil-usuario.dart';
import '../../Cores/app_colors.dart';
class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final score = await NewContentProgressService.getUserScore();
    if (mounted) {
      setState(() {
        userScore = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: const Color(0xFF1A2236),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, bottom: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.neutral80, AppColors.background],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardColor,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.videogame_asset_rounded,
                      size: 44, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 16),
                Text(
                  'OrdemDev',
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.7),
                        AppColors.icon,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.9, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child:
                    const Icon(Icons.person, color: Color(0xFF6C88EF), size: 28),
              ),
            ),
            title: Text(
              'Perfil',
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: Colors.white.withOpacity(0.03),
            hoverColor: AppColors.icon,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const UserProfileScreen()),
              );
            },
          ),
          if (user != null) ...[
            const SizedBox(height: 8),
            ListTile(
              leading:
                  Icon(Icons.logout, color: Colors.red.shade300, size: 28),
              title: Text(
                'Sair',
                style: GoogleFonts.robotoMono(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              tileColor: Colors.white.withOpacity(0.03),
              hoverColor: Colors.red.withOpacity(0.08),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
