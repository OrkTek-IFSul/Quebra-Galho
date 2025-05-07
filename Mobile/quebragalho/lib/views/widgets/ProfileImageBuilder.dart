import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';

/// Widget para carregar imagens de perfil com fallback para a primeira letra do nome.
/// Usa um builder pattern para fornecer a ImageProvider ao widget filho.
class ProfileImageBuilder extends StatelessWidget {
  final Prestador prestador;
  final Widget Function(BuildContext context, ImageProvider? imageProvider) builder;

  const ProfileImageBuilder({
    super.key,
    required this.prestador,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    // Se não houver imgPerfil, retornamos null para o imageProvider
    if (prestador.imgPerfil == null || prestador.imgPerfil!.isEmpty) {
      return builder(context, null);
    }

    // Tenta carregar a imagem da URL
    return FutureBuilder<Object>(
      future: _precacheImage(prestador.imgPerfil!, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {
          // Imagem carregada com sucesso
          return builder(
            context,
            NetworkImage(prestador.imgPerfil!),
          );
        } else if (snapshot.hasError || snapshot.data == false) {
          // Erro ao carregar a imagem, usar fallback
          debugPrint('Erro ao carregar imagem: ${snapshot.error}');
          return builder(context, null);
        } else {
          // Ainda carregando, usar fallback temporariamente
          return builder(context, null);
        }
      },
    );
  }

  Future<bool> _precacheImage(String url, BuildContext context) async {
    try {
      // Verifica se a URL é válida ou acessível
      final imageProvider = NetworkImage(url);
      await precacheImage(imageProvider, context);
      return true;
    } catch (e) {
      debugPrint('Erro ao pré-carregar imagem: $e');
      return false;
    }
  }
}