import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

import 'package:quebragalho2/views/cliente/pages/prestador_detalhes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/popular_card_home.dart';
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

  /// Inicializa os dados na ordem correta
  Future<void> _initializeData() async {
    // Primeiro verifica o status de login
    await _checkLoginStatus();

    // Se estiver logado, carrega os dados do usuário
    if (isLoggedIn) {
      await Future.wait([_loadNomeUsuario(), _loadProfileImage()]);
    }

    // Por último, carrega os dados da página
    await _loadInitialData();
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
      final uri = Uri.parse(
        'https://${ApiConfig.baseUrl}/api/usuario/homepage/prestadores',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _prestadoresFiltrados = data;
        });
      } else {
        print(
          'Falha ao carregar prestadores: ${response.statusCode} ${response.body}',
        );
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
        if (searchController.text.trim().isNotEmpty)
          'nome': searchController.text.trim(),
        if (selectedTags.isNotEmpty) 'tags': selectedTags.join(','),
        'page': '0',
        'size': '10',
      };

      final uri = Uri.parse(
        'https://${ApiConfig.baseUrl}/api/usuario/homepage/buscar',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _prestadoresFiltrados = data['content'] ?? [];
        });
      } else {
        print(
          'Falha ao buscar prestadores: ${response.statusCode} ${response.body}',
        );
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
      final uri = Uri.parse(
        'https://${ApiConfig.baseUrl}/api/usuario/homepage/tags',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          categories = ['Todos', ...data.map((tag) => tag['nome'].toString())];
        });
      } else {
        print(
          'Falha ao carregar categorias: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  // --- MÉTODOS DE AUTENTICAÇÃO E OUTROS ---

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('usuario_id');

      if (mounted) {
        setState(() {
          isLoggedIn = token != null && token.isNotEmpty;
          usuarioId = userId;
        });
      }

      print('Status de login: $isLoggedIn, Usuario ID: $usuarioId'); // Debug
    } catch (e) {
      print('Erro ao verificar status de login: $e');
      if (mounted) {
        setState(() {
          isLoggedIn = false;
          usuarioId = null;
        });
      }
    }
  }

  Future<void> _confirmLogout() async {
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
    _initializeData();
  }

  Future<void> _loadNomeUsuario() async {
    if (!isLoggedIn || usuarioId == null) {
      print('Usuário não logado ou ID não encontrado'); // Debug
      return;
    }

    try {
      print('Carregando nome do usuário para ID: $usuarioId'); // Debug

      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$usuarioId'),
      );

      print('Status da resposta (nome): ${response.statusCode}'); // Debug

      if (response.statusCode == 200) {
        // Aplicando a decodificação UTF-8 aqui também
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('Dados recebidos (nome): $data'); // Debug

        if (mounted) {
          setState(() {
            nomeUsuario = data['nome']?.toString() ?? 'Usuário';
          });
        }
        print('Nome carregado: $nomeUsuario'); // Debug
      } else {
        print(
          'Erro ao carregar nome: ${response.statusCode} - ${response.body}',
        );
        if (mounted) {
          setState(() {
            nomeUsuario = 'Usuário';
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar nome do usuário: $e');
      if (mounted) {
        setState(() {
          nomeUsuario = 'Usuário';
        });
      }
    }
  }

  Future<void> _loadProfileImage() async {
    if (!isLoggedIn || usuarioId == null) {
      print('Usuário não logado ou ID não encontrado para imagem'); // Debug
      return;
    }

    try {
      print('Carregando imagem do usuário para ID: $usuarioId'); // Debug

      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$usuarioId'),
      );

      print('Status da resposta (imagem): ${response.statusCode}'); // Debug

      if (response.statusCode == 200) {
        // Aplicando a decodificação UTF-8 aqui também
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print('Dados recebidos (imagem): $data'); // Debug

        final imagemPerfil = data['imagemPerfil'];
        print('Caminho da imagem: $imagemPerfil'); // Debug

        if (imagemPerfil != null && imagemPerfil.toString().isNotEmpty) {
          final imageUrl =
              'https://${ApiConfig.baseUrl}/$imagemPerfil?ts=${DateTime.now().millisecondsSinceEpoch}';
          print('URL final da imagem: $imageUrl'); // Debug

          if (mounted) {
            setState(() {
              _profileImageUrl = imageUrl;
            });
          }
        } else {
          print('Imagem de perfil não encontrada ou vazia');
          if (mounted) {
            setState(() {
              _profileImageUrl = null;
            });
          }
        }
      } else {
        print(
          'Erro ao carregar imagem: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Erro ao carregar imagem de perfil: $e');
    }
  }

  // --- WIDGETS ---

  /// Constrói os chips de categoria.
  Widget _buildCategoryChip(String category) {
    final isSelected =
        category == 'Todos'
            ? selectedTags.isEmpty
            : selectedTags.contains(category);

    return ChoiceChip(
      label: Text(
        category,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      selectedColor: Colors.black,
      backgroundColor: Colors.grey[200],
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (category == 'Todos') {
            selectedTags.clear();
            searchController.clear();
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
        backgroundColor: Colors.white,
        elevation: 0,
        title:
            isLoggedIn
                ? Row(
                  children: [
                    const SizedBox(height: 10),
                    // Foto de perfil ou avatar padrão
                    _profileImageUrl != null
                        ? GestureDetector(
                            onTap: _confirmLogout,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(_profileImageUrl!),
                              backgroundColor: Colors.transparent,
                              onBackgroundImageError: (exception, stackTrace) {
                                print('Erro ao carregar imagem: $exception');
                              },
                            ),
                          )
                        : GestureDetector(
                            onTap: _confirmLogout,
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFFF0F0F0),
                              child: Icon(Icons.person, color: Colors.black87),
                            ),
                          ),
                    const SizedBox(width: 12),
                    // Textos de boas-vindas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Bem-vindo,',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            nomeUsuario ?? 'Carregando...',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : const Text(
                  '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                  color: Colors.black87,
                  splashRadius: 24,
                ),
              ),
            ),
          ],
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "O que você precisa pra hoje?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquise pelo nome do usuário ou empresa',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
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
                itemBuilder:
                    (context, index) => _buildCategoryChip(categories[index]),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: const Color.fromARGB(255, 63, 63, 63)),
                    Text(
                      'Prestadores',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 112, 112, 112),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
               
              ],
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _prestadoresFiltrados.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhum prestador encontrado.\nTente ajustar sua busca ou filtros.',
                          textAlign: TextAlign.center,
                        ),
                      )
                      : ListView.builder(
                        itemCount: _prestadoresFiltrados.length,
                        itemBuilder: (context, index) {
                          final prestador = _prestadoresFiltrados[index];
                          final String imageUrl =
                              (prestador['imagemPerfil'] != null &&
                                      (prestador['imagemPerfil'] as String)
                                          .isNotEmpty)
                                  ? 'https://${ApiConfig.baseUrl}/${prestador['imagemPerfil']}'
                                  : '';
                          final String nome =
                              prestador['nome'] as String? ??
                              'Nome Indisponível';
                          final List<String> tags =
                              (prestador['tags'] as List?)
                                  ?.map(
                                    (tag) =>
                                        (tag is Map && tag['nome'] != null)
                                            ? tag['nome'].toString()
                                            : '',
                                  )
                                  .where((tagNome) => tagNome.isNotEmpty)
                                  .toList() ??
                              [];
                          final double rating =
                              (prestador['mediaAvaliacoes'] as num?)
                                  ?.toDouble() ??
                              0.0;
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
                                    builder:
                                        (context) => PrestadorDetalhesPage(
                                          id: prestadorId,
                                          isLoggedIn: isLoggedIn,
                                        ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'ID do prestador indisponível.',
                                    ),
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
    );
  }
}
