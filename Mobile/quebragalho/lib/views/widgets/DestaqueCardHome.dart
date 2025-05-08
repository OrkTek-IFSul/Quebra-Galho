import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/tag_model.dart';

class DestaqueCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final List<Tag> tags;
  final int price;
  final VoidCallback? onTap;
  final ImageProvider? imageProvider;

  const DestaqueCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.tags,
    required this.price,
    this.onTap,
    this.imageProvider,
  });

  ImageProvider? get _finalImageProvider {
    try {
      if (imageProvider != null) return imageProvider;
      if (imageUrl.trim().isEmpty) return null;
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return NetworkImage(imageUrl);
      }
    } catch (_) {
      // Qualquer erro na criação da imagem, retorna null e mostra o container roxo
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider? finalImage = _finalImageProvider;

    return SizedBox(
      width: 250,
      height: 320,
      child: Stack(
        clipBehavior:
            Clip.none, // Permite que o conteúdo do Stack ultrapasse os limites
        children: [
          Card(
            color: Colors.white,
            clipBehavior:
                Clip.none, // Permite que o conteúdo ultrapasse os limites do card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                35,
              ), // Cantos mais arredondados
              side: const BorderSide(
                color: Color.fromARGB(255, 204, 204, 204),
                width: 1.0,
              ), // Borda cinza adicionada
            ),
            child: Stack(
              clipBehavior:
                  Clip.none, // Permite que o conteúdo do Stack ultrapasse os limites
              children: [
                InkWell(
                  splashColor: Colors.purple,
                  onTap: onTap,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 40,
                          backgroundImage: finalImage,
                          child:
                              finalImage == null
                                  ? Center(
                                    child: Text(
                                      name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                  : null,
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          // Exibe todas as tags em um Wrap
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children:
                                tags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          tag.nome, // ✅ Acessa o nome de cada tag individual
                                          style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          Row(
                            children: [
                              const Text(
                                "R\$ ",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                price.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.purple,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              const Text(
                                "/ h ",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Esfera roxa com ícone de seta no canto inferior direito
          Positioned(
            bottom: 0, // Faz a esfera escapar mais para fora do card
            right: 0, // Faz a esfera escapar mais para fora do card
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
