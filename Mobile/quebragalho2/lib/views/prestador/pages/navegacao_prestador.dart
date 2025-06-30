import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quebragalho2/views/prestador/pages/chat_list_prestador.dart';
import 'package:quebragalho2/views/prestador/pages/home_page.dart';
import 'package:quebragalho2/views/prestador/pages/tela_perfil.dart';
import 'package:quebragalho2/views/moderador/moderador_page.dart';

class NavegacaoPrestador extends StatefulWidget {
  final int id_prestador;

  const NavegacaoPrestador({super.key, required this.id_prestador});

  @override
  State<NavegacaoPrestador> createState() => _NavegacaoPrestadorState();
}

class _NavegacaoPrestadorState extends State<NavegacaoPrestador> {
  int _selectedIndex = 0;
  bool isModerador = false;
  List<Widget> paginas = [];

  @override
  void initState() {
    super.initState();
    _carregarModerador();
  }

  Future<void> _carregarModerador() async {
    final prefs = await SharedPreferences.getInstance();
    final moderador = prefs.getBool('isModerador') ?? false;

    setState(() {
      isModerador = moderador;
      paginas = [
        HomePage(),
        ChatListPrestador(),
        PerfilPage(),
        if (isModerador) ModeradorPage(),
      ];
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: paginas),
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
            if (isModerador)
              IconButton(
                icon: Icon(
                  Icons.shield_outlined,
                  color: _selectedIndex == 3 ? Colors.black : Colors.grey,
                ),
                onPressed: () => _onTabTapped(3),
              ),
          ],
        ),
      ),
    );
  }
}
