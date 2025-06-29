import 'package:flutter/material.dart';
import 'package:quebragalho2/views/prestador/pages/chat_list_prestador.dart';
import 'package:quebragalho2/views/prestador/pages/home_page.dart';
import 'package:quebragalho2/views/prestador/pages/tela_perfil.dart';

class NavegacaoPrestador extends StatefulWidget {
  final int id_prestador;

  NavegacaoPrestador({super.key, required this.id_prestador});

  @override
  State<NavegacaoPrestador> createState() => _NavegacaoPrestadorState();
}

class _NavegacaoPrestadorState extends State<NavegacaoPrestador> {
  // Index da página selecionada
  int _selectedIndex = 0;

  //Lista de páginas da navegação
  late final List<Widget> paginas;

  @override
  void initState() {
    super.initState();
    paginas = [
      HomePage(),
      ChatListPrestador(),
      PerfilPage(),
    ];
  }

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
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () => _onTabTapped(1),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _onTabTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}



