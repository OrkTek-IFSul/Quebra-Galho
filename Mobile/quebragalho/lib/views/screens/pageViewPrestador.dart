import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/UserProfile.dart';
import 'package:flutter_quebragalho/views/screens/chatsPage.dart';

/// Widget principal que gerencia a navegação entre telas através de PageView e BottomNavigationBar.
class PageViewPrestadorCore extends StatefulWidget {
  const PageViewPrestadorCore({super.key});

  @override
  State<PageViewPrestadorCore> createState() => _PageViewPrestadorCoreState();
}

class _PageViewPrestadorCoreState extends State<PageViewPrestadorCore> {
  int _currentIndex = 0; // Armazena o índice da aba selecionada.
  final PageController _pageController =
      PageController(); // Controlador para a navegação entre páginas.

  // Lista de telas que serão exibidas em cada aba.
  final List<Widget> _pages = [
    UserProfile(), // Tela de perfil do usuário
    HomeScreen(), // Tela inicial
    ChatsPage(), // Tela de conversas
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A área principal usa PageView para permitir swipes entre as páginas.
      body: PageView(
        controller: _pageController, // Controlador para definir a página atual.
        onPageChanged: (index) {
          setState(() {
            _currentIndex =
                index; // Atualiza o índice da aba ao trocar de página.
          });
        },
        children: _pages, // Exibe as telas definidas na lista _pages.
      ),
      // Barra de navegação inferior para alternar entre as páginas.
      bottomNavigationBar: BottomNavigationBar(
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
              size:
                  30, // Remove a cor fixa para permitir o controle automático.
            ),
            label: '', // Sem texto para o label.
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sms_outlined,
              size:
                  30, // Remove a cor fixa para permitir o controle automático.
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_none_outlined,
              size:
                  30, // Remove a cor fixa para permitir o controle automático.
            ),
            label: '',
          ),
        ],
        selectedItemColor: Colors.purple, // Cor para o item selecionado.
        unselectedItemColor: Colors.grey, // Cor para os itens não selecionados.
        showSelectedLabels: false, // Não exibe labels para o item selecionado.
        showUnselectedLabels:
            false, // Não exibe labels para os itens não selecionados.
      ),
    );
  }
}

// Telas de exemplo

/// Tela inicial do aplicativo. Exibe um texto simples centralizado.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Exibe o texto "Home Screen" com estilo de destaque.
      child: Text(
        'Home Screen',
        style: TextStyle(
          fontSize: 24, // Tamanho da fonte destacado.
          fontWeight: FontWeight.bold, // Texto em negrito.
        ),
      ),
    );
  }
}
