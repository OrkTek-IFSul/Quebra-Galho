import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/editar_dados_page.dart';
import 'package:quebragalho2/views/cliente/pages/minhas_solicitacoes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/info_campos_perfil.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// FOTO DE PERFIL COM ÍCONE DE EDITAR
            Stack(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    'assets/perfil.jpg',
                  ), // ou NetworkImage
                  backgroundColor: Colors.grey,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// DADOS DO USUÁRIO
            InfoCamposPerfil(titulo: "Nome", valor: "João da Silva"),
            InfoCamposPerfil(titulo: "Telefone", valor: "(11) 91234-5678"),
            InfoCamposPerfil(titulo: "Email", valor: "joao@gmail.com"),
            InfoCamposPerfil(titulo: "CPF", valor: "123.456.789-00"),

            const SizedBox(height: 30),

            /// BOTÕES ESTILOSOS
            ElevatedButton.icon(
              onPressed: () {
                // navegar pra tela de solicitações
                // navegar pra edição
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MinhasSolicitacoesPage(),
                  ),
                );
              },
              icon: const Icon(Icons.list_alt),
              label: const Text("Minhas Solicitações"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // navegar pra edição
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarDadosPage(usuarioId: 1),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Editar meus dados"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
