import 'package:flutter/material.dart';

// 1. Modelo de Dados para a Notificação
class NotificationItem {
  final String imageUrl;
  final String title;
  final String timeAgo;
  final DateTime date; // Para organizar as notificações por data

  NotificationItem({
    required this.imageUrl,
    required this.title,
    required this.timeAgo,
    required this.date,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Lista de notificações de exemplo
  final List<NotificationItem> _notifications = [
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg', // Imagem de exemplo
      title: 'Jean Carlo aceitou sua solicitação!',
      timeAgo: '2 horas atrás',
      date: DateTime(2025, 8, 25, 10, 0), // Exemplo de data e hora
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Maria Silva aceitou sua solicitação!',
      timeAgo: '3 horas atrás',
      date: DateTime(2025, 8, 25, 9, 0),
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Ana Paula aceitou sua solicitação!',
      timeAgo: 'Ontem',
      date: DateTime(2025, 8, 24, 15, 0),
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Pedro Oliveira aceitou sua solicitação!',
      timeAgo: '3 dias atrás',
      date: DateTime(2025, 8, 22, 11, 0),
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Luisa Mendes aceitou sua solicitação!',
      timeAgo: '4 dias atrás',
      date: DateTime(2025, 8, 21, 14, 0),
    ),
     NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg', // Imagem de exemplo
      title: 'Jean Carlo aceitou sua solicitação!',
      timeAgo: '2 horas atrás',
      date: DateTime(2025, 8, 25, 10, 0), // Exemplo de data e hora
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Maria Silva aceitou sua solicitação!',
      timeAgo: '3 horas atrás',
      date: DateTime(2025, 8, 25, 9, 0),
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Ana Paula aceitou sua solicitação!',
      timeAgo: 'Ontem',
      date: DateTime(2025, 8, 24, 15, 0),
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Pedro Oliveira aceitou sua solicitação!',
      timeAgo: '3 dias atrás',
      date: DateTime(2025, 8, 22, 11, 0),
    ),
    NotificationItem(
      imageUrl: 'https://nftnow.com/wp-content/uploads/2024/04/alien-punk.jpg',
      title: 'Luisa Mendes aceitou sua solicitação!',
      timeAgo: '4 dias atrás',
      date: DateTime(2025, 8, 21, 14, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Para simplificar, vamos dividir as notificações manualmente para a exibição "mais recentes" e "esta semana"
    // Em uma aplicação real, você faria essa lógica de filtragem com base nas datas reais.
    final List<NotificationItem> recentNotifications = _notifications.sublist(0, 3); // 3 mais recentes
    final List<NotificationItem> thisWeekNotifications = _notifications.sublist(3); // O restante para "esta semana"

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notificações",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        // Removendo o botão de voltar padrão se não for necessário
        // automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "As notificações mais recentes",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true, // Importante para ListView dentro de SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // Desabilita o scroll do ListView interno
              itemCount: recentNotifications.length,
              itemBuilder: (context, index) {
                final notification = recentNotifications[index];
                return _buildNotificationTile(notification);
              },
            ),
            const SizedBox(height: 20), // Espaço entre as seções
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Esta Semana",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: thisWeekNotifications.length,
              itemBuilder: (context, index) {
                final notification = thisWeekNotifications[index];
                return _buildNotificationTile(notification);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper para construir cada item de notificação
  Widget _buildNotificationTile(NotificationItem notification) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(notification.imageUrl),
            backgroundColor: Colors.grey[200], // Placeholder caso a imagem não carregue
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: notification.title.split(' ')[0], // Primeiro nome
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Cor padrão do texto
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: ' ${notification.title.substring(notification.title.indexOf(' ') + 1)}', // O restante da frase
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(
            '${_formatDate(notification.date)} - ${notification.timeAgo}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          onTap: () {
            // Ação ao clicar na notificação (ex: navegar para detalhes)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notificação clicada: ${notification.title}')),
            );
          },
        ),
        const Divider(height: 1, indent: 72), // Linha divisória
      ],
    );
  }

  // Função helper para formatar a data (apenas dia/mês/ano para corresponder à imagem)
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}