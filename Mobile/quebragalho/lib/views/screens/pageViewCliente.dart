import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/HomePage.dart';
import 'package:flutter_quebragalho/views/screens/UserProfile.dart';

/// Widget principal que gerencia a navegação entre telas através de PageView e BottomNavigationBar.
class PageViewCore extends StatefulWidget {
  const PageViewCore({super.key});

  @override
  State<PageViewCore> createState() => _PageViewCoreState();
}

class _PageViewCoreState extends State<PageViewCore> {
  int _currentIndex = 0; // Armazena o índice da aba selecionada.
  final PageController _pageController = PageController(); // Controlador para a navegação entre páginas.

  // Lista de telas que serão exibidas em cada aba.
  final List<Widget> _pages = [
    HomePage(),  // Tela inicial
    UserProfile(), // Tela de perfil do usuário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // A área principal usa PageView para permitir swipes entre as páginas.
      body: PageView(
        controller: _pageController, // Controlador para definir a página atual.
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Atualiza o índice da aba ao trocar de página.
          });
        },
        children: _pages, // Exibe as telas definidas na lista _pages.
      ),
      // Barra de navegação inferior para alternar entre as páginas.
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex, // Define a aba atualmente selecionada.
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza o índice selecionado.
            // Anima a transição para a página selecionada.
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
            );
          });
        },
        // Itens da BottomNavigationBar representando cada aba.
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30, // Remove a cor fixa para permitir o controle automático.
            ),
            label: '', // Sem texto para o label.
          ),
          /*BottomNavigationBarItem(
            icon: Icon(
              Icons.sms_outlined,
              size: 30, // Remove a cor fixa para permitir o controle automático.
            ),
            label: '',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30, // Remove a cor fixa para permitir o controle automático.
            ),
            label: '',
          ),
        ],
        selectedItemColor: Colors.purple, // Cor para o item selecionado.
        unselectedItemColor: Colors.grey, // Cor para os itens não selecionados.
        showSelectedLabels: false, // Não exibe labels para o item selecionado.
        showUnselectedLabels: false, // Não exibe labels para os itens não selecionados.
      ),
    );
  }
}

// Telas de exemplo

/// Tela inicial do aplicativo. Exibe um texto simples centralizado.