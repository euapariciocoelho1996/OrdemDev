import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfilePhotoService {
  static const String _profilePhotoUrlKey = 'profile_photo_url';
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final ImagePicker _picker = ImagePicker();

  /// Obtém a URL da foto de perfil do usuário
  static Future<String?> getProfilePhotoUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Primeiro tenta buscar do Firestore
      final doc = await _firestore.collection('user_profiles').doc(user.uid).get();
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('photoUrl')) {
        final photoUrl = doc['photoUrl'] as String;
        // Sincroniza com o local
        await _savePhotoUrlToLocal(photoUrl);
        return photoUrl;
      }
    } catch (e) {
      print('Erro ao buscar foto do Firestore: $e');
    }

    // Se não houver no Firestore, busca do local
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilePhotoUrlKey);
  }

  /// Salva a URL da foto de perfil
  static Future<void> saveProfilePhotoUrl(String photoUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Salva no Firestore
      await _firestore.collection('user_profiles').doc(user.uid).set({
        'photoUrl': photoUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Salva localmente
      await _savePhotoUrlToLocal(photoUrl);
      print('URL da foto salva com sucesso');
    } catch (e) {
      print('Erro ao salvar URL da foto: $e');
    }
  }

  /// Verifica se há conectividade com a internet
  static Future<bool> _hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Erro ao verificar conectividade: $e');
      return false;
    }
  }

  /// Faz upload da foto para o Firebase Storage
  static Future<String?> uploadProfilePhoto(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuário não autenticado');
      return null;
    }

    // Verifica conectividade
    final hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      print('Sem conexão com a internet');
      return null;
    }

    try {
      // Cria referência no Storage com timestamp para evitar conflitos
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('profile_photos/${user.uid}_$timestamp.jpg');
      
      // Configurações de upload
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': user.uid,
          'uploadedAt': timestamp.toString(),
        },
      );
      
      print('Iniciando upload da foto...');
      
      // Faz upload do arquivo
      final uploadTask = ref.putFile(imageFile, metadata);
      
      // Aguarda o upload completar
      final snapshot = await uploadTask;
      
      // Obtém a URL de download
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('Foto enviada com sucesso: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Erro ao fazer upload da foto: $e');
      if (e.toString().contains('object-not-found')) {
        print('Erro: Objeto não encontrado no Storage. Verifique as regras de segurança do Firebase Storage.');
      } else if (e.toString().contains('permission-denied')) {
        print('Erro: Permissão negada. Verifique as regras de segurança do Firebase Storage.');
      } else if (e.toString().contains('network')) {
        print('Erro de rede. Verifique sua conexão com a internet.');
      }
      return null;
    }
  }

  /// Seleciona e edita uma foto da galeria
  static Future<File?> pickAndCropImage() async {
    try {
      // Seleciona a imagem
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      // Edita a imagem (crop)
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Ajustar Foto',
            toolbarColor: const Color(0xFF0D1117),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            backgroundColor: const Color(0xFF0D1117),
            activeControlsWidgetColor: const Color(0xFF00BFFF),
            cropFrameColor: const Color(0xFF00BFFF),
            cropGridColor: const Color(0xFF00BFFF).withOpacity(0.5),
          ),
          IOSUiSettings(
            title: 'Ajustar Foto',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            doneButtonTitle: 'Concluir',
            cancelButtonTitle: 'Cancelar',
          ),
        ],
      );

      if (croppedFile == null) return null;
      return File(croppedFile.path);
    } catch (e) {
      print('Erro ao selecionar/editar imagem: $e');
      return null;
    }
  }

  /// Seleciona e edita uma foto da câmera
  static Future<File?> takeAndCropPhoto() async {
    try {
      // Tira a foto
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      // Edita a imagem (crop)
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Ajustar Foto',
            toolbarColor: const Color(0xFF0D1117),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            backgroundColor: const Color(0xFF0D1117),
            activeControlsWidgetColor: const Color(0xFF00BFFF),
            cropFrameColor: const Color(0xFF00BFFF),
            cropGridColor: const Color(0xFF00BFFF).withOpacity(0.5),
          ),
          IOSUiSettings(
            title: 'Ajustar Foto',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            doneButtonTitle: 'Concluir',
            cancelButtonTitle: 'Cancelar',
          ),
        ],
      );

      if (croppedFile == null) return null;
      return File(croppedFile.path);
    } catch (e) {
      print('Erro ao tirar/editar foto: $e');
      return null;
    }
  }

  /// Processo completo: seleciona, edita, faz upload e salva a URL
  static Future<bool> updateProfilePhoto({bool fromCamera = false}) async {
    try {
      // Seleciona e edita a imagem
      final File? imageFile = fromCamera 
          ? await takeAndCropPhoto() 
          : await pickAndCropImage();
      
      if (imageFile == null) return false;

      // Faz upload para o Storage
      final String? photoUrl = await uploadProfilePhoto(imageFile);
      if (photoUrl == null) return false;

      // Salva a URL no Firestore e localmente
      await saveProfilePhotoUrl(photoUrl);
      
      // Limpa fotos antigas (opcional)
      await _cleanupOldPhotos();
      
      return true;
    } catch (e) {
      print('Erro ao atualizar foto de perfil: $e');
      return false;
    }
  }

  /// Limpa fotos antigas do usuário (mantém apenas as 3 mais recentes)
  static Future<void> _cleanupOldPhotos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final listRef = _storage.ref().child('profile_photos');
      final result = await listRef.listAll();
      
      // Filtra apenas as fotos do usuário atual
      final userPhotos = result.items
          .where((item) => item.name.startsWith('${user.uid}_'))
          .toList();
      
      // Ordena por data de criação (mais recente primeiro)
      userPhotos.sort((a, b) => b.name.compareTo(a.name));
      
      // Remove fotos antigas (mantém apenas as 3 mais recentes)
      if (userPhotos.length > 3) {
        for (int i = 3; i < userPhotos.length; i++) {
          try {
            await userPhotos[i].delete();
            print('Foto antiga removida: ${userPhotos[i].name}');
          } catch (e) {
            print('Erro ao remover foto antiga ${userPhotos[i].name}: $e');
          }
        }
      }
    } catch (e) {
      print('Erro ao limpar fotos antigas: $e');
    }
  }

  /// Remove a foto de perfil
  static Future<void> removeProfilePhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Remove todas as fotos do usuário do Storage
      final listRef = _storage.ref().child('profile_photos');
      final result = await listRef.listAll();
      
      for (final item in result.items) {
        if (item.name.startsWith('${user.uid}_')) {
          try {
            await item.delete();
            print('Foto removida do Storage: ${item.name}');
          } catch (e) {
            print('Erro ao remover foto ${item.name}: $e');
          }
        }
      }

      // Remove do Firestore
      await _firestore.collection('user_profiles').doc(user.uid).update({
        'photoUrl': FieldValue.delete(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Remove localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profilePhotoUrlKey);

      print('Foto de perfil removida com sucesso');
    } catch (e) {
      print('Erro ao remover foto de perfil: $e');
    }
  }

  /// Salva a URL da foto localmente
  static Future<void> _savePhotoUrlToLocal(String photoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilePhotoUrlKey, photoUrl);
  }
}
