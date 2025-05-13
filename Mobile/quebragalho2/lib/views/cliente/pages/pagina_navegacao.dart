import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/home_page.dart';


class PaginaDeNavegacao extends StatefulWidget {
  const PaginaDeNavegacao({super.key});

  @override
  State<PaginaDeNavegacao> createState() => _PaginaDeNavegacaoState();
}

class _PaginaDeNavegacaoState extends State<PaginaDeNavegacao> {
  // Index da página selecionada
  int _selectedIndex = 0;

//Lista de páginas da navegação
  final List<Widget> paginas = [
    HomePage(),
    
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



