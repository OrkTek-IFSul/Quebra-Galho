import 'package:flutter/material.dart';
import 'package:quebragalho2/views/prestador/pages/home_page.dart';
import 'package:quebragalho2/views/prestador/pages/tela_perfil.dart';

class NavegacaoPrestador extends StatefulWidget {
  const NavegacaoPrestador({super.key, required prestadorId});

  @override
  State<NavegacaoPrestador> createState() => _NavegacaoPrestadorState();
}

class _NavegacaoPrestadorState extends State<NavegacaoPrestador> {
  // Index da página selecionada
  int _selectedIndex = 0;

//Lista de páginas da navegação
  final List<Widget> paginas = [
    const HomePage(),
    PerfilPage(),
  ];

  void _onTabTapped(int index) {
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



