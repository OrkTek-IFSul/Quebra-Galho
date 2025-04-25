import 'package:flutter/material.dart';

/// Página de cadastro que permite o registro de clientes e prestadores.
/// Utiliza abas para alternar entre os dois formulários.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Define duas abas: uma para Cliente e outra para Prestador.
      child: Scaffold(
        // AppBar customizado para não exibir a barra superior.
        appBar: AppBar(
          backgroundColor: Colors.white, // Fundo branco.
          elevation: 0, // Remove a sombra.
          toolbarHeight: 0, // Oculta a altura da toolbar padrão.
        ),
        // Corpo da tela de cadastro com padding interno.
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupa toda a largura disponível.
            children: [
              // Espaço para posicionar o título mais abaixo.
              SizedBox(height: 35),
              // Título centralizado para iniciar o cadastro.
              Text(
                'Vamos começar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Subtítulo explicativo sobre o cadastro.
              Text(
                'Selecione seu tipo de cadastro e adicione suas informações para começar a usufruir do app :)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromARGB(255, 190, 190, 190),
                ),
              ),
              SizedBox(height: 16),
              // Exibição das abas para selecionar o tipo de cadastro.
              TabBar(
                indicatorColor: Colors.purple, // Cor do indicador da aba selecionada.
                labelColor: Colors.purple, // Cor do texto da aba selecionada.
                unselectedLabelColor: Colors.grey, // Cor do texto das abas não selecionadas.
                tabs: <Widget>[
                  Tab(text: 'Cliente'), // Aba para cadastro de clientes.
                  Tab(text: 'Prestador'), // Aba para cadastro de prestadores.
                ],
              ),
              // Conteúdo das abas (formulários).
              Expanded(
                child: TabBarView(
                  children: [
                    // Formulário de cadastro para Clientes.
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          // Aplica espaçamento horizontal relativo à largura da tela.
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo "NOME COMPLETO"
                              Text(
                                'NOME COMPLETO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 65, 1, 77),
                                ),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Digite seu nome completo',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8), // Espaçamento reduzido
                              // Linha para TELEFONE e CPF
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TELEFONE',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: '(99) 99999-9999',
                                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CPF',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'XXX.XXX.XXX-XX',
                                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Campo para EMAIL
                              Text(
                                'EMAIL',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Digite seu email',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para NOVA SENHA
                              Text(
                                'NOVA SENHA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              TextField(
                                obscureText: true, // Esconde o conteúdo digitado
                                decoration: InputDecoration(
                                  hintText: 'Digite sua nova senha',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para CONFIRMAR SENHA
                              Text(
                                'CONFIRMAR SENHA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirme sua nova senha',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Checkbox para aceitar os termos.
                              Row(
                                children: [
                                  Checkbox(
                                    value: false, // Valor inicial não selecionado.
                                    onChanged: (value) {
                                      // Lógica para aceitar os termos (a ser implementada).
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Eu aceito os termos de compromisso e privacidade',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Formulário de cadastro para Prestadores.
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo "NOME COMPLETO"
                              Text(
                                'NOME COMPLETO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 65, 1, 77),
                                ),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Digite seu nome completo',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Linha para TELEFONE e CPF / CNPJ.
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TELEFONE',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: '(99) 99999-9999',
                                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CPF / CNPJ',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: 'XXX.XXX.XXX-XX',
                                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Campo para EMAIL
                              Text(
                                'EMAIL',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Digite seu email',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Seção para UPLOAD DE DOCUMENTO
                              Text(
                                'UPLOAD DE DOCUMENTO',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              SizedBox(height: 8),
                              // Container que simula a área de upload para documentos
                              GestureDetector(
                                onTap: () {
                                  // Lógica para realizar o upload de documento.
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromARGB(255, 243, 173, 255), width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color.fromARGB(50, 230, 200, 250),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cloud_upload, size: 40, color: Colors.purple),
                                        SizedBox(height: 8),
                                        Text(
                                          'Upload de documento',
                                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '(RG, CPF ou Comprovante de CNPJ)',
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para NOVA SENHA
                              Text(
                                'NOVA SENHA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Digite sua nova senha',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para CONFIRMAR SENHA
                              Text(
                                'CONFIRMAR SENHA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirme sua nova senha',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Checkbox para aceitar os termos.
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (value) {
                                      // Lógica para aceitar os termos (a ser implementada).
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Eu aceito os termos de compromisso e privacidade',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Botão "Cadastrar" fixado no rodapé da tela.
        bottomNavigationBar: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              // Ação a ser executada ao clicar no botão "Cadastrar".
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // Cor de fundo do botão.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Remove cantos arredondados.
              ),
            ),
            child: Text(
              'Cadastrar',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
