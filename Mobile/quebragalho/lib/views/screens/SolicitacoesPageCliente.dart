import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/widgets/solicitacao_item.dart';

class SolicitacoesPageCliente extends StatelessWidget {
  const SolicitacoesPageCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título "Minhas solicitações"
            Row(
              children: [
                Icon(Icons.handyman, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Minhas solicitações',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Campo de pesquisa
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquise...',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Título "Últimas solicitações"
            Text(
              'Últimas solicitações',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 160, 160, 160),
              ),
            ),
            SizedBox(height: 16),
            // Lista de solicitações
            Expanded(
              child: ListView(
                children: const [
                  SolicitacaoItem(
                    nome: 'Jean Carlo',
                    data: '18/04',
                    hora: '16:00',
                    status: 'Conversar',
                    statusColor: Colors.purple,
                  ),
                  SolicitacaoItem(
                    nome: 'Rogério Silvano',
                    data: '18/04',
                    hora: '13:00',
                    status: 'Pendente',
                    statusColor: Color.fromARGB(255, 224, 224, 224),
                  ),
                  SolicitacaoItem(
                    nome: 'Rogério Silvano',
                    data: '18/04',
                    hora: '17:00',
                    status: 'Cancelado',
                    statusColor: Color.fromARGB(255, 224, 224, 224),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}