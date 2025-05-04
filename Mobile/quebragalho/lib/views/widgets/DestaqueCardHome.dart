import 'package:flutter/material.dart';

class DestaqueCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String tag;
  final int price;
  final VoidCallback? onTap;

  const DestaqueCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.tag,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 320,
      child: Stack(
        clipBehavior:
            Clip.none, // Permite que o conteúdo do Stack ultrapasse os limites
        children: [
          Card(
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
                          radius: 40,
                          backgroundImage: NetworkImage(imageUrl),
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 10,
                              ),
                            ),
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
