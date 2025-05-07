import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/service_request.dart';
import 'package:flutter_quebragalho/services/service_request_service.dart';

class ServiceConfirmationModal extends StatelessWidget {
  final ServiceRequest serviceRequest;

  const ServiceConfirmationModal({super.key, required this.serviceRequest});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmar Serviço'),
      content: Text('Tem certeza que deseja agendar o serviço?'),
      actions: [
        ElevatedButton(
          onPressed: () async {
            bool success = await ServiceRequestService().confirmService(
              serviceRequest,
            );
            if (success) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Falha ao confirmar o serviço')),
              );
            }
          },
          child: Text('Confirmar'),
        ),
      ],
    );
  }
}
