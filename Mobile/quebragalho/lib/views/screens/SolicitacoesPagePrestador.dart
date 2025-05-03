import 'package:flutter/material.dart';

class SolicitacoesPagePrestador extends StatelessWidget {
  const SolicitacoesPagePrestador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Título movido para cima da barra de pesquisa
            Row(
              children: [
                Icon(Icons.handyman, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Solicitações',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 24,
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
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            // Lista de solicitações
            Expanded(
              child: ListView(
                children: [
                  _buildSolicitacaoItem(
                    'Jean Carlo',
                    '18/04',
                    '16:00',
                    Status.pending,
                  ),
                  _buildSolicitacaoItem(
                    'Rogério Silvano',
                    '18/04',
                    '13:00',
                    Status.pending,
                  ),
                  _buildSolicitacaoItem(
                    'Diego Lima',
                    '18/04',
                    '14:00',
                    Status.confirmed,
                  ),
                  _buildSolicitacaoItem(
                    'Laila de Oliveira',
                    '18/04',
                    '15:00',
                    Status.canceled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolicitacaoItem(
    String nome,
    String data,
    String hora,
    Status status,
  ) {
    return Opacity(
      opacity: status == Status.canceled ? 0.6 : 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(radius: 24, backgroundColor: Colors.grey.shade300),
            SizedBox(width: 16),
            // Informações do usuário
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Data: $data | Hora: $hora',
                    style: TextStyle(fontSize: 12, color: Colors.purple),
                  ),
                ],
              ),
            ),
            // Botões de ação
            if (status == Status.pending) ...[
              Row(
                children: [
                  Container(
                    width: 32, // Define a largura fixa
                    height: 32, // Define a altura fixa
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple,
                    ),
                    child: IconButton(
                      iconSize: 16, 
                      icon: Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        // Lógica para aceitar solicitação
                      },
                    ),
                  ),
                  SizedBox(width: 14), // Espaçamento entre os botões
                  Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 243, 173, 255)
                      ),
                    child: IconButton(
                      iconSize: 16,
                      icon: Icon(Icons.close, color: const Color.fromARGB(255, 68, 0, 80)),
                      onPressed: () {
                        // Lógica para recusar solicitação
                      },
                    ),
                  ),
                ],
              ),
            ] else if (status == Status.confirmed)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                 border: Border.all(
                  color: Colors.purple,
                  width: 2,
                 ),
                 borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Confirmado',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (status == Status.canceled)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Cancelado',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum Status { pending, confirmed, canceled }
