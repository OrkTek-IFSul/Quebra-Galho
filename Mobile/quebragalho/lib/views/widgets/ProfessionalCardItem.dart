import 'package:flutter/material.dart';

class ProfessionalCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String tag;
  final double price;
  final bool isVerified; // Novo parâmetro para verificação
  final VoidCallback? onTap;

  const ProfessionalCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.tag,
    required this.price,
    required this.isVerified, // Valor padrão é falso
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Ícone de verificação, exibido apenas se isVerified for true
                          if (isVerified)
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.verified,
                                color: Colors.purple,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
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
                  ),
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
