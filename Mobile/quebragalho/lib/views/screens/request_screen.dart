import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/service_request.dart';
import 'package:flutter_quebragalho/views/widgets/solicitacao_item.dart';

class RequestScreen extends StatelessWidget {
  final List<ServiceRequest> requests = [
    ServiceRequest(
      nome: 'José Silva',
      data: '12/05/2025',
      hora: '14:00',
      status: 'Pendente',
      statusColor: Colors.pink.shade100,
    ),
    ServiceRequest(
      nome: 'Maria Oliveira',
      data: '13/05/2025',
      hora: '09:00',
      status: 'Confirmado',
      statusColor: Colors.green.shade100,
    ),
    // Mais solicitações...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Solicitações')),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return SolicitacaoItem(
            nome: requests[index].nome,
            data: requests[index].data,
            hora: requests[index].hora,
            status: requests[index].status,
            statusColor: requests[index].statusColor,
          );
        },
      ),
    );
  }
}
