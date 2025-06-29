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
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.black : Colors.grey,
              ),
              onPressed: () => _onTabTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: _selectedIndex == 1 ? Colors.black : Colors.grey,
              ),
              onPressed: () => _onTabTapped(1),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 2 ? Colors.black : Colors.grey,
              ),
              onPressed: () => _onTabTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}



