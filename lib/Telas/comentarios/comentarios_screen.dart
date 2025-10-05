import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../appBar/app-bar.dart'; 
import '../../body/BodyContainer.dart'; 
import '../../Cores/app_colors.dart'; 
import '../../widgets/enhanced_button.dart'; 
import '../../widgets/celebration_effects.dart'; 
import '../../widgets/particle_background.dart'; 
import '../../Telas/telaInicial/btn-home.dart';
import 'package:OrdemDev/Telas/telaInicial/tela-inicial.dart';

//==============================================================================
// TELA PRINCIPAL
//==============================================================================

class ComentariosScreen extends StatefulWidget {
  const ComentariosScreen({super.key});

  @override
  State<ComentariosScreen> createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  final TextEditingController _comentarioController = TextEditingController();
  bool _hasInternetConnection = true;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _onlyMine = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          _hasInternetConnection = result != ConnectivityResult.none;
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _hasInternetConnection = connectivityResult != ConnectivityResult.none;
      });
    }
  }

  Future<void> _enviarComentario() async {
    final texto = _comentarioController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (!_hasInternetConnection) {
      CelebrationUtils.showSimpleError(context, 'Sem conexão com a internet');
      return;
    }

    if (texto.isEmpty || user == null) {
      if (user == null && mounted) {
        CelebrationUtils.showSimpleError(context, 'Você precisa estar logado para comentar');
      }
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('comentarios').add({
        'texto': texto,
        'data': Timestamp.now(),
        'userId': user.uid,
        'userName': user.displayName ?? 'Usuário Anônimo',
        'likes': [],
      });
      _comentarioController.clear();
      if (mounted) {
        CelebrationUtils.showSimpleSuccess(context, 'Comentário enviado com sucesso!');
      }
    } catch (e) {
      debugPrint('Erro ao enviar comentário: $e');
      if (mounted) {
        CelebrationUtils.showSimpleError(context, 'Erro ao enviar o comentário');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return ParticleBackground(
      particleCount: 20,
      particleType: ParticleType.circles,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'Sessão de Comentários',
        ),
        body: BodyContainer(
          child: Column(
            children: [
              // Indicador de conectividade
              if (!_hasInternetConnection)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.errorGradient),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.errorGradient.first.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sem conexão com a internet',
                        style: GoogleFonts.robotoMono(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: -1).fadeIn(),
              // Campo de comentário aprimorado
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.nightGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGradient.first.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deixe seu comentário',
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _comentarioController,
                      enabled: _hasInternetConnection,
                      maxLines: 3,
                      style: GoogleFonts.robotoMono(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Compartilhe suas ideias...',
                        hintStyle: GoogleFonts.robotoMono(
                          color: AppColors.subtleText,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accent.withOpacity(0.4),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.accent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: AppColors.background.withOpacity(0.5),
                        filled: true,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      cursorColor: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: EnhancedButton(
                        text: 'Enviar Comentário',
                        icon: Icons.send,
                        type: ButtonType.primary,
                        onPressed: _hasInternetConnection ? _enviarComentario : null,
                        isLoading: false,
                      ),
                    ),
                  ],
                ),
              ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),
              // Filtro: apenas comentários do usuário logado
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.filter_list, color: AppColors.textPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Meus comentários',
                          style: GoogleFonts.robotoMono(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _onlyMine,
                      activeColor: AppColors.accent,
                      onChanged: (val) {
                        if (!_hasInternetConnection) {
                          CelebrationUtils.showSimpleError(context, 'Sem conexão com a internet');
                          return;
                        }
                        setState(() {
                          _onlyMine = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Lista de comentários
              Expanded(
                child: _hasInternetConnection
                    ? (_onlyMine && currentUser == null)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: AppColors.textSecondary,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Faça login para ver seus comentários',
                                  style: GoogleFonts.robotoMono(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: (() {
                              Query query = FirebaseFirestore.instance
                                  .collection('comentarios');
                              final bool filteringMine = _onlyMine && currentUser != null;
                              if (filteringMine) {
                                // Apenas filtra por userId; ordenação será feita no cliente para evitar necessidade de índice composto
                                query = query.where('userId', isEqualTo: currentUser.uid);
                              } else {
                                // Ordenação no servidor quando não estiver filtrando apenas meus
                                query = query.orderBy('data', descending: true);
                              }
                              return query.snapshots();
                            })(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: AppColors.accent,
                                        strokeWidth: 3,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Carregando comentários...',
                                        style: GoogleFonts.robotoMono(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: AppColors.errorGradient.first,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Erro ao carregar comentários',
                                        style: GoogleFonts.robotoMono(
                                          color: AppColors.errorGradient.first,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              List<QueryDocumentSnapshot> comentarios = List<QueryDocumentSnapshot>.from(snapshot.data?.docs ?? []);
                              // Se filtrando apenas meus comentários, ordenar localmente por data desc
                              if (_onlyMine && currentUser != null) {
                                comentarios.sort((a, b) {
                                  final aData = (a.data() as Map<String, dynamic>);
                                  final bData = (b.data() as Map<String, dynamic>);
                                  final aTs = aData['data'] is Timestamp ? aData['data'] as Timestamp : null;
                                  final bTs = bData['data'] is Timestamp ? bData['data'] as Timestamp : null;
                                  if (aTs == null && bTs == null) return 0;
                                  if (aTs == null) return 1; // nulos ao final
                                  if (bTs == null) return -1;
                                  return bTs.compareTo(aTs); // desc
                                });
                              }
                              if (comentarios.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      
                                      Text(
                                        'Nenhum comentário ainda 👻',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.textPrimary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      
                                      
                                    ],
                                  ),
                                );
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                itemCount: comentarios.length,
                                itemBuilder: (context, index) {
                                  final comentario = comentarios[index];
                                  return CommentCard(
                                    comentario: comentario,
                                    hasInternet: _hasInternetConnection,
                                  ).animate(delay: Duration(milliseconds: index * 100))
                                    .slideX(begin: 0.3)
                                    .fadeIn();
                                },
                              );
                            },
                          )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: AppColors.textSecondary,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sem conexão com a internet',
                              style: GoogleFonts.poppins(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Conecte-se para ver os comentários',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoMono(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
            
        ),
        floatingActionButton: CustomFloatingButton(
            icon: Icons.home,
            color: Colors.deepPurple,
            navigateTo: const HomeScreen(),
          ),
      ),
    );
  }
}

//==============================================================================
// WIDGET PARA CADA CARD DE COMENTÁRIO
//==============================================================================

class CommentCard extends StatefulWidget {
  final QueryDocumentSnapshot comentario;
  final bool hasInternet;

  const CommentCard({
    super.key,
    required this.comentario,
    this.hasInternet = true,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isExpanded = false;

  Future<void> _toggleLike() async {
    if (!widget.hasInternet) {
      CelebrationUtils.showSimpleError(context, 'Sem conexão com a internet');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CelebrationUtils.showSimpleError(context, 'Você precisa estar logado para curtir');
      return;
    }
    final commentRef = FirebaseFirestore.instance
        .collection('comentarios')
        .doc(widget.comentario.id);
    final data = widget.comentario.data() as Map<String, dynamic>;
    final List<String> likes = List<String>.from(data['likes'] ?? []);

    if (likes.contains(user.uid)) {
      await commentRef.update({
        'likes': FieldValue.arrayRemove([user.uid])
      });
    } else {
      await commentRef.update({
        'likes': FieldValue.arrayUnion([user.uid])
      });
    }
  }

  void _mostrarDialogoResposta(String commentId) {
    if (!widget.hasInternet) {
      CelebrationUtils.showSimpleError(context, 'Sem conexão com a internet');
      return;
    }

    final TextEditingController respostaController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Responder ao comentário',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: respostaController,
          autofocus: true,
          maxLines: 3,
          style: GoogleFonts.robotoMono(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Escreva sua resposta...',
            hintStyle: GoogleFonts.robotoMono(color: AppColors.subtleText),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 2.0),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: AppColors.secondaryCard,
            filled: true,
          ),
          cursorColor: AppColors.accent,
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancelar',
              style: GoogleFonts.robotoMono(color: AppColors.textSecondary),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          EnhancedButton(
            text: 'Enviar',
            type: ButtonType.primary,
            onPressed: () async {
              final texto = respostaController.text.trim();
              final user = FirebaseAuth.instance.currentUser;
              if (texto.isEmpty || user == null) return;

              try {
                await FirebaseFirestore.instance
                    .collection('comentarios')
                    .doc(commentId)
                    .collection('respostas')
                    .add({
                  'texto': texto,
                  'data': Timestamp.now(),
                  'userId': user.uid,
                  'userName': user.displayName ?? 'Usuário Anônimo',
                });
                if (mounted) {
                  Navigator.pop(context);
                  CelebrationUtils.showSimpleSuccess(context, 'Resposta enviada!');
                }
              } catch (e) {
                if (mounted) {
                  CelebrationUtils.showSimpleError(context, 'Erro ao enviar resposta');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    if (!widget.hasInternet) {
      CelebrationUtils.showSimpleError(context, 'Sem conexão com a internet');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.errorGradient.first,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Excluir Comentário',
              style: GoogleFonts.poppins(
                color: AppColors.errorGradient.first,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Tem certeza? Esta ação excluirá o comentário e todas as suas respostas permanentemente.',
          style: GoogleFonts.robotoMono(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancelar',
              style: GoogleFonts.robotoMono(color: AppColors.textSecondary),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          EnhancedButton(
            text: 'Excluir',
            type: ButtonType.error,
            onPressed: () {
              _deleteComment();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteComment() async {
    final commentRef = FirebaseFirestore.instance
        .collection('comentarios')
        .doc(widget.comentario.id);
    try {
      final batch = FirebaseFirestore.instance.batch();
      final repliesSnapshot = await commentRef.collection('respostas').get();
      for (final doc in repliesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(commentRef);
      await batch.commit();

      if (mounted) {
        CelebrationUtils.showSimpleSuccess(context, 'Comentário excluído');
      }
    } catch (e) {
      debugPrint('Erro ao excluir comentário: $e');
      if (mounted) {
        CelebrationUtils.showSimpleError(context, 'Erro ao excluir o comentário');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final data = widget.comentario.data() as Map<String, dynamic>;
    final authorId = data['userId'];
    final texto = data['texto'] ?? '';
    final userName = data['userName'] ?? 'Usuário Anônimo';
    final Timestamp? ts = data['data'] as Timestamp?;
    final DateTime? timestamp = ts?.toDate();
    final List<String> likesList = List<String>.from(data['likes'] ?? []);
    final bool isLikedByCurrentUser =
        user != null && likesList.contains(user.uid);
    final int likeCount = likesList.length;
    final bool isAuthor = user != null && user.uid == authorId;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColors.textPrimary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Like button moved to top-right
                    GestureDetector(
                      onTap: widget.hasInternet ? _toggleLike : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isLikedByCurrentUser
                              ? AppColors.cardPink.withOpacity(0.3)
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isLikedByCurrentUser
                                ? AppColors.cardPink
                                : Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLikedByCurrentUser
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isLikedByCurrentUser
                                  ? AppColors.cardPink
                                  : AppColors.textPrimary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              likeCount.toString(),
                              style: GoogleFonts.robotoMono(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isAuthor)
                     
                      Container(
                        padding: const EdgeInsets.all(4), // Adicionado para dar espaço ao ícone
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle, // Alterado para círculo
                        ),
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(Icons.more_vert,
                              size: 20.0, color: AppColors.textPrimary),
                          onSelected: (value) {
                            if (value == 'delete') _showDeleteConfirmationDialog();
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: AppColors.errorGradient.first,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Excluir",
                                    style: GoogleFonts.robotoMono(
                                      color: AppColors.errorGradient.first,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          color: AppColors.primaryCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                texto,
                style: GoogleFonts.robotoMono(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (timestamp != null)
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        // ================== MUDANÇA AQUI (COR DE FUNDO DA DATA) ==================
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year} · ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                          // ================== MUDANÇA AQUI (COR DO TEXTO DA DATA) ==================
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: widget.hasInternet
                            ? () => _mostrarDialogoResposta(widget.comentario.id)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          // ================== MUDANÇA AQUI (ESTILO DO BOTÃO RESPONDER) ==================
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.accent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.reply,
                                color: AppColors.textPrimary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Responder',
                                style: GoogleFonts.robotoMono(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('comentarios')
                  .doc(widget.comentario.id)
                  .collection('respostas')
                  .orderBy('data')
                  .snapshots(),
              builder: (context, replySnapshot) {
                if (replySnapshot.connectionState == ConnectionState.waiting ||
                    !replySnapshot.hasData ||
                    replySnapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }
                final respostas = replySnapshot.data!.docs;
                final totalRespostas = respostas.length;
                final respostasParaMostrar =
                    _isExpanded ? respostas : respostas.take(2);

                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      ...respostasParaMostrar.map((replyDoc) {
                        final replyData =
                            replyDoc.data() as Map<String, dynamic>;
                        final Timestamp? replyTs = replyData['data'] as Timestamp?;
                        final DateTime? replyDate = replyTs?.toDate();
                        final String replyDateStr = replyDate != null
                            ? '${replyDate.day.toString().padLeft(2, '0')}/${replyDate.month.toString().padLeft(2, '0')}/${replyDate.year}'
                            : '';
                        final String replyTimeStr = replyDate != null
                            ? '${replyDate.hour.toString().padLeft(2, '0')}:${replyDate.minute.toString().padLeft(2, '0')}'
                            : '';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.reply,
                                    color: AppColors.subtleText,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    replyData['userName'] ?? 'Usuário Anônimo',
                                    style: GoogleFonts.robotoMono(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                replyData['texto'] ?? '',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (replyDate != null)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '$replyDateStr · $replyTimeStr',
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      if (totalRespostas > 2)
                        Center(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _isExpanded = !_isExpanded),
                            child: Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _isExpanded
                                    ? 'Ocultar respostas'
                                    : 'Ver mais ${totalRespostas - 2} respostas',
                                style: GoogleFonts.robotoMono(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}