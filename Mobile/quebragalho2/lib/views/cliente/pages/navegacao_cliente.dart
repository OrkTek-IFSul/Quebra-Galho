import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quebragalho2/views/cliente/pages/home_page.dart';
import 'package:quebragalho2/views/cliente/pages/perfil_page.dart';

class NavegacaoCliente extends StatefulWidget {
  const NavegacaoCliente({super.key});

  @override
  State<NavegacaoCliente> createState() => _NavegacaoClienteState();
}

class _NavegacaoClienteState extends State<NavegacaoCliente> {
  // Index da página selecionada
  int _selectedIndex = 0;
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    _carregarUsuarioId();
  }

  Future<void> _carregarUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('usuario_id');

    if (id == null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    setState(() {
      usuarioId = id;
    });
  }

  // Lista de páginas da navegação
  List<Widget> get paginas => [
        const HomePage(),
        if (usuarioId != null) PerfilPage(usuarioId: usuarioId!), // Passe o id aqui
      ];

  void _onTabTapped(int index) {
    // Verifica se usuário está logado antes de ir para perfil
    if (index == 1 && usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Você precisa estar logado para acessar o perfil')),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: paginas,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onTabTapped(0),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _onTabTapped(1),
            ),
          ],
        ),
      ),
    );
  }
}
