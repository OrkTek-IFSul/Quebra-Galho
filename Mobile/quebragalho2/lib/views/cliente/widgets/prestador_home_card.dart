import 'package:flutter/material.dart';

class PrestadorHomeCard extends StatelessWidget {
  final String name;
  final List<String> categories; // Agora é lista
  final double rating;
  final String imageUrl;
  final VoidCallback? onTap;

  const PrestadorHomeCard({super.key, 
    required this.name,
    required this.categories,
    required this.rating,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagem com cantos arredondados
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              SizedBox(width: 10),
      
              // Coluna com nome e categorias
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: categories.take(3).map((cat) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(color: Colors.green.shade800, fontSize: 12),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
      
              // Estrela e nota
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(height: 4),
                  Text(rating.toStringAsFixed(1)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
