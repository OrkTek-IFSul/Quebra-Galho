import 'package:flutter/material.dart';
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

//Lista de páginas da navegação
  final List<Widget> paginas = [
    HomePage(),
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



