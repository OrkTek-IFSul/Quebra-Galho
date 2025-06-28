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
  String? nomeUsuario; // Adicione esta variável
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadProfileImage();
    _loadNomeUsuario(); // Chame aqui
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
  Future<void> _filtrarEBuscarPrestadores() async {
    setState(() {
      isLoading = true;
    });

    final termoBusca = searchController.text.trim();

    if (termoBusca.isEmpty && selectedTags.isEmpty) {
      await fetchPrestadores();
    } else {
      await _searchPrestadoresComFiltros();
    }
  }

  /// Carrega os dados iniciais da página.
  Future<void> _loadInitialData() async {
    await fetchCategorias();
    await _filtrarEBuscarPrestadores();
  }

  /// Listener para o campo de busca com debounce.
  void _debouncedSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filtrarEBuscarPrestadores();
    });
  }

  // --- MÉTODOS DE API ---

  /// Busca TODOS os prestadores (sem filtros).
  Future<void> fetchPrestadores() async {
    if (!isLoading) setState(() => isLoading = true);

    try {
      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/prestadores');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // AJUSTE DE DECODIFICAÇÃO APLICADO AQUI
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
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

      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/buscar')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // AJUSTE DE DECODIFICAÇÃO APLICADO AQUI
        final data = jsonDecode(utf8.decode(response.bodyBytes));
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
      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/tags');
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
  
  // --- MÉTODOS DE AUTENTICAÇÃO E OUTROS (sem alterações) ---
  
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (!mounted) return;
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout realizado com sucesso')),
    );
    _loadInitialData();
  }

  Future<void> _confirmLogout() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação de Logout'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      _logout();
    }
  }

  Future<void> carregarUsuarioId() async {
    // Implemente a busca do ID do usuário se necessário
  }

  Future<void> _loadNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeUsuario = prefs.getString('user_name') ?? '';
    });
  }

  Future<void> _loadProfileImage() async {
    if (!isLoggedIn) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('usuario_id');
      if (userId == null) return;

      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imagemPerfil = data['imagemPerfil'];
        
        if (imagemPerfil != null && imagemPerfil.isNotEmpty) {
          setState(() {
            _profileImageUrl = 'https://${ApiConfig.baseUrl}/$imagemPerfil?ts=${DateTime.now().millisecondsSinceEpoch}';
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar imagem de perfil: $e');
    }
  }

  // --- WIDGETS ---

  /// Constrói os chips de categoria.
  Widget _buildCategoryChip(String category) {
    final isSelected = category == 'Todos'
        ? selectedTags.isEmpty
        : selectedTags.contains(category);

    return ChoiceChip(
      label: Text(
        category,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black, // texto branco se selecionado
        ),
      ),
      selectedColor: Colors.black, // selecionado fica preto
      backgroundColor: Colors.grey[200],
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (category == 'Todos') {
            selectedTags.clear();
            searchController.clear(); // opcional: limpa busca ao selecionar 'Todos'
          } else {
            if (selected) {
              selectedTags.add(category);
            } else {
              selectedTags.remove(category);
            }
          }
        });
        _filtrarEBuscarPrestadores();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(''), // Remove o "Olá, {Usuario}"
        actions: [
          if (isLoggedIn) ...[
            // Ícone de notificações
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                  color: Colors.black87,
                  splashRadius: 24,
                ),
              ),
            ),
            // Foto de perfil do usuário (substitui o ícone de logout)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: _confirmLogout,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: _profileImageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_profileImageUrl!),
                          onBackgroundImageError: (exception, stackTrace) {
                            setState(() {
                              _profileImageUrl = null;
                            });
                          },
                        )
                      : const CircleAvatar(
                          backgroundColor: Color(0xFFF0F0F0),
                          child: Icon(
                            Icons.person,
                            color: Colors.black87,
                            size: 24,
                          ),
                        ),
                ),
              ),
            ),
          ] else ...[
            // Botão de login para usuários não logados
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ),
                  color: Colors.black87,
                  splashRadius: 24,
                ),
              ),
            ),
          ],
          const SizedBox(width: 12), // Espaçamento à direita
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
  child: RefreshIndicator(
    onRefresh: () async {
      await _loadInitialData(); // recarrega as categorias e os prestadores
    },
    child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : _prestadoresFiltrados.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum prestador encontrado.\nTente ajustar sua busca ou filtros.',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(), // garante o gesto mesmo com poucos itens
                itemCount: _prestadoresFiltrados.length,
                itemBuilder: (context, index) {
                  final prestador = _prestadoresFiltrados[index];
                  final String imageUrl =
                      (prestador['imagemPerfil'] != null && (prestador['imagemPerfil'] as String).isNotEmpty)
                          ? 'https://${ApiConfig.baseUrl}/${prestador['imagemPerfil']}'
                          : '';
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
                            builder: (context) => PrestadorDetalhesPage(
                              id: prestadorId,
                              isLoggedIn: isLoggedIn,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID do prestador indisponível.')),
                        );
                      }
                    },
                  );
                },
              ),
  ),
)
,
          ],
        ),
      ),
    );
  }
}