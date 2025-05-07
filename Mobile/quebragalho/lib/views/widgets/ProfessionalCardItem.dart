import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/tag_model.dart';

class ProfessionalCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final List<Tag> tags;
  final double price;
  final bool isVerified;
  final VoidCallback? onTap;
  final ImageProvider? imageProvider;

  const ProfessionalCard({
    super.key,
    this.imageUrl,
    required this.name,
    required this.tags,
    required this.price,
    required this.isVerified,
    this.onTap,
    this.imageProvider,
  });

  ImageProvider? get _finalImageProvider {
    try {
      if (imageProvider != null) return imageProvider;
      if (imageUrl == null || imageUrl!.trim().isEmpty) return null;
      if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
        return NetworkImage(imageUrl!);
      }
    } catch (_) {
      // Qualquer erro na criação da imagem, retorna null e mostra o container roxo
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider? finalImage = _finalImageProvider;

    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.purple,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            finalImage == null
                                ? const Color.fromARGB(255, 120, 0, 141)
                                : null,
                        image:
                            finalImage != null
                                ? DecorationImage(
                                  image: finalImage,
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          finalImage == null
                              ? Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : null,
                    ),
                  ),

                  // LINHA COM CONSTRUÇÃO CARD
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 38, 0, 73),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isVerified)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.verified,
                                color: Colors.purple,
                                size: 18,
                              ),
                            ),
                        ],
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
                                      horizontal: 6.0,
                                      vertical: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        244,
                                        184,
                                        255,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      tag.nome, // ✅ Acessa a tag correta
                                      style: const TextStyle(
                                        color: Colors.purple,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  /*Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      children: [
                        const Text(
                          "R\$ ",
                          style: TextStyle(color: Colors.purple, fontSize: 14),
                        ),
                        Text(
                          price.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "/h ",
                          style: TextStyle(color: Colors.purple, fontSize: 14),
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 199, 199, 199),
        ),
      ],
    );
  }
}
