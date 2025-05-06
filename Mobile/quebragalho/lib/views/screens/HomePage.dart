import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/PrestadorPage_UserVision.dart';
import 'package:flutter_quebragalho/views/screens/notificationsPage.dart';
import 'package:flutter_quebragalho/views/widgets/DestaqueCardHome.dart';
import 'package:flutter_quebragalho/views/widgets/ProfessionalCardItem.dart';
import 'package:flutter_quebragalho/views/widgets/_HeaderDelegate.dart';
import 'package:flutter_quebragalho/views/widgets/buildTabCategories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = [
    'Todos',
    'Mecânico',
    'Eletricista',
    'Encanador',
    'Pintor',
    'Diarista',
  ];

  final professionals = [
    {
      'imageUrl':
          'https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png',
      'name': 'João Silva',
      'tag': 'Mecânico',
      'price': 85.0,
      'isVerified': true,
    },
    {
      'imageUrl':
          'https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png',
      'name': 'Maria Santos',
      'tag': 'Eletricista',
      'price': 99.0,
      'isVerified': false,
    },
    {
      'imageUrl':
          'https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png',
      'name': 'Pedro Oliveira',
      'tag': 'Encanador',
      'price': 75.0,
      'isVerified': false,
    },
    {
      'imageUrl':
          'https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png',
      'name': 'Pedro Oliveira',
      'tag': 'Encanador',
      'price': 75.0,
      'isVerified': true,
    },
    {
      'imageUrl':
          'https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png',
      'name': 'Pedro Oliveira',
      'tag': 'Encanador',
      'price': 75.0,
      'isVerified': true,
    },
    {
      'imageUrl':
          'https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png',
      'name': 'Pedro Oliveira',
      'tag': 'Encanador',
      'price': 75.0,
      'isVerified': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            expandedHeight: 80,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
              ).copyWith(top: MediaQuery.of(context).padding.top + 10),
              child: Row(
                children: [
                  Text(
                    'O que você precisa ',
                    style: TextStyle(color: Colors.purple, fontSize: 24),
                  ),
                  Text(
                    'hoje?',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.notifications_none_outlined),
                    color: Colors.purple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Título 'Destaques' na homepage
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.diamond_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Destaques',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Ver mais',
                          style: TextStyle(color: Colors.purple, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Destaques na homepage
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: DestaqueCard(
                          imageUrl:
                              "https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png",
                          name: "Nome Template",
                          tag: "Tag Template",
                          price: 75,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrestadorPageUserVision(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              ),
            ),
          ),

          // SliverPersistente para categorias
          SliverPersistentHeader(
            pinned: true,
            delegate: CategoryHeaderDelegate(
              minExtent: 160,
              maxExtent: 160,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 45),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Pesquise...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Color(0xFFC4C4C4)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomCategoryTabBar(
                      categories: categories,
                      onCategorySelected: (index) {
                        debugPrint(
                          'Categoria selecionada: ${categories[index]}',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final professional = professionals[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: 8,
                ),
                child: ProfessionalCard(
                  imageUrl: professional['imageUrl'] as String,
                  name: professional['name'] as String,
                  tag: professional['tag'] as String,
                  price: professional['price'] as double,
                  isVerified: professional['isVerified'] as bool,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrestadorPageUserVision(),
                      ),
                    );
                  },
                ),
              );
            }, childCount: professionals.length),
          ),
        ],
      ),
    );
  }
}
