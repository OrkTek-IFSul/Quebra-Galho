import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/prestador_detalhes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/prestador_home_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de categorias (com "Todos" fixo)
  final List<String> categories = [
    'Todos',
    'Elétrica',
    'Encanamento',
    'Pintura',
    'Limpeza',
    'Jardinagem',
  ];

  // Categoria selecionada (começa com "Todos")
  String selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de pesquisa
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Filtros de categorias
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 12),

            // Lista de prestadores
            Expanded(
              child: ListView.builder(
                itemCount:
                    10, // Aqui você pode depois filtrar baseado na categoria
                itemBuilder: (_, index) {
                  return PrestadorHomeCard(
                    name: 'João Consertos',
                    categories: ['Elétrica', 'Encanamento'],
                    rating: 4.8,
                    imageUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUHhw-PjsQMctXKtdjfwGRBfyTlDid2CFZuA&s',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 200),
                          pageBuilder:
                              (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => PrestadorDetalhesPage(
                                name: 'João Consertos',
                                categories: ['Elétrica', 'Encanamento'],
                                imageUrl:
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUHhw-PjsQMctXKtdjfwGRBfyTlDid2CFZuA&s',
                                descricao:
                                    'Profissional top, mais de 10 anos de experiência!',
                                servicos: [
                                  {'nome': 'Trocar resistência', 'preco': 90.0},
                                  {
                                    'nome': 'Instalação hidráulica',
                                    'preco': 150.0,
                                  },
                                  {
                                    'nome': 'Reparo em encanamento',
                                    'preco': 120.0,
                                  },
                                ],
                              ),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            final offsetAnimation = Tween<Offset>(
                              begin: Offset(0.0, 1.5),
                              end: Offset.zero,
                            ).animate(animation);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
