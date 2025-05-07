import 'package:flutter_quebragalho/models/service_request.dart';

class ServiceRequestService {
  Future<bool> confirmService(ServiceRequest request) async {
    await Future.delayed(Duration(seconds: 2));
    return true; // Simulando sucesso
  }
}
