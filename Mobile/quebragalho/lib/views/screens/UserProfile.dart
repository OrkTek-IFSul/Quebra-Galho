import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/reviewsPage.dart';

/// Widget que exibe o perfil do usuário, permitindo a alternância entre as
/// visualizações de Cliente e Prestador, além de exibir informações e ações.
class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isPrestador = false; // Controla se o perfil é de Prestador ou Cliente

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar customizada com título, pontuação e ícone de estrela
      appBar: AppBar(
        backgroundColor: Colors.white, // Fundo branco para a AppBar
        elevation: 0, // Remove a sombra da AppBar
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Text(
            'Perfil',
            style: TextStyle(
              color: Colors.purple, // Cor púrpura para o título
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false, // Título alinhado à esquerda (não centralizado)
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_border_outlined,
                  color: Colors.purple,
                  size: 22,
                ),
                SizedBox(width: 4),
                Text(
                  '3.5', // Pontuação do usuário
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Corpo do perfil
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .center, // Centraliza os conteúdos horizontalmente
          children: [
            SizedBox(height: 16),

            // Avatar do usuário com botão de edição posicionado
            Stack(
              alignment: Alignment.center,
              children: [
                // Avatar externo com borda decorativa
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.purple.withOpacity(0.1),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                  ),
                ),
                // Ícone de edição posicionado no canto inferior direito do avatar
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Nome do usuário
            Text(
              'Fabricio Machado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),

            // Exibição do tipo de perfil: Cliente ou Prestador
            SizedBox(height: 8),
            Text(
              isPrestador ? 'Prestador de Serviço' : 'Serviços solicitados',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            // Botões para alternar entre as visualizações de Cliente e Prestador
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão para selecionar perfil Cliente
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPrestador =
                          false; // Alterna para a visualização de Cliente
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !isPrestador ? Colors.purple : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Cliente',
                    style: TextStyle(
                      color: !isPrestador ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Botão para selecionar perfil Prestador
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPrestador =
                          true; // Alterna para a visualização de Prestador
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPrestador ? Colors.purple : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Prestador',
                    style: TextStyle(
                      color: isPrestador ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            // Espaço para o conteúdo específico do perfil, dependendo do tipo selecionado
            SizedBox(height: 40),
            // Se o perfil for de Prestador, exibe opções e portfólio
            if (isPrestador)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seção "OPÇÕES" para o prestador
                      Text(
                        'OPÇÕES',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 51, 6, 59),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Scroll horizontal com botões de ações
                      SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Permite rolagem horizontal
                        child: Row(
                          children: [
                            _buildActionItem(
                              Icons.settings,
                              'Solicitações\nde serviços',
                              2,
                            ),
                            SizedBox(width: 3), // Espaçamento entre os itens
                            _buildActionItem(
                              Icons.history,
                              'Histórico\nde valores',
                              0,
                            ),
                            SizedBox(width: 3),
                            _buildActionItem(
                              Icons.star,
                              'Minhas\navaliações',
                              0,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewsPage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 3),
                            _buildActionItem(
                              Icons.people_alt_outlined,
                              'Meus\ndados',
                              0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      // Seção de portfólio para o prestador
                      Text(
                        'MEU PORTFÓLIO (3/5 fotos)',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 51, 6, 59),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Linha de itens de portfólio
                      Row(
                        children: [
                          // Botão fixo para adicionar fotos
                          Container(
                            width: 80, // Largura do botão
                            height: 200, // Altura do botão
                            decoration: BoxDecoration(
                              color: Colors.transparent, // Cor de fundo do botão
                              borderRadius: BorderRadius.circular(8), // Bordas arredondadas
                              border: Border.all( // Contorno roxo
                                color: Colors.purple, 
                                width: 2, // Espessura do contorno
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.purple, // Cor do ícone
                              ), // Ícone de "+"
                              onPressed: () {
                                // Lógica para adicionar fotos
                              },
                            ),
                          ),
                          SizedBox(width: 8), // Espaço entre o botão fixo e os itens roláveis
                          // Itens de portfólio com scroll horizontal
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Permite rolagem horizontal
                              child: Row(
                                children: [
                                  // Adicionando 5 containers cinzas
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[300], // Placeholder cinza
                                    margin: EdgeInsets.only(right: 8), // Espaço entre os containers
                                  ),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[300],
                                    margin: EdgeInsets.only(right: 8),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[300],
                                    margin: EdgeInsets.only(right: 8),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[300],
                                    margin: EdgeInsets.only(right: 8),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[300],
                                    margin: EdgeInsets.only(right: 8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              // Se o perfil for de Cliente, exibe apenas as informações de contato
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exibe o rótulo EMAIL
                  Text(
                    'EMAIL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Linha com o email do usuário e um botão para editar
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'fabriciomachado2002@uol.com.br',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          overflow:
                              TextOverflow
                                  .ellipsis, // Trunca o texto se for muito longo
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Lógica para editar o email (a ser implementada)
                        },
                        icon: Icon(Icons.edit, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Método para construir um item de ação com ícone, rótulo e contador opcional.
  Widget _buildActionItem(
    IconData icon,
    String label,
    int count, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(5), // Adiciona margem para evitar corte do contador
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.purple, size: 24),
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (count > 0)
            Positioned(
              top: 0, // Ajustado para considerar a margem
              right: 0, // Ajustado para considerar a margem
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.purple,
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Método para construir um item do portfólio.
  /// Se isAddButton for verdadeiro, exibe uma área para adicionar fotos.
}
