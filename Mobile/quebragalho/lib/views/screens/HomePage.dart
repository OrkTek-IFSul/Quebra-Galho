import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/tag_model.dart';
import 'package:flutter_quebragalho/services/prestador_service.dart';
import 'package:flutter_quebragalho/services/tag_service.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';
import 'package:flutter_quebragalho/views/screens/PrestadorPage_UserVision.dart';
import 'package:flutter_quebragalho/views/widgets/ProfessionalCardItem.dart';
import 'package:flutter_quebragalho/views/widgets/ProfileImageBuilder.dart';
import 'package:flutter_quebragalho/views/widgets/_HeaderDelegate.dart';
import 'package:flutter_quebragalho/views/widgets/buildTabCategories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //VARIAVEIS REFERENTES AS TAGS
  List<Tag> tags = [];
  final Tag todosTag = Tag(id: 0, nome: 'Todos', status: 'ativo');

  bool isLoadingTags = true;
  String? errorTags;

  //VARIAVEIS REFERENTES AOS PRESTADORES
  List<Prestador> prestadores = [];
  bool isLoading = true;
  String? error;

  int selectedTagIndex = 0;

  // Dentro da classe _HomePageState
  List<Prestador> _prestadoresAleatorios = [];

  //VARIAVEIS REFERENTES A BARRA DE BUSCA
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Prestador> _prestadoresFiltrados = [];

  @override
  void initState() {
    super.initState();
    _loadTags();
    _loadPrestadores();
    _loadPrestadores().then((_) {
      _gerarPrestadoresAleatorios();
    });
  }

  // Método para gerar prestadores aleatórios
  void _gerarPrestadoresAleatorios() {
    final random = Random();
    _prestadoresAleatorios = List.generate(10, (index) {
      return prestadores[random.nextInt(prestadores.length)];
    });
  }

  // Método para carregar as tags da API
  Future<void> _loadTags() async {
    try {
      setState(() {
        isLoadingTags = true;
        errorTags = null;
      });

      // Buscar todas as tags da API
      final loadedTags = await TagService.getTodasTags();

      setState(() {
        // Adicionar a tag "Todos" no início e depois as tags da API
        tags = [todosTag, ...loadedTags];
        isLoadingTags = false;
      });
    } catch (e) {
      setState(() {
        errorTags = 'Erro ao carregar categorias: $e';
        isLoadingTags = false;
      });
      debugPrint('Erro ao carregar categorias: $e');
    }
  }

  //Método para carregar os prestadores e add na lista de prestadores
  Future<void> _loadPrestadores() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final loadedPrestadores = await PrestadorService.getPrestadores();

      setState(() {
        prestadores = loadedPrestadores;
        _aplicarFiltros();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Erro ao carregar prestadores: $e';
        isLoading = false;
      });
      debugPrint('Erro ao carregar prestadores: $e');
    }
  }

  // Método para carregar todos os dados (tags e prestadores)
  Future<void> _refreshAll() async {
    await Future.wait([_loadTags(), _loadPrestadores()]);
  }

  // Método para filtrar prestadores por tag (será implementado posteriormente)
  void _filtrarPrestadores(String query) {
    _searchQuery = query;
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    setState(() {
      _prestadoresFiltrados =
          prestadores.where((p) {
            // Filtro por pesquisa
            final matchesSearch = p.nome.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );

            // Filtro por tag
            final selectedTag = tags[selectedTagIndex];
            final matchesTag =
                selectedTag.id == 0 || // Tag "Todos"
                p.tags.any((tagPrestador) => tagPrestador.id == selectedTag.id);

            return matchesSearch && matchesTag;
          }).toList();
    });
  }

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
                  /*IconButton(
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
                  ),*/
                ],
              ),
            ),
          ),

          // SliverPersistentHeader para categorias
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
                    SizedBox(height: 30),
                    TextField(
                      controller: _searchController,
                      onChanged: _filtrarPrestadores,
                      decoration: InputDecoration(
                        hintText: 'Pesquise...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
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
                    const SizedBox(height: 10),

                    if (isLoadingTags)
                      Center(
                        child: SizedBox(
                          height: 40,
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                        ),
                      )
                    else if (errorTags != null)
                      Center(
                        child: Text(
                          'Erro ao carregar categorias',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    else
                      CustomCategoryTabBar(
                        categories: tags.map((tag) => tag.nome).toList(),
                        onTagSelected: (index) {
                          setState(() {
                            selectedTagIndex = index;
                          });
                          _aplicarFiltros();
                        },
                        initialSelectedIndex: selectedTagIndex,
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Estado de carregamento
          if(isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Colors.purple),
              ),
            )
          else if (error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      error!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadPrestadores,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      child: Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            )
          else if (prestadores.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'Nenhum prestador encontrado',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final prestador = _prestadoresFiltrados[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: 8,
                  ),
                  child: ProfileImageBuilder(
                    prestador: prestador,
                    builder: (context, imageProvider) {
                      return ProfessionalCard(
                        // Não usamos aqui, fornecemos o imageProvider
                        imageUrl: prestador.imgPerfil,
                        name: prestador.nome,
                        tags: prestador.tags,
                        price: 99, // Valor padrão se não existir
                        isVerified: prestador.isVerified,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrestadorPageUserVision(prestador: prestador),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }, 
              childCount: _prestadoresFiltrados.length),
            ),
        ],
      ),
    );
  }
}