import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

import 'package:quebragalho2/views/cliente/pages/prestador_detalhes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/prestador_home_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quebragalho2/api_config.dart'; // nova importação para a baseUrl

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ['Todos'];
  List<String> selectedTags = [];
  final TextEditingController searchController = TextEditingController();
  List<dynamic> _prestadoresFiltrados = [];
  bool isLoading = false;
  bool isLoggedIn = false;
  Timer? _debounce;

  int? usuarioId;

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
    _loadInitialData();
    searchController.addListener(_debouncedSearch);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_debouncedSearch);
    searchController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE LÓGICA E DADOS ---

  /// Método centralizador que decide qual busca realizar.
  /// Ele verifica o estado do campo de busca e das tags.
  Future<void> _filtrarEBuscarPrestadores() async {
    setState(() {
      isLoading = true;
    });

    final termoBusca = searchController.text.trim();

    // Condição principal: Se a busca está vazia e nenhuma tag específica
    // foi selecionada, busca todos os prestadores.
    if (termoBusca.isEmpty && selectedTags.isEmpty) {
      await fetchPrestadores();
    } else {
      // Caso contrário, realiza uma busca com os filtros atuais.
      await _searchPrestadoresComFiltros();
    }
  }

  /// Carrega os dados iniciais da página.
  Future<void> _loadInitialData() async {
    await fetchCategorias();
    await _filtrarEBuscarPrestadores(); // Usa o método centralizado
  }

  /// Listener para o campo de busca com debounce.
  void _debouncedSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filtrarEBuscarPrestadores(); // Chama o método centralizado
    });
  }

  // --- MÉTODOS DE API ---

  /// Busca TODOS os prestadores (sem filtros).
  Future<void> fetchPrestadores() async {
    // Garante que o estado de loading seja o correto
    if (!isLoading) setState(() => isLoading = true);

    try {
      final uri = Uri.parse('http://${ApiConfig.baseUrl}/api/usuario/homepage/prestadores');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _prestadoresFiltrados = data;
        });
      } else {
        print('Falha ao carregar prestadores: ${response.statusCode} ${response.body}');
        setState(() => _prestadoresFiltrados = []);
      }
    } catch (e) {
      print('Erro ao carregar prestadores: $e');
      setState(() => _prestadoresFiltrados = []);
    } finally {
      // Garante que o loading seja desativado
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Realiza a busca com os filtros (nome e/ou tags).
  Future<void> _searchPrestadoresComFiltros() async {
    if (!isLoading) setState(() => isLoading = true);

    try {
      final queryParams = {
        if (searchController.text.trim().isNotEmpty) 'nome': searchController.text.trim(),
        if (selectedTags.isNotEmpty) 'tags': selectedTags.join(','),
        'page': '0',
        'size': '10',
      };

      final uri = Uri.parse('http://${ApiConfig.baseUrl}/api/usuario/homepage/buscar')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _prestadoresFiltrados = data['content'] ?? [];
        });
      } else {
        print('Falha ao buscar prestadores: ${response.statusCode} ${response.body}');
        setState(() => _prestadoresFiltrados = []);
      }
    } catch (e) {
      print('Erro na busca: $e');
      setState(() => _prestadoresFiltrados = []);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  
  /// Busca as categorias/tags disponíveis.
  Future<void> fetchCategorias() async {
    try {
      final uri = Uri.parse('http://${ApiConfig.baseUrl}/api/usuario/homepage/tags');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          categories = [
            'Todos',
            ...data.map((tag) => tag['nome'].toString()),
          ];
        });
      } else {
        print('Falha ao carregar categorias: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }
  
  // --- MÉTODOS DE AUTENTICAÇÃO E OUTROS ---
  
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todos os dados de autenticação
    
    if (!mounted) return;
    
    // Navega para LoginPage e remove todas as rotas anteriores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout realizado com sucesso')),
    );
    _loadInitialData(); // Recarrega os dados para o estado de deslogado
  }

  Future<void> carregarUsuarioId() async {
    // Implemente a busca do ID do usuário se necessário
    // final id = await obterIdUsuario(); 
    // setState(() {
    //   usuarioId = id;
    // });
  }

  // --- WIDGETS ---

  /// Constrói os chips de categoria.
  Widget _buildCategoryChip(String category) {
    final isSelected = category == 'Todos'
        ? selectedTags.isEmpty
        : selectedTags.contains(category);

    return ChoiceChip(
      label: Text(category),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
      selected: isSelected,
      onSelected: (bool selected) {
        // A lógica de seleção de tag agora é mais simples.
        // Apenas atualiza o estado da lista `selectedTags`.
        setState(() {
          if (category == 'Todos') {
            selectedTags.clear();
          } else {
            if (selected) {
              selectedTags.add(category);
            } else {
              selectedTags.remove(category);
            }
          }
        });
        // Após qualquer mudança nas tags, chama o método centralizador
        // para atualizar a lista de prestadores.
        _filtrarEBuscarPrestadores();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout, // Chama a função de logout
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) =>
                    _buildCategoryChip(categories[index]),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _prestadoresFiltrados.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum prestador encontrado.\nTente ajustar sua busca ou filtros.',
                            textAlign: TextAlign.center,
                          )
                        )
                      : ListView.builder(
                          itemCount: _prestadoresFiltrados.length,
                          itemBuilder: (context, index) {
                            final prestador = _prestadoresFiltrados[index];
                            final String imageUrl = prestador['imagemPerfil'] as String? ?? '';
                            final String nome = prestador['nome'] as String? ?? 'Nome Indisponível';
                            final List<String> tags = (prestador['tags'] as List?)
                                    ?.map((tag) => (tag is Map && tag['nome'] != null) ? tag['nome'].toString() : '')
                                    .where((tagNome) => tagNome.isNotEmpty)
                                    .toList() ??
                                [];
                            final double rating = (prestador['mediaAvaliacoes'] as num?)?.toDouble() ?? 0.0;
                            final int? prestadorId = prestador['id'] as int?;
                            return PrestadorHomeCard(
                              imageUrl: imageUrl,
                              name: nome,
                              categories: tags,
                              rating: rating,
                              onTap: () {
                                if (prestadorId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrestadorDetalhesPage(id: prestadorId),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('ID do prestador indisponível.'))
                                  );
                                }
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