import 'package:flutter/material.dart';

/// Página de chat que exibe a conversa entre usuários
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizada com botões de ação
      appBar: AppBar(
        // Botão de voltar personalizado
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        // Título com nome do usuário
        title: Row(
          children: [
            Text(
              'Jean Carlo',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        // Botões de ação (Cancelar e Confirmar)
        actions: [
          Row(
            children: [
              // Botão Cancelar com fundo cinza
              Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 219, 219),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: const Color.fromARGB(255, 88, 88, 88), fontSize: 14),
                  ),
                ),
              ),
              // Botão Confirmar com fundo roxo
              Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.purple,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              // Espaçamento de 3% da largura da tela
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            ],
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      // Corpo principal do chat
      body: Column(
        children: [
          // Lista de mensagens com scroll
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Mensagens do chat com horários
                _buildMessage(
                  'Precisa ainda precisando de um conserto de geladeira aqui em casa, dá uma mão?',
                  true,
                  '17:33',
                ),
                _buildMessage('bola mano', false, '17:35'),
                _buildMessage('que tipo de geladeira que é?', false, '17:37'),
                _buildMessage('Brastemp, das antigas aquelas', true, '17:44'),
                _buildMessage('show bem tranquilo', false, '17:45'),
                _buildMessage('passa o endereço', false, '17:45'),
                _buildMessage('Rua fulano de tal, 247', true, '17:44'),
              ],
            ),
          ),
          // Campo de entrada de mensagem
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// Constrói uma mensagem individual do chat
  /// [message] é o texto da mensagem
  /// [isReceived] indica se a mensagem foi recebida (true) ou enviada (false)
  /// [time] é o horário da mensagem
  Widget _buildMessage(String message, bool isReceived, String time) {
    return Align(
      // Alinha mensagens recebidas à direita e enviadas à esquerda
      alignment: isReceived ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          // Cor diferente para mensagens recebidas e enviadas
          color: isReceived 
              ? Colors.purple[100] 
              : const Color.fromARGB(255, 224, 224, 224),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Texto da mensagem
            Text(
              message,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            SizedBox(height: 4),
            // Horário da mensagem
            Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
          ],
        ),
      ),
    );
  }

  /// Constrói o campo de entrada de mensagem com botões
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Botão de agendamento (relógio)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 8),
          // Campo de texto para digitar mensagem
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 228, 228),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Digite uma mensagem...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          // Botão de enviar mensagem
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
