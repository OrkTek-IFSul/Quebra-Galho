import 'package:flutter/material.dart';

class PrestadorHomeCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final List<String> categories;
  final double rating;
  final VoidCallback onTap;

  const PrestadorHomeCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.categories,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagem do perfil
              // Imagem do perfil com cantos arredondados (não é círculo)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),

              SizedBox(width: 12),
              // Informações do prestador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Wrap para as categorias
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children:
                          categories
                              .map(
                                (category) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
              // Avaliação
              Column(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
