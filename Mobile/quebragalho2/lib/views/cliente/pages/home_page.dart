import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/cliente/pages/login_page.dart';
import 'package:quebragalho2/views/cliente/pages/prestador_detalhes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/prestador_home_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';

// Função placeholder
Future<int?> obterIdPrestador() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('prestador_id');
}

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
  int? _idPrestadorLogado;

  String? nomeUsuario;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeData();
    searchController.addListener(_debouncedSearch);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_debouncedSearch);
    searchController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE INICIALIZAÇÃO ---

  // ALTERAÇÃO APLICADA AQUI
  Future<void> _initializeData() async {
    // 1. REMOVIDO: setState(() => isLoading = true);
    
    await Future.wait([
      _checkLoginStatus(),
      _loadPrestadorId(),
    ]);
    
    if (isLoggedIn) {
      await Future.wait([
        _loadNomeUsuario(),
        _loadProfileImage(),
      ]);
    }
    
    // Esta chamada agora controlará o isLoading por conta própria.
    await _loadInitialData();

    // 2. REMOVIDO: if (mounted) { setState(() => isLoading = false); }
  }

  // --- MÉTODOS DE LÓGICA E DADOS (sem alterações) ---

  Future<void> _loadPrestadorId() async {
    final id = await obterIdPrestador();
    if (mounted) {
      setState(() {
        _idPrestadorLogado = id;
      });
    }
  }

  Future<void> _filtrarEBuscarPrestadores() async {
    if (isLoading) return;
    setState(() => isLoading = true); // Define como carregando
    
    final termoBusca = searchController.text.trim();
    if (termoBusca.isEmpty && selectedTags.isEmpty) {
      await fetchPrestadores();
    } else {
      await _searchPrestadoresComFiltros();
    }
  }

  Future<void> _loadInitialData() async {
    await fetchCategorias();
    await _filtrarEBuscarPrestadores();
  }

  void _debouncedSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filtrarEBuscarPrestadores();
    });
  }

  Future<void> fetchPrestadores() async {
    try {
      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/prestadores');
      final response = await http.get(uri);
      if (mounted && response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _prestadoresFiltrados = data.where((p) => p['id'] != _idPrestadorLogado).toList();
        });
      } else if (mounted) {
        setState(() => _prestadoresFiltrados = []);
      }
    } catch (e) {
      if (mounted) setState(() => _prestadoresFiltrados = []);
    } finally {
      // Este finally garante que o loading termine APÓS a busca
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _searchPrestadoresComFiltros() async {
    try {
      final queryParams = {
        if (searchController.text.trim().isNotEmpty) 'nome': searchController.text.trim(),
        if (selectedTags.isNotEmpty) 'tags': selectedTags.join(','),
        'page': '0',
        'size': '20',
      };
      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/buscar')
          .replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (mounted && response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _prestadoresFiltrados = (data['content'] as List<dynamic>?)
                  ?.where((p) => p['id'] != _idPrestadorLogado)
                  .toList() ??
              [];
        });
      } else if (mounted) {
        setState(() => _prestadoresFiltrados = []);
      }
    } catch (e) {
      if (mounted) setState(() => _prestadoresFiltrados = []);
    } finally {
      // Este finally garante que o loading termine APÓS a busca
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> fetchCategorias() async {
    try {
      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/tags');
      final response = await http.get(uri);
      if (mounted && response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          categories = ['Todos', ...data.map((tag) => tag['nome'].toString())];
        });
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('usuario_id');
    if (mounted) {
      setState(() {
        isLoggedIn = token != null && token.isNotEmpty;
        usuarioId = userId;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout realizado com sucesso')),
    );
  }

  Future<void> _confirmLogout() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação de Logout'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Sair')),
        ],
      ),
    );
    if (confirmar == true) {
      _logout();
    }
  }

  Future<void> _loadNomeUsuario() async {
    if (!isLoggedIn || usuarioId == null) return;
    try {
      final response = await http.get(Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$usuarioId'));
      if (mounted && response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() => nomeUsuario = data['nome']?.toString() ?? 'Usuário');
      } else if (mounted) {
        setState(() => nomeUsuario = 'Usuário');
      }
    } catch (e) {
      if (mounted) setState(() => nomeUsuario = 'Usuário');
    }
  }

  Future<void> _loadProfileImage() async {
    if (!isLoggedIn || usuarioId == null) return;
    try {
      final response = await http.get(Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$usuarioId'));
      if (mounted && response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final imagemPerfil = data['imagemPerfil'];
        if (imagemPerfil != null && imagemPerfil.toString().isNotEmpty) {
          final imageUrl = 'https://${ApiConfig.baseUrl}/$imagemPerfil?ts=${DateTime.now().millisecondsSinceEpoch}';
          setState(() => _profileImageUrl = imageUrl);
        } else {
          setState(() => _profileImageUrl = null);
        }
      }
    } catch (e) {
      print('Erro ao carregar imagem de perfil: $e');
    }
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = (category == 'Todos' && selectedTags.isEmpty) || selectedTags.contains(category);
    return ChoiceChip(
      label: Text(category, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
      selectedColor: Colors.black,
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.transparent)),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (category == 'Todos') {
            selectedTags.clear();
          } else {
            selected ? selectedTags.add(category) : selectedTags.remove(category);
          }
        });
        _filtrarEBuscarPrestadores();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: isLoggedIn
            ? Row(
                children: [
                  GestureDetector(
                    onTap: _confirmLogout,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                      backgroundColor: Colors.grey[200],
                      child: _profileImageUrl == null ? const Icon(Icons.person, color: Colors.black87) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Bem-vindo,', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text(
                          nomeUsuario ?? 'Carregando...',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Text('Bem-vindo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          if (!isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: const Icon(Icons.login),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                color: Colors.black87,
                splashRadius: 24,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _initializeData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoggedIn)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "O que você precisa pra hoje?",
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Pesquise por nome ou serviço',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) => _buildCategoryChip(categories[index]),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(Icons.bolt, color: Color.fromARGB(255, 63, 63, 63)),
                        SizedBox(width: 4),
                        Text('Prestadores', style: TextStyle(color: Color.fromARGB(255, 112, 112, 112), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _prestadoresFiltrados.isEmpty
                        ? const Center(child: Text('Nenhum prestador encontrado.'))
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: _prestadoresFiltrados.length,
                            itemBuilder: (context, index) {
                              final prestador = _prestadoresFiltrados[index];
                              final String imageUrl =
                                  (prestador['imagemPerfil'] != null && (prestador['imagemPerfil'] as String).isNotEmpty)
                                      ? 'https://${ApiConfig.baseUrl}/${prestador['imagemPerfil']}'
                                      : '';
                              final String nome = prestador['nome'] as String? ?? 'Nome Indisponível';
                              final List<String> tags = (prestador['tags'] as List?)
                                      ?.map((tag) => (tag is Map && tag['nome'] != null)
                                          ? tag['nome'].toString()
                                          : '')
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
                                        builder: (context) => PrestadorDetalhesPage(id: prestadorId, isLoggedIn: isLoggedIn),
                                      ),
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
      ),
    );
  }
}